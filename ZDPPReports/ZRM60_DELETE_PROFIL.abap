*
REPORT RM60_DELETE_PROFIL.

DATA: LT_PBIM TYPE PBIM OCCURS 100 WITH HEADER LINE.
DATA: LT_TPHVP TYPE TPHVP OCCURS 100 WITH HEADER LINE.
DATA: INIT_PROFILID LIKE PBIM-PROFILID,
      COUNTER TYPE I.

SELECT * FROM PBIM INTO TABLE LT_PBIM
                  WHERE PROFILID NE INIT_PROFILID.

SELECT * FROM TPHVP INTO TABLE LT_TPHVP.

LOOP AT LT_PBIM.
  READ TABLE LT_TPHVP WITH KEY PROFILID = LT_PBIM-PROFILID.
  IF NOT SY-SUBRC IS INITIAL.
    CLEAR LT_PBIM-PROFILID.
    MODIFY LT_PBIM.
    COUNTER = COUNTER + 1.
  ENDIF.
ENDLOOP.
IF SY-SUBRC IS INITIAL AND COUNTER GT 0.
  UPDATE PBIM FROM TABLE LT_PBIM.
  WRITE:/, COUNTER, 'PBIM records are updated'.
ENDIF.
