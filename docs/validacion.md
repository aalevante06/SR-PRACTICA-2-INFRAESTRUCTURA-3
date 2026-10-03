# Validación de la Infraestructura 3

La validación comprueba dos requisitos independientes:

1. **HTTPS debe funcionar sin VPN.**
2. **SSH al servidor debe funcionar únicamente mediante la VPN IPsec Remote Access.**

| Evidencia | Validación | Resultado |
|---|---|---|
| `02-fortigate-interfaces.png` | WAN, VLAN 10, port3 y túnel definidos | OK |
| `03-fortigate-firewall-policies.png` | SSH directo bloqueado y SSH desde VPN permitido | OK |
| `04-ipsec-vpn-remote-access.png` | FortiGate muestra una conexión dial-up activa | OK |
| `05-strongswan-vpn-established.png` | IKE_SA y CHILD_SA establecidos | OK |
| `06-ssh-con-vpn-exitoso.png` | Login SSH exitoso a `10.21.74.130` por VPN | OK |
| `07-ssh-sin-vpn-bloqueado.png` | Al bajar el túnel, el cliente VPN pierde la ruta protegida | OK |
| `08-https-sin-vpn-exitoso.png` | `https://21.74.4.2` devuelve `HTTP/1.1 200 OK` sin VPN | OK |
| `09-web-ok-ssh-bloqueado-sin-vpn.png` | Desde PC-USER: HTTPS funciona y SSH directo expira | OK |
| `10-ruta-ssh-por-vpn.png` | Ruta al servidor usa `src 10.212.135.10` vía `192.168.79.99` | OK |
| `11-cisco-nat-y-exencion-vpn.png` | PAT + publicación 443 + exención de retorno hacia `21.74.3.2` | OK |
| `12-isp-ruta-hacia-web-server.png` | ISP enruta `10.21.74.128/28` vía `21.74.4.2` | OK |
| `17-switch-vlan10-y-trunk.png` | VLAN 10 activa y trunk permite VLAN 10 | OK |
| `19-fortigate-ipsec-phase1.png` | IKEv1 Aggressive, XAUTH, pool y DH5 | OK |
| `20-fortigate-ipsec-phase2.png` | DES/SHA1, PFS DH5 y lifetime 43200 s | OK |
| `23-web-server-puertos-ssh-https.png` | Servidor escucha en TCP/22 y TCP/443 | OK |
| `26-cisco-nat-https.png` | Traducción estática `21.74.4.2:443 -> 10.21.74.130:443` | OK |

## Prueba funcional principal

### HTTPS sin VPN

Desde `PC-USER-2174`:

```bash
curl -k -I https://21.74.4.2
```

Resultado observado: `HTTP/1.1 200 OK` con Apache2.

### SSH directo bloqueado

Desde `PC-USER-2174`:

```bash
ssh -o ConnectTimeout=5 ariel@10.21.74.130
```

Resultado observado: `Connection timed out`.

### SSH por VPN

Desde `VPN-CLIENT-2174`:

```bash
sudo ipsec up VPN-REMOTE-2174
ip route get 10.21.74.130
ssh ariel@10.21.74.130
```

Resultado observado:

- VPN establecida correctamente.
- IP virtual `10.212.135.10/32`.
- Ruta protegida hacia `10.21.74.130` vía `192.168.79.99`.
- Sesión SSH exitosa en `WEB-SV-2174`.

## Flujo de retorno SSH

La política VPN del FortiGate aplica SNAT con `21.74.3.2`. El router Cisco excluye de PAT el tráfico del servidor destinado a `21.74.3.2`, por lo que la respuesta regresa al FortiGate sin una segunda traducción. El FortiGate asocia el retorno a la sesión y lo entrega al cliente por el túnel IPsec.
