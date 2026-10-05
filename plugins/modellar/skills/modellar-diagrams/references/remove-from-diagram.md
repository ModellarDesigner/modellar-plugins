# Remove components, ports or connections from a diagram

Take boxes, ports or connection lines **off one diagram**. Only the drawing goes:
the component, port or connector stays in the model, on every other diagram, and
can be put back on this one later (at a new default place).

## Hide, remove or delete: which one the user means

Three different things look alike. Pick by what the user wants to happen:

| The user wants …                                           | Effect                                                                          | Do                                                       |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------------- |
| "hide it", "not now", "declutter"                          | **Hide**: stays on the diagram, keeps its place, comes back with Show           | task `show-or-hide-all.md` or `change-diagram-layout.md` |
| "take it off this diagram", "it doesn't belong here"       | **Remove**: its box, ports and lines leave this diagram; the model is untouched | this task                                                |
| "delete the component / port / connector" (from the model) | **Delete**: the element itself goes, everywhere                                 | not available yet: tell the user                         |

When the words are ambiguous ("get rid of X", "delete X from the diagram"), ask:
"Hide it (keeps its place), or take it off this diagram? The component itself
stays in the model either way."

## 1. Where am I?

The URL contains `/diagram/`. The top-left button shows the diagram's name and
kind. Removing works on composition, atomic SWC, ECU and system diagrams. On a
**workspace**, a box stands for a whole diagram: its menu item is **Delete node**
(task `add-diagram-to-workspace.md`, Traps).

## 2. MCP route (default)

Many items in **one** call.

1. `list_diagrams` → the diagram's id. `get_diagram_layout` (pass `node` to see
   one box with all its ports) → find what the user named.
2. If the diagram is open in the user's tab, save first (task
   `change-diagram-layout.md`, step 3).
3. Say what will go, by name, including what goes along with it (a box takes its
   ports and every line on them, and the boxes inside it), and wait for go.
   Removing loses the boxes' places on this diagram.
4. Call `remove_from_diagram` with `diagramId` and any of:
   - `nodes`: box names (up to 100);
   - `frame` (+ `nameContains`): every box inside that frame, not the frame;
   - `ports`: per box, `{ node, ports | which | filter }` (composition and
     atomic diagrams only);
   - `connections` (names) or `connectionKind` (`assembly`, `delegation`,
     `mapping`): lines.
5. The answer lists `nodesRemoved`, `portsRemoved`, `connectionsRemoved`, and
   `alsoRemoved` (counts of what went with them). Refresh the open diagram
   (`refresh-diagram.md`).

The diagram's own frame can't be removed (the tool refuses): that would empty
the diagram. Deleting a whole diagram is not offered through the connector.

## 3. Visual route

### A box: the ⋮ menu

1. Open the box's ⋮ menu, top right of the box: the button **Actions for
   <name>**.
2. Click **Remove from Diagram** (red, last in the menu). It exists on component
   boxes (composition and ECU), ECU prototypes (system), runnables and RTE events
   (atomic). Frames don't have it.
3. The dialog **Remove from diagram?** says what goes: the box, its ports and
   position, and its connections on this diagram. Summarise it for the user and
   wait for go, then click **Remove** (not **Cancel**).
4. Toast **"Removed from diagram"**: "<name> and N connection(s) removed. The
   element itself was not deleted." It is saved at once: no Save Diagram needed.

On failure the toast is **"Remove failed"**: report its text.

### A port or a line

The UI has no remove for single ports or lines, only hide:

- a port: right-click its handle → **Hide Port**, or the Ports tab's eye button
  **Hide port <name>** (skill `modellar-ports`, `show-hide-or-move-ports.md`);
- a line: right-click it → **Hide connection** (**Hide mapping** on an ECU
  diagram), or the Connections tab's **Hide** (skill `modellar-connectors`,
  `show-or-hide-connections.md`).

Then **Save Diagram**. To really take them off, use the MCP route.

## 4. Report

What was removed from which diagram, what went along with it (ports, lines,
inner boxes), and that the model elements are untouched and can be shown again.

## Traps

- **Hide from Diagram ≠ Remove from Diagram.** Frames (and runnables, RTE
  events) have **Hide from Diagram** in the same menu: that only hides, and only
  until a reload unless you click **Save Diagram**.
- **Trash buttons delete the element, not the drawing.** In the properties panel,
  **Delete port <name>**, **Delete component prototype <name>**, **Delete
  connector <name>** and the line's right-click **Delete connection** / **Delete
  mapping** are about the model element. They open **Delete <Label>** with
  **Delete (not available yet)** disabled. Never use them to remove something
  from a diagram.
- The properties panel has **no** remove: its card buttons are **Add**, **Show**
  and **Hide** only.
- Right-clicking the canvas or a box opens nothing; the Delete key does nothing.
- Port handles can't be reached by keyboard: right-clicking one needs its
  position. Prefer the Ports tab or the MCP route.
- **Workspace boxes**: **Delete node** removes the box from the workspace at
  once, with no confirmation. The diagram itself stays.
- A removed component comes back with **Add** on its card (task
  `show-component-on-diagram.md`) or `set_node_visibility`, at a new place and
  with its ports hidden. A removed connector comes back drawn with
  `set_connection_visibility`.
