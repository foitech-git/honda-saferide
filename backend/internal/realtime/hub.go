package realtime

import (
	"log"
	"net/http"
	"sync"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		// Allow all origins for development
		return true
	},
}

// Hub maintains the set of active clients and broadcasts messages to the clients.
type Hub struct {
	sync.RWMutex
	clients map[*websocket.Conn]string // Map connection to User/Device ID
}

func NewHub() *Hub {
	return &Hub{
		clients: make(map[*websocket.Conn]string),
	}
}

func (h *Hub) HandleConnection(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("Failed to upgrade connection: %v", err)
		return
	}

	h.Lock()
	// In a real scenario, extract the user/device ID from auth token or query params
	h.clients[conn] = "anonymous"
	h.Unlock()

	go h.readPump(conn)
}

func (h *Hub) readPump(conn *websocket.Conn) {
	defer func() {
		h.Lock()
		delete(h.clients, conn)
		h.Unlock()
		conn.Close()
	}()

	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("error: %v", err)
			}
			break
		}
		
		// For the development simulator: echo incoming telemetry/events to all clients.
		// In production, this would go through a message broker (MQTT/EMQX) and event processor.
		h.Broadcast(message)
	}
}

func (h *Hub) Broadcast(message []byte) {
	h.RLock()
	defer h.RUnlock()
	for conn := range h.clients {
		err := conn.WriteMessage(websocket.TextMessage, message)
		if err != nil {
			log.Printf("error writing message: %v", err)
			conn.Close()
		}
	}
}
