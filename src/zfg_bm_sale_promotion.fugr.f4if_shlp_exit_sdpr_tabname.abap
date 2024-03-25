FUNCTION F4IF_SHLP_EXIT_SDPR_TABNAME.
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
       lt_DD02T TYPE TABLE OF DD02t.

    SELECT DISTINCT D~TABNAME DDLANGUAGE AS4LOCAL AS4VERS DDTEXT
      FROM ZTB_BM_SDPR_DIM as d INNER JOIN DD02T as t
        on d~TABNAME = t~TABNAME AND T~DDLANGUAGE = sy-LANGU
      INTO TABLE lt_DD02T.

    CALL FUNCTION 'F4UT_RESULTS_MAP'
     EXPORTING
       SOURCE_STRUCTURE         = 'DD02T'
      TABLES
        SHLP_TAB                 = SHLP_TAB
        RECORD_TAB               = RECORD_TAB
        SOURCE_TAB               = lt_DD02T
      CHANGING
        SHLP                     = SHLP
        CALLCONTROL              = CALLCONTROL
*     EXCEPTIONS
*       ILLEGAL_STRUCTURE        = 1
*       OTHERS                   = 2
              .
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

*   PERFORM STEP_SELECT TABLES RECORD_TAB SHLP_TAB
*                       CHANGING SHLP CALLCONTROL RC.
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
