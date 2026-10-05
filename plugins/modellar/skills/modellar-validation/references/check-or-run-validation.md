# Check or run validation

Find out where one element (a component, composition, port, connector, interface…)
stands with validation, explain its issues, and validate it again when the user
wants. For a composition, its children (ports, prototypes, connectors) can be
checked in the same read.

## Where am I?

- `/designer/{modelId}/validation`: the **Validation Dashboard** (cards
  **Validation Summary** and **Validation Issues**). The model's open issues.
- `/designer/{modelId}/diagram/...`: a diagram. Each node shows a status badge.
- `/designer/{modelId}/configuration/{section}`: a table; its **Status** column
  shows the same badge.

Badges: **Staged** (not validated since it was created or changed), **Validated**,
**Validation Failed**, **Failed**, **Promoted**, **Pending**, **Unstaged**.

## MCP route (default)

1. **The model and the element.** `list_accessible_models` if the user named the
   model in words. `search_elements({ modelId, search: "<name>", elementType })`
   → the element's `id`. Several matches: ask which.
2. **Read the last result.**
   `list_validation_issues({ modelId, elementId, includeChildren })`. Use
   `includeChildren: true` for a composition or a component. You get:
   - `element.state`: `passed`, `failed`, `not_validated` or `in_progress`;
   - `children` (with `includeChildren`): how many are in each state, and the
     first ones not yet validated;
   - `issues`, most severe first, each with the element it belongs to. `totalCount`
     is how many are open; page with `offset: <nextOffset>` while `nextOffset` is
     not null.
     Without `elementId` it lists the whole model's open issues.
3. **Report and decide.**
   - `passed`: say so. Nothing to run.
   - `failed`: explain the issues (group them by element for a composition). For
     each "Referenced … exists but is invalid", "… not validated yet" or "… is
     not validated in staging", name that reference: it has to be fixed or
     validated first. "… is not validated in staging" can also mean the element
     with that path is only in another model: then it has to be imported into
     this one. For "… does not exist", the referenced element is not in the
     model.
   - `not_validated`: say the element changed since its last validation, so the
     issues listed (if any) may be out of date. **Ask** whether to validate it.
4. **Validate, after go.** `validate_element({ modelId, elementId })`. It answers
   with the new `element.state`, `passed`, the open `issues` and a
   `dependencyNote`. One element per call: to validate a chain, go bottom-up
   (interface, port, connector, composition), and say which element you validate
   before each call.
5. **Failed again?** Pass on the `dependencyNote` in your own words, with the
   reference the issue names. Offer to read that reference
   (`list_validation_issues` on it) and validate it first.
6. Offer to open the element (`pagePath`) or the Validation Dashboard (skill
   `modellar-navigation`).

## Visual route

**Read the issues:**

1. Top menubar **Model** → **Validation**. The card **Validation Issues** lists
   the model's open issues, with the columns **Severity**, **Issue**, **Element
   Type**, **Element**, **Component / Interface**, **Batch ID**, **Source File**,
   **Action**.
2. To narrow: **Add Filter** → popover **Filter Issues**. Type the element's name
   in **Search in name or description** (placeholder "Search text..."), or tick a
   **Severity** (**Error**, **Warning**, **Info**). The line under the table reads
   "Showing X to Y of N issues".
3. A failed badge on a diagram node or in a table's **Status** column also shows
   the reasons when you hover it (tooltip **Validation Failed**, sections
   **Reason:**, **Missing Fields:**, …).

**Validate one element**, on a composition or system diagram, only while its badge
reads **Staged**:

1. Click the node's **⋮** button (no visible text; its name is "Open node actions
   menu").
2. Choose **Validate Staged Element**. The item is not in the menu when the node
   is not **Staged** (already validated, failed or promoted).
3. Toasts: "Validating..." then "Validation initiated". The badge changes to
   **Validated** or **Validation Failed** shortly after.

**Re-validate an element that has issues:** on the Validation Dashboard click the
issue's row (or its **Action** button, named "Edit"). Its edit dialog opens; save
it. Saving re-validates that element: toast "Re-validating…", then "Issue
resolved", "{n} issues resolved" or "No issues resolved".

## Report

The element, its state, the open issues in plain words (grouped by element for a
composition), which references must be fixed or validated first, and whatever you
validated with its new state.

## Traps

- **"Does not exist" can be misleading on older results.** Issues recorded before
  the clearer messages were introduced say "does not exist" even when the
  referenced element exists but is invalid. Re-validating the element rewrites
  them.
- **A failed or validated element has no Validate Staged Element item** on the
  diagram. Use `validate_element`, or the dashboard's edit-and-save.
- **Validating a composition does not validate its ports or connectors.** Its
  result depends on them; `includeChildren` shows which ones are not validated.
- **Staged means "changed since last validation"**: an element you just edited
  is **Staged** again, and its old issues are stale until it is validated.
- **The Validate Batch** dialog on the ARXML page validates a whole batch, and
  skips elements that are already validated or failed. It is not the tool for one
  element.
