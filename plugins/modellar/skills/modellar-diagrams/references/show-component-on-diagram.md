# Show a component on a composition diagram

Put a component that already exists in a composition (an SWC prototype) onto the
composition's diagram. Adding the component to the composition and showing it on
the diagram are separate steps: a new component is created **hidden**, and the
diagram shows it only after this task.

The Modellar connector does it in one call (section 2); the panel route
(sections 3 to 5) is for when the user asks to see it done, or the tools aren't
connected.

## 1. Where am I?

You must be on the composition's diagram: the URL contains
`/diagram/composition-sw-component-type/`, and the top-left button shows the
composition's name with "Composition" underneath. If not, open it first (task
`open-or-create-swc-diagram.md`).

## 2. MCP route (default)

1. `list_diagrams` with the composition's id (from `search_elements`) → the
   diagram's id.
2. If the diagram is open in the user's tab, save first (skill
   `modellar-diagrams`, `change-diagram-layout.md`, step 3).
3. `set_node_visibility` with `diagramId`, `nodes: ["<component name>"]` and
   `visible: true`. The name is the SW component prototype's short name.
   - `created`: the component was never on this diagram; it now has a box in a
     free spot of the frame, with its ports hidden.
   - `changed`: it was hidden; it is shown again where it was.
   - `unchanged`: it was already shown. Tell the user.
   - "No node or component named …": it isn't in this composition (or the name
     is spelled differently). Check with `search_elements`.
4. Refresh the open diagram (`refresh-diagram.md`). Offer to show its ports
   (skill `modellar-ports`, `show-hide-or-move-ports.md`).

## 3. Visual route: open the Components panel

1. On the canvas, click the big **frame** whose header shows the composition's
   name. It's the outer box that contains the other components. This selects it.
2. Open the properties panel (see `properties-panel.md`): the button **Properties
   panel**, a small "<" chevron on the right edge of the canvas, at mid-height.
   Collapsed, it is `expanded=false`. If the panel is already open, it shows the
   heading **Properties**, and the button is `expanded=true`: don't click it again.
3. In the panel, click the tab **Components**. The tabs are Properties, Ports,
   Components, Connections. You now see "SW Component Prototypes".

## 4. Find the component's card

Find the card with the component's name. Its footer button tells you its state.
The button's name includes the component's name:

| Button reads | Its name                          | Means                       |
| ------------ | --------------------------------- | --------------------------- |
| **Add**      | "Add <component> to the diagram"  | never drawn on this diagram |
| **Show**     | "Show <component> on the diagram" | drawn before, now hidden    |
| **Hide**     | "Hide <component> on the diagram" | already on the diagram      |

- **Already on the diagram** (button **Hide**): tell the user and stop.
- **Not in the list:** if it was just added through the Modellar tools, wait about
  10 seconds; the list updates by itself. Still missing? Refresh the diagram (task
  `refresh-diagram.md`), open the panel again and look once more. If it still isn't
  there, tell the user: it may belong to another composition, or the list may be
  filtered (see Traps).

## 5. Show it

Click the button **once**. It is disabled while it works, and afterwards it reads
**Hide**: a second click would hide the component again.

- **Add**: toast **"Component node created successfully"**. The box now appears
  inside the frame, and it is saved. Its ports are **not** shown yet: a new
  component node starts with its port handles hidden, by design. Don't report
  missing ports as a problem.
- **Show**: toast **"Component shown successfully"**. The box appears, but only on
  this canvas: click **Save Diagram** afterwards, or a refresh hides it again.

Showing a component needs no confirmation: it changes only this diagram, and the
user can hide it again.

Don't use **Show All** unless the user asks. It reveals every hidden component, not
just this one. For many at once, use task `show-or-hide-all.md`.

## 6. Report

Tell the user the component is now shown on the diagram, inside the composition's
frame.

## Traps

- Clicking the frame alone does not open the panel. You must click the "<" button.
- The toolbar's **Filter Components** at the top of the canvas is not this list: it
  shows only boxes already on the canvas, so a never-placed component isn't in it.
- The frame's ⋮ menu has no "add component" item, and its "Show Details" does
  nothing. Use the panel.
- If the Components tab list is filtered (a **Filter** popover with search,
  status and visibility), the card may be hidden. Use **Clear filters**.
- **Reload Diagram** doesn't bring a hidden component onto the canvas. Only its
  **Add** or **Show** button does.
- Don't click the button again because the layout shifted or nothing seemed to
  happen. Wait for the toast, then read the button: if it reads **Hide**, it
  worked.
- **Show** and **Hide** change only the canvas until **Save Diagram**; **Add** is
  saved at once. The dock's unsaved dot doesn't light up for visibility changes:
  save anyway. For many components at once, use task `show-or-hide-all.md`.
