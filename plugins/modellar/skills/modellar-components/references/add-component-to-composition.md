# Add a component to a composition

Add a component (an SWC prototype: an instance of an atomic or composition type) to
a composition, and make it visible on the composition's diagram. The Modellar MCP
connector looks things up and finds the diagram. The component is added in the UI
for now (see section 3).

The user names two things:

- **the composition** (e.g. "Zuko"): the parent that gets the new component;
- **the component type** (e.g. "SpeedSensor"): what gets instantiated.

Optionally they also give the **instance name** (the prototype's short name).

## 1. Where am I?

URL: `https://<host>/designer/{modelId}/...`. Take `{modelId}` from it.

You are already on the composition's diagram if **both** are true:

- the URL contains `/diagram/composition-sw-component-type/`;
- the top-left button shows the composition's name, with "Composition" underneath.

## 2. Look up and check (MCP)

1. Call `search_elements({ modelId, elementType: "SwComponent", search: "<name>", includeElementData: true })`
   once for the composition and once for the component type.
   - The composition's `elementData.type` must be `Composition` (or
     `RootComposition`). If it's anything else, tell the user.
   - If the component type doesn't exist, offer to create it first (task
     `create-swc-type.md` in this skill).
   - Several matches: ask which one, showing each `qualifiedName`.
2. **No duplicate instance.** Call
   `search_elements({ modelId, elementType: "SwComponentPrototype", search: "<instance name>" })`.
   If a match's `qualifiedName` is `<the composition's qualifiedName>/<instance name>`,
   stop and tell the user. The Components panel (visual route) shows the same list.
3. **Get onto the composition's diagram.** Use skill `modellar-diagrams`, task
   `open-or-create-swc-diagram.md`: `list_diagrams` with the composition's id, then
   open `/designer/{modelId}/diagram/composition-sw-component-type/{diagramId}`.
   Skip this if section 1 says you are already there.

## 3. Add it

**The UI does the write for now.** `stage_element` (element type
`SwComponentPrototype`) needs the id of the user's staging batch, and no Modellar
tool returns one yet. A component added that way would also stay off the canvas
until it's added in the UI. Don't ask the user for a batch id.

Summarise the instance name, the type's `qualifiedName` and the composition for the
user and ask for go, then follow the visual route below.

## 4. Visual route

### Open the Components panel

1. On the canvas, click the big **frame** whose header shows the composition's
   name. It's the outer box that contains the other components. This selects it.
2. Open the properties panel with the button **Properties panel** (a small "<"
   chevron on the right edge of the canvas, at mid-height). Collapsed, it is
   `expanded=false`. If the panel is already open, it shows the heading
   **Properties**, and the button is `expanded=true`: don't click it again.
3. In the panel, click the tab **Components**. The tabs are Properties, Ports,
   Components, Connections. You now see "SW Component Prototypes".
4. **Check for duplicates.** If the instance name is already in the list, stop
   and tell the user.

### Fill the Add Component form

1. Click **Add Component**. If the list is empty, the button reads **Add your
   first component** instead.
2. The dialog **Add Component to <Composition>** opens.
3. **Short Name \*.** The instance name. If the user didn't give one, propose
   `<TypeName>_Proto` or ask. It must start with a letter and use only letters,
   digits and `_`.
4. **Software Component Type \*.** Click the combobox **Select a component type...**,
   type the type's short name into the search box, and pick the row whose grey path
   equals its `qualifiedName`. Atomic and composition types are both listed; the
   type chip narrows the list. Root compositions are never offered.
5. **Description.** Optional.
6. If you haven't confirmed the values yet, summarise them and wait for go. Then
   click **Create Prototype** and wait until it stops reading "Creating...".

Success shows the toast **"Component prototype created successfully."**

### Make it visible on the canvas

A new component is created **hidden**. The count grows, but nothing appears on
the canvas yet.

1. In the Components list, find the new card. Its status icon reads "Not in diagram".
2. Click its footer button **Add** (tooltip "Add component to diagram").
3. Toast: "Component node created successfully". The box now appears inside the frame.

Don't use **Show All** unless the user asks. It reveals every hidden component, not
just this one.

## 5. Report

Tell the user the instance name, its type (qualified name), the composition, and
that it is now shown on the diagram.

## Traps

- Clicking the frame alone does not open the panel. You must click the "<" button.
- The frame's ⋮ menu has no "add component" item, and its "Show Details" does
  nothing. Use the panel.
- If the Components tab list is filtered (a **Filter** popover with search,
  status and visibility), the new card may be hidden. Use **Clear filters**.
- **Reload Diagram** in the dock doesn't bring a hidden component onto the canvas.
  Only its **Add** button does.
