# Create a software component type

Create a new SWC type: atomic (Application, Service, Sensor Actuator, …) or a
composition. The Modellar MCP connector looks up what is needed. The component
itself is created in the UI for now (see section 3).

## 1. Where am I?

Read the current URL: `https://<host>/designer/{modelId}/...`.

- `{modelId}` (an id or a slug) is the model to use with every MCP call.
- If the URL has no `/designer/`, ask the user which model to work in. Use
  `list_accessible_models` to offer the choices.

## 2. Gather and check (MCP)

| Field        | Rule                                                                           |
| ------------ | ------------------------------------------------------------------------------ |
| Short Name   | Starts with a letter, then only letters, digits and `_`. No spaces.            |
| Kind         | Atomic or composition (see the Type values below). Ask if the user didn't say. |
| Package Path | Like `Compositions/Zuko` or `App_IL/SWCTypes`. **No leading slash.**           |
| Source File  | The ARXML file it belongs to (see below).                                      |
| Description  | Optional.                                                                      |

Type values:

- **Atomic:** Application (default), Service, NV Block, Complex Device Driver,
  Service Proxy, ECU Abstraction, Sensor Actuator, Parameter.
- **Composition:** Composition (default), Root Composition. Use Root Composition
  only if the user asks for it explicitly.

1. **Source File and Package Path.** Find a related component with
   `search_elements({ modelId, elementType: "SwComponent", search: "<a sibling or parent name>", includeElementData: true })`.
   Reuse its `elementData.sourceFile`. If the user named a parent composition
   ("under Zuko"), use that composition's `elementData.packagePath`. If nothing fits,
   ask the user.
2. **It must not exist yet.**
   `search_elements({ modelId, elementType: "SwComponent", search: "<ShortName>" })`.
   If a result's `qualifiedName` equals `/<Package Path>/<ShortName>`, **stop**. Tell
   the user it already exists and offer to open its diagram instead (skill
   `modellar-diagrams`, task `open-or-create-swc-diagram.md`).

## 3. Create it

**The UI does the write for now.** `stage_element` (element type `SwComponent`)
needs the id of the user's staging batch, and no Modellar tool returns one yet. The
UI form picks the batch by itself. Don't ask the user for a batch id.

Summarise the values from section 2 for the user and ask for go, then follow the
visual route below. Fill the form with exactly those values.

## 4. Visual route

### Open the create form

1. In the top menubar, click **Diagram**.
2. Click the item that matches the kind:
   - **Manage Composition SW Component Types** → in the dialog footer click **Create New CSwC Type**.
   - **Manage Atomic Sw Component Types** → in the dialog footer click **Create New ASwC Type**.
   - Do not click the footer's **Create Diagram**. It makes a diagram for an existing component, not a new type.

If that path fails, use the fallback: menubar **Configuration** → **SW Component
Types** (page "Software Components Types Manager") → **New Software Component** →
**Atomic Component** or **Composition Component**.

The dialog opens with the title **Create Composition SWC Type** or **Create Atomic SWC Type**.

### Fill the form

1. **Staging Batch.** Already selected. Keep it unless the user named a batch.
2. **Short Name \***
3. **Type \*.** A dropdown with placeholder "Select component type". Pick the value.
4. **Package Path \*.** No leading slash.
5. **Source File \***
6. **Description.** Optional.

If you haven't confirmed the values yet, summarise them and ask for go. Then click
**Create Component** and wait until the button stops reading "Creating...".

Success shows the toast **"Software component created successfully"** (sometimes
twice; that is normal). A red message under a field means it wasn't saved. Fix
exactly that field and submit again.

### The optional diagram step

The same dialog then shows **Create Diagram for New SWC** (badge "Optional").

- If the user asked for a diagram, or wants to add components next: leave
  "Diagram Name" as it is, confirm, then click **Create Diagram**. The app opens
  the new diagram.
- Otherwise, click **Skip Diagram**.

## 5. Report

Tell the user the type, the qualified name `/<Package Path>/<ShortName>`, and
whether a diagram was created.

## Traps

- A leading slash in Package Path produces `//Pkg/Name`. Strip it.
- The name must be unique in its package. Always do the check in section 2.
- Root Composition is for the system's top-level composition only. Never pick it
  as a default.
