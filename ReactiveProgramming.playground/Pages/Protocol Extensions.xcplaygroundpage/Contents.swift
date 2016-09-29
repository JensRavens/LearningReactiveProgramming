/*:
 # Protocol Extensions for Observables of Results
 [Previous](@previous)
 
 If you want to work with an Observable containing a Result it's often the case to only continue a chain for a successful Result:
 */
let greeting = Observable(Result.success("Hello World"))
func transform(_ text: String)->String {
    return text.uppercased()
}
//: ## The Painfull Way
//: Unwrapping all your boxes to apply this transform is quite painful:
let transformedGreeting = greeting.map { result in
    result.map { text in
        return transform(text)
    }
}
//: ## A Better Way
/*: 
 Because this is so common, there is an easier way called `next`.
 - Note: Because Swift 3 does not yet support extensions of generics, we have to work around it by using protocol extensions. I've included a Protocol `ResultType` that just wraps a Result.
 - Experiment: Implement the `next` function for Observables that contain Results.
*/
extension Observable where T : ResultType {
    func then<U>(_ transform: @escaping (T.Value) -> U) -> Observable<Result<U>> {
        return Observable<Result<U>>() // Your code here
    }
}
//: And now you can use it do directly transform your Observable:
greeting.then(transform).subscribe { print($0) }
print(Result.success("Test"))
/*: 
 - Note: This should print `success("HELLO WORLD")`.
 
 Of course we have to take care of the case where a transform can fail. We call it also `then` and let Swift's type inference take care of selecting the right one.
 - Experiment: Implement `then` for throwing functions.
 */
extension Observable where T : ResultType {
    func then<U>(_ transform: @escaping (T.Value) throws -> U) -> Observable<Result<U>> {
        return Observable<Result<U>>() // Your code here
    }
}
/*:
 - Experiment: And now to the really cool part: `then` for async returning functions!
 */
extension Observable where T : ResultType {
    func then<U>(_ transform: @escaping (T.Value) -> Observable<Result<U>>) -> Observable<Result<U>> {
        return Observable<Result<U>>() // Your code here
    }
}
/*:
 Now we can write asynchronous, failable code in a way that almost looks synchronous:
 */
func asyncReverse(_ text: String) -> Observable<Result<String>> {
    return Observable(.success("\(text.characters.reversed())"))
}
Observable(Result.success("Hello World"))
    .then(asyncReverse)
    .then(transform)
    .subscribe { result in
        print(result)
}
/*:
 And so we wrote our own library for Reactive Programming in under 100 lines of code. Congratulations!
 
 This is the basis of a library called Interstellar. In the next examples we'll have a look at some additional features in that library.
 [We start with Warpdrive](@next)
 */
