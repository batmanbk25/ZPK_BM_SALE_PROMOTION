FUNCTION-POOL ZFG_BM_SALE_PROMOTION.        "MESSAGE-ID ..

* INCLUDE LZFG_BM_SALE_PROMOTIOND...         " Local class definition
INCLUDE ZIN_COMMONTOP.

**********************************************************************
* DATA
**********************************************************************
TABLES: VBAK, VBAP, VBKD.
DATA:
  GT_SDPR TYPE TABLE OF ZST_SDPR,
  GT_SDPR_D_ALV TYPE ZTT_BM_SDPR_D_ALV.
