# Show a component on a composition diagram

Put a component that already exists in a composition (an SWC prototype) onto the
composition's diagram. Adding the component to the composition and showing it on
the diagram are separate steps: a new component is created **hidden**, and the
diagram shows it only after this task.

No Modellar tool places nodes yet, so this task always uses the UI.

## 1. Where am I?

You must be on the composition's diagram: the URL contains
`/diagram/composition-sw-component-type/`, and the top-left button shows the
composition's name with "Composition" underneath. If not, open it first (task
`open-or-create-swc-diagram.md`).

## 2. Open the Components panel

1. On the canvas, click the big **frame** whose header shows the composition's
   name. It's the outer box that contains the other components. This selects it.
2. Open the properties panel with the button **Properties panel** (a small "<"
   chevron on the right edge of the canvas, at mid-height). Collapsed, it is
   `expanded=false`. If the panel is already open, it shows the heading
   **Properties**, and the button is `expanded=true`: don't click it again.
3. In the panel, click the tab **Components**. The tabs are Properties, Ports,
   Components, Connections. You now see "SW Component Prototypes".

## 3. Find the component's card

Find the card with the component's name. Its status icon reads **"Not in diagram"**
when it is hidden.

- **Already on the diagram** (no "Not in diagram"): tell the user and stop.
- **Not in the list:** if it was just added through the Modellar tools, wait about
  10 seconds; the list updates by itself. Still missing? Refresh the diagram (task
  `refresh-diagram.md`), open the panel again and look once more. If it still isn't
  there, tell the user: it may belong to another composition, or the list may be
  filtered (see Traps).

## 4. Show it

1. Click the card's footer button **Add** (tooltip "Add component to diagram").
2. Toast: **"Component node created successfully"**. The box now appears inside the
   frame. Its ports are **not** shown yet: a new component node starts with its port
   handles hidden, by design. Don't report missing ports as a problem.

Showing a component needs no confirmation: it changes only this diagram, and the
user can hide it again.

Don't use **Show All** unless the user asks. It reveals every hidden component, not
just this one.

## 5. Report

Tell the user the component is now shown on the diagram, inside the composition's
frame.

## Traps

- Clicking the frame alone does not open the panel. You must click the "<" button.
- The frame's ⋮ menu has no "add component" item, and its "Show Details" does
  nothing. Use the panel.
- If the Components tab list is filtered (a **Filter** popover with search,
  status and visibility), the card may be hidden. Use **Clear filters**.
- **Reload Diagram** doesn't bring a hidden component onto the canvas. Only its
  **Add** button does.
