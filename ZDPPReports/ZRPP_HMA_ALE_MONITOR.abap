*&---------------------------------------------------------------------*
*& Report  ZRPP_HMA_ALE_MONITOR                                        *
*&---------------------------------------------------------------------*
*& Program:                                                            *
*& Type   :                                                            *
*& Author :                                                            *
*& Title  :                                                            *
*&---------------------------------------------------------------------*
*& Requested by:  Andy choi                                            *
*&---------------------------------------------------------------------*
*  MODIFICATION LOG
************************************************************************
*  DATE      Developer      RequestNo.      Description
*  06/10/10  sjlee                          Init.
************************************************************************

REPORT  ZRPP_HMA_ZPODER    .

*---------------------------------------------------------------------*
*  INCLUDE
*---------------------------------------------------------------------*
INCLUDE ZRPP_HMA_ALE_MONITOR_TOP.
INCLUDE ZRPP_HMA_ALE_MONITOR_C01.
INCLUDE ZRPP_HMA_ALE_MONITOR_SEL.
INCLUDE ZRPP_HMA_ALE_MONITOR_F01.
INCLUDE ZRPP_HMA_ALE_MONITOR_O01.
INCLUDE ZRPP_HMA_ALE_MONITOR_I01.


*---------------------------------------------------------------------*
* INITIALIZATION .
*---------------------------------------------------------------------*
INITIALIZATION .
GV_REPID = SY-REPID.
*---------------------------------------------------------------------*
*  START-OF-SELECTION
*---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM P2000_GET_DATA.

END-OF-SELECTION.

  CALL SCREEN 0100.
