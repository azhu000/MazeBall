from flask import Flask, abort, jsonify, request

from inspector import Inspector

app = Flask(__name__)

inspections = Inspector.get_inspections() #returns a list of inspector objects

inspect_list = []

for inspection in inspections: #iterates over the list of objects and converts them to json dictionaries
    inspect_list.append(inspection.to_json())

@app.route("/search", methods=["GET"])
def search():
    cuisine = request.args.get('cuisine') #retrieves the cusine param
    restaurant_name = request.args.get('restaurant_name') #retrieves the restaurant name param
    zipcode = request.args.get('zipcode') #retrieves the zipcode param
    limit = request.args.get('limit') # retrieves the limit param

    if not limit: #if limit is not provided set the value of limit to 10
        limit = 10
    
    counter = int(limit) #set counter to the value of limit

    results = []

    for items in inspect_list: #iterates over the inspection list and if the values are satisfied they are appended to results

        if counter == 0: #if counter is 0 meaning we reached the limit, just break the loop no need to look further
            break

        if ((restaurant_name is None or restaurant_name.lower() in items['restaurant_name'].lower()) 
            and (cuisine is None or cuisine.lower() in items['cuisine'].lower()) and  #all the filters 
            (zipcode is None or items['zipcode'] == zipcode)):

            results.append(items) 
            counter -= 1 #decrements counter when a restaurant is appended

    results.sort(key=lambda x: x['restaurant_id']) # applys a function that sorts on the restaurant id's based off results
        
    return jsonify({"data":results}) #finally returns the data
    abort(501)

if __name__ == "__main__":
    app.run(host="localhost", debug=True, port=8000) # I was required to use port 8000 because I am on a mac.
