/*:
 # Who's afraid of the Monad?
 [Previous](@previous)
 
 Let's talk about some data and structs:
 */
struct User {
    let id: Int
    let name: String
}
let users = [User(id: 1, name: "Chris"), User(id: 2, name: "Lara")]

//: - Experiment: Create an Array<Int> containing the user's ids using `map`.
let userIDs: Array<Int> = [] // Your code here

/*:
 Map is not only defined on arrays but also on `Optional<T>`. Again it takes the value if present, applies the function and then returns an optional.
 - Experiment: Use map to retrieve the users name.
 */
let user = users.first
// let userName = Your code here
//: Assuming we have a funtion that returns an optional, we would retrieve an Optional<Optional<String>>.
func optionalRetrieve(_ user: User) -> String? {
    return user.name
}
let doubleOptional = user.map(optionalRetrieve)
//: Usually this is not what we want. You can use flatmap instead to automatically resolve that problem.
let userNameFlat = user.flatMap(optionalRetrieve)
/*:
 As you can see having this concept of `map` and `flatMap` on types that contain things is very practical.
 - __map__ takes a function, applys it to the content and then returns it neatly boxed within itself (e.g. returning an Optional<String>).
 - __flatMap__ does the same but accepts a function that returns an already boxed value.
 
 Because this concept is so common, types that conform to it have a name: __Monad__.
 
 - Experiment: Let's now implement `map` on our Observable. Map will return a new Observable that contains a transformed value. Whenever the value of the original Observable changes, the returned one should update its subscribers, too.
 */
extension Observable {
    func map<U>(_ transform: @escaping (T)->U) -> Observable<U> {
        return Observable<U>() // your code here
    }
}

func greet(name: String) -> String {
    return "Hello \(name)"
}

Observable("World")
    .map(greet)
    .subscribe { text in
    print(text)
}
/*: 
 - Note: "Hello World" should be printed to the log.
 - Experiment: Next we will implement `flatMap`. This allows us to write transforms that return at a later time.
*/

extension Observable {
    func flatMap<U>(_ transform: @escaping (T)->Observable<U>) -> Observable<U> {
        return Observable<U>() // your code here
    }
}

import Dispatch
func greetLater(name: String) -> Observable<String> {
    let a = Observable<String>()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        a.update("Late hello to \(name)")
    }
    return a
}

Observable("World")
    .flatMap(greetLater)
    .subscribe { text in
    print(text)
}
/*: 
 - Note: "Late hello to World" should be printed with a slight delay.
 As you can see Observables can make asynchronous work a lot easier to write and read.
 [Let's talk about error handling.](@Next)
*/
