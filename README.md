# Terminal Chat

A lightweight private terminal chat application built with Python, TCP sockets, systemd, and Tailscale.

Terminal Chat allows multiple people to communicate through their terminals over a private Tailscale network.

---

# Features

- Lightweight Python TCP chat server
- Python terminal client
- Private networking through Tailscale
- Multiple users
- Username support
- `/users` command
- `/quit` command
- Automatic server startup with systemd
- Simple `chat` command
- One-command client installation
- Fedora firewalld support
- No public port forwarding required

---

# How It Works

```text
                         TAILSCALE
                    Private Network
                           │
             ┌─────────────┴─────────────┐
             │                           │
             ▼                           ▼

       SERVER COMPUTER              CLIENT COMPUTER
       ───────────────              ───────────────
       Linux                        Linux
       Tailscale                    Tailscale
       Python                       Python
          │                            │
          ▼                            ▼
     server.py                     client.py
          │                            │
          │       TCP port 5000        │
          └────────────────────────────┘
