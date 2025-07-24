// MySwiftClass.swift

import Foundation

public class MySwiftClass: NSObject {

    public func sayHelloFromSwift() -> String {
        return "Hello from Swift!"
    }

    public static func staticMessage() -> String {
        return "Static message from Swift"
    }

    public static func init() {
        print("MySwiftClass initialized")
    }
}
