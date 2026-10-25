# Changelog

## 2.0.1
- Use reelyActive's recommended quick-start clone (`git clone --recurse-submodules`) with full history.
- Keep the .git folder and git binary in the image; optional PARETO_ANYWHERE_REF checkout.

## 2.0.0
- Data source is now HPE Aruba APs via IoT Transport WebSocket (built into Pareto Anywhere).
- Removed local Bluetooth scanning (barnowl-hci); no host networking or elevated privileges required.
- Removed MQTT bridge; consume data from Node-RED via Pareto Anywhere's Socket.IO API.

## 1.0.0
- Initial release.
