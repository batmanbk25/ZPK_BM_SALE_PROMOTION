*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTB_BM_SDPR_DIM.................................*
DATA:  BEGIN OF STATUS_ZTB_BM_SDPR_DIM               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTB_BM_SDPR_DIM               .
CONTROLS: TCTRL_ZTB_BM_SDPR_DIM
            TYPE TABLEVIEW USING SCREEN '0106'.
*...processing: ZVI_BM_SDPR_C...................................*
TABLES: ZVI_BM_SDPR_C, *ZVI_BM_SDPR_C. "view work areas
CONTROLS: TCTRL_ZVI_BM_SDPR_C
TYPE TABLEVIEW USING SCREEN '0102'.
DATA: BEGIN OF STATUS_ZVI_BM_SDPR_C. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVI_BM_SDPR_C.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVI_BM_SDPR_C_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVI_BM_SDPR_C.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVI_BM_SDPR_C_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVI_BM_SDPR_C_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVI_BM_SDPR_C.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVI_BM_SDPR_C_TOTAL.

*...processing: ZVI_BM_SDPR_D...................................*
TABLES: ZVI_BM_SDPR_D, *ZVI_BM_SDPR_D. "view work areas
CONTROLS: TCTRL_ZVI_BM_SDPR_D
TYPE TABLEVIEW USING SCREEN '0104'.
DATA: BEGIN OF STATUS_ZVI_BM_SDPR_D. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVI_BM_SDPR_D.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVI_BM_SDPR_D_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVI_BM_SDPR_D.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVI_BM_SDPR_D_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVI_BM_SDPR_D_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVI_BM_SDPR_D.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVI_BM_SDPR_D_TOTAL.

*...processing: ZVI_BM_SDPR_H...................................*
TABLES: ZVI_BM_SDPR_H, *ZVI_BM_SDPR_H. "view work areas
CONTROLS: TCTRL_ZVI_BM_SDPR_H
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_ZVI_BM_SDPR_H. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVI_BM_SDPR_H.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVI_BM_SDPR_H_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVI_BM_SDPR_H.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVI_BM_SDPR_H_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVI_BM_SDPR_H_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVI_BM_SDPR_H.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVI_BM_SDPR_H_TOTAL.

*.........table declarations:.................................*
TABLES: *ZTB_BM_SDPR_DIM               .
TABLES: T001                           .
TABLES: TVAK                           .
TABLES: ZTB_BM_SDPR_C                  .
TABLES: ZTB_BM_SDPR_D                  .
TABLES: ZTB_BM_SDPR_DIM                .
TABLES: ZTB_BM_SDPR_H                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
