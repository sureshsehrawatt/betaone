// MySwiftClass.swift

import Foundation

@objc public class MySwiftClass: NSObject {

    @objc public func sayHelloFromSwift() -> String {
        return "Hello from Swift!"
    }

    @objc public static func staticMessage() -> String {
        return "Static message from Swift"
    }
}
