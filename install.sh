#!/bin/bash

set -e

echo "======================================"
echo "       PRIVATE TERMINAL CHAT"
echo "          INSTALLER"
echo "======================================"
echo

INSTALL_DIR="$HOME/terminal-chat"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

echo "[1/4] Checking Python..."

if ! command -v python3 >/dev/null 2>&1; then
    echo "Python 3 is not installed."

    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y python3
    elif command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y python3
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --needed --noconfirm python
    else
        echo
        echo "Could not automatically install Python 3."
        echo "Please install Python 3 and run this installer again."
        exit 1
    fi
fi

echo "Python 3 found."
echo

echo "[2/4] Checking Tailscale..."

if ! command -v tailscale >/dev/null 2>&1; then
    echo "Tailscale is not installed."

    if command -v dnf >/dev/null 2>&1; then
        curl -fsSL https://tailscale.com/install.sh | sh
    elif command -v apt >/dev/null 2>&1; then
        curl -fsSL https://tailscale.com/install.sh | sh
    elif command -v pacman >/dev/null 2>&1; then
        curl -fsSL https://tailscale.com/install.sh | sh
    else
        echo
        echo "Could not automatically install Tailscale."
        echo "Please install Tailscale manually and run this installer again."
        exit 1
    fi
fi

echo "Tailscale found."
echo

echo "[3/4] Installing chat client..."

cat > "$INSTALL_DIR/client.py" <<'PYTHON'
import socket
import threading
import os

HOST = "100.119.205.8"
PORT = 5000


def receive_messages(sock):
    while True:
        try:
            data = sock.recv(4096)

            if not data:
                print("\nDisconnected from server.")
                os._exit(0)

            print(data.decode(), end="")
            print("> ", end="", flush=True)

        except:
            os._exit(0)


def main():
    os.system("clear")

    print("======================================")
    print("       PRIVATE TERMINAL CHAT")
    print("======================================")
    print()

    username = input("Username: ").strip()

    if not username:
        username = "Anonymous"

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    try:
        sock.connect((HOST, PORT))
    except:
        print()
        print("Could not connect to the chat server.")
        print()
        print("Make sure:")
        print("  - Tailscale is connected")
        print("  - You have joined the chat network")
        print("  - The server is online")
        print()
        return

    sock.sendall(username.encode())

    os.system("clear")

    print("======================================")
    print("       PRIVATE TERMINAL CHAT")
    print("======================================")
    print()
    print("Connected.")
    print()
    print("Commands:")
    print("  /users  - show who's online")
    print("  /quit   - leave the chat")
    print()

    receiver = threading.Thread(
        target=receive_messages,
        args=(sock,),
        daemon=True
    )

    receiver.start()

    while True:
        try:
            message = input("> ")

            if not message:
                continue

            sock.sendall(message.encode())

            if message == "/quit":
                break

        except KeyboardInterrupt:
            try:
                sock.sendall(b"/quit")
            except:
                pass
            break

    sock.close()


if __name__ == "__main__":
    main()
PYTHON

echo "[4/4] Creating chat command..."

cat > "$BIN_DIR/chat" <<'BASH'
#!/bin/bash
exec python3 "$HOME/terminal-chat/client.py"
BASH

chmod +x "$BIN_DIR/chat"

if ! grep -q 'HOME/.local/bin' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

export PATH="$HOME/.local/bin:$PATH"

echo
echo "======================================"
echo "       INSTALLATION COMPLETE"
echo "======================================"
echo

if command -v tailscale >/dev/null 2>&1; then
    echo "Tailscale is installed."
else
    echo "Tailscale installation may require attention."
fi

echo
echo "IMPORTANT:"
echo
echo "Tailscale must be connected to the same"
echo "private network as the chat server."
echo
echo "If you have not joined the chat network yet,"
echo "ask the chat owner for an invitation."
echo
echo "After Tailscale is connected, run:"
echo
echo "    chat"
echo
echo "======================================"
