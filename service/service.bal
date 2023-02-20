import ballerina/http;

//Catelog recode

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + return - string array with hello message or error
    resource function get catelog() returns string[]|error {
        return ["ProductA", "ProductB"];
    }
}
