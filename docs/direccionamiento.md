# Plan de direccionamiento — Infraestructura 3

| Segmento | Dispositivo / interfaz | Dirección | Prefijo | Función |
|---|---|---:|---:|---|
| Salida GNS3/NAT | ISP-2174 Fa0/0 | DHCP (observado: `192.168.136.129`) | /24 | Salida a Internet del laboratorio |
| WAN FortiGate–ISP | ISP-2174 Fa1/0 | `21.74.3.1` | /30 | Lado ISP |
| WAN FortiGate–ISP | FG-2174 port1 / WAN-ISP | `21.74.3.2` | /30 | WAN FortiGate |
| WAN ISP–Cisco | ISP-2174 Fa1/1 | `21.74.4.1` | /30 | Lado ISP |
| WAN ISP–Cisco | R-CISCO-2174 Fa1/0 | `21.74.4.2` | /30 | WAN Cisco / publicación HTTPS |
| Usuarios VLAN 10 | FG-2174 VLAN10-USERS | `10.21.74.1` | /25 | Gateway + DHCP |
| Usuarios VLAN 10 | PC-USER-2174 | DHCP (observado: `10.21.74.10`) | /25 | Cliente de usuario |
| Servidores | R-CISCO-2174 Fa1/1 | `10.21.74.129` | /28 | Gateway del servidor |
| Servidores | WEB-SV-2174 ens3 | `10.21.74.130` | /28 | HTTPS/443 + SSH/22 |
| Acceso VPN | FG-2174 port3 | `192.168.79.99` | /24 | Terminación IPsec / GUI del laboratorio |
| Acceso VPN | VPN-CLIENT-2174 ens3 | `192.168.79.2` | /24 | Cliente strongSwan |
| Pool IPsec | VPN-REMOTE-2174 | `10.212.135.10` – `10.212.135.20` | /24 | Direcciones virtuales de clientes VPN |
| IP virtual observada | VPN-CLIENT-2174 | `10.212.135.10` | /32 | IP asignada al túnel activo |

## DHCP de VLAN 10

- Pool: `10.21.74.10` – `10.21.74.100`
- Gateway: `10.21.74.1`
- DNS: `8.8.8.8` y `1.1.1.1`

## Publicación HTTPS

`R-CISCO-2174` publica únicamente HTTPS mediante NAT estático:

```text
21.74.4.2:443  ->  10.21.74.130:443
```

## Acceso SSH por VPN

El cliente IPsec recibe `10.212.135.10/32` y el split tunnel instala una ruta específica hacia `10.21.74.130/32`. En FortiGate, la política de la VPN permite únicamente el servicio SSH hacia `WEB-SV-2174`.
