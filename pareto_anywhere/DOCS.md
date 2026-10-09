# Pareto Anywhere add-on

Runs reelyActive's open-source Pareto Anywhere middleware on Home Assistant OS. HPE Aruba access points
forward BLE data to it over Aruba IoT Transport (WebSocket), and Node-RED consumes the decoded data
over Pareto Anywhere's Socket.IO API.

```
BLE sensors ─► Aruba APs ─(IoT Transport, ws://<HA host>:3001/aruba)─► Pareto Anywhere ─(Socket.IO)─► Node-RED
```

Everything is served on one port, **3001/tcp**:

| Path | Purpose |
|---|---|
| `/` | Pareto Anywhere web apps (Open Web UI) |
| `/aruba` | Aruba IoT Transport WebSocket endpoint (barnowl-aruba) |
| Socket.IO on `/` | Real-time raddec, dynamb and spatem stream for Node-RED |

## Installation

The image is built on the HA host and pulls source from github.com and packages from registry.npmjs.org,
so the host needs outbound internet access during installation. The add-on has no options to configure.
If you change the host port on the add-on's Network tab, use that port in the Aruba and Node-RED settings.

## Aruba configuration

The APs (or the Virtual Controller) must be able to reach the HA host on TCP 3001, so check firewall rules
and ACLs between the AP management VLAN and the HA host.

### AOS 8 (Instant)

```
(config) # iot transportProfile pareto
(IoT Transport Profile "pareto") # bleDataForwarding
(IoT Transport Profile "pareto") # endpointType telemetry-websocket
(IoT Transport Profile "pareto") # endpointURL ws://<HA host IP>:3001/aruba
(IoT Transport Profile "pareto") # endpointToken <any token>
(IoT Transport Profile "pareto") # payloadContent all
(IoT Transport Profile "pareto") # transportInterval 1
(IoT Transport Profile "pareto") # rssiReporting average
(IoT Transport Profile "pareto") # end
(config) # iot useTransportProfile pareto
```

Narrow `payloadContent` to just your sensor vendors once things are working, to cut traffic.

### AOS 10 (Central / IoT Operations)

Create a WebSocket IoT Transport pointing at the HA host on port 3001. Recent barnowl-aruba versions
document version-specific paths (`/aruba/aos8`, `/aruba/aos10`); confirm the correct path for your
Pareto Anywhere version against reelyActive's "Configure Aruba IoT Operations" tutorial.

### Security notes

- barnowl-aruba accepts any WebSocket client and does not validate `endpointToken`. Anyone who can
  reach port 3001 can send data or view the web apps, so restrict access to the AP and Node-RED hosts.
- This add-on serves plain `ws://`/`http://`. If your AOS version or policy requires `wss://`, put a TLS
  reverse proxy in front (e.g. the NGINX SSL proxy add-on) and point Aruba at that.

## Node-RED

1. Install the Node-RED add-on and, in Node-RED → Manage palette, install
   `@reelyactive/node-red-pareto-anywhere`.
2. Add a **pareto-anywhere-socketio** node. It defaults to `localhost:3001`, which does **not** work here
   because Node-RED runs in its own container. Point it at one of:
   - `http://local-pareto-anywhere:3001` (add-on internal hostname when installed as a local add-on;
     if installed from a Git repo, the hostname is `<repo-hash>-pareto-anywhere`, shown on the add-on's
     Info page)
   - `http://<HA host IP>:3001`
3. Wire its outputs to debug nodes. You should see `raddec` (who is where), `dynamb` (sensor readings)
   and `spatem` (location) messages.

From there, use the Home Assistant nodes in Node-RED to update entities, or route data anywhere else.

## Troubleshooting

- **Nothing in the web UI**: check the add-on log for Aruba connections; check the AP-side transport
  status (`show iot transportProfile` / `show iot server` on Instant); confirm TCP 3001 is reachable from
  the APs.
- **Web UI shows data but Node-RED doesn't**: the socket node is probably still pointing at localhost.
- Device names and metadata entered in the Pareto Anywhere apps may not survive an add-on rebuild.
