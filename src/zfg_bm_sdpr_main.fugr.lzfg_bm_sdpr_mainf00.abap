*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVI_BM_SDPR_C...................................*
FORM GET_DATA_ZVI_BM_SDPR_C.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTB_BM_SDPR_C WHERE
(VIM_WHERETAB) .
    CLEAR ZVI_BM_SDPR_C .
ZVI_BM_SDPR_C-MANDT =
ZTB_BM_SDPR_C-MANDT .
ZVI_BM_SDPR_C-PRMNR =
ZTB_BM_SDPR_C-PRMNR .
ZVI_BM_SDPR_C-BUKRS =
ZTB_BM_SDPR_C-BUKRS .
ZVI_BM_SDPR_C-CONDID =
ZTB_BM_SDPR_C-CONDID .
ZVI_BM_SDPR_C-RTABLE =
ZTB_BM_SDPR_C-RTABLE .
ZVI_BM_SDPR_C-RFIELD =
ZTB_BM_SDPR_C-RFIELD .
ZVI_BM_SDPR_C-FDESC =
ZTB_BM_SDPR_C-FDESC .
ZVI_BM_SDPR_C-RANGID =
ZTB_BM_SDPR_C-RANGID .
ZVI_BM_SDPR_C-RSIGN =
ZTB_BM_SDPR_C-RSIGN .
ZVI_BM_SDPR_C-ROPTI =
ZTB_BM_SDPR_C-ROPTI .
ZVI_BM_SDPR_C-RLOW =
ZTB_BM_SDPR_C-RLOW .
ZVI_BM_SDPR_C-LDESC =
ZTB_BM_SDPR_C-LDESC .
ZVI_BM_SDPR_C-RHIGH =
ZTB_BM_SDPR_C-RHIGH .
ZVI_BM_SDPR_C-HDESC =
ZTB_BM_SDPR_C-HDESC .
    SELECT * FROM DD03L WHERE
TABNAME = ZTB_BM_SDPR_C-RTABLE AND
FIELDNAME = ZTB_BM_SDPR_C-RFIELD .
      SELECT * FROM DD04L WHERE
ROLLNAME = DD03L-ROLLNAME .
        EXIT.
      ENDSELECT.
      EXIT.
    ENDSELECT.
    SELECT * FROM DD02T WHERE
TABNAME = ZTB_BM_SDPR_C-RTABLE AND
DDLANGUAGE = 'EN' .
ZVI_BM_SDPR_C-RTABTX =
DD02T-DDTEXT .
      EXIT.
    ENDSELECT.
<VIM_TOTAL_STRUC> = ZVI_BM_SDPR_C.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVI_BM_SDPR_C .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVI_BM_SDPR_C.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVI_BM_SDPR_C-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTB_BM_SDPR_C WHERE
  PRMNR = ZVI_BM_SDPR_C-PRMNR AND
  BUKRS = ZVI_BM_SDPR_C-BUKRS AND
  CONDID = ZVI_BM_SDPR_C-CONDID AND
  RTABLE = ZVI_BM_SDPR_C-RTABLE AND
  RFIELD = ZVI_BM_SDPR_C-RFIELD AND
  RANGID = ZVI_BM_SDPR_C-RANGID .
    IF SY-SUBRC = 0.
    DELETE ZTB_BM_SDPR_C .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTB_BM_SDPR_C WHERE
  PRMNR = ZVI_BM_SDPR_C-PRMNR AND
  BUKRS = ZVI_BM_SDPR_C-BUKRS AND
  CONDID = ZVI_BM_SDPR_C-CONDID AND
  RTABLE = ZVI_BM_SDPR_C-RTABLE AND
  RFIELD = ZVI_BM_SDPR_C-RFIELD AND
  RANGID = ZVI_BM_SDPR_C-RANGID .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTB_BM_SDPR_C.
    ENDIF.
ZTB_BM_SDPR_C-MANDT =
ZVI_BM_SDPR_C-MANDT .
ZTB_BM_SDPR_C-PRMNR =
ZVI_BM_SDPR_C-PRMNR .
ZTB_BM_SDPR_C-BUKRS =
ZVI_BM_SDPR_C-BUKRS .
ZTB_BM_SDPR_C-CONDID =
ZVI_BM_SDPR_C-CONDID .
ZTB_BM_SDPR_C-RTABLE =
ZVI_BM_SDPR_C-RTABLE .
ZTB_BM_SDPR_C-RFIELD =
ZVI_BM_SDPR_C-RFIELD .
ZTB_BM_SDPR_C-FDESC =
ZVI_BM_SDPR_C-FDESC .
ZTB_BM_SDPR_C-RANGID =
ZVI_BM_SDPR_C-RANGID .
ZTB_BM_SDPR_C-RSIGN =
ZVI_BM_SDPR_C-RSIGN .
ZTB_BM_SDPR_C-ROPTI =
ZVI_BM_SDPR_C-ROPTI .
ZTB_BM_SDPR_C-RLOW =
ZVI_BM_SDPR_C-RLOW .
ZTB_BM_SDPR_C-LDESC =
ZVI_BM_SDPR_C-LDESC .
ZTB_BM_SDPR_C-RHIGH =
ZVI_BM_SDPR_C-RHIGH .
ZTB_BM_SDPR_C-HDESC =
ZVI_BM_SDPR_C-HDESC .
    IF SY-SUBRC = 0.
    UPDATE ZTB_BM_SDPR_C ##WARN_OK.
    ELSE.
    INSERT ZTB_BM_SDPR_C .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVI_BM_SDPR_C-UPD_FLAG,
STATUS_ZVI_BM_SDPR_C-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVI_BM_SDPR_C.
  SELECT SINGLE * FROM ZTB_BM_SDPR_C WHERE
PRMNR = ZVI_BM_SDPR_C-PRMNR AND
BUKRS = ZVI_BM_SDPR_C-BUKRS AND
CONDID = ZVI_BM_SDPR_C-CONDID AND
RTABLE = ZVI_BM_SDPR_C-RTABLE AND
RFIELD = ZVI_BM_SDPR_C-RFIELD AND
RANGID = ZVI_BM_SDPR_C-RANGID .
ZVI_BM_SDPR_C-MANDT =
ZTB_BM_SDPR_C-MANDT .
ZVI_BM_SDPR_C-PRMNR =
ZTB_BM_SDPR_C-PRMNR .
ZVI_BM_SDPR_C-BUKRS =
ZTB_BM_SDPR_C-BUKRS .
ZVI_BM_SDPR_C-CONDID =
ZTB_BM_SDPR_C-CONDID .
ZVI_BM_SDPR_C-RTABLE =
ZTB_BM_SDPR_C-RTABLE .
ZVI_BM_SDPR_C-RFIELD =
ZTB_BM_SDPR_C-RFIELD .
ZVI_BM_SDPR_C-FDESC =
ZTB_BM_SDPR_C-FDESC .
ZVI_BM_SDPR_C-RANGID =
ZTB_BM_SDPR_C-RANGID .
ZVI_BM_SDPR_C-RSIGN =
ZTB_BM_SDPR_C-RSIGN .
ZVI_BM_SDPR_C-ROPTI =
ZTB_BM_SDPR_C-ROPTI .
ZVI_BM_SDPR_C-RLOW =
ZTB_BM_SDPR_C-RLOW .
ZVI_BM_SDPR_C-LDESC =
ZTB_BM_SDPR_C-LDESC .
ZVI_BM_SDPR_C-RHIGH =
ZTB_BM_SDPR_C-RHIGH .
ZVI_BM_SDPR_C-HDESC =
ZTB_BM_SDPR_C-HDESC .
    SELECT * FROM DD03L WHERE
TABNAME = ZTB_BM_SDPR_C-RTABLE AND
FIELDNAME = ZTB_BM_SDPR_C-RFIELD .
      SELECT * FROM DD04L WHERE
ROLLNAME = DD03L-ROLLNAME .
        EXIT.
      ENDSELECT.
      IF SY-SUBRC NE 0.
        CLEAR SY-SUBRC.
      ENDIF.
      EXIT.
    ENDSELECT.
    IF SY-SUBRC NE 0.
      CLEAR SY-SUBRC.
    ENDIF.
    SELECT * FROM DD02T WHERE
TABNAME = ZTB_BM_SDPR_C-RTABLE AND
DDLANGUAGE = 'EN' .
ZVI_BM_SDPR_C-RTABTX =
DD02T-DDTEXT .
      EXIT.
    ENDSELECT.
    IF SY-SUBRC NE 0.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_C-RTABTX .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVI_BM_SDPR_C USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVI_BM_SDPR_C-PRMNR TO
ZTB_BM_SDPR_C-PRMNR .
MOVE ZVI_BM_SDPR_C-BUKRS TO
ZTB_BM_SDPR_C-BUKRS .
MOVE ZVI_BM_SDPR_C-CONDID TO
ZTB_BM_SDPR_C-CONDID .
MOVE ZVI_BM_SDPR_C-RTABLE TO
ZTB_BM_SDPR_C-RTABLE .
MOVE ZVI_BM_SDPR_C-RFIELD TO
ZTB_BM_SDPR_C-RFIELD .
MOVE ZVI_BM_SDPR_C-RANGID TO
ZTB_BM_SDPR_C-RANGID .
MOVE ZVI_BM_SDPR_C-MANDT TO
ZTB_BM_SDPR_C-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTB_BM_SDPR_C'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTB_BM_SDPR_C TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTB_BM_SDPR_C'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZVI_BM_SDPR_C USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZTB_BM_SDPR_C-MANDT =
ZVI_BM_SDPR_C-MANDT .
ZTB_BM_SDPR_C-PRMNR =
ZVI_BM_SDPR_C-PRMNR .
ZTB_BM_SDPR_C-BUKRS =
ZVI_BM_SDPR_C-BUKRS .
ZTB_BM_SDPR_C-CONDID =
ZVI_BM_SDPR_C-CONDID .
ZTB_BM_SDPR_C-RTABLE =
ZVI_BM_SDPR_C-RTABLE .
ZTB_BM_SDPR_C-RFIELD =
ZVI_BM_SDPR_C-RFIELD .
ZTB_BM_SDPR_C-FDESC =
ZVI_BM_SDPR_C-FDESC .
ZTB_BM_SDPR_C-RANGID =
ZVI_BM_SDPR_C-RANGID .
ZTB_BM_SDPR_C-RSIGN =
ZVI_BM_SDPR_C-RSIGN .
ZTB_BM_SDPR_C-ROPTI =
ZVI_BM_SDPR_C-ROPTI .
ZTB_BM_SDPR_C-RLOW =
ZVI_BM_SDPR_C-RLOW .
ZTB_BM_SDPR_C-LDESC =
ZVI_BM_SDPR_C-LDESC .
ZTB_BM_SDPR_C-RHIGH =
ZVI_BM_SDPR_C-RHIGH .
ZTB_BM_SDPR_C-HDESC =
ZVI_BM_SDPR_C-HDESC .
    SELECT * FROM DD03L WHERE
TABNAME = ZTB_BM_SDPR_C-RTABLE AND
FIELDNAME = ZTB_BM_SDPR_C-RFIELD .
      SELECT * FROM DD04L WHERE
ROLLNAME = DD03L-ROLLNAME .
        EXIT.
      ENDSELECT.
      IF SY-SUBRC NE 0.
        CLEAR SY-SUBRC.
      ENDIF.
      EXIT.
    ENDSELECT.
    IF SY-SUBRC NE 0.
      CLEAR SY-SUBRC.
    ENDIF.
    SELECT * FROM DD02T WHERE
TABNAME = ZTB_BM_SDPR_C-RTABLE AND
DDLANGUAGE = 'EN' .
ZVI_BM_SDPR_C-RTABTX =
DD02T-DDTEXT .
      EXIT.
    ENDSELECT.
    IF SY-SUBRC NE 0.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_C-RTABTX .
    ENDIF.
ENDFORM.
*...processing: ZVI_BM_SDPR_D...................................*
FORM GET_DATA_ZVI_BM_SDPR_D.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTB_BM_SDPR_D WHERE
(VIM_WHERETAB) .
    CLEAR ZVI_BM_SDPR_D .
ZVI_BM_SDPR_D-MANDT =
ZTB_BM_SDPR_D-MANDT .
ZVI_BM_SDPR_D-PRMNR =
ZTB_BM_SDPR_D-PRMNR .
ZVI_BM_SDPR_D-BUKRS =
ZTB_BM_SDPR_D-BUKRS .
ZVI_BM_SDPR_D-POSNR =
ZTB_BM_SDPR_D-POSNR .
ZVI_BM_SDPR_D-PSTYV =
ZTB_BM_SDPR_D-PSTYV .
ZVI_BM_SDPR_D-PLTYP =
ZTB_BM_SDPR_D-PLTYP .
ZVI_BM_SDPR_D-MATNR =
ZTB_BM_SDPR_D-MATNR .
ZVI_BM_SDPR_D-MENGE =
ZTB_BM_SDPR_D-MENGE .
ZVI_BM_SDPR_D-MEINS =
ZTB_BM_SDPR_D-MEINS .
    SELECT * FROM ZTB_BM_SDPR_H WHERE
PRMNR = ZTB_BM_SDPR_D-PRMNR .
ZVI_BM_SDPR_D-AUART =
ZTB_BM_SDPR_H-AUART .
      EXIT.
    ENDSELECT.
    SELECT SINGLE * FROM MARA WHERE
MATNR = ZTB_BM_SDPR_D-MATNR .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MAKT WHERE
MATNR = MARA-MATNR AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-MAKTX =
MAKT-MAKTX .
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM TVPT WHERE
PSTYV = ZTB_BM_SDPR_D-PSTYV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM TVAPT WHERE
PSTYV = TVPT-PSTYV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-VTEXT =
TVAPT-VTEXT .
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM TVM3 WHERE
MVGR3 = ZTB_BM_SDPR_D-PLTYP .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM TVM3T WHERE
MVGR3 = TVM3-MVGR3 AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-BEZEI =
TVM3T-BEZEI .
      ENDIF.
    ENDIF.
<VIM_TOTAL_STRUC> = ZVI_BM_SDPR_D.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVI_BM_SDPR_D .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVI_BM_SDPR_D.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVI_BM_SDPR_D-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTB_BM_SDPR_D WHERE
  PRMNR = ZVI_BM_SDPR_D-PRMNR AND
  BUKRS = ZVI_BM_SDPR_D-BUKRS AND
  POSNR = ZVI_BM_SDPR_D-POSNR .
    IF SY-SUBRC = 0.
    DELETE ZTB_BM_SDPR_D .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTB_BM_SDPR_D WHERE
  PRMNR = ZVI_BM_SDPR_D-PRMNR AND
  BUKRS = ZVI_BM_SDPR_D-BUKRS AND
  POSNR = ZVI_BM_SDPR_D-POSNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTB_BM_SDPR_D.
    ENDIF.
ZTB_BM_SDPR_D-MANDT =
ZVI_BM_SDPR_D-MANDT .
ZTB_BM_SDPR_D-PRMNR =
ZVI_BM_SDPR_D-PRMNR .
ZTB_BM_SDPR_D-BUKRS =
ZVI_BM_SDPR_D-BUKRS .
ZTB_BM_SDPR_D-POSNR =
ZVI_BM_SDPR_D-POSNR .
ZTB_BM_SDPR_D-PSTYV =
ZVI_BM_SDPR_D-PSTYV .
ZTB_BM_SDPR_D-PLTYP =
ZVI_BM_SDPR_D-PLTYP .
ZTB_BM_SDPR_D-MATNR =
ZVI_BM_SDPR_D-MATNR .
ZTB_BM_SDPR_D-MENGE =
ZVI_BM_SDPR_D-MENGE .
ZTB_BM_SDPR_D-MEINS =
ZVI_BM_SDPR_D-MEINS .
    IF SY-SUBRC = 0.
    UPDATE ZTB_BM_SDPR_D ##WARN_OK.
    ELSE.
    INSERT ZTB_BM_SDPR_D .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVI_BM_SDPR_D-UPD_FLAG,
STATUS_ZVI_BM_SDPR_D-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVI_BM_SDPR_D.
  SELECT SINGLE * FROM ZTB_BM_SDPR_D WHERE
PRMNR = ZVI_BM_SDPR_D-PRMNR AND
BUKRS = ZVI_BM_SDPR_D-BUKRS AND
POSNR = ZVI_BM_SDPR_D-POSNR .
ZVI_BM_SDPR_D-MANDT =
ZTB_BM_SDPR_D-MANDT .
ZVI_BM_SDPR_D-PRMNR =
ZTB_BM_SDPR_D-PRMNR .
ZVI_BM_SDPR_D-BUKRS =
ZTB_BM_SDPR_D-BUKRS .
ZVI_BM_SDPR_D-POSNR =
ZTB_BM_SDPR_D-POSNR .
ZVI_BM_SDPR_D-PSTYV =
ZTB_BM_SDPR_D-PSTYV .
ZVI_BM_SDPR_D-PLTYP =
ZTB_BM_SDPR_D-PLTYP .
ZVI_BM_SDPR_D-MATNR =
ZTB_BM_SDPR_D-MATNR .
ZVI_BM_SDPR_D-MENGE =
ZTB_BM_SDPR_D-MENGE .
ZVI_BM_SDPR_D-MEINS =
ZTB_BM_SDPR_D-MEINS .
    SELECT * FROM ZTB_BM_SDPR_H WHERE
PRMNR = ZTB_BM_SDPR_D-PRMNR .
ZVI_BM_SDPR_D-AUART =
ZTB_BM_SDPR_H-AUART .
      EXIT.
    ENDSELECT.
    IF SY-SUBRC NE 0.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_D-AUART .
    ENDIF.
    SELECT SINGLE * FROM MARA WHERE
MATNR = ZTB_BM_SDPR_D-MATNR .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MAKT WHERE
MATNR = MARA-MATNR AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-MAKTX =
MAKT-MAKTX .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZVI_BM_SDPR_D-MAKTX .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_D-MAKTX .
    ENDIF.
    SELECT SINGLE * FROM TVPT WHERE
PSTYV = ZTB_BM_SDPR_D-PSTYV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM TVAPT WHERE
PSTYV = TVPT-PSTYV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-VTEXT =
TVAPT-VTEXT .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZVI_BM_SDPR_D-VTEXT .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_D-VTEXT .
    ENDIF.
    SELECT SINGLE * FROM TVM3 WHERE
MVGR3 = ZTB_BM_SDPR_D-PLTYP .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM TVM3T WHERE
MVGR3 = TVM3-MVGR3 AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-BEZEI =
TVM3T-BEZEI .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZVI_BM_SDPR_D-BEZEI .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_D-BEZEI .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVI_BM_SDPR_D USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVI_BM_SDPR_D-PRMNR TO
ZTB_BM_SDPR_D-PRMNR .
MOVE ZVI_BM_SDPR_D-BUKRS TO
ZTB_BM_SDPR_D-BUKRS .
MOVE ZVI_BM_SDPR_D-POSNR TO
ZTB_BM_SDPR_D-POSNR .
MOVE ZVI_BM_SDPR_D-MANDT TO
ZTB_BM_SDPR_D-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTB_BM_SDPR_D'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTB_BM_SDPR_D TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTB_BM_SDPR_D'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZVI_BM_SDPR_D USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZTB_BM_SDPR_D-MANDT =
ZVI_BM_SDPR_D-MANDT .
ZTB_BM_SDPR_D-PRMNR =
ZVI_BM_SDPR_D-PRMNR .
ZTB_BM_SDPR_D-BUKRS =
ZVI_BM_SDPR_D-BUKRS .
ZTB_BM_SDPR_D-POSNR =
ZVI_BM_SDPR_D-POSNR .
ZTB_BM_SDPR_D-PSTYV =
ZVI_BM_SDPR_D-PSTYV .
ZTB_BM_SDPR_D-PLTYP =
ZVI_BM_SDPR_D-PLTYP .
ZTB_BM_SDPR_D-MATNR =
ZVI_BM_SDPR_D-MATNR .
ZTB_BM_SDPR_D-MENGE =
ZVI_BM_SDPR_D-MENGE .
ZTB_BM_SDPR_D-MEINS =
ZVI_BM_SDPR_D-MEINS .
    SELECT * FROM ZTB_BM_SDPR_H WHERE
PRMNR = ZTB_BM_SDPR_D-PRMNR .
ZVI_BM_SDPR_D-AUART =
ZTB_BM_SDPR_H-AUART .
      EXIT.
    ENDSELECT.
    IF SY-SUBRC NE 0.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_D-AUART .
    ENDIF.
    SELECT SINGLE * FROM MARA WHERE
MATNR = ZTB_BM_SDPR_D-MATNR .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MAKT WHERE
MATNR = MARA-MATNR AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-MAKTX =
MAKT-MAKTX .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZVI_BM_SDPR_D-MAKTX .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_D-MAKTX .
    ENDIF.
    SELECT SINGLE * FROM TVPT WHERE
PSTYV = ZTB_BM_SDPR_D-PSTYV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM TVAPT WHERE
PSTYV = TVPT-PSTYV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-VTEXT =
TVAPT-VTEXT .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZVI_BM_SDPR_D-VTEXT .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_D-VTEXT .
    ENDIF.
    SELECT SINGLE * FROM TVM3 WHERE
MVGR3 = ZTB_BM_SDPR_D-PLTYP .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM TVM3T WHERE
MVGR3 = TVM3-MVGR3 AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_D-BEZEI =
TVM3T-BEZEI .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZVI_BM_SDPR_D-BEZEI .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_D-BEZEI .
    ENDIF.
ENDFORM.
*...processing: ZVI_BM_SDPR_H...................................*
FORM GET_DATA_ZVI_BM_SDPR_H.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTB_BM_SDPR_H WHERE
(VIM_WHERETAB) .
    CLEAR ZVI_BM_SDPR_H .
ZVI_BM_SDPR_H-MANDT =
ZTB_BM_SDPR_H-MANDT .
ZVI_BM_SDPR_H-PRMNR =
ZTB_BM_SDPR_H-PRMNR .
ZVI_BM_SDPR_H-BUKRS =
ZTB_BM_SDPR_H-BUKRS .
ZVI_BM_SDPR_H-AUART =
ZTB_BM_SDPR_H-AUART .
ZVI_BM_SDPR_H-DESCR =
ZTB_BM_SDPR_H-DESCR .
ZVI_BM_SDPR_H-XBLNR =
ZTB_BM_SDPR_H-XBLNR .
ZVI_BM_SDPR_H-DATBE =
ZTB_BM_SDPR_H-DATBE .
ZVI_BM_SDPR_H-DATEN =
ZTB_BM_SDPR_H-DATEN .
ZVI_BM_SDPR_H-ACTIVE =
ZTB_BM_SDPR_H-ACTIVE .
ZVI_BM_SDPR_H-CRUSR =
ZTB_BM_SDPR_H-CRUSR .
ZVI_BM_SDPR_H-CRDAT =
ZTB_BM_SDPR_H-CRDAT .
ZVI_BM_SDPR_H-CHUSR =
ZTB_BM_SDPR_H-CHUSR .
ZVI_BM_SDPR_H-CHDAT =
ZTB_BM_SDPR_H-CHDAT .
    SELECT SINGLE * FROM T001 WHERE
BUKRS = ZTB_BM_SDPR_H-BUKRS .
    IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_H-BUTXT =
T001-BUTXT .
    ENDIF.
    SELECT SINGLE * FROM TVAK WHERE
AUART = ZTB_BM_SDPR_H-AUART .
    IF SY-SUBRC EQ 0.
    ENDIF.
<VIM_TOTAL_STRUC> = ZVI_BM_SDPR_H.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVI_BM_SDPR_H .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVI_BM_SDPR_H.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVI_BM_SDPR_H-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTB_BM_SDPR_H WHERE
  PRMNR = ZVI_BM_SDPR_H-PRMNR AND
  BUKRS = ZVI_BM_SDPR_H-BUKRS .
    IF SY-SUBRC = 0.
    DELETE ZTB_BM_SDPR_H .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTB_BM_SDPR_H WHERE
  PRMNR = ZVI_BM_SDPR_H-PRMNR AND
  BUKRS = ZVI_BM_SDPR_H-BUKRS .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTB_BM_SDPR_H.
    ENDIF.
ZTB_BM_SDPR_H-MANDT =
ZVI_BM_SDPR_H-MANDT .
ZTB_BM_SDPR_H-PRMNR =
ZVI_BM_SDPR_H-PRMNR .
ZTB_BM_SDPR_H-BUKRS =
ZVI_BM_SDPR_H-BUKRS .
ZTB_BM_SDPR_H-AUART =
ZVI_BM_SDPR_H-AUART .
ZTB_BM_SDPR_H-DESCR =
ZVI_BM_SDPR_H-DESCR .
ZTB_BM_SDPR_H-XBLNR =
ZVI_BM_SDPR_H-XBLNR .
ZTB_BM_SDPR_H-DATBE =
ZVI_BM_SDPR_H-DATBE .
ZTB_BM_SDPR_H-DATEN =
ZVI_BM_SDPR_H-DATEN .
ZTB_BM_SDPR_H-ACTIVE =
ZVI_BM_SDPR_H-ACTIVE .
ZTB_BM_SDPR_H-CRUSR =
ZVI_BM_SDPR_H-CRUSR .
ZTB_BM_SDPR_H-CRDAT =
ZVI_BM_SDPR_H-CRDAT .
ZTB_BM_SDPR_H-CHUSR =
ZVI_BM_SDPR_H-CHUSR .
ZTB_BM_SDPR_H-CHDAT =
ZVI_BM_SDPR_H-CHDAT .
    IF SY-SUBRC = 0.
    UPDATE ZTB_BM_SDPR_H ##WARN_OK.
    ELSE.
    INSERT ZTB_BM_SDPR_H .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVI_BM_SDPR_H-UPD_FLAG,
STATUS_ZVI_BM_SDPR_H-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVI_BM_SDPR_H.
  SELECT SINGLE * FROM ZTB_BM_SDPR_H WHERE
PRMNR = ZVI_BM_SDPR_H-PRMNR AND
BUKRS = ZVI_BM_SDPR_H-BUKRS .
ZVI_BM_SDPR_H-MANDT =
ZTB_BM_SDPR_H-MANDT .
ZVI_BM_SDPR_H-PRMNR =
ZTB_BM_SDPR_H-PRMNR .
ZVI_BM_SDPR_H-BUKRS =
ZTB_BM_SDPR_H-BUKRS .
ZVI_BM_SDPR_H-AUART =
ZTB_BM_SDPR_H-AUART .
ZVI_BM_SDPR_H-DESCR =
ZTB_BM_SDPR_H-DESCR .
ZVI_BM_SDPR_H-XBLNR =
ZTB_BM_SDPR_H-XBLNR .
ZVI_BM_SDPR_H-DATBE =
ZTB_BM_SDPR_H-DATBE .
ZVI_BM_SDPR_H-DATEN =
ZTB_BM_SDPR_H-DATEN .
ZVI_BM_SDPR_H-ACTIVE =
ZTB_BM_SDPR_H-ACTIVE .
ZVI_BM_SDPR_H-CRUSR =
ZTB_BM_SDPR_H-CRUSR .
ZVI_BM_SDPR_H-CRDAT =
ZTB_BM_SDPR_H-CRDAT .
ZVI_BM_SDPR_H-CHUSR =
ZTB_BM_SDPR_H-CHUSR .
ZVI_BM_SDPR_H-CHDAT =
ZTB_BM_SDPR_H-CHDAT .
    SELECT SINGLE * FROM T001 WHERE
BUKRS = ZTB_BM_SDPR_H-BUKRS .
    IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_H-BUTXT =
T001-BUTXT .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_H-BUTXT .
    ENDIF.
    SELECT SINGLE * FROM TVAK WHERE
AUART = ZTB_BM_SDPR_H-AUART .
    IF SY-SUBRC EQ 0.
    ELSE.
      CLEAR SY-SUBRC.
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVI_BM_SDPR_H USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVI_BM_SDPR_H-PRMNR TO
ZTB_BM_SDPR_H-PRMNR .
MOVE ZVI_BM_SDPR_H-BUKRS TO
ZTB_BM_SDPR_H-BUKRS .
MOVE ZVI_BM_SDPR_H-MANDT TO
ZTB_BM_SDPR_H-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTB_BM_SDPR_H'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTB_BM_SDPR_H TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTB_BM_SDPR_H'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZVI_BM_SDPR_H USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZTB_BM_SDPR_H-MANDT =
ZVI_BM_SDPR_H-MANDT .
ZTB_BM_SDPR_H-PRMNR =
ZVI_BM_SDPR_H-PRMNR .
ZTB_BM_SDPR_H-BUKRS =
ZVI_BM_SDPR_H-BUKRS .
ZTB_BM_SDPR_H-AUART =
ZVI_BM_SDPR_H-AUART .
ZTB_BM_SDPR_H-DESCR =
ZVI_BM_SDPR_H-DESCR .
ZTB_BM_SDPR_H-XBLNR =
ZVI_BM_SDPR_H-XBLNR .
ZTB_BM_SDPR_H-DATBE =
ZVI_BM_SDPR_H-DATBE .
ZTB_BM_SDPR_H-DATEN =
ZVI_BM_SDPR_H-DATEN .
ZTB_BM_SDPR_H-ACTIVE =
ZVI_BM_SDPR_H-ACTIVE .
ZTB_BM_SDPR_H-CRUSR =
ZVI_BM_SDPR_H-CRUSR .
ZTB_BM_SDPR_H-CRDAT =
ZVI_BM_SDPR_H-CRDAT .
ZTB_BM_SDPR_H-CHUSR =
ZVI_BM_SDPR_H-CHUSR .
ZTB_BM_SDPR_H-CHDAT =
ZVI_BM_SDPR_H-CHDAT .
    SELECT SINGLE * FROM T001 WHERE
BUKRS = ZTB_BM_SDPR_H-BUKRS .
    IF SY-SUBRC EQ 0.
ZVI_BM_SDPR_H-BUTXT =
T001-BUTXT .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVI_BM_SDPR_H-BUTXT .
    ENDIF.
    SELECT SINGLE * FROM TVAK WHERE
AUART = ZTB_BM_SDPR_H-AUART .
    IF SY-SUBRC EQ 0.
    ELSE.
      CLEAR SY-SUBRC.
    ENDIF.
ENDFORM.

* base table related FORM-routines.............
INCLUDE LSVIMFTX .