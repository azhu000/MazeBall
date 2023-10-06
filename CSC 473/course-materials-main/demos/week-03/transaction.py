import typing


class Transaction:
    def __init__(self, vendor: str, amount: float):
        self.vendor = vendor
        self.amount = amount

    def __dict__(self) -> typing.Dict:
        return {
            "vendor": self.vendor,
            "amount": self.amount,
        }
