# Pareto Anywhere for Home Assistant

Home Assistant OS add-on repository with one add-on, **Pareto Anywhere**, which ingests BLE data from
HPE Aruba APs (IoT Transport WebSocket) and serves it to Node-RED over Socket.IO.

## Install option A: local add-on

1. Install the **Samba share** or **Advanced SSH & Web Terminal** add-on.
2. Copy the `pareto_anywhere` folder into the host's `/addons` directory.
3. Settings → Add-ons → Add-on Store → ⋮ → **Check for updates**.
4. Open **Pareto Anywhere** under **Local add-ons** → **Install** → **Start**.

## Install option B: Git repository

1. Push this folder (including `repository.yaml`) to a Git repo reachable from the HA host and update
   the `url` in `repository.yaml`.
2. Settings → Add-ons → Add-on Store → ⋮ → **Repositories** → add the repo URL.
3. Install **Pareto Anywhere** from the store.

Bump `version` in `pareto_anywhere/config.yaml` to have HA offer an update after changes.

See `pareto_anywhere/DOCS.md` for Aruba and Node-RED setup.
