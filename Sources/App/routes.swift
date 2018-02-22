import Routing
import Vapor
import Foundation
/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of creating a Service and using it.
    router.get("hash", String.parameter) { req -> String in
        // Create a BCryptHasher using the Request's Container
        let hasher = try req.make(BCryptHasher.self)

        // Fetch the String parameter (as described in the route)
        let string = try req.parameter(String.self)

        // Return the hashed string!
        return try hasher.make(string)
    }

    router.get("hello", "vapor") { req in
        return "Hello Vapor!"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameter(String.self)
        return "Hello \(name)!"
    }
    //return as string
    router.post("info") { req -> String in
        let data = try req.content.decode(infoData.self).await(on: req)
        return "Hello \(data.name)"
    }
    //return as json
    router.post("infojson") { req -> InfoResponse in
        let data = try req.content.decode(infoData.self).await(on: req)
        return InfoResponse(request: data)
    }
    
    // challenge
    //return today's date
    router.get("date") { req -> String in
        let date = Date()
        let dateString = date.toString(dateFormat: "dd-MM-YYYY")
        return "Today's date is \(dateString)"
    }
    
    // return the count in json
    
    router.get("counter", Int.parameter) { req -> Int in
        let count = try req.parameter(Int.self)
        return count
    }
    
    router.get("counter-json", Int.parameter) { req -> CountJSON in
        let count = try req.parameter(Int.self)
        return CountJSON(count: count)
    }
    
    //return which accepts name and age as Int and return "Hello NAME, you are AGE"
    
    router.post("user-info") { req -> String in
        let data = try req.content.decode(userInfo.self).await(on: req)
        return "Hello \(data.name), you are \(data.age) years old!"
    }
    
    // return the above in json
    router.post("user-info-json") { req -> userResponse in
        let data = try req.content.decode(userInfo.self).await(on: req)
        return userResponse(userRequest: data)
    }

    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}


struct infoData: Content {
    let name:String
}

struct InfoResponse: Content {
    let request: infoData
}

struct userInfo: Content {
    let name:String
    let age:Int
}
struct userResponse:Content {
    let userRequest: userInfo
}

struct CountJSON: Content {
    let count: Int
}


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
