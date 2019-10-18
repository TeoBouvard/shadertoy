import random
from datetime import datetime
from hash import md5

def hash_function(string):
    return md5(string.encode())


USERS = ['Alice', 'Bob', 'John', 'David', 'Thomas', 'Isaac', 'Bill']


class Blockchain():

    def __init__(self):
        self.blocks = []

    def add_block(self, block):
        block.previous_hash = hash_function(self.blocks[-1].to_hash()) if len(self.blocks) != 0 else '0'
        self.blocks.append(block)

    def __repr__(self):
        return str(self)

    def __str__(self):
        if len(self.blocks) == 0:
            return 'Empty chain ! \n'
        elif len(self.blocks) == 1:
            s = '1 block\n\n'
            s += ' ' + 100*'=' + '\n||\n'
            s += str(self.blocks[0])
            s += '||\n ' + 100*'=' + '\n'
            return s
        else:
            s = '{} blocks\n\n'.format(len(self.blocks))
            for block in self.blocks[:0:-1]:
                s += ' ' + 100*'=' + '\n||\n'
                s += str(block)
                s += '||\n ' + 100*'=' + '\n'
                s += 3*'{}|\n'.format(50*' ')
                s += '{}v\n'.format(50*' ')
            s += ' ' + 100*'=' + '\n||\n'
            s += str(self.blocks[0])
            s += '||\n ' + 100*'=' + '\n'
            return s


class Block():
    
    def __init__(self):
        self.timestamp = datetime.now()
        self.previous_hash = 'Block not been added to the chain yet !'
        self.tx_root = MerkleTree()

    def add_transaction(self, transaction):
        self.tx_root.add(transaction)

    def to_hash(self):
        s = str(self.timestamp)
        s += self.previous_hash
        s += self.tx_root.to_hash()
        return s

    def __repr__(self):
        return str(self)

    def __str__(self):
        s  = '|| Timestamp {} - {}'.format(self.timestamp, str(self.tx_root))
        s += '|| Previous block hash : {}\n'.format(self.previous_hash)
        s += '|| Transaction root hash : {}\n'.format(self.tx_root.root)
        return s

class Transaction():
    def __init__(self, sender=None, receiver=None, value=None):
        self.timestamp = datetime.now()
        self.sender = sender
        self.receiver = receiver
        self.value = value
    
    def to_hash(self):
        s = str(self.timestamp)
        s += self.sender 
        s += self.receiver 
        s += str(self.value)
        return s

    def __str__(self):
        return str(self.timestamp)

    
class MerkleTree():
    def __init__(self):
        self.transactions = []
        self.hashes = []
        self.n_transactions = 0
        self.root = 0

    def add(self, transaction):
        self.transactions.append(transaction)
        self.hashes.append(hash_function(transaction.to_hash()))
        self.n_transactions += 1
        self.compute_root(self.hashes)
    
    def to_hash(self):
        s = str(self.transactions)
        s += str(self.hashes) 
        s += str(self.n_transactions)
        s += self.root
        return s

    def compute_root(self, hashlist):
        pair_hashes = []

        for i, current_hash in enumerate(hashlist[::2]):
            if i < self.n_transactions - 1:
                pair_hashes.append(hash_function(current_hash + self.hashes[i+1]))
            else:
                pair_hashes.append(hash_function(current_hash))

        if len(pair_hashes) > 1:
            self.compute_root(pair_hashes)
        else:
            self.root = pair_hashes[0]

    def __repr__(self):
        return str(self)

    def __str__(self):
        s = '{} transactions\n'.format(self.n_transactions)
        return s
    


if __name__ == '__main__':

    chain = Blockchain()

    for _ in range(random.randint(1, 5)):
        block = Block()

        for _ in range(random.randint(1, 6)):
            users = random.sample(USERS, k=2)
            transaction = Transaction(sender=users[0], receiver=users[1], value=random.randint(1, 100))
            block.add_transaction(transaction)
        
        chain.add_block(block)

    print(chain)
