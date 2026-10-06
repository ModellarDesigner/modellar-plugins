# ModellAR plugins for Claude

A Claude plugin marketplace with one plugin, **`modellar`**. Its skills teach Claude
how to use the [ModellAR Designer](https://public-modellar-designer.vercel.app):
where things are, the order of steps, and the traps.

The skills work together with the **Modellar MCP connector**, which you connect
separately in Claude with an API key from your ModellAR **Profile** page. Claude uses
the connector by default, and the UI when you ask for something to be done visually.

## Install

**Claude Code**

```
/plugin marketplace add ModellarDesigner/modellar-plugins
/plugin install modellar@modellar-plugins
```

**claude.ai, Claude Desktop, Cowork:** Customize → Plugins → **Add marketplace** →
`ModellarDesigner/modellar-plugins`, then install **modellar**.

## Keep it updated

Updates reach you only if auto-update is on for this marketplace. It is **off by
default**. In Claude Code: `/plugin` → **Marketplaces** → `modellar-plugins` →
**Enable auto-update**.

## Layout

```
.claude-plugin/marketplace.json     the marketplace: lists the plugin below
plugins/modellar/
  .claude-plugin/plugin.json        the plugin: name, version
  skills/<area>/SKILL.md            one skill per area of the app, with a task table
  skills/<area>/references/*.md     one file per task, read only when needed
```

| Skill                    | Covers                                                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| `modellar-components`    | Create SWC types; add a component to a composition                                                                 |
| `modellar-diagrams`      | List, open or create diagrams; the properties panel; show a component; show or hide all; refresh                   |
| `modellar-ports`         | Add or edit a port; show, hide or move ports on a diagram                                                          |
| `modellar-connectors`    | Add or edit assembly and delegation connectors; show or hide them                                                  |
| `modellar-configuration` | Create, edit or find data types, interfaces, operations, modes, runnables, events and other configuration elements |
| `modellar-navigation`    | Go to a diagram, element or page: Go to… (Ctrl+K), sidebar or address                                              |

## Releasing a change

Bump `version` in `plugins/modellar/.claude-plugin/plugin.json` with every change
meant for users: patch for a wording fix, minor for a new task or skill. While the
version stays the same, installed copies are **not** updated, even when new commits
are pushed.

The pre-commit hook refuses a plugin change without a bump. Enable it once per clone:

```
git config core.hooksPath .githooks
```

The **Version bump** GitHub workflow checks the same rule on every push and pull
request, for commits made without the hook.
