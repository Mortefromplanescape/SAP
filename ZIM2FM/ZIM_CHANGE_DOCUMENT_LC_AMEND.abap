FUNCTION ZIM_CHANGE_DOCUMENT_LC_AMEND.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     REFERENCE(UPD_CHNGIND) LIKE  CDPOS-CHNGIND
*"     REFERENCE(N_ZTMLCAMHD) LIKE  ZTMLCAMHD STRUCTURE  ZTMLCAMHD
*"     REFERENCE(O_ZTMLCAMHD) LIKE  ZTMLCAMHD STRUCTURE  ZTMLCAMHD
*"     REFERENCE(N_ZTREQHD) LIKE  ZTREQHD STRUCTURE  ZTREQHD
*"     REFERENCE(O_ZTREQHD) LIKE  ZTREQHD STRUCTURE  ZTREQHD
*"     REFERENCE(N_ZTREQST) LIKE  ZTREQST STRUCTURE  ZTREQST
*"     REFERENCE(O_ZTREQST) LIKE  ZTREQST STRUCTURE  ZTREQST
*"----------------------------------------------------------------------
   data : objecid      like    CDHDR-OBJECTID.

   refresh : it_CdtXT.
   clear : it_CdtXT.
   objecid = N_ZTREQST+3(15).

   CALL FUNCTION 'ZILCADOC_WRITE_DOCUMENT'
       EXPORTING
            OBJECTID           =    objecid
            TCODE              =    SY-TCODE
            UTIME              =    SY-UZEIT
            UDATE              =    SY-DATUM
            USERNAME           =    SY-UNAME
            N_ZTMLCAMHD        =    N_ZTMLCAMHD
            O_ZTMLCAMHD        =    O_ZTMLCAMHD
            UPD_ZTMLCAMHD      =    UPD_CHNGIND
            N_ZTREQHD          =    N_ZTREQHD
            O_ZTREQHD          =    O_ZTREQHD
            UPD_ZTREQHD        =    UPD_CHNGIND
            N_ZTREQST          =    N_ZTREQST
            O_ZTREQST          =    O_ZTREQST
            UPD_ZTREQST        =    UPD_CHNGIND
*           cdoc_upd_object    =    UPD_CHNGIND
            object_change_indicator = 'U'
            PLANNED_OR_REAL_CHANGES = ''
            NO_CHANGE_POINTERS      = ''
            UPD_ICDTXT_ZILCADOC     = ''
      tables
            ICDTXT_ZILCADOC     =    it_CdtXT.

ENDFUNCTION.
