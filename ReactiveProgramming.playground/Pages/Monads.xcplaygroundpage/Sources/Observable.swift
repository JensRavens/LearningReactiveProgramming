public class Observable<T> {
    public private(set) var value: T?
    private var subscribers = [(T)->Void]()
    
    public init() {}
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func subscribe(_ update: @escaping (T)->Void) {
        subscribers.append(update)
        value.map(update)
    }
    
    public func update(_ value: T) {
        self.value = value
        subscribers.forEach { $0(value) }
    }
}
