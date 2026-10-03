# Show or hide all (components, ports, connections …)

Show or hide many boxes or connections of one diagram at once: "show all the
components of Kessy", "hide every port of BCM", "show only the hidden connectors",
"hide all assembly connections". Optionally narrowed by a filter (name, status,
kind).

Showing or hiding changes only the drawing, never the model: nothing is deleted
and the user can undo it. No confirmation is needed, except for a **big Show All**
(step 3.3): one that creates boxes, or draws more than about 100 lines. Those are
slow to undo and can freeze the page, so tell the user the numbers first and
wait for go.

For one single component, use task `show-component-on-diagram.md` instead.

## 1. Where am I?

The URL contains `/diagram/`, and the top-left button shows the diagram's name and
kind. If the wrong diagram is open, open the right one first (task
`open-or-create-swc-diagram.md`). A workspace has nothing to show or hide.

## 2. MCP route (default)

Works for what is **already on the diagram** (shown or hidden). It can't put a
never-placed component, ECU prototype or connector on a diagram: that part needs
the visual route.

1. `list_diagrams` → the diagram's id. `get_diagram_layout` (pass
   `ports: "none"` unless ports are the subject) → its boxes, each with
   `visible`, and its connections.
2. Compare with the model when the user says "all": `search_elements` for the
   frame's children (for example the composition's SW component prototypes). A
   child that is not in the layout at all was never placed: count those for the
   visual route.
3. If the user has this diagram open and may have unsaved changes, ask them to
   click **Save Diagram** **before** you write. A save from the old canvas afterwards
   would overwrite your change.
4. Write, one call per kind:
   - boxes: `set_node_visibility` with `nodes` (names, up to 100) and `visible`.
     Hiding a frame does not hide the boxes inside it: hide those by name.
   - ports of one box: `set_port_visibility` with `node` and `which`
     (`all`, `connected`, `unconnected`) or `ports`, and `visible`. Composition and
     atomic diagrams only. Hiding ports also hides their connections.
   - connections: `set_connection_visibility` with `all: true`, or `kind`
     (`assembly`, `delegation`, `mapping`), or `node`, or `connections`, and
     `visible`. Showing a connection also shows the ports at both of its ends.
5. Each result lists `changed` and `unchanged`. Then the open canvas must be
   refreshed to show it: task `refresh-diagram.md` (it was saved first, so nothing
   is lost).
6. Never-placed children left over (step 2)? Do the visual route for them, with the
   **Visibility: Hidden** filter, or tell the user how many remain.

## 3. Visual route

Use the frame's **properties panel**, never the toolbar's **Filter Components**
(that one lists only boxes already on the canvas). How to open the panel and read
its tabs: `properties-panel.md`.

### 3.1 Pick the frame and the tab

| To show or hide …               | Diagram                      | Select            | Tab                |
| ------------------------------- | ---------------------------- | ----------------- | ------------------ |
| the components of a composition | Composition                  | composition frame | **Components**     |
| the connectors of a composition | Composition                  | composition frame | **Connections**    |
| a frame's ports                 | Composition, Atomic SWC, ECU | the frame         | **Ports**          |
| a component's ports             | Composition, ECU             | the component box | **Ports**          |
| the PDU-to-component mappings   | ECU                          | ECU frame         | **Mapping**        |
| the ECU prototypes of a system  | System                       | system frame      | **ECU Prototypes** |
| the connectors of a system      | System                       | system frame      | **Connections**    |

A composition frame placed inside an ECU diagram has its own **Components** and
**Connections** tabs: select that inner frame.

Runnables, RTE events and behaviours (atomic diagram) have **no** Show All: show
them one card at a time.

### 3.2 Narrow it (optional, sometimes required)

**Show All** and **Hide All** act on the cards that pass the filter (every card,
not only the 10 on screen). Click **Filter**, set the fields, click **OK**:

- a name part: **Search by name**;
- a kind: **Connector Type** (Assembly / Delegation), **Direction**,
  **Interface Type**;
- a state: **Staging Status**, **Visibility**.

**The button shows only one of the two, and you can't choose it.** It is a toggle:

| Tab                                     | Reads **Hide All** when …        |
| --------------------------------------- | -------------------------------- |
| Components, Connections, ECU Prototypes | **any** filtered card is shown   |
| Ports, Mapping                          | **every** filtered card is shown |

Read the button's text before you click it. When it already says what the user
asked, one click does it. When it says the opposite, use **two clicks**:

- **Show all**, but the button reads **Hide All** (at least one card is already
  shown, on Components, Connections or ECU Prototypes): click **Hide All**, wait for
  its toast, then click **Show All**.
- **Hide all**, but the button reads **Show All** (at least one card is hidden, on
  Ports or Mapping): on **Ports**, set the filter **Visibility** to **Visible**,
  so the button reads **Hide All**, click it, then clear the filter. On
  **Mapping**: click **Show All**, wait for its toast, then click **Hide All**
  (that draws every mapping first, so on a big ECU prefer `set_connection_visibility`
  with `kind: "mapping"`).

The end state is the same as one click would have given. Do the two clicks only
when the one click can't do it, and always with the same filter in place, so the
first click doesn't touch cards outside the user's request.

### 3.3 Click it

1. **Before a Show All, count what it will do**, and if it's big, tell the user
   and wait for go:
   - **Components / ECU Prototypes**: cards with the button **Add** ("Not in
     diagram") become new boxes, saved at once.
   - **Connections**: every listed connector becomes a line, and a component at
     an end that isn't on the diagram becomes a new box. The tab says how many
     are listed ("Showing X of Y connectors").
   - **Mapping**: every listed mapping becomes a line, and **every component it
     maps to becomes a new box**, without any card saying so (about 60 on a
     typical ECU).

   Over about 100 lines, drawing and then saving can freeze the page for a
   minute. Offer to narrow the list with the filter first.
2. Click **Show All** or **Hide All**. Components and ECU prototypes show
   "Showing All…" / "Hiding All…", then the toast **"Success"** with
   "<n> components shown" (or hidden), ", <k> already in desired state",
   " (<c> created)". Ports: **"Port visibility updated"**, "<n> port(s) shown".
   Connectors: "Updated <n> connector(s) successfully" or "Created <n>
   connector(s)". Mapping: **"Connection visibility updated"**.
   **"Partially Completed"** means some failed: report the numbers.
3. Click **Save Diagram** in the dock and wait for **"Diagram Saved"**. Do it even
   though the dock shows no unsaved dot: visibility changes don't light it. The boxes
   Show All created are already saved, but shown/hidden states, ports and connection
   lines are not until this save, and a reload would undo them.
4. If you set a filter only for this, click **Filter** → **Clear filters** (in
   Connections tabs: **Reset all filters**) → **OK**, so the user's list isn't left
   narrowed.

## 4. Report

What was shown or hidden (the count from the toast or the MCP result), on which
diagram, the filter used if any, and that it is saved. Mention new boxes created
by Show All. A component box placed this way starts with its ports hidden: offer to
show its ports (Ports tab of the box, or `set_port_visibility`), don't report it
as a fault.

## Traps

- **Toolbar Filter Components ≠ all components.** Its list and its master checkbox
  cover only boxes already on the canvas. It can't place a never-placed component,
  and its changes are also lost without **Save Diagram**.
- **One visible item flips the button.** On Components, Connections and ECU
  Prototypes, a single shown card makes it **Hide All**: click **Hide All**, then
  **Show All** (step 3.2).
- **Show All on Components places every never-placed component**, saved at once.
  On a big composition that fills the frame with boxes. Narrow first if the user
  asked for some.
- **Show All on Connections creates the missing connector lines** and, if an end
  component isn't on the diagram, places it too. These lines do save (tested with
  473 lines, after the page froze for about a minute). Lines drawn from the ⋮
  menu's Show Connections picker are the ones that fail to save ("Save Failed").
  Still read the Save Diagram toast: on **"Save Failed"**, Reload Diagram and draw
  them from their ports (skill `modellar-connectors`,
  `show-or-hide-connections.md`).
- **Hide All on Ports shrinks the frame** to its minimum; Show All grows it back.
- **Hiding a frame keeps its children shown**, on the canvas and through MCP.
- **Not saved = lost.** Only newly created boxes are saved by themselves. Showing or
  hiding, ports (handles), connection lines and box positions live only on the
  canvas until **Save Diagram**; Reload Diagram or a page reload brings back the old
  state.
- **MCP writes don't reach an open canvas** until **Reload Diagram**, and a save
  from the old canvas afterwards overwrites them.
