FUNCTION F4IF_SHLP_EXIT_SDPR_FIELDNAME.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------

* EXIT immediately, if you do not want to handle this step
  IF CALLCONTROL-STEP <> 'SELONE' AND
     CALLCONTROL-STEP <> 'SELECT' AND
     " AND SO ON
     CALLCONTROL-STEP <> 'DISP'.
    EXIT.
  ENDIF.

*"----------------------------------------------------------------------
* STEP SELONE  (Select one of the elementary searchhelps)
*"----------------------------------------------------------------------
* This step is only called for collective searchhelps. It may be used
* to reduce the amount of elementary searchhelps given in SHLP_TAB.
* The compound searchhelp is given in SHLP.
* If you do not change CALLCONTROL-STEP, the next step is the
* dialog, to select one of the elementary searchhelps.
* If you want to skip this dialog, you have to return the selected
* elementary searchhelp in SHLP and to change CALLCONTROL-STEP to
* either to 'PRESEL' or to 'SELECT'.
  IF CALLCONTROL-STEP = 'SELONE'.
*   PERFORM SELONE .........
    EXIT.
  ENDIF.

*"----------------------------------------------------------------------
* STEP PRESEL  (Enter selection conditions)
*"----------------------------------------------------------------------
* This step allows you, to influence the selection conditions either
* before they are displayed or in order to skip the dialog completely.
* If you want to skip the dialog, you should change CALLCONTROL-STEP
* to 'SELECT'.
* Normaly only SHLP-SELOPT should be changed in this step.
  IF CALLCONTROL-STEP = 'PRESEL'.
*   PERFORM PRESEL ..........
    EXIT.
  ENDIF.
*"----------------------------------------------------------------------
* STEP SELECT    (Select values)
*"----------------------------------------------------------------------
* This step may be used to overtake the data selection completely.
* To skip the standard seletion, you should return 'DISP' as following
* step in CALLCONTROL-STEP.
* Normally RECORD_TAB should be filled after this step.
* Standard function module F4UT_RESULTS_MAP may be very helpfull in this
* step.
  IF CALLCONTROL-STEP = 'SELECT'.
    DATA:
      LT_FIELDNAME TYPE TABLE OF ZST_SDPR_FIELDNAME,
      LS_SELOPT    TYPE DDSHSELOPT,
      LR_TABNAME   TYPE RANGE OF TABNAME,
      LS_TABNAME   LIKE LINE OF LR_TABNAME.

    READ TABLE SHLP_TAB INDEX 1.
    LOOP AT SHLP_TAB-SELOPT INTO LS_SELOPT
      WHERE SHLPFIELD = 'TABNAME'.
      MOVE-CORRESPONDING LS_SELOPT TO LS_TABNAME.
      APPEND LS_TABNAME TO LR_TABNAME.
    ENDLOOP.
    SELECT D~TABNAME
           D~FIELDNAME
           F~ROLLNAME
           DDTEXT
      FROM ZTB_BM_SDPR_DIM AS D INNER JOIN DD03L AS F
        ON D~TABNAME = F~TABNAME AND D~FIELDNAME = F~FIELDNAME
      LEFT JOIN DD04T AS T
        ON F~ROLLNAME = T~ROLLNAME AND T~DDLANGUAGE = SY-LANGU
      INTO TABLE LT_FIELDNAME
     WHERE D~TABNAME IN LR_TABNAME.

    CALL FUNCTION 'F4UT_RESULTS_MAP'
      EXPORTING
        SOURCE_STRUCTURE  = 'ZST_SDPR_FIELDNAME'
      TABLES
        SHLP_TAB          = SHLP_TAB
        RECORD_TAB        = RECORD_TAB
        SOURCE_TAB        = LT_FIELDNAME
      CHANGING
        SHLP              = SHLP
        CALLCONTROL       = CALLCONTROL
      EXCEPTIONS
        ILLEGAL_STRUCTURE = 1
        OTHERS            = 2.
    IF SY-SUBRC = 0.
      CALLCONTROL-STEP = 'DISP'.
    ELSE.
      CALLCONTROL-STEP = 'EXIT'.
    ENDIF.
    EXIT. "Don't process STEP DISP additionally in this call.
  ENDIF.
*"----------------------------------------------------------------------
* STEP DISP     (Display values)
*"----------------------------------------------------------------------
* This step is called, before the selected data is displayed.
* You can e.g. modify or reduce the data in RECORD_TAB
* according to the users authority.
* If you want to get the standard display dialog afterwards, you
* should not change CALLCONTROL-STEP.
* If you want to overtake the dialog on you own, you must return
* the following values in CALLCONTROL-STEP:
* - "RETURN" if one line was selected. The selected line must be
*   the only record left in RECORD_TAB. The corresponding fields of
*   this line are entered into the screen.
* - "EXIT" if the values request should be aborted
* - "PRESEL" if you want to return to the selection dialog
* Standard function modules F4UT_PARAMETER_VALUE_GET and
* F4UT_PARAMETER_RESULTS_PUT may be very helpfull in this step.
  IF CALLCONTROL-STEP = 'DISP'.
*   PERFORM AUTHORITY_CHECK TABLES RECORD_TAB SHLP_TAB
*                           CHANGING SHLP CALLCONTROL.
    EXIT.
  ENDIF.
ENDFUNCTION.
