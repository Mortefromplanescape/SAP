*&---------------------------------------------------------------------*
*&  Include           ZHACR01000O001
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'G0100'.
  SET TITLEBAR 'T0100'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  ALV_CL_PROCESS1  OUTPUT
*&---------------------------------------------------------------------*
MODULE ALV_CL_PROCESS1 OUTPUT.

 IF G_CUSTOM_CONTAINER1 IS INITIAL.
    PERFORM ALV_CL_CONTROL1.
    PERFORM ALV_CL_CONTROL2.

  ELSE.
*   ALV Refresh
    PERFORM ALV_CL_REFRESH_TABLE_DISPLAY
                            USING  G_ALV_GRID1
                                   G_REC_STABLE1.
  ENDIF.

ENDMODULE.                 " ALV_CL_PROCESS1  OUTPUT
