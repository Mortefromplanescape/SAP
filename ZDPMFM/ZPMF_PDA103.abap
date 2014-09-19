FUNCTION ZPMF_PDA103.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  EXPORTING
*"     VALUE(SUBRC) LIKE  SY-SUBRC
*"  TABLES
*"      T103 STRUCTURE  ZSPM_PDA103
*"      TMSEG STRUCTURE  ZMSEG
*"      MESSTAB STRUCTURE  ZBDCMSG
*"----------------------------------------------------------------------
  DATA : IT_MSEG LIKE TABLE OF MSEG WITH HEADER LINE.
  DATA : L_MATNR  LIKE  EKPO-MATNR,
         L_WERKS LIKE EKPO-WERKS.

  CLEAR : L_MATNR.
  CLEAR : GS_HEADER, GS_CODE,
          GT_ITEM, GT_RETURN,
          MATERIALDOCUMENT, MATDOCUMENTYEAR.
  REFRESH : GT_ITEM, GT_RETURN.

  READ TABLE T103 INDEX 1.

*** GR HEADER DATA ?? ***
  GS_HEADER-PSTNG_DATE      =  T103-BUDAT.     " ??? ???
  GS_HEADER-DOC_DATE        =  T103-BUDAT.     " ?????
  GS_HEADER-HEADER_TXT      =  T103-UNAME.
*** GR CODE DATA ?? ***
* TABLE T158G ?? ??
*  GM_code :: ??????
*  01 :: MB01  02 :: MB31  03 :: MB1A
*  04 :: MB1B  05 :: MB1C  06 :: MB11  07 :: MB04
  GS_CODE-GM_CODE = '01'.

*** GR ITEM DATA ?? ***
*** T156SC - movement indicator ***

* B   Goods movement for purchase order
* F   Goods movement for production order
* L   Goods movement for delivery note
* K   Goods movement for kanban requirement (WM - internal only)
* O   Subsequent adjustment of "material-provided" consumption
* W   Subsequent adjustment of proportion/product unit material

  LOOP AT T103.
    PERFORM CONVERSION_EXIT_ALPHA_INPUT USING T103-EBELN T103-EBELN.
    PERFORM CONVERSION_EXIT_CUNIT_INPUT USING T103-MEINS T103-MEINS.

    SELECT SINGLE MATNR WERKS
           INTO (L_MATNR, L_WERKS)
           FROM EKPO
          WHERE EBELN EQ T103-EBELN
          AND   EBELP EQ T103-EBELP
          AND   LOEKZ EQ SPACE.

    GT_ITEM-MATERIAL    =  L_MATNR.         " ????
*    GT_ITEM-PLANT       =  'P001'.          " ???
    GT_ITEM-PLANT       =  L_WERKS.          " ???
    GT_ITEM-STGE_LOC    =  T103-LGORT.      " ????
    GT_ITEM-MOVE_TYPE   =  '101'.           " ????
    GT_ITEM-ENTRY_QNT   =  T103-MENGE.      " ??????
    GT_ITEM-ENTRY_UOM   =  T103-MEINS.      " ????
    GT_ITEM-PO_NUMBER   =  T103-EBELN.      " ????
    GT_ITEM-PO_ITEM     =  T103-EBELP.      " ??????
    GT_ITEM-GR_RCPT     =  T103-WEMPF.
    GT_ITEM-MVT_IND     =  'B'.             " ?????
    APPEND : GT_ITEM. CLEAR : GT_ITEM.
    CLEAR : L_MATNR.
  ENDLOOP.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      GOODSMVT_HEADER       = GS_HEADER
      GOODSMVT_CODE         = GS_CODE
*     TESTRUN               = GR_TESTRUN
    IMPORTING
      MATERIALDOCUMENT      = MATERIALDOCUMENT
      MATDOCUMENTYEAR       = MATDOCUMENTYEAR
    TABLES
      GOODSMVT_ITEM         = GT_ITEM
*     GOODSMVT_SERIALNUMBER = GR_SERIALNUMBER
      RETURN                = GT_RETURN.

  SUBRC = 4.
  IF NOT MATERIALDOCUMENT IS INITIAL.
    SUBRC = 0.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
         EXPORTING
              WAIT = 'X'.

    WAIT UP TO 1 SECONDS.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_MSEG
           FROM MSEG
          WHERE MBLNR EQ MATERIALDOCUMENT
          AND   MJAHR EQ MATDOCUMENTYEAR.
    LOOP AT IT_MSEG.
      MOVE-CORRESPONDING IT_MSEG TO TMSEG.

      SELECT SINGLE MAKTX INTO TMSEG-MAKTX
             FROM MAKT
            WHERE MATNR EQ TMSEG-MATNR
            AND   SPRAS EQ SY-LANGU.

     PERFORM CONVERSION_EXIT_ALPHA_OUTPUT USING TMSEG-MBLNR TMSEG-MBLNR
   .
     PERFORM CONVERSION_EXIT_MATN1_OUTPUT USING TMSEG-MATNR TMSEG-MATNR
   .
     PERFORM CONVERSION_EXIT_CUNIT_OUTPUT USING TMSEG-ERFME TMSEG-ERFME
   .

      APPEND TMSEG. CLEAR TMSEG.
    ENDLOOP.
  ENDIF.

  LOOP AT GT_RETURN.
    MESSTAB-MSGTYP = GT_RETURN-TYPE.
    MESSTAB-MSGID = GT_RETURN-ID.
    MESSTAB-MSGNR = GT_RETURN-NUMBER.
    MESSTAB-MSGV1 = GT_RETURN-MESSAGE_V1.
    MESSTAB-MSGV2 = GT_RETURN-MESSAGE_V2.
    MESSTAB-MSGV3 = GT_RETURN-MESSAGE_V3.
    MESSTAB-MSGV4 = GT_RETURN-MESSAGE_V4.
    MESSTAB-MESSAGE_TEXT = GT_RETURN-MESSAGE.

    APPEND MESSTAB. CLEAR MESSTAB.
  ENDLOOP.





ENDFUNCTION.