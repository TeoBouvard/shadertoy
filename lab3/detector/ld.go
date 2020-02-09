// +build !solution

package detector

import (
	"sort"
	"sync"
)

// A MonLeaderDetector represents a Monarchical Eventual Leader Detector as
// described at page 53 in:
// Christian Cachin, Rachid Guerraoui, and Luís Rodrigues: "Introduction to
// Reliable and Secure Distributed Programming" Springer, 2nd edition, 2011.
type MonLeaderDetector struct {
	nodeIDs     []int
	suspected   map[int]bool
	leader      int
	subscribers map[int]chan int

	mutex sync.Mutex
}

// NewMonLeaderDetector returns a new Monarchical Eventual Leader Detector
// given a list of node ids.
func NewMonLeaderDetector(nodeIDs []int) *MonLeaderDetector {
	m := &MonLeaderDetector{
		nodeIDs:     nodeIDs,
		suspected:   make(map[int]bool),
		leader:      UnknownID,
		subscribers: make(map[int]chan int, len(nodeIDs)),
		mutex:       sync.Mutex{},
	}

	m.leader = m.Leader()
	for i := range m.subscribers {
		m.subscribers[i] = make(chan int, len(nodeIDs))
	}

	return m
}

// Leader returns the current leader. Leader will return UnknownID if all nodes
// are suspected.
func (m *MonLeaderDetector) Leader() int {
	// TODO(student): Implement
	// https://golang.org/pkg/sort/#Reverse
	sort.Sort(sort.Reverse(sort.IntSlice(m.nodeIDs)))
	for _, id := range m.nodeIDs {
		if id > UnknownID && !m.suspected[id] {
			return id
		}
	}
	return UnknownID
}

// Suspect instructs m to consider the node with matching id as suspected. If
// the suspect indication result in a leader change the leader detector should
// this publish this change its subscribers.
func (m *MonLeaderDetector) Suspect(id int) {
	m.mutex.Lock()
	defer m.mutex.Unlock()
	m.suspected[id] = true
	//log.Printf("Node [%d] is suspected\n", id)
	m.publish()
}

// Restore instructs m to consider the node with matching id as restored. If
// the restore indication result in a leader change the leader detector should
// this publish this change its subscribers.
func (m *MonLeaderDetector) Restore(id int) {
	m.mutex.Lock()
	defer m.mutex.Unlock()
	delete(m.suspected, id)
	m.publish()
}

// Subscribe returns a buffered channel that m on leader change will use to
// publish the id of the highest ranking node. The leader detector will publish
// UnknownID if all nodes become suspected. Subscribe will drop publications to
// slow subscribers. Note: Subscribe returns a unique channel to every
// subscriber; it is not meant to be shared.
func (m *MonLeaderDetector) Subscribe(id int) <-chan int {
	m.mutex.Lock()
	defer m.mutex.Unlock()
	sub := make(chan int, 10)
	m.subscribers[id] = sub
	return sub
}

func (m *MonLeaderDetector) Unsubscribe(id int) {
	m.mutex.Lock()
	defer m.mutex.Unlock()
	delete(m.subscribers, id)
}

func (m *MonLeaderDetector) publish() {
	potentialLeader := m.Leader()
	if m.leader != potentialLeader {
		m.leader = potentialLeader
		for _, sub := range m.subscribers {
			sub <- m.leader
		}
	}
}
