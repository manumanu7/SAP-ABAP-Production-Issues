# 📘 Production Issue #001

# Excel Attachment Date Changes from MM/DD/YYYY to DD.MM.YYYY

---

## 🎯 Business Scenario

A background job generates an Excel report and sends it automatically to business users through email.

Inside SAP, the report displays dates correctly.

However, after opening the Excel attachment, users notice that the date format changes unexpectedly.

Expected:

28.06.2026

Actual:

06/28/2026

This leads to confusion, especially for users working with European date formats.

---

# 🔍 Problem

The ABAP internal table stores the values correctly.

The ALV report also displays the dates correctly.

But the generated Excel attachment shows a different format.

Changing the SAP user date format does not solve the issue.

---

# 🧠 Root Cause

The issue is **not caused by SAP**.

SAP exports the date value correctly.

Microsoft Excel automatically interprets the value as a Date data type and displays it according to the user's regional settings.

Therefore:

- User A (USA)

06/28/2026

- User B (Germany)

28.06.2026

- User C (UK)

28/06/2026

The same Excel file displays different formats on different computers.

---

# ❌ Common Attempts That Usually Fail

Many developers try:

- Conversion Exit
- MASK
- WRITE Statement
- Changing User Date Format
- Changing DATS to CHAR in the original structure

Most of these approaches either do not solve the issue or introduce new problems.

---

# ✅ Recommended Solution

Instead of changing the original processing structure, create a dedicated export structure.

Convert only the date fields into formatted character strings before generating the Excel file.

This preserves the business-required display format without affecting the application's internal processing.

> The exact implementation depends on the Excel generation method (ALV export, XML Spreadsheet, CSV, XLSX library, etc.).

---

# 💻 Sample Code

Example:

```abap
DATA lv_date TYPE char10.

WRITE ls_data-valid_from TO lv_date DD/MM/YYYY.

REPLACE ALL OCCURRENCES OF '/' IN lv_date WITH '.'.

ls_export-valid_from = lv_date.
```

---

# 💡 Best Practices

- Keep processing structures and export structures separate.
- Do not change the original DATS fields only for reporting.
- Test Excel output using different regional settings.
- Validate background job output as well as foreground execution.
- Document business formatting requirements.

---

# 📋 Testing Checklist

- Foreground Execution
- Background Job
- Email Attachment
- Multiple Date Fields
- Empty Dates
- Different Windows Regional Settings
- Different Excel Versions

---

# 🎯 Interview Question

**Question**

Why does Excel display the same SAP date differently on different user machines?

**Answer**

Excel formats date values based on the user's regional settings unless the exported value is text or an explicit Excel cell format is applied.

---

# 📚 Lessons Learned

This issue demonstrates an important distinction between:

- Data Storage
- Data Presentation

SAP stores the correct value.

Excel decides how that value is displayed.

Understanding this difference helps avoid unnecessary debugging and incorrect fixes.

---

# 📄 Resources

- PDF Guide
- Sample ABAP Code

---

## ⭐ If this helped you

Please consider starring this repository.

New production issues are added regularly.
