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

    resource function post items(@http:Payload ItemRequest item) returns Item|error {
        Item it = {name: item.name, id: item.name, price: item.price, isFollowing: false};
        catelog.add(it);
        return it;
    }

    resource function put item/[string id](@http:Payload ItemRequest item) returns Item|error {
        foreach var it in catelog {
            if (it.id == id) {
                _ = catelog.remove(it.id);
                Item updatedItem = {name: item.name, id: item.name, price: item.price, isFollowing: false};
                catelog.add(updatedItem);
                return updatedItem;
            }
        }
        return error("Item not found");
    }

    resource function delete item/[string id]() returns Item|error {
        foreach var item in catelog {
            if (item.id == id) {
                Item removedItem = catelog.remove(item.id);
                return removedItem;
            }
        }
        return error("Item not found");
    }
}
