*&------------------------------------------------------------------
*& Program ID     : ZHKPMR0070
*& Profram Name   : PM Material Stock Shortage List l/F
*& Created by     : HS
*& Created on     : 06.16.2014
*& Development ID :
*& Reference Pgm. :
*& Description    :
*&
*& Modification Log
*&====================================================================
*& Date     Developer      Request ID      Description
*&
*&--------------------------------------------------------------------

REPORT  zhkpmr0070 NO STANDARD PAGE HEADING MESSAGE-ID zdpm_getis .

INCLUDE ZHKPMR0070TOP. "Declare Data
INCLUDE ZHKPMR0070F01. "Process

INCLUDE zhkpmr0000com . "Common Process
*&---------------------------------------------------------------------
* # INITIALIZATION:
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM initialization .

*&----------------------------------------------------------------------
* # AT SELECTION-SCREEN OUTPUT
*&----------------------------------------------------------------------
AT SELECTION-SCREEN OUTPUT.
*  PERFORM MODIFY_SCREEN.

*&----------------------------------------------------------------------
* # AT SELECTION-SCREEN :
*&----------------------------------------------------------------------
AT SELECTION-SCREEN.
  PERFORM SELECTION_SCREEN.

*&---------------------------------------------------------------------*
* # START-OF-SELECTION:
*&---------------------------------------------------------------------*
START-OF-SELECTION .

  g_job_start_date = sy-datum.
  GET TIME FIELD g_job_start_time.
  GET TIME STAMP FIELD g_time_stamp .

  PERFORM get_data .
  PERFORM modify_data .

*&-------------------------------------------------------------------*
* # END-OF-SELECTION :
*&-------------------------------------------------------------------*
END-OF-SELECTION.

  g_job_end_date = sy-datum.
  GET TIME FIELD g_job_end_time.

  IF gt_data[] IS INITIAL .
    MESSAGE s000 WITH 'Not found data' .
  ELSE .
    IF sy-batch IS NOT INITIAL .
      PERFORM process_batch .
      PERFORM display_log.
    ELSE .
      DESCRIBE TABLE gt_data LINES sy-ffile .
      MESSAGE S001 WITH sy-ffile 'has been viewed.' .
      PERFORM display_alv_screen.
    ENDIF .
  ENDIF .
