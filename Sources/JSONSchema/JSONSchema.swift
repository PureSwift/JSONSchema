//
//  JSONSchema.swift
//  JSONSchema
//
//  Created by Alsey Coleman Miller on 12/16/17.
//

import Foundation

/// JSON Schema is a vocabulary that allows you to annotate and validate JSON documents.
///
/// - SeeAlso: [json-schema.org](http://json-schema.org)
public enum JSONSchema: String, Codable {
    
    case draft4 = "http://json-schema.org/draft-04/schema#"
}

// MARK: - URL Conversion

public extension JSONSchema {
    
    public init?(url: URL) {
        
        self.init(rawValue: url.absoluteString)
    }
    
    public var url: URL {
        
        return URL(string: rawValue)!
    }
}

// MARK: - Supporting Types

public extension JSONSchema {
    
    
}

public final class Indirect <T: Codable>: Codable {
    
    public let value: T
    
    public init(_ value: T) {
        
        self.value = value
    }
}
