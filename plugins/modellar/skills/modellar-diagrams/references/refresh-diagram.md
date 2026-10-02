# Refresh the open diagram

Redraw the open diagram from the database, without reloading the page. Use it when
something was added outside this canvas (through the Modellar tools, another tab,
another user) and the user wants to see it here.

The diagram does **not** pick up new nodes or handles by itself. It updates the
names and details of what is already on the canvas about every 10 seconds, but a
new component, port or connection appears only after a refresh. That is on
purpose: the canvas belongs to the user while they work on it.

## 1. Where am I?

The URL contains `/diagram/` and a canvas is shown. If not, there is nothing to
refresh. Open the diagram first (task `open-or-create-swc-diagram.md`).

## 2. Unsaved layout is lost

A refresh discards layout changes that weren't saved: nodes the user moved or
resized since the last **Save Diagram**. Components, ports and connections are never
deleted by it.

If the user may have moved things on this canvas, ask first: "Refreshing discards
unsaved layout changes. Save first?" If they want to save, click **Save Diagram**
and wait for the toast **"Diagram Saved"**.

## 3. Steps

1. In the floating dock on the canvas (the group of diagram action buttons), click
   **Reload Diagram**. If the dock is collapsed, click **Expand dock** first.
2. The dialog **"Reload diagram from the database?"** opens. Click **Reload diagram**.
   (**Cancel** closes it and changes nothing.)
3. Wait for the toast **"Diagram Reloaded"** ("<n> nodes, <m> edges read from the
   database").

The page doesn't reload, and the zoom and position stay as they were.

## 4. Report

Tell the user the diagram was refreshed, and what you expected to appear (for
example "SpeedSensor_Proto is now in the Components panel").

## Traps

- A refresh shows only elements that **have a place on this diagram**. A component
  that was staged but never added to the diagram stays off the canvas. Add it with
  task `show-component-on-diagram.md`.
- A toast **"Reload Failed"** means nothing changed. Report it; don't retry in a loop.
- Don't press the browser's reload instead: it does the same, but loses the zoom
  and position.
