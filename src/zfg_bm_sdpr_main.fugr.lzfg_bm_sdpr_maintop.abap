FUNCTION-POOL ZFG_BM_SDPR_MAIN           MESSAGE-ID SV.

* INCLUDE LZFG_BM_SDPR_MAIND...              " Local class definition
  INCLUDE LSVIMDAT                                . "general data decl.
  INCLUDE LZFG_BM_SDPR_MAINT00                    . "view rel. data dcl.'

  TABLES: MARA, MAKT, DD03L, DD02L, DD02T, DD04L, DD04T,
    T189, TVPT, T189T, TVAPT, TVM3, TVM3T.
