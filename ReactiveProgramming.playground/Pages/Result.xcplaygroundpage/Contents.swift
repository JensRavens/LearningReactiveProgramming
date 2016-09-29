/*:
 # Error Handling with Results
 [Previous](@previous)
 
 Error handling for synchronous functions is achieved by throwing functions since Swift 2:
 */
func greet(name: String) throws -> String {
    guard name.characters.count > 0 else { throw "Cannot greet unnamed things" }
    return "Hello \(name)"
}
//: Then you can call those functions with a do block:
do {
    let greeting = try greet(name: "World")
} catch let e {
    print(e)
}
//: This does not work for asynchronous functions, therefore usually there is a completion block with two parameters:
func greetAsync(name: String, completion: @escaping (String?, Error?)->Void) {
    guard name.characters.count > 0 else { completion(nil, "Cannot greet unnamed things"); return }
    completion("Hello \(name)", nil)
}
//: This gives us two optionals to handle. Not that great. Let's introduce a new type called `Result`.
enum Result<T> {
    case success(T), error(Error)
}
//: Our greet function now can return a result instead of two optionals, therefore we can use pattern matching:
func greetAsync2(name: String, completion: @escaping (Result<String>)->Void) {
    guard name.characters.count > 0 else { completion(.error("Cannot greet unnamed things")); return }
    completion(.success("Hello \(name)"))
}
greetAsync2(name: "World") { result in
    switch result {
    case let .success(text): print(text)
    case let .error(error): print(error)
    }
}
/*:
 Much easier. Isn't it?
 
 - Experiment: Because Results contain a another type, you can implement map:
 */
extension Result {
//    func map<U>(_ transform: (T) -> U) -> U {
//        Your code here
//    }
}
/*:
 - Experiment: Of course there is also `flatMap` for transforms that might fail:
 */
extension Result {
//    func flatMap<U>(_ transform: (T) throws -> U) -> U {
//        Your code here
//    }
}
/*:
 At this time the magic of flatMap strikes again: If you have a chain of multiple throwing functions and one of them fail, the rest of the chain is skipped until the end and an `.error` is returned. Now you can concentrate on the happy path and leave the error handling till the end! 🎉
 */
