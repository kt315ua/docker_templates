# Wireguard Client setup

## Docker deploy

1. Prepare network macvlan for using `IP_ADDR` env from env-file.template and save it as `.env` (DO NOT commit that file)
2. Setup volume `wireguard_data` in portainer
3. Put `wg_vpn.conf`, `wg_vpn_up.sh` and `wg_vpn_down.sh` into volume `wireguard_data`
4. Update settings in `wg_vpn.conf` (DO NOT commit that file with changes)
5. Deploy service: `docker-compose up -d`
6. Service will be running until stop

