class Account:
    def __init__(self, name, balance=0.00, transactions=[]):
        self.name = name
        self.balance = balance
        self.transactions = transactions

    def __dict__(self):
        return {
            "name": self.name,
            "balance": self.balance,
            "transactions": [
                transaction.__dict__() for transaction in self.transactions
            ],
        }
