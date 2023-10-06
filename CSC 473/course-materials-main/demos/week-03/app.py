import datetime

from flask import Flask, abort, jsonify, request

import account
import transaction

app = Flask(__name__)

accounts = {
    "checking": account.Account(name="Checking", balance=0.00, transactions=[]),
    "credit_card": account.Account(
        name="Credit Card",
        balance=75.00,
        transactions=[
            transaction.Transaction(vendor="Chipotle", amount=25.00),
            transaction.Transaction(vendor="Lyft", amount=50.00),
        ],
    ),
}


# curl -s localhost:5000/balance | json_pp
@app.route("/balance", methods=["GET"])
def balance():
    return jsonify(
        {
            "accounts": [vars(account)() for account in accounts.values()],
            "current_time": datetime.datetime.today(),
        }
    )


# curl -s --header "Content-Type: application/json" \
#         --request POST \
#         --data '{"account":"checking","amount":"25"}' \
#         localhost:5000/deposit | json_pp
@app.route("/deposit", methods=["POST"])
def deposit():
    data = request.json

    account_name = data["account"]
    if account_name not in accounts:
        abort(400, "Account {} not found.".format(account_name))

    amount = int(data["amount"])
    if amount <= 0:
        abort(400, "Amount must be greater than 0.")

    account = accounts[account_name]
    account.balance += amount
    account.transactions.append(transaction.Transaction(vendor="ATM", amount=amount))

    return jsonify(vars(account)())


# Give this endpoint a shot!
@app.route("/withdraw")
def withdraw():
    abort(501, "Unimplemented")


# Give this endpoint a shot!
@app.route("/charge")
def charge():
    abort(501, "Unimplemented")


if __name__ == "__main__":
    app.run(debug=True, port=5000)
