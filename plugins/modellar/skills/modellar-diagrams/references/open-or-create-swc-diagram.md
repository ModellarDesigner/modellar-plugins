# Open or create the diagram of a software component

Find the component's diagram and open it, or create the diagram when there is none.
Finding and opening go through the Modellar MCP connector and the address bar.
**Creating** a diagram happens in the UI: no Modellar tool creates diagrams.

## 1. Where am I?

Current URL: `https://<host>/designer/{modelId}/...`. Take `{modelId}` from it.
If there's no `/designer/`, ask for the model and use `list_accessible_models`.

| URL contains                                                  | You are on            |
| ------------------------------------------------------------- | --------------------- |
| `/diagram/composition-sw-component-type/<diagramId>`          | a composition diagram |
| `/diagram/atomic-sw-component-type/<diagramId>`               | an atomic SWC diagram |
| `/diagram/ecu/…`, `/diagram/system/…`, `/diagram/workspace/…` | other diagrams        |

The top-left button shows the open diagram's name, with its kind underneath
("Composition", "Atomic SWC", …). If the URL is the right kind **and** that name is
the SWC's name, tell the user they are already there and stop.

## 2. MCP route (default)

1. **Find the component.**
   `search_elements({ modelId, elementType: "SwComponent", search: "<name>", includeElementData: true })`.
   - Several matches: ask which one, showing each `qualifiedName`.
   - No match: the component doesn't exist. Offer to create it (skill
     `modellar-components`, task `create-swc-type.md`).
   - `elementData.type` gives the kind: `Composition` or `RootComposition` →
     composition; `Ecu` → not supported here, tell the user; anything else
     (Application, Service, SensorActuator, …) → atomic.
2. **Find its diagram.** `list_diagrams({ modelId, stagedElementId: "<the component's id>" })`.
3. **One diagram:** open it by address (skill `modellar-navigation`):
   - composition → `/designer/{modelId}/diagram/composition-sw-component-type/{diagramId}`
   - atomic → `/designer/{modelId}/diagram/atomic-sw-component-type/{diagramId}`

   `{diagramId}` is the `id` from `list_diagrams`, not the component's id. Opening
   needs no confirmation.
4. **Several diagrams:** list their names and ask which one.
5. **None:** create it with the visual route, section 4.

## 3. Visual route: open an existing diagram

Use this when the user asks to do it in the UI, or the Modellar tools aren't
connected.

1. In the top menubar, click **Diagram**.
2. Click **Manage Composition SW Component Types** or **Manage Atomic Sw Component
   Types**. (The dialog title reads "Manage Atomic Software Component Types".)
3. Type the SWC's short name into **Search existing diagrams...**.
4. If a row's name matches, click its button **"Open <name>"** (the name itself).
   Never click the trash icon next to it ("Delete diagram"): it deletes the diagram
   at once, without asking.
5. A diagram's name usually equals the SWC name, but users can rename it. If the
   only rows are close but not exact, ask the user before picking one.

Don't use the top-left recent-diagrams button to find a diagram. It lists only
diagrams opened recently in this browser.

## 4. Visual route: create the diagram

1. Open the manager for the kind (section 3, steps 1–2).
2. In the dialog footer, click **Create Diagram**. Not "Create New CSwC/ASwC Type";
   that makes a new component.
3. The dialog **Create Composition SWC Diagram** or **Create Atomic SWC Diagram**
   opens.
4. Click the combobox **Select a composition SWC...** or **Select an atomic SWC...**.
5. Type the short name into **Search by name, short name, or description...**.
6. Pick the row whose grey path matches the component's `qualifiedName`.
7. Leave **Diagram Name (Optional)** empty (it defaults to the SWC name). Fill
   **Description (Optional)** only if the user gave one.
8. Tell the user what you're creating and wait for go. Then click **Create
   Diagram**.

On success the toast reads "… SWC diagram created successfully" and the app opens
the new diagram.

## 5. Report

Tell the user which diagram is open (its name and kind), or that you created it.

## Traps

- **Never create a diagram that already exists.** The app doesn't stop duplicates,
  and creating twice gives two diagrams. Always check first (`list_diagrams`, or the
  manager's search).
- The toast **"Staged Element not found"** usually means the component was created by
  another user. The app only lets its creator make its diagram. Report this; don't
  retry.
- If the SWC isn't in the combobox list, check you are in the right manager
  (composition vs atomic).
- `list_diagrams` shows only diagrams this user can open. Someone else's diagram of
  the same component can exist without showing up.
