# Add a diagram to a workspace, and open it from there

A workspace diagram is a board of links: each box on it stands for another diagram
(composition, atomic SWC, ECU, system or another workspace). This task places an
existing diagram on the open workspace, and opens a diagram from its box.

Placing a box changes only this workspace, and the user can remove it again, so it
needs no confirmation. Creating a **new** diagram does (step 3).

No Modellar tool places a box on a workspace, so this task uses the UI. Use the
Modellar tools to look things up first.

## 1. Where am I?

You must be on the workspace: the URL contains `/diagram/workspace/`. If not, open it
first (skill `modellar-navigation`).

A workspace with no boxes shows **"No diagrams on this workspace yet."** on the
canvas. That is a finished page, not one still loading.

## 2. Check the diagram exists (MCP)

`list_diagrams({ modelId, diagramType })` lists the diagrams of that kind with their
names. Take the exact name from there.

- **Not in the list:** the diagram doesn't exist, or the user can't open it. Tell
  the user, and offer to create it (step 3).
- **Already a box on this workspace** (the page lists a group named
  `"<name> – <kind>"`): tell the user and stop. The app refuses a second box anyway,
  with the toast **"Already on canvas"**.

## 3. Place it

1. In the floating dock on the canvas, click the button for the diagram's kind:
   **Add Composition Diagram**, **Add Atomic Diagram**, **Add ECU Diagram**,
   **Add System Diagram** or **Add Workspace Diagram**. If the dock is collapsed,
   click **Expand dock** first.
2. A dialog opens. Its title matches the kind, e.g. **"Add an Atomic Diagram to the
   Workspace"**, and it lists the existing diagrams of that kind. To narrow the list,
   type in **Search existing diagrams...**.
3. Click the row button **"Add <name> to workspace"**. While it works, the row shows a
   spinner and the other rows are disabled. Then the dialog closes and the toast
   **"Diagram added"** appears (`"<name>" added to the workspace.`).
4. The new box appears in the middle of the current view.

The box is saved at once: it is still there after a reload. **Moving or resizing
boxes afterwards is not saved** until someone clicks **Save Diagram** in the dock
(toast **"Diagram Saved"**). While moves are unsaved, **Save Diagram** carries a small
dot, and its description reads "Unsaved layout changes: …". Save before you leave
the page.

**The diagram doesn't exist yet?** Click **Create Diagram** (for a workspace:
**Create Workspace**) in the same dialog only if the user asked for a new diagram.
Fill the form, then **stop before the final submit** and wait for the user's go. A
diagram created from this dialog is placed on the workspace too.

## 4. Open a diagram from its box

Use the box's menu; it is the most reliable way:

1. Click the box's menu button **"Actions for <name>"** (the ⋮ in the box's corner).
2. Click **Go to diagram**.

Other ways: double-click the box, or focus it, press **Enter** to select it, and
press **Enter** again to open it.

The page changes to that diagram. If the user has no access to it, a toast says so
and the page stays on the workspace.

## 5. Report

- Placed: "<name> is now on the workspace <workspace name>." Mention any box you
  moved, and whether you saved.
- Opened: the name and kind of the diagram that is now open.

## Traps

- **Delete node** in the box's menu removes the box from this workspace only. The
  diagram itself stays. The trash button in the **Add …** dialog's list deletes the
  **diagram**, for everyone: never click it unless the user asked to delete the
  diagram.
- Placing a box doesn't open the diagram. Open it with step 4 if the user wants to see
  it.
- Don't tell the user the layout is saved unless you saw the **"Diagram Saved"**
  toast, or **Save Diagram** no longer says "Unsaved layout changes".
