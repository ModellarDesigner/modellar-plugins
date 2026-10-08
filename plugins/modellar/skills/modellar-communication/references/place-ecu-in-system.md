# Place an ECU in a system

Make an ECU type part of a system (an ECU prototype), so it can send and receive
that system's PDUs. This is why an ECU is missing from **Add transmitting ECU**.

## 1. Where am I?

- From the System Description editor: the assign dialog offers it for the diagram's
  own ECU (task `send-or-receive-a-pdu.md`, visual route step 2).
- On a **System diagram**: select the system frame; tab **ECU Prototypes** lists the
  ECUs placed in it (heading **ECU Instance Prototypes**).

## 2. MCP route (default)

1. `list_ecus({ modelId, search: "<ECU name>" })`: its `id` and `placedIn`. Already
   placed in the system: nothing to do.
2. `list_systems({ modelId })`: the system's `id` (pick by `sourceFile` when names
   repeat). For a PDU, use the system `get_pdu` returns.
3. The batch: `list_staging_batches({ modelId })`, the user picks.
4. Summarise ("place ECU X in system S, file F") and wait for go.
5. `place_ecu_in_system({ modelId, batchId, ecuId, systemId })`. It fills every
   reference itself. When the ECU is already there it answers `alreadyPlaced: true`
   and stages nothing. When another ECU of the same name is already placed in the
   system, the new placement is named `<ECU>_1` (then `_2` …): its `qualifiedName`
   in the answer says which.

## 3. Visual route

1. Open the System diagram of that system (skill `modellar-diagrams`).
2. Select the system frame. Tab **ECU Prototypes**. Click **Add ECU Prototype** (or
   **Add your first ECU prototype** when the list is empty). Dialog **Create ECU
   Prototype**.
3. **Staging Batch**, **Short Name** (usually the ECU's own name), **ECU Instance
   Type** (the ECU), optional **Description**.
4. Summarise and wait for go. Click **Create Prototype**.

## 4. Report

The ECU, the system and its file. Offer the next step: making it send or receive the
PDU (`send-or-receive-a-pdu.md`).

## Traps

- Several systems are called "CanSystem": place the ECU in the PDU's own system (its
  file), or it still can't be picked. `list_ecus` gives each placement's
  `systemSourceFile`.
- `stage_element` with `EcuInstancePrototype` needs seven reference fields, two of
  them duplicates: use `place_ecu_in_system` instead.
