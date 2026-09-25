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

echo "[1/3] Installing chat client..."

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
        print("Make sure Tailscale is connected.")
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

echo "[2/3] Creating chat command..."

cat > "$BIN_DIR/chat" <<'BASH'
#!/bin/bash
exec python3 "$HOME/terminal-chat/client.py"
BASH

chmod +x "$BIN_DIR/chat"

echo "[3/3] Configuring PATH..."

if ! grep -q 'HOME/.local/bin' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

export PATH="$HOME/.local/bin:$PATH"

echo
echo "======================================"
echo "       INSTALLATION COMPLETE"
echo "======================================"
echo
echo "Run the chat with:"
echo
echo "    chat"
echo
echo "Make sure Tailscale is connected first."
echo
