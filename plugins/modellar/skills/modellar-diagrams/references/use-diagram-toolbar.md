# Use the diagram toolbar

Lay out a whole diagram, resize every box at once, and change how the diagram is
drawn (labels, line shape, animation), using the toolbar at the top of the canvas.
These act instantly on the open canvas. There is no Modellar tool for them on
purpose: the toolbar uses the sizes the browser actually drew. This task is
always visual.

For moving or resizing **one** node, placing it next to another, or showing and
hiding components, ports and connections by name, use task
`change-diagram-layout.md` instead.

## 1. Where am I?

The URL contains `/diagram/` and a canvas is shown, with a toolbar centred at the
top. If not, open the diagram first (task `open-or-create-swc-diagram.md`).

## 2. Find what the user asked for

| The user says …                                              | Click                    | Then                                                                                                                               |
| ------------------------------------------------------------ | ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| "lay it out", "tidy it up", "left to right", "top down"      | **Layout: …**            | **Top to Bottom**, **Left to Right**, **Bottom to Top** or **Right to Left** (composition only: **Fit in Frame**)                  |
| "fit the boxes to their ports", "make room for the ports"    | **Resize Nodes**         | **Fit all nodes to ports** (every node) or **Fit frames to ports** (frames only; inner frames follow, other boxes keep their size) |
| "make everything as small as possible", "remove empty space" | **Resize Nodes**         | **Shrink all to minimum**                                                                                                          |
| "make the frame wrap its components"                         | **Resize Nodes**         | **Fit frames to children**                                                                                                         |
| "show / hide the port names"                                 | **Port Visuals**         | **Show port labels** / **Hide port labels**                                                                                        |
| "show / hide the connection names"                           | **Edge Visuals**         | **Show edge labels** / **Hide edge labels**                                                                                        |
| "straight lines", "right angles", "curved lines"             | **Edge Visuals**         | under Edge Type: **Straight**, **Step**, **Bezier** or **Smooth Step**                                                             |
| "animate the data flow" / "stop the animation"               | **Edge Visuals**         | **Show animations** / **Stop animations**; the shape under Animation Type: **Sphere**, **Package** or **Moving dashes**            |
| "highlight what a component is connected to"                 | **Edge Visuals**         | **Highlight connected edges** (or **No connection highlight** to turn it off); then select a node                                  |
| "show only some components", "hide the sensors"              | **Filter Components**    | type in **Search components...**, then tick or untick components; the top checkbox shows or hides all the matching ones            |
| "where is X", "zoom to X", "find port Y"                     | **Focus element** (icon) | search the node, port or connection in the dialog and pick it                                                                      |

The **Layout** button shows the current choice in its text, for example
**Layout: Top to Bottom**. Click it to open the menu of choices.

## 3. Keep the result

- **Layout**, **Resize Nodes** and **Filter Components** change boxes and what is
  shown. They are lost on a refresh unless saved. If the user wants to keep the
  result, click **Save Diagram** in the floating dock and wait for the toast
  **"Diagram Saved"**. Ask first if you are not sure they want to keep it.
- **Port Visuals**, **Edge Visuals** and the animation are view settings. The
  browser remembers them for every diagram. They are not saved with the diagram
  and other users don't see them. Nothing to save.

## 4. Report

Say what you clicked and what changed, for example "Laid out left to right and
fitted every box to its ports, then saved."

## Traps

- **Layout rearranges everything.** If nodes were placed on purpose (by the user,
  or with task `change-diagram-layout.md`), say so and ask before pressing it.
- A layout or resize right after a refresh works on the refreshed canvas. Don't
  refresh after it without saving, or it is gone.
- **Filter Components lists only boxes already on the canvas.** A component never
  placed on this diagram isn't in it. For "show all components", or one that
  isn't there, use task `show-or-hide-all.md` (the frame's properties panel).
- **Fit in Frame** appears only on composition diagrams.
- **Focus element** is an icon-only button at the right end of the toolbar. Find
  it by its name "Focus element".
- The toolbar acts on the open canvas only. Nothing here can be done for a
  diagram that isn't open.
