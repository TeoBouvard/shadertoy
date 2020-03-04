// +build !solution

package singlepaxos

// Acceptor represents an acceptor as defined by the single-decree Paxos
// algorithm.
type Acceptor struct {
	//TODO(student): Task 2 and 3 - algorithm and distributed implementation
	// Add needed fields
	id int

	rnd  Round
	vrnd Round
	vval Value

	prepareIn chan Prepare
	acceptIn  chan Accept

	promiseOut chan<- Promise
	learnOut   chan<- Learn

	stop chan struct{}
}

// NewAcceptor returns a new single-decree Paxos acceptor.
// It takes the following arguments:
//
// id: The id of the node running this instance of a Paxos acceptor.
//
// promiseOut: A send only channel used to send promises to other nodes.
//
// learnOut: A send only channel used to send learns to other nodes.
func NewAcceptor(id int, promiseOut chan<- Promise, learnOut chan<- Learn) *Acceptor {
	//TODO(student): Task 2 and 3 - algorithm and distributed implementation

	return &Acceptor{
		id: id,

		rnd:  NoRound,
		vrnd: NoRound,
		vval: ZeroValue,

		prepareIn: make(chan Prepare, 10),
		acceptIn:  make(chan Accept, 10),

		promiseOut: promiseOut,
		learnOut:   learnOut,

		stop: make(chan struct{}),
	}
}

// Start starts a's main run loop as a separate goroutine. The main run loop
// handles incoming prepare and accept messages.
func (a *Acceptor) Start() {
	go func() {
		for {
			//TODO(student): Task 3 - distributed implementation
			select {
			case prp := <-a.prepareIn:
				prm, output := a.handlePrepare(prp)
				if output {
					a.promiseOut <- prm
				}
			case acc := <-a.acceptIn:
				lrn, output := a.handleAccept(acc)
				if output {
					a.learnOut <- lrn
				}
			case <-a.stop:
				return
			}
		}
	}()
}

// Stop stops a's main run loop.
func (a *Acceptor) Stop() {
	//TODO(student): Task 3 - distributed implementation
	a.stop <- struct{}{}
}

// DeliverPrepare delivers prepare prp to acceptor a.
func (a *Acceptor) DeliverPrepare(prp Prepare) {
	//TODO(student): Task 3 - distributed implementation
	a.prepareIn <- prp
}

// DeliverAccept delivers accept acc to acceptor a.
func (a *Acceptor) DeliverAccept(acc Accept) {
	//TODO(student): Task 3 - distributed implementation
	a.acceptIn <- acc
}

// Internal: handlePrepare processes prepare prp according to the single-decree
// Paxos algorithm. If handling the prepare results in acceptor a emitting a
// corresponding promise, then output will be true and prm contain the promise.
// If handlePrepare returns false as output, then prm will be a zero-valued
// struct.
func (a *Acceptor) handlePrepare(prp Prepare) (prm Promise, output bool) {
	//TODO(student): Task 2 - algorithm implementation
	if prp.Crnd > a.rnd {
		a.rnd = prp.Crnd
		return Promise{To: prp.From, From: a.id, Rnd: a.rnd, Vrnd: a.vrnd, Vval: a.vval}, true
	}
	return Promise{}, false
}

// Internal: handleAccept processes accept acc according to the single-decree
// Paxos algorithm. If handling the accept results in acceptor a emitting a
// corresponding learn, then output will be true and lrn contain the learn.  If
// handleAccept returns false as output, then lrn will be a zero-valued struct.
func (a *Acceptor) handleAccept(acc Accept) (lrn Learn, output bool) {
	//TODO(student): Task 2 - algorithm implementation
	if acc.Rnd >= a.rnd && acc.Rnd != a.vrnd {
		a.rnd = acc.Rnd
		a.vrnd = acc.Rnd
		a.vval = acc.Val
		return Learn{From: a.id, Rnd: a.rnd, Val: a.vval}, true
	}
	return Learn{}, false
}

//TODO(student): Add any other unexported methods needed.
