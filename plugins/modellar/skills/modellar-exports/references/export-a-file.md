# Export a file

Get a model's analytics (PDF report or Excel workbook) or its validation issues
(Excel) into a file on the user's computer, by handing them a download link or
by using the page's Export button.

| Export              | Formats     | Filters | Page and control                                                                 |
| ------------------- | ----------- | ------- | -------------------------------------------------------------------------------- |
| `model-analytics`   | pdf, xlsx   | none    | **Model Analytics** page: **Export** (top right) → **PDF report** / **Excel workbook** |
| `validation-issues` | xlsx        | yes     | **Validation Dashboard**, card **Validation Issues**: **Export to Excel**, next to **Add Filter** |

- **PDF report:** one section per page (Overview, Components, Ports, Interfaces,
  Behavior) with headline figures, bar charts and tables. A long table is cut in
  the PDF, with a note pointing to the Excel file.
- **Excel workbook (analytics):** the same content, one sheet per chart or table,
  tables in full.
- **Excel (validation issues):** one row per open issue (severity, issue type,
  element, message, owning component or interface, field, expected and actual
  values, batch, source file), plus a **Filters** sheet listing the filters used.

## Where am I?

- `/designer/{modelId}/analytics`: the **Model Analytics** page. The **Export**
  button is at the top right.
- `/designer/{modelId}/validation`: the **Validation Dashboard** (cards
  **Validation Summary** and **Validation Issues**). **Export to Excel** is in the
  **Validation Issues** card. It exports what the list shows,
  so the filters already set there apply.
- Any other `/designer/{modelId}/…` page: the model is `{modelId}`. Use the MCP
  route, or open the page first.

## MCP route (default)

1. **The model.** Take `modelId` from the URL, or call `list_accessible_models` if
   the user named the model in words.
2. **What can be exported.** If the user's wish doesn't clearly match one export,
   call `list_exports({ modelId })` and offer the choices with their formats.
3. **The link.** `get_export_link({ modelId, export, format })`:
   - analytics: `export: "model-analytics"`, `format: "pdf"` for a report to read
     or print, `"xlsx"` for Excel.
   - validation issues: `export: "validation-issues"`, `format: "xlsx"`. Add
     `filters` only for what the user asked:
     `{ severity: ["error"|"warning"|"info"], elementType: ["PortPrototype"], component: ["<component or interface short name>"], batchId: [...], sourceFile: [...], search: "<text>" }`.
     Values must be exact, or the file comes out empty (no error):
     - element type: as `list_validation_issues` shows it (`elementType`);
     - component: the owning component's or interface's short name
       (`search_elements`);
     - batch: the id from `list_staging_batches`;
     - source file: no tool lists them. Ask the user for the path, or let them
       pick it under **Add Filter** on the page and use **Export to Excel**.
4. **Hand it over.** The answer has `downloadPath` (relative to the ModellAR host,
   like `pagePath`):
   - If you drive the user's browser: open `downloadPath` on the ModellAR host
     their tab is on. The browser downloads or asks where to save it.
   - Otherwise: give the full link (`https://<their ModellAR host>` +
     `downloadPath`) for them to click while signed in.
   - Also name the button that does the same (`pagePath` + `control`), for next time.

## Visual route

1. Open the page with skill `modellar-navigation`, or from the header: **Model** →
   **Analytics** (the **Model Analytics** page), or **Model** → **Validation**
   (the **Validation Dashboard**).
2. **Analytics:** click **Export** (top right) and choose **PDF report** or
   **Excel workbook**.
3. **Validation issues:** set the filters first, if the user wants only some issues
   (**Add Filter**; the chips under the card title show what is set, **Clear all**
   removes them). Then click **Export to Excel**.
4. The button shows **Exporting…** while the file is built. In Chrome and Edge, a
   **Save As** dialog opens first: the user picks the folder and name. In other
   browsers, the file goes to the downloads folder. The toast **File saved**
   confirms it. **Export failed** shows the reason.

## Report

Tell the user which file they got (export, format, the filters or "all open
issues"), where it went (the link you gave, or their download folder), and the
page button they can use next time.

## Traps

- **A link from the tool can't be opened by you.** It needs the user's signed-in
  browser. Don't retry it, and don't call it a failure.
- **The file is built when the link is opened,** so it is current at that moment,
  not when you got the link.
- **Exports from the validation page follow its filters.** If the user wants
  everything, check that the card says **No filters applied**, or click **Clear
  all** first.
- **Cancelling the Save As dialog saves nothing,** and no toast appears. That isn't
  an error.
- **Validation issues have no PDF.** If the user asks for one, offer Excel, or the
  analytics PDF report if they wanted an overview.
