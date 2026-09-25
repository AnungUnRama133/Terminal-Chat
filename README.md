# Terminal Chat

A lightweight private terminal chat for friends.

Chat with friends directly from your Linux terminal through a private Tailscale network.

---

## What You Need

- A Linux computer
- An internet connection
- Tailscale
- An invitation to the private Tailscale network

You do not need to set up the chat server.

---

## 1. Join the Tailscale Network

The chat owner will send you an invitation to join the private Tailscale network.

Accept the invitation and connect Tailscale.

Check that Tailscale is running with:

```bash
tailscale status
```

---

## 2. Install Terminal Chat

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/AnungUnRama133/Terminal-Chat/main/install.sh | bash
```

The installer automatically:

- Installs Python if needed
- Installs Tailscale if needed
- Creates the chat client
- Configures the chat client automatically
- Creates the `chat` command
- Adds the command to your PATH

You do not need to enter an IP address or port.

---

## 3. Start Chatting

Run:

```bash
chat
```

Enter your username.

You should now be connected to the chat.

---

## Commands

### See who is online

```text
/users
```

### Leave the chat

```text
/quit
```

---

## Troubleshooting

### `chat: command not found`

Run:

```bash
source ~/.bashrc
```

Then:

```bash
chat
```

### Cannot connect

Check Tailscale:

```bash
tailscale status
```

Make sure you have joined the correct Tailscale network.

Then try:

```bash
chat
```

If you still cannot connect, contact the person who invited you.

---

## You Do Not Need To

You do not need to:

- Enter the server IP
- Enter the port
- Edit any files
- Configure a firewall
- Port-forward your router
- Set up a server
- Run Python manually

The installer handles the client configuration for you.

---

## Quick Start

If you have already joined the Tailscale network:

```bash
curl -fsSL https://raw.githubusercontent.com/AnungUnRama133/Terminal-Chat/main/install.sh | bash
```

Then:

```bash
chat
```

That is it.

---

## Have Fun

```text
======================================
       PRIVATE TERMINAL CHAT
======================================
