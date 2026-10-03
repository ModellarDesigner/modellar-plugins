# Create a configuration element

Create one element of any type listed in `element-catalog.md`: a data type, an
interface, an operation, a mode declaration, a runnable, and so on. One run creates
one element. For a chain (an interface and its operations), repeat it per element.

Open `element-catalog.md` at the element type's row before you start. It gives the
type's parent, its fields, and which route works today.

## 1. Where am I?

URL: `https://<host>/designer/{modelId}/...`. Take `{modelId}` from it for every MCP
call. No `/designer/` in the URL: ask which model, offering `list_accessible_models`.

## 2. Gather and check

1. **The values.** The user names at least the type and the short name. The catalog
   row lists what else the type needs (a kind, a data type, a period, …). Ask for a
   missing required value; don't invent one. Short name rules: starts with a letter,
   then letters, digits and `_`, at most 128 characters, not a C/C++ keyword such as
   `int` or `class`.
2. **The parent** (child types only, see the catalog). Find it:
   `search_elements({ modelId, elementType: "<parent type>", search: "<parent name>", includeElementData: true })`.
   Keep its `id`, `qualifiedName`, `batchId` and `elementData.sourceFile`. Several
   matches: ask which one, showing each `qualifiedName`. Not found: offer to create
   it first (another run of this task).
3. **Referenced elements** (a data type for a data element, a mode declaration group
   for a prototype, …): look each one up the same way and keep `id` and
   `qualifiedName`.
4. **No duplicate.**
   `search_elements({ modelId, elementType: "<type>", search: "<short name>" })`.
   A result whose `qualifiedName` equals the new element's qualified name (catalog:
   **Qname**) already exists: stop, tell the user, offer `edit-element.md` instead.
5. **The batch.**
   - A **child** goes into its parent's batch: the parent's `batchId`. Don't ask.
   - A **top-level** element (catalog: "Top-level") goes into a batch the user
     chooses: `list_staging_batches({ modelId })`, show the batches (newest first,
     with status and element count), and let the user pick. Never pick one
     yourself; reuse their choice for the rest of the conversation. Empty list: ask
     them to create one (**Model** menu → **ARXML Management** → **Process
     Batches** tab → **Add batch**).
6. **Source file.** A child copies its parent's `elementData.sourceFile`. A
   top-level element reuses the `sourceFile` of a related element of the same kind
   (search one, `includeElementData: true`), or the user names one.

## 3. MCP route (default)

1. **Confirm.** Summarise: type, qualified name, parent, the values, the batch. Wait
   for go.
2. **Shape.** `describe_element_type({ elementType: "<type>" })` once per type in the
   conversation. Fill exactly the fields the catalog row names, with the schema's
   spelling of every enum value.
3. **Stage it.** `stage_element` with:
   - `modelId`, `batchId` (step 2.5), `elementType`;
   - `absoluteQualifiedName`: the catalog's **Qname** for the type;
   - `elementData`: the catalog's fields, plus `shortName`, `sourceFile` and
     `description` if given. Don't put `elementType` inside `elementData`;
   - `idempotencyKey`: e.g. `"<type>-<short name>-1"`.
4. **Validation issues** (`"Validation failed - nothing was staged."`): fix exactly
   the fields listed and call again with the same key.
5. **Next.** Offer to open it: `search_elements` returns a `pagePath` for the new
   element, or use **Go to…** with its name (skill `modellar-navigation`).

## 4. Visual route

For when the user asks to use the form. Check the catalog row first: some create
forms are broken today and say which other way to use.

### Open the form

Pick one:

- **The table's dialog:** menubar **Configuration** → the page (catalog: **Menu**)
  → the button **New …** (catalog: **Button**). A dialog opens (catalog: **Dialog**).
- **The full page:** **Go to…** (or **Ctrl+K**), type `New <section>` (for example
  `New Interfaces`, `New Data Types`, plural) and press **Enter** once the entry is
  visible. The page shows the heading **Create …**.

Never open a form on an address that holds the model's slug (see skill
`modellar-navigation`): it displays fine, but nothing it saves arrives.

### Fill it

1. **Staging Batch** (top-level types only). The newest batch is usually
   preselected: the button shows an 8-character id, a status and "N elements". To
   pick another, click it, type part of the id into **Search by batch or trigger
   run id...**, then click the entry (or press **Enter**). Child types have no
   batch field: they take the parent's.
2. **The parent picker first** (child types): Interface, Software Component,
   Internal Behaviour, Mode Declaration Group, …. Some forms show **Short Name**
   only after the parent is chosen.
3. **Searchable pickers** (any field whose button reads "Select a …"): click it,
   **type the name** into the search box, then click the row with the right name.
   They load 10 rows at a time; the description shows "(N total)". Typing beats
   scrolling. Opening a picker only highlights the first row: it isn't chosen until
   you click it or press **Enter**. A click closes the picker by itself. **Don't
   press Escape after a pick**: in a dialog it closes the whole dialog and loses
   what you filled in.
4. **Short Name**, then the other fields of the catalog row, by their labels.
5. Summarise the values and wait for go. Then click the submit button (catalog:
   **Submit**) and wait until it stops reading "Creating...".

### After submit

- Success: the toast **"<Thing> created successfully"** (or "… staged
  successfully"), sometimes twice. The dialog closes, or the full page returns to
  the list.
- **"Fix 1 field before saving"** / **"Fix N fields before saving"**: read the red
  message under each field, fix exactly those, and submit again.
- **Nothing happens** (no toast, the dialog stays open, the button is back to its
  label): the save failed without a message. Check with `search_elements`. If the
  element isn't there, switch to the MCP route and tell the user the form failed.

## 5. Report

The element's type and qualified name, its parent, the batch, and where to see it
(its edit page or table). Offer the next step of the chain, if any.

## Traps

- **Duplicates are created silently.** Always do step 2.4.
- After an error from `stage_element`, search before retrying: it may have been
  written anyway. Retry with the **same** idempotency key. Never retry after a
  warning that says not to.
- **"Staging batch not found"** for a child: the parent sits in another user's
  batch. Tell the user; don't try another batch.
- A leading slash in **Package Path** produces `//Pkg/Name`. Strip it.
- Operations have **no arguments** yet: neither the form nor the connector can add
  them. Say so if the user asks for arguments.
- Delete isn't available (no tool; the menu item says "Delete not available yet" or
  "Not supported yet"). Don't promise it.
