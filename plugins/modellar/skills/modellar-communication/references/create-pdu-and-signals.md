# Create a PDU and its signals

Create a new PDU (with its interface, and optionally its frame and its system), add
signals to a PDU, or change a PDU or a signal.

## 1. Where am I?

The System Description editor (skill `modellar-communication`, task
`find-pdus-and-signals.md`, section 1). On a diagram's dock panel, press **Edit**
(top right) first: it opens view only.

## 2. MCP route (default)

**New PDU**

1. Look first: `list_pdus({ modelId, search: "<name>" })`. A PDU with that name
   already made in the app makes `create_pdu` refuse.
2. Find the system: `list_systems({ modelId })` (pick by `sourceFile` when names
   repeat). **Pick the system now**: without one, no ECU can send or receive the
   PDU. A frame is optional: `search_elements({ modelId, elementType: "Frame",
   search: "<frame name>" })`.
3. The batch: `list_staging_batches({ modelId })`, the user picks.
4. Summarise (name, length in bytes, PDU type, bus, system, frame) and wait for go.
5. `create_pdu({ modelId, batchId, name, lengthBytes, controllerType, pduType?,
   systemId?, frameId? })`. `controllerType` is the bus: `CAN`, `CANFD`, `LIN`,
   `FlexRay`, `Ethernet` or `MOST`.

**New signal**

1. `get_pdu({ modelId, pduId })`: its signals and free bits.
2. Summarise (name, start bit, bit length, all in **bits**) and wait for go.
3. `add_signal({ modelId, batchId, pduId, name, bitLength, startBit? })`. Without
   `startBit` it goes right after the last signal; the answer says where. It is
   refused when it overlaps a signal, doesn't fit the PDU's length, or the name is
   taken in that PDU.

**Change a PDU or a signal**: no dedicated tool. Use `update_staged_element`
(general rules apply), or the visual route below.

A failed write lists what it already staged before the failure: don't stage those
again. Afterwards, send the user to the System Description page and have them press
**Refresh**.

## 3. Visual route

**New PDU**

1. Click **New PDU**. Dialog **New PDU**.
2. **Name**, **Length (bytes)**, **PDU type**, **Controller**.
3. **Frame (optional)** and **System (optional)**: searchable lists. Type part of a
   name, or of the file name shown under it, then click the row.
4. Summarise and wait for go. Click **Create**. Toast **PDU created**; the new PDU's
   row opens.

**New signal**

1. In the PDU's opened row click **+ Signal** (named "Add signal to <PDU>"). Dialog
   **New Signal**, with **Parent PDU** set and **Start bit** at the first free bit.
   (The toolbar's **New Signal** does the same for the one open PDU, or the PDU just
   created; otherwise pick **Parent PDU** from its searchable list.)
2. **Name**, **Bit length** (bits). **End bit** is computed. Optional **Data type
   reference** and **Description**.
3. Summarise and wait for go. Click **Create**. Toast **Signal created**; the signal
   appears in the opened row. A refused signal shows the reason in the toast.

**Edit**

- **Edit PDU**: the pencil in the opened row's header (named "Edit PDU <PDU>").
  Name, type, length, **System**, **Frame**; **Save**. Choosing **No system** removes
  the PDU's system link.
- **Edit a signal**: the pencil on the signal's line (named "Edit <signal>"). Dialog
  **Edit signal**; **Save**.

## 4. Report

What was created (PDU qualified name, its system, frame) or the signal (start bit,
bit length). Offer the next step: signals, then who sends and receives it
(`send-or-receive-a-pdu.md`).

## Traps

- Length units: the PDU in **bytes**, signals in **bits**. 8 bytes = bits 0–63.
- Escape or a click outside does **not** close a dialog that holds input: use
  **Cancel**.
- Deleting a PDU or signal isn't possible yet. **Delete <PDU>** (trash icon) only
  shows what a delete would affect; `get_deletion_impact` gives the same list.
