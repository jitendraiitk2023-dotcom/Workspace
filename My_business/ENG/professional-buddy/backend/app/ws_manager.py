from typing import Dict
from fastapi import WebSocket


class ConnectionManager:
    """Keeps track of one active websocket per online user_id and routes messages."""

    def __init__(self):
        self.active_connections: Dict[str, WebSocket] = {}

    async def connect(self, user_id: str, websocket: WebSocket):
        await websocket.accept()
        self.active_connections[user_id] = websocket

    def disconnect(self, user_id: str):
        self.active_connections.pop(user_id, None)

    async def send_to_user(self, user_id: str, payload: dict):
        """Send if the user is currently connected. Returns True if delivered live."""
        ws = self.active_connections.get(user_id)
        if ws:
            try:
                await ws.send_json(payload)
                return True
            except Exception:
                self.disconnect(user_id)
        return False

    def is_online(self, user_id: str) -> bool:
        return user_id in self.active_connections


manager = ConnectionManager()
