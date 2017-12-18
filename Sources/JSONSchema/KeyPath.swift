//
//  KeyPath.swift
//  JSONSchema
//
//  Created by Alsey Coleman Miller on 12/17/17.
//

public protocol DynamicKeyable {
    
    associatedtype DynamicKey: RawRepresentable where Self.RawValue == String
    
    func value(for key: DynamicKey) -> Any?
}

public enum DynamicKeyableError: Error {
    
    case
}

public extension DynamicKeyable {
    
    subscript (key: DynamicKey) -> Any? {
        
        
    }
    
    subscript (path: [String]) -> Any? {
    
        
    }
    
    func value(for keyPath: [String]) throws -> Any? {
        
        var keyable: DynamicKeyable = self
        
        for key in path {
            
            keyable.value(for: <#T##DynamicKeyable.DynamicKey#>)
        }
    }
}
