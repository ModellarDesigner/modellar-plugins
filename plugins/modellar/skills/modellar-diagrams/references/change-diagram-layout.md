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

Find what the user named. If a name matches several nodes, ask which one; the
tools refuse to guess and list the candidates.

## 3. If the diagram is open: Save first

The tools write to the saved diagram. An open canvas shows the change only after
**Reload Diagram**, and a **Save Diagram** pressed on it afterwards writes the old
layout back over your change.

So, **before** you change anything on an open diagram:

1. Ask: "I'll save the diagram first so nothing you arranged is lost. OK?" Then
   click **Save Diagram** in the floating dock (or ask the user to) and wait for
   the toast **"Diagram Saved"**.
2. Make the changes (step 4).
3. Refresh with task `refresh-diagram.md`. Skip its "Save first?" question: you
   just saved.

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
  `get_diagram_layout`.** Showing it is task `show-component-on-diagram.md`, not
  `set_node_visibility`.
- **Same for a connection that was never drawn**: `set_connection_visibility`
  only changes connections already on the diagram. Otherwise use the component's
  ⋮ menu (**Show Assembly Connections** / **Show Delegation Connections**) on the
  canvas, then **Save Diagram**.
- **A new port or connection is a model change, not a layout change.** Stage it
  first (`stage_element`), then show it here.
- **Hiding a port hides its connections too.** Showing a connection also shows
  the ports at its ends.
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
