---
name: modellar-navigation
description: Build the address of a ModellAR Designer page and go straight to it - a model, a diagram (composition, atomic SWC, ECU, system, workspace), or a configuration list, create or edit page for an element - instead of clicking through menus. Use when the user, in the ModellAR Designer (URL contains /designer/), asks to go to, open, jump to or show a model, diagram, element or configuration page, or after a Modellar MCP change to take the user to what changed.
---

# ModellAR: going to a page by address

Every designer page has an address you can build from ids the Modellar MCP
connector returns. Going there directly is faster and more reliable than clicking
through menus.

## Ground rules

- Use the host of the user's current tab. Never switch between the live site and a
  local one.
- Build addresses only from ids the tools returned. Never guess an id.
- Opening a page needs no confirmation.
- After opening, check the page: the top-left button shows the open diagram's name,
  and a configuration page shows its title. A page that is still loading can show
  the previous page for a moment; wait briefly and look again.
- **No Modellar tools?** Ask the user to connect the Modellar connector in Claude's
  connector settings, using an API key from their ModellAR **Profile** page
  (**New API key**). Until then, navigate with the menus.

## The model

`/designer/{modelId}`. `{modelId}` is the model's `id` or `slug` from
`list_accessible_models`, or the segment after `/designer/` in the current URL.
It opens the most recent workspace diagram.

## Diagrams

Get `{diagramId}` from `list_diagrams({ modelId, stagedElementId })`. It is the
diagram's own `id`, **not** the id of the element it shows.

| `diagramType` from `list_diagrams`                                  | Address                                                    |
| ------------------------------------------------------------------- | ---------------------------------------------------------- |
| `COMPOSITION_SW_COMPONENT_TYPE`, `ROOT_COMPOSITION_SW_COMPONENT_TYPE` | `/designer/{modelId}/diagram/composition-sw-component-type/{diagramId}` |
| `ATOMIC_SW_COMPONENT_TYPE`                                          | `/designer/{modelId}/diagram/atomic-sw-component-type/{diagramId}` |
| `ECU_MANAGEMENT`                                                    | `/designer/{modelId}/diagram/ecu/{diagramId}`              |
| `SYSTEM_MANAGEMENT`                                                 | `/designer/{modelId}/diagram/system/{diagramId}`           |
| `WORKSPACE`                                                         | `/designer/{modelId}/diagram/workspace/{diagramId}`        |

Without `{diagramId}` the address opens the most recent diagram of that kind.

There is no address that selects or centres one node. Once the diagram is open,
find the node by its name on the canvas.

## Configuration pages

`/designer/{modelId}/configuration/{section}` lists the elements of one kind.
Most sections also have:

- `/designer/{modelId}/configuration/{section}/create`: a new element;
- `/designer/{modelId}/configuration/{section}/{elementId}/edit`: edit one element.
  `{elementId}` is the element's `id` from `search_elements`.

Sections with create and edit pages:
`sw-component-types`, `sw-component-prototypes`, `port-prototypes`, `interfaces`,
`datatypes`, `operations`, `access-points`, `runnable-entitys` (spelled this way),
`rte-events`, `swc-internal-behaviors`, `com-specs`, `connectors`, `triggers`,
`variable-data-prototypes`, `parameter-data-prototypes`, `mode-declarations`,
`mode-declaration-groups`, `mode-declaration-group-prototypes`, `ecu-types`,
`system-configs`.

List only: `base-types`, `connections`, `ecu-ports`, `ecu-prototypes`, `mappings`,
`system-description`.

Other model pages: `/designer/{modelId}/arxml`, `/designer/{modelId}/validation`,
`/designer/{modelId}/analytics`.

## After an MCP change

- **A changed element that is already on an open diagram** updates by itself within
  about 10 seconds. No reload needed.
- **A new element** never appears on a diagram by itself. Go to the diagram, or to
  its configuration page, and tell the user where it is.
