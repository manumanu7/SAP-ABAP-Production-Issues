```abap
*-----------------------------------------------------------------------
* Production Issue #001
*
* Title:
* Excel Attachment Date Changes from MM/DD/YYYY to DD.MM.YYYY
*
* Problem
* -------
* Excel changes date format while opening attachment.
*
* Description:
* Excel automatically formats DATS fields based on the user's regional
* settings. To preserve a fixed display format in the email attachment,
* create a separate character field and populate it only for the export.
*
* Module      : Email Framework
* Category    : Excel Export
* Difficulty  : Intermediate
*
* Root Cause
* ----------
* Excel interprets DATS values according to regional settings.
*
* Solution
* --------
* Export a formatted character field instead of the original DATS field.
*
* Author      : Manu Kumar
* Repository  : SAP-ABAP-Production-Issues
*-----------------------------------------------------------------------
* Note:
* This is a generic example. Adapt it to your own report structure.
*-----------------------------------------------------------------------

TYPES: BEGIN OF ty_final,
         valid_from      TYPE datum,
         valid_from_char TYPE char10,
       END OF ty_final.

DATA: lt_final TYPE STANDARD TABLE OF ty_final,
      ls_final TYPE ty_final.

*-----------------------------------------------------------------------
* Sample Data
*-----------------------------------------------------------------------

ls_final-valid_from = sy-datum.

*-----------------------------------------------------------------------
* Populate character field only for background/email export
*-----------------------------------------------------------------------

IF sy-batch = abap_true.

  ls_final-valid_from_char =
    |{ ls_final-valid_from+6(2) }.{ ls_final-valid_from+4(2) }.{ ls_final-valid_from+0(4) }|.

ENDIF.

APPEND ls_final TO lt_final.

*-----------------------------------------------------------------------
* Display using SALV
*-----------------------------------------------------------------------

TRY.

    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(lo_alv)
      CHANGING
        t_table      = lt_final ).

  CATCH cx_salv_msg.
    " Handle Exception

ENDTRY.

*-----------------------------------------------------------------------
* Column Handling
*-----------------------------------------------------------------------
* Online Execution
* ----------------
* Show:
*     VALID_FROM
*
* Hide:
*     VALID_FROM_CHAR
*
* Background / Email Attachment
* -----------------------------
* Show:
*     VALID_FROM_CHAR
*
* Hide:
*     VALID_FROM
*
* This ensures:
*
* Online ALV
*     28.06.2026 (DATS formatting according to SAP)
*
* Excel Attachment
*     28.06.2026 (Fixed text format)
*
*-----------------------------------------------------------------------
```
