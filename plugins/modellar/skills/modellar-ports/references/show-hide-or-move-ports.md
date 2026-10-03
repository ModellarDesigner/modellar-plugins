# Show, hide or move ports on a diagram

Draw a port on a box (show it), take it off (hide it), or move it to another side
of the box. This changes only the drawing on one diagram, never the model. No
confirmation is needed.

For **all** ports of a box at once: skill `modellar-diagrams`, task
`show-or-hide-all.md`. This task is for some ports by name or kind (connected,
unconnected).

Composition and atomic SWC diagrams only. ECU ports work the same way in the
visual route (no Edit there).

## 1. Where am I?

The URL contains `/diagram/composition-sw-component-type/` or
`/diagram/atomic-sw-component-type/`. Name the box whose ports change: the
diagram's frame (the SWC itself) or a component box inside a composition.

## 2. MCP route (default)

Skill `modellar-diagrams`, task `change-diagram-layout.md`: save first if the
diagram is open, then `set_port_visibility` (show, hide; by `ports` or `which`:
`all`, `connected`, `unconnected`) or `set_port_placement` (`side`: `left`,
`right`, `top`, `bottom`), then refresh.

A port missing from `get_diagram_layout` was just created and never drawn on this
diagram: use the visual route to show it.

## 3. Visual route

Moving a port to another side has **no lasting way in the UI**: the handle's menu
item **Change Position** is unfinished (marked "TODO") and isn't saved. Use the MCP
route for moving.

### Show or hide

1. Select the box (a frame: click its header; a component: click the box) and open
   the properties panel, tab **Ports** (skill `modellar-diagrams`,
   `properties-panel.md`).
2. Find the port's card (use **Filter** → **Search by name** in a long list).
3. Click its eye button: **Show port <name>** or **Hide port <name>**. Toast:
   **"Port visibility updated"**, "Port <name> is now visible" (or hidden). A hidden
   port's card is dimmed.
4. Click **Save Diagram** in the dock and wait for **"Diagram Saved"**. Ports are not
   saved until then, and the dock shows no unsaved dot for them.

Showing a component's connected ports only: on the component box's ⋮ menu
(**Actions for <name>**) the item **Show Ports** opens a list with one checkbox per
port; or filter the Ports tab and use the eye buttons. The node menu also has
**Hide All Ports**.

## 4. Report

Which ports of which box are now shown, hidden or moved, and that it is saved.

## Traps

- **New box, no ports.** A component just put on a composition diagram shows none
  of its ports: that's by design, not a fault. Show the ones the user wants.
- **Hiding a port: the tool and the screen differ.** `set_port_visibility` hides
  the port's connections too. The Ports tab's eye only hides the port: its line
  stops being drawn but stays "shown", and comes back when the port is shown
  again. To take the line away for good, hide the connection as well.
- **"Unconnected" means no shown connection.** A port whose only connection is
  hidden counts as unconnected for `which`.
- **First show picks the side by direction**: provider ports on the right, receiver
  ports on the left. Move them afterwards with `set_port_placement` if asked.
- Canvas port handles can't be focused or named by the keyboard: right-clicking one
  needs its position. Prefer the Ports tab, whose buttons are named.
- **Not saved = lost**, in the visual route: **Reload Diagram** or a page reload
  brings back the old ports.
