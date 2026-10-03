# Arrange a diagram with the Modellar tools

Move or resize nodes, place a node next to another, show or hide components,
ports and connections, and move ports to another side, by name, through the
Modellar connector. Works whether or not the diagram is open.

Use task `use-diagram-toolbar.md` instead for a whole diagram at once ("tidy it
up", "left to right", "fit every box to its ports") and for view settings (port
or edge labels, line shape, animation).

## 1. Where am I?

You need the diagram's id: call `list_diagrams` (task
`list-or-describe-diagrams.md`). If the user is on the diagram already, its id is
the last part of the URL (`/diagram/<kind>/<id>`).

Is the diagram **open in the user's tab**? That decides step 3.

## 2. Read the diagram

Call `get_diagram_layout` with the `diagramId`. You get:

- **nodes**: name, id, parent frame, `x`/`y` relative to that frame, `width`,
  `height`, `visible`;
- each node's **ports**: name, side, `visible`, `connected` (has a connection on
  this diagram, shown or hidden);
- **connections**: name, kind (`assembly`, `delegation`, `mapping`), the node
  and port at each end, `visible`.

A frame can have hundreds of ports, so only the ports that are shown or
connected are listed; each node says how many it left out (`portsLeftOut`). To
see every port of one node, call it again with `node` (that node only, all its
ports). `ports: "none"` gives the boxes only.

Find what the user named. If a name matches several nodes, ask which one; the
tools refuse to guess and list the candidates.

## 3. If the diagram is open: Save first

The tools write to the saved diagram. An open canvas shows the change only after
**Reload Diagram**, and a **Save Diagram** pressed on it afterwards writes the old
layout back over your change.

So, **before** you change anything on an open diagram, **always ask**, even if
nothing looks unsaved. The dock's unsaved-changes dot lights up for moved boxes
only: shown or hidden boxes, ports and connections never light it, so "no dot"
doesn't mean "nothing to save".

1. Ask: "I'll save the diagram first so nothing you arranged is lost. OK?" Then
   click **Save Diagram** in the floating dock (or ask the user to) and wait for
   the toast **"Diagram Saved"**.
2. Make the changes (step 4).
3. Refresh with task `refresh-diagram.md`: click **Reload Diagram**, then confirm
   the dialog **"Reload diagram from the database?"** with **Reload diagram**. You
   can skip that task's "Save first?" question to the user: you just saved.

Never ask for a save **after** your change.

## 4. Make the change

Say in one line what you will change, then call the tool. These change only how
the diagram looks; nothing is deleted, so no further confirmation is needed.

| The user says …                                           | Call                                                                                                                   |
| --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| "put X next to / below / left of Y"                       | `update_node_layout` with `changes: [{ node: X, beside: { node: Y, side: "right" \| "left" \| "above" \| "below" } }]` |
| "line X up with Y"                                        | the same, with `align: "start"` (top or left edges), `"center"` or `"end"`                                             |
| "move X 200 to the right", "move X to 100, 400"           | `update_node_layout` with `dx`/`dy`, or `x`/`y`                                                                        |
| "make X bigger / 600 wide"                                | `update_node_layout` with `width`/`height`                                                                             |
| "hide X", "show X again"                                  | `set_node_visibility` with `nodes: [X]`, `visible`                                                                     |
| "show all ports of X", "hide the unconnected ports"       | `set_port_visibility` with `node: X`, `which: "all" \| "connected" \| "unconnected"`, `visible`                        |
| "show port P of X"                                        | `set_port_visibility` with `node: X`, `ports: [P]`, `visible: true`                                                    |
| "put the ports of X on the left", "move P to the top"     | `set_port_placement` with `node: X`, `which` or `ports`, `side`                                                        |
| "hide the delegation connections", "show X's connections" | `set_connection_visibility` with `kind`, `node`, `connections` or `all`, and `visible`                                 |

Several moves go in **one** `update_node_layout` call, in order: a later change
sees the earlier ones ("put B right of A, then C below B").

Each answer lists what changed. `update_node_layout` also returns `before`, the
boxes as they were: keep it, so "undo that" is one call with those values.

**Read the warnings.** An overlap, a node sticking out of its frame, or a size
raised to the minimum is reported, not refused. Fix it with another call (move
the node, or make the frame bigger), or tell the user.

## 5. Show the result

- Diagram open: refresh it (task `refresh-diagram.md`) and look.
- Not open: offer to open it (task `open-or-create-swc-diagram.md`).

## 6. Report

Say what moved or changed, by name, and any warning you could not fix: "Placed
Controller right of Sensor and showed its 3 connected ports. Controller now
overlaps Logger; want me to move Logger down?"

## Traps

- **A component that was never placed on the diagram is not in
  `get_diagram_layout`.** Showing it is task `show-component-on-diagram.md` (one)
  or `show-or-hide-all.md` (many), not `set_node_visibility`.
- **Same for a connection that was never drawn**: `set_connection_visibility`
  only changes connections already on the diagram. To draw one on the canvas:
  show the ports at both ends first (`set_port_visibility`, then refresh), then
  in the component's ⋮ menu click **Show Connections of Visible Ports**, then
  **Save Diagram**. Avoid the menu's **Show Connections** picker for this for
  now: a connection drawn from it fails to save ("Save Failed").
- **If the user opens the Show Connections picker anyway**, know what it does:
  - There is no Apply button. Ticking a row draws the connection at once, and the
    tick and the counters catch up only after a second or two. Wait; don't click
    again.
  - Ticking also puts the component at the other end on the diagram if it
    wasn't there, and **that box is saved at once**. The ports it shows are not
    saved until **Save Diagram**.
  - Unticking removes the line only. The component it added and the ports stay.
  - The card's **Visible: N** counts shown **ports**, not connections, so it
    doesn't drop when you untick.
  - The checkbox at the top acts on every matching connection, including rows
    not scrolled into view yet. Its name says how many.
- **A new port or connection is a model change, not a layout change.** Stage it
  first (`stage_element`), then show it here.
- **Hiding a port hides its connections too.** Showing a connection also shows
  the ports at its ends.
- **`which: "connected"` / `"unconnected"` look at shown connections only.** A
  port whose connections are all hidden counts as unconnected.
- **Results list at most 50 names.** `changedCount` (or `movedCount`, …) is the
  exact total, and `…NotListed` says how many names were left out.
- **Hiding a frame doesn't hide the nodes inside it.**
- Port tools work only on composition and atomic component diagrams.
- Moving a port with the canvas's own right-click **Change Position** is not
  saved yet: after a refresh the port is back on its old side.
  `set_port_placement` is saved.
- `x`/`y` are relative to the node's frame, not to the screen. Prefer `beside`
  over computing coordinates.
- **The toolbar's Layout rearranges everything**, including what you placed. Don't
  press it after placing nodes by name unless the user asks.
- "This credential lacks the "diagram.write" scope": the user's API key is older
  than these tools. They need a new key from their **Profile** page, with
  **Arrange diagrams** ticked, set in the connector.
