import ballerina/http;

//Catelog record with product name and product id
type Item record {
    string name;
    readonly string id;
    int price;
    boolean isFollowing;
};

type ItemRequest record {
    string name;
    int price;
};

table<Item> key(id) catelog = table [
    {name: "Laptop", id: "LAP001", price: 100, isFollowing: false},
    {name: "Mobile", id: "MOB001", price: 500, isFollowing: false},
    {name: "Tablet", id: "TAB001", price: 300, isFollowing: false}
];

table<Item> key(id) cart = table [];

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function get items() returns Item[]|error {
        Item[] response = [];
        foreach var item in catelog {
            response.push(item);
        }
        return response;
    }

    resource function post item/[string id]/follow() returns Item|error {

        foreach var item in catelog {
            if (item.id == id) {
                item.isFollowing = true;
                return item;
            }
        }
        return error("Item not found");
    }

    resource function post item/[string id]/unfollow() returns Item|error {

        foreach var item in catelog {
            if (item.id == id) {
                item.isFollowing = false;
                return item;
            }
        }
        return error("Item not found");
    }

    resource function get cart() returns Item[]|error {
        Item[] response = [];
        foreach var item in cart {
            response.push(item);
        }
        return response;
    }

    resource function post cart/add(string id) returns Item[]|error {

        foreach var item in catelog {
            if (item.id == id) {
                cart.add(item);

                Item[] response = [];
                foreach var it in cart {
                    response.push(it);
                }
                return response;
            }
        }
        return error("Item not found");
    }

    resource function post cart/remove(string id) returns Item[]|error {

        foreach var item in cart {
            if (item.id == id) {
                Item _ = cart.remove(item.id);

                Item[] response = [];
                foreach var it in cart {
                    response.push(it);
                }
                return response;
            }
        }
        return error("Item not found");
    }

    resource function post cart/checkout() returns Item[]|error {
        Item[] response = cart.toArray();
        cart = table [];
        return response;
    }
}
