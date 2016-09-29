/*:
 # Coding your own Observable
 [Previous](@previous)
 
 Let's start by implementing our own basic version of `Observable<T>`. This is a class that tracks a value `T` and notifies observers when the value changes.
 
 - Experiment: Fill out the missing implementation to make the Observable work. See the usage example below to see if it works.
*/
class Observable<T> {
    private(set) var value: T?
    
    init() {
        
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(_ update: @escaping (T)->Void) {
        // Here goes your code
    }
    
    func update(_ value: T) {
        // Here goes your code
    }
}
/*:
 Let's see how our implementation performs. We'll create an observable and subscribe to it's value:
*/
let greeting = Observable("Hello World")
//: The type T is automatically inferred from the initializer, now it's an `Observable<String>`
greeting.subscribe { text in
    print(text)
}
/*: 
 On subscribe the handler is immediately called with the initial value.
 - Note: Was "Hello World" printed to the console?
 
 There can be more than one observer registered for an observable:
*/
greeting.subscribe { text in
    print(text.uppercased())
}
/*:
 Once the observable is created it can be updated at a later time:
 - Note: You should now see this message in the console two times.
*/
greeting.update("Isn't this cool?")
//:[Now it's time to move on to some functional concepts.](@Next)
