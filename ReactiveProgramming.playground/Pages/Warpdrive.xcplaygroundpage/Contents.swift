/*:
 # Launching into time space continuums with Warpdrive
 [Previous](@previous)
 
 Warpdrive is a micro library included with Interstellar that integrates GCD (also available on Linux).
 ## Delay
 Sometimes you just need to delay the update of an Observable, e.g. to dismiss a typing indicator:
 */
let userStoppedTyping = Observable<Void>(options: [.NoInitialValue])
userStoppedTyping.subscribe { print("User stopped typing") }
userStoppedTyping.delay(0.8).subscribe { print("Dismissing Typing Indicator") }
userStoppedTyping.update()
/*:
 ## Debounce
 Imagine you're implementing a search field and the user is hammering the keyboard. You don't want to make a request for every keystroke but want to delay the executing for some time. But also the app should not look unresponsive so while typing you want to give some regular updates. That's where `debounce` comes into play.
 */
let searchTerm = Observable("gif")
searchTerm.subscribe { text in print("user did hit the keyboard: \(text)") }
searchTerm.debounce(0.5).subscribe { text in print("doing a network request for \(text)") }
searchTerm.update("gif c")
searchTerm.update("gif ca")
searchTerm.update("gif cat")
/*:
 ## Queue Hopping
 Signals will call the subscribers on the queue that issued the update call. If you as the receiver want something different, you can map the signal somehwere else:
 */
import Foundation
func expensiveSearch(term: String) -> [String] {
    Foundation.Thread.sleep(forTimeInterval: 2)
    return ["Result 1", "Result 2"]
}
let asyncSearch = Observable<String>()
asyncSearch
    .flatMap(Queue.background)
    .map(expensiveSearch)
    .flatMap(Queue.main)
    .subscribe { result in
        print(result)
}
asyncSearch.update("kitten gifs")

import XCPlayground
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true