*----------------------------------------------------------------------*
***INCLUDE LZFG_BM_SALE_PROMOTIONF01.

*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form 0000_GET_SALE_PROGRAMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
FORM 0000_GET_SALE_PROGRAMS .
  DATA:
    LS_SDPR   TYPE ZST_SDPR,
    LS_COND   TYPE ZST_BM_FIELD_COND,
    LS_NEST_D TYPE ZST_BM_SDPR_D.

* Get header
  SELECT *
    FROM ZTB_BM_SDPR_H
    INTO TABLE @DATA(LT_SDPR_H)
   WHERE ACTIVE = @GC_XMARK
     AND DATBE <= @SY-DATUM
     AND DATEN >= @SY-DATUM.
  SORT LT_SDPR_H BY PRMNR BUKRS.

* Get condition
  SELECT *
    FROM ZTB_BM_SDPR_C
    INTO TABLE @DATA(LT_SDPR_C).
  SORT LT_SDPR_C BY PRMNR BUKRS CONDID RTABLE RFIELD RANGID.

* Get details
  SELECT D~PRMNR, BUKRS, POSNR, D~PSTYV, D~PLTYP, D~MATNR, M~MAKTX, MENGE,
         MEINS, V~VTEXT, P~BEZEI
    FROM ZTB_BM_SDPR_D AS D
   INNER JOIN TVAPT AS V ON D~PSTYV	=	V~PSTYV AND V~SPRAS = @SY-LANGU
   INNER JOIN TVM3T AS P ON D~PLTYP	=	P~MVGR3 AND P~SPRAS = @SY-LANGU
   INNER JOIN MAKT AS M ON D~MATNR  = M~MATNR AND M~SPRAS = @SY-LANGU
    INTO TABLE @DATA(LT_SDPR_D).
  SORT LT_SDPR_D BY PRMNR BUKRS POSNR MATNR.

* Build nest structure
  LOOP AT LT_SDPR_H INTO DATA(LS_SDPR_H).
    CLEAR LS_SDPR.
    MOVE-CORRESPONDING LS_SDPR_H TO LS_SDPR.

    READ TABLE LT_SDPR_C TRANSPORTING NO FIELDS
      WITH KEY PRMNR = LS_SDPR_H-PRMNR
               BUKRS = LS_SDPR_H-BUKRS BINARY SEARCH.
    IF SY-SUBRC IS INITIAL.
      LOOP AT LT_SDPR_C INTO DATA(LS_SDPR_C) FROM SY-TABIX.
        IF LS_SDPR_C-PRMNR <> LS_SDPR_H-PRMNR
        OR LS_SDPR_C-BUKRS <> LS_SDPR_H-BUKRS .
          EXIT.
        ENDIF.
        MOVE-CORRESPONDING LS_SDPR_C TO LS_COND.
        APPEND LS_COND TO LS_SDPR-CONDITIONS.
      ENDLOOP.
    ENDIF.

    READ TABLE LT_SDPR_D TRANSPORTING NO FIELDS
      WITH KEY PRMNR = LS_SDPR_H-PRMNR
               BUKRS = LS_SDPR_H-BUKRS BINARY SEARCH.
    IF SY-SUBRC IS INITIAL.
      LOOP AT LT_SDPR_D INTO DATA(LS_SDPR_D) FROM SY-TABIX.
        IF LS_SDPR_D-PRMNR <> LS_SDPR_H-PRMNR
        OR LS_SDPR_D-BUKRS <> LS_SDPR_H-BUKRS .
          EXIT.
        ENDIF.
        MOVE-CORRESPONDING LS_SDPR_D TO LS_NEST_D.
        APPEND LS_NEST_D TO LS_SDPR-DETAIL.
      ENDLOOP.
    ENDIF.

    APPEND LS_SDPR TO GT_SDPR.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form CONDITION_CHECK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LPS_VBAK
*&      --> LPS_VBKD
*&      --> LPS_VBAP
*&      --> LPT_KOMV
*&      <-- LPW_FIT
*&---------------------------------------------------------------------*
FORM CONDITION_CHECK
  USING   LPS_VBAK TYPE VBAK
          LPS_VBKD TYPE VBKD
          LPS_VBAP TYPE VBAPVB
          LPT_KOMV TYPE KOMV_TAB
          LPS_SDPR TYPE ZST_SDPR
 CHANGING LPW_FIT  TYPE XMARK.

  LPW_FIT = GC_XMARK.

  SELECT SINGLE *
    FROM MARA
    INTO @DATA(LS_MARA)
   WHERE MATNR = @LPS_VBAP-MATNR.

  CALL FUNCTION 'ZFM_DATA_COND_SET_CHECK_RECORD'
    EXPORTING
      I_RECORD     = LPS_VBAK
      T_CONDITIONS = LPS_SDPR-CONDITIONS
      I_TABNAME    = 'VBAK'
    IMPORTING
      E_FIT        = LPW_FIT.
  CHECK LPW_FIT = GC_XMARK.
  CALL FUNCTION 'ZFM_DATA_COND_SET_CHECK_RECORD'
    EXPORTING
      I_RECORD     = LPS_VBKD
      T_CONDITIONS = LPS_SDPR-CONDITIONS
      I_TABNAME    = 'VBKD'
    IMPORTING
      E_FIT        = LPW_FIT.
  CHECK LPW_FIT = GC_XMARK.
  CALL FUNCTION 'ZFM_DATA_COND_SET_CHECK_RECORD'
    EXPORTING
      I_RECORD     = LPS_VBAP
      T_CONDITIONS = LPS_SDPR-CONDITIONS
      I_TABNAME    = 'VBAP'
    IMPORTING
      E_FIT        = LPW_FIT.
  CHECK LPW_FIT = GC_XMARK.
  CALL FUNCTION 'ZFM_DATA_COND_SET_CHECK_RECORD'
    EXPORTING
      I_RECORD     = LS_MARA
      T_CONDITIONS = LPS_SDPR-CONDITIONS
      I_TABNAME    = 'MARA'
    IMPORTING
      E_FIT        = LPW_FIT.
  CHECK LPW_FIT = GC_XMARK.
  LOOP AT LPT_KOMV INTO DATA(LS_KOMV)
    WHERE KPOSN = LPS_VBAP-POSNR.
    CALL FUNCTION 'ZFM_DATA_COND_SET_CHECK_RECORD'
      EXPORTING
        I_RECORD     = LS_KOMV
        T_CONDITIONS = LPS_SDPR-CONDITIONS
        I_TABNAME    = 'KOMV'
      IMPORTING
        E_FIT        = LPW_FIT.
    IF LPW_FIT = GC_XMARK.
      EXIT.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SO_ITEM_GENERATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LPS_VBAK
*&      --> LPS_VBKD
*&      --> LS_VBAP
*&      --> LS_SDPR
*&      <-- LT_VBAP_GEN
*&---------------------------------------------------------------------*
FORM SO_ITEM_GENERATE
  USING   LPS_VBAK TYPE VBAK
          LPS_VBKD TYPE VBKD
*          LPS_VBAP TYPE VBAPVB
*          LPS_SDPR TYPE ZST_SDPR
          LPT_SDPR_D_ALV TYPE ZTT_BM_SDPR_D_ALV
 CHANGING LPT_VBAP_GEN  TYPE TT_VBAPVB.

  DATA:
    LS_SDPR_DET   TYPE ZST_BM_SDPR_D,
    LS_SDPR_D_ALV TYPE ZST_BM_SDPR_D_ALV,
    LS_XVBKD      TYPE VBKDVB.

  FIELD-SYMBOLS:
    <LF_RV45A>  TYPE RV45A,
    <LF_VBEP>   TYPE VBEP,
    <LF_VBKD>   TYPE VBKD,
    <LFT_XVBKD> TYPE TAB_XYVBKD,
    <LF_VBAP>   TYPE VBAP.

*  LOOP AT LPS_SDPR-DETAIL INTO LS_SDPR_DET.
  LOOP AT LPT_SDPR_D_ALV INTO LS_SDPR_D_ALV
    WHERE SELECTED = 'X'.
    ASSIGN ('(SAPMV45A)VBAP') TO <LF_VBAP>.
    ASSIGN ('(SAPMV45A)VBEP') TO <LF_VBEP>.
    ASSIGN ('(SAPMV45A)RV45A') TO <LF_RV45A>.
    CLEAR: <LF_VBAP>.
*   Initialize workareas for <lf_vbap> and VBEP
    PERFORM VBAP_UNTERLEGEN(SAPFV45P).
    PERFORM VBEP_UNTERLEGEN(SAPFV45E).
*   Populate material number and quantity
    <LF_VBAP>-MATNR    = LS_SDPR_D_ALV-MATNR.
*    <LF_VBAP>-UEPOS    = LS_SDPR_D_ALV-UEPOS.
    <LF_VBAP>-ADACN    = LS_SDPR_D_ALV-ADACN.
    <LF_VBAP>-LSTANR   = 'X'.
    <LF_VBAP>-VRKME    = LS_SDPR_D_ALV-MEINS.
    <LF_RV45A>-KWMENG  = LS_SDPR_D_ALV-MENGE.
*      <lf_vbap>-KWMENG   = LS_ADD_FG_SUM-KWMENG.
    <LF_VBEP>-WMENG    = LS_SDPR_D_ALV-MENGE.
    <LF_VBAP>-KDMAT    = LS_SDPR_D_ALV-PRMNR.
    <LF_VBAP>-PSTYV    = LS_SDPR_D_ALV-PSTYV.
*      RV45A-<lf_vbap>_SELKZ = SPACE.
*   Call standard performs to populate material details.
*   Perform for material validations and details
*    PERFORM <lf_vbap>-MATNR_PRUEFEN(SAPFV45P) USING CHARX SY-SUBRC.
    PERFORM VBAP-MATNR_PRUEFEN(SAPFV45P) USING GC_XMARK SY-SUBRC.
*   Perform for item category determination. This will take care of substitution items if any for this material.
    PERFORM VBAP-PSTYV_PRUEFEN(SAPFV45P).
*   Perform for filling <lf_vbap> with default values from configuration and master tables
    PERFORM VBAP_FUELLEN(SAPFV45P).
    <LF_VBAP>-MVGR3    = LS_SDPR_D_ALV-PLTYP.
    PERFORM VBAP-MATNR_NULL_PRUEFEN(SAPFV45P).
    PERFORM VBEP-WMENG_SETZEN(SAPFV45E).
*   Perform to check sales unit
    PERFORM VBAP-VRKME_PRUEFEN(SAPFV45P)
      USING GC_XMARK
      CHANGING SY-SUBRC SY-MSGID SY-MSGTY SY-MSGNO
               SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*   Perform to update <lf_vbap> values
    PERFORM VBAP_BEARBEITEN(SAPFV45P).

*   Perform for filling VBEP with default values. This will take care of schedule lines of the item
    PERFORM VBEP_FUELLEN(SAPFV45E).
*   Perform to check quantity
    PERFORM VBEP-WMENG_PRUEFEN(SAPFV45E)
      USING GC_XMARK
      CHANGING SY-SUBRC SY-MSGID SY-MSGTY SY-MSGNO
               SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*   Perform to update VBEP values
    PERFORM VBEP_BEARBEITEN(SAPFV45E).
*   Perform to fill conditions and pricing data
    PERFORM VBAP_BEARBEITEN_ENDE(SAPFV45P).
  ENDLOOP.
**   Clear selected item in I<lf_vbap>[]
*  CLEAR: LS_I<lf_vbap>.
*  MODIFY I<lf_vbap>[] FROM LS_I<lf_vbap>
*    TRANSPORTING SELKZ WHERE POSNR <> SPACE.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form SO_ITEM_ADD_OPT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_VBAP
*&      --> LS_SDPR
*&      <-- LT_SDPR_D_ALV
*&---------------------------------------------------------------------*
FORM SO_ITEM_ADD_OPT
  USING   LPS_VBAP TYPE VBAPVB
          LPS_SDPR TYPE ZST_SDPR
 CHANGING LPT_SDPR_D_ALV  TYPE ZTT_BM_SDPR_D_ALV.
  DATA:
    LS_SDPR_D_ALV  TYPE ZST_BM_SDPR_D_ALV.

  CLEAR: LS_SDPR_D_ALV.
*  LS_SDPR_D_ALV-UEPOS = LPS_VBAP-POSNR.
  LS_SDPR_D_ALV-ADACN = LPS_VBAP-POSNR.
  MOVE-CORRESPONDING LPS_SDPR TO LS_SDPR_D_ALV.
  LOOP AT LPS_SDPR-DETAIL INTO DATA(LS_DETAIL).
    MOVE-CORRESPONDING LS_DETAIL TO LS_SDPR_D_ALV.
    APPEND LS_SDPR_D_ALV TO LPT_SDPR_D_ALV.
  ENDLOOP.

ENDFORM.
