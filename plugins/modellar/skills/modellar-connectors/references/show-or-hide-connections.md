# Show or hide connections on a composition diagram

Draw a connector on the composition's diagram (show it), or take it off (hide it).
This changes only the drawing, never the model: no confirmation is needed.

For **all** connections, or all of one kind at once: skill `modellar-diagrams`,
task `show-or-hide-all.md`.

## 1. Where am I?

The composition's diagram: the URL contains
`/diagram/composition-sw-component-type/`. If not, open it (skill
`modellar-diagrams`, `open-or-create-swc-diagram.md`).

## 2. Which route

A connector has one of three states on a diagram. The card in the **Connections**
tab tells you by its button:

| Card button | State                       | MCP can …   |
| ----------- | --------------------------- | ----------- |
| **Add**     | never drawn on this diagram | nothing: UI |
| **Show**    | drawn, then hidden          | show it     |
| **Hide**    | shown                       | hide it     |

Through MCP: `get_diagram_layout` lists the connections the diagram has (shown or
hidden). A connector missing from it was never drawn: use the visual route.

## 3. MCP route (connections already on the diagram)

Skill `modellar-diagrams`, task `change-diagram-layout.md`: save first if the
diagram is open, then `set_connection_visibility` with `visible` and one of
`connections` (names), `node` (every connection of one component), `kind`
(`assembly`, `delegation`), combined to narrow; then refresh. Showing a
connection also shows the ports at its ends.

## 4. Visual route

### A connector already drawn (card button Show or Hide)

1. Select the composition's frame (click its header) and open the properties panel,
   tab **Connections** (skill `modellar-diagrams`, `properties-panel.md`).
2. Find the connector's card (**Filter** → **Search by name**, or **Connector
   Type**). Its title is the connector's name.
3. Click the card's **Show** or **Hide**. Toast: **"Connector shown successfully"**
   or **"Connector hidden successfully"**. If the card said shown but its ports were
   hidden, the click reveals the ports: **"Connection shown"**.
4. Click **Save Diagram** in the dock and wait for **"Diagram Saved"**.

### A connector never drawn (card button Add)

Draw it from its ports, the route known to save:

1. Show the port at **both** ends (skill `modellar-ports`,
   `show-hide-or-move-ports.md`). For a delegation, one end is the frame's port.
2. Open the ⋮ menu of a component at one end (**Actions for <name>**) and click
   **Show Connections of Visible Ports**. Toast **"Connections shown"**. It draws
   every connector between visible ports of that component.
3. Click **Save Diagram** and wait for **"Diagram Saved"**.

Avoid the ⋮ menu's **Show Connections** picker for this: a line drawn from it
currently fails to save (**"Save Failed"**). The Connections tab's **Show All**
draws lines that do save; the card's **Add** button uses the same drawing and
should too. If Save Diagram says **"Save Failed"** anyway, click **Reload
Diagram** and use the ports route above.

**One port's connections**: the Ports tab of the box → the port card's button
**Show connections of port <name>**, then Save Diagram.

## 5. Report

Which connections are now shown or hidden, and that it is saved.

## Traps

- **Drawing can place missing ends.** If a component at one end isn't on the
  diagram, drawing the connector places it too, and that box is saved at once.
- **Not saved = lost.** Reload Diagram or a page reload removes unsaved lines.
- The connector card's button is named just **Add** / **Show** / **Hide**: use the
  one inside the connector's own card.
- A component's ⋮ menu has no "Show Assembly Connections" item, whatever older
  notes say. Use **Show Connections of Visible Ports**.
- **"Save Failed"** after drawing a line: Reload Diagram (the unsaved line goes)
  and draw it again from its ports.
