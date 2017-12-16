//
//  Draft4.swift
//  JSONSchema
//
//  Created by Alsey Coleman Miller on 12/16/17.
//

import Foundation

public extension JSONSchema {
    
    /// Core schema meta-schema
    ///
    /// [Draft 04](http://json-schema.org/draft-04/schema#)
    public struct Draft4: Codable /*, Equatable */ {
        
        public static let type: SchemaType = .draft4
        
        public var identifier: URL?
        
        public var schema: SchemaType? // should only be draft-04
        
        public var required: [String]
        
        public var reference: String?
        
        public var type: ValueType?
        
        public var title: String?
        
        public var description: String?
        
        public var `default`: Indirect<Schema>? // {}
        
        public var multipleOf: Double? // minimum: 0, exclusiveMinimum: true
        
        public var maximum: Double?
        
        public var exclusiveMaximum: Bool? // #### false
        
        public var minimum: Double?
        
        public var exclusiveMinimum: Bool? // #### false
        
        public var maxLength: PositiveInteger?
        
        public var minLength: PositiveIntegerDefault0?
        
        public var pattern: String? // format: regex
        
        public var additionalItems: AdditionalItems?
        
        public var items: Items?
        
        public var maxItems: PositiveInteger?
        
        public var minItems: PositiveIntegerDefault0?
        
        public var uniqueItems: Bool? // ### false
        
        public var maxProperties: PositiveInteger?
        
        public var minProperties: PositiveIntegerDefault0?
        
        public var required: StringArray?
        
        public var propertyOrder: [String]?
        
        public var additionalProperties: AdditionalProperties?
        
        public var definitions: [String: Schema]?
        
        public var properties: [String: Schema]?
        
        public var patternProperties: [String: Schema]?  // "additionalProperties": { "$ref": "#" }
        
        public var dependencies: [String: Dependencies]?
        
        public var `enum`: [StringArray]? // "enum": { "type": "array", "minItems": 1, "uniqueItems": true }
        
        public var allOf: SchemaArray? // { "$ref": "#/definitions/schemaArray" }
        
        public var anyOf: SchemaArray? // { "$ref": "#/definitions/schemaArray" }
        
        public var oneOf: SchemaArray? // { "$ref": "#/definitions/schemaArray" }
        
        public var not: Indirect<Schema> // { "$ref": "#" }
                
        private enum CodingKeys: String, CodingKey {
            case ref = "$ref"
            case type = "type"
            case id = "id"
            case schema = "$schema"
            case title = "title"
            case description = "description"
            case `default` = "default"
            case multipleOf = "multipleOf"
            case maximum = "maximum"
            case exclusiveMaximum = "exclusiveMaximum"
            case minimum = "minimum"
            case exclusiveMinimum = "exclusiveMinimum"
            case maxLength = "maxLength"
            case minLength = "minLength"
            case pattern = "pattern"
            case additionalItems = "additionalItems"
            case items = "items"
            case maxItems = "maxItems"
            case minItems = "minItems"
            case uniqueItems = "uniqueItems"
            case maxProperties = "maxProperties"
            case minProperties = "minProperties"
            case required = "required"
            case propertyOrder = "propertyOrder"
            case additionalProperties = "additionalProperties"
            case definitions = "definitions"
            case properties = "properties"
            case patternProperties = "patternProperties"
            case dependencies = "dependencies"
            case `enum` = "enum"
            case allOf = "allOf"
            case anyOf = "anyOf"
            case oneOf = "oneOf"
            case not = "not"
        }
    }
}

// MARK: - Supporting Types

public protocol

public extension JSONSchema.Draft4 {
    
    public typealias Schema = JSONSchema.Draft4
    
    public typealias SchemaType = JSONSchema
    
    /// ```JSON
    /// "schemaArray": {
    /// "type": "array",
    /// "minItems": 1,
    /// "items": { "$ref": "#" }
    /// }
    /// ```
    public struct SchemaArray: RawRepresentable, Codable /*, Equatable */ {
        
        public let rawValue: [Schema]
        
        public init?(rawValue: [Schema]) {
            
            guard rawValue.count >= 1
                else { return nil }
            
            self.rawValue = rawValue
        }
        
        public init(from decoder: Decoder) throws {
            
            let singleValue = try decoder.singleValueContainer()
            
            let rawValue = try singleValue.decode(RawValue.self)
            
            guard let value = SchemaArray.init(rawValue: rawValue)
                else { throw DecodingError.typeMismatch(RawValue.self, DecodingError.Context.init(codingPath: decoder.codingPath, debugDescription: "Invalid raw value")) }
            
            self = value
        }
        
        public func encode(to encoder: Encoder) throws {
            
            var singleValue = encoder.singleValueContainer()
            
            try singleValue.encode(rawValue)
        }
    }
    
    /**
     ```JSON
     "positiveInteger": {
     "type": "integer",
     "minimum": 0
     }
     ```
    */
    public struct PositiveInteger: RawRepresentable, Codable {
        
        public let rawValue: Int
        
        public init?(rawValue: Int) {
            
            guard rawValue >= 0
                else { return nil }
            
            self.rawValue = rawValue
        }
    }
    
    /**
     ```JSON
     
     ```
    */
    public struct PositiveIntegerDefault0: RawRepresentable, Codable {
        
        
    }
    
    /**
     ```JSON
     "simpleTypes": {
     "enum": [ "array", "boolean", "integer", "null", "number", "object", "string" ]
     }
     ```
     */
    public enum SimpleTypes: String {
        
        case object
        case array
        case string
        case integer
        case number
        case boolean
        case null
    }
    
    public
    
    public enum AdditionalProperties : Codable {
        
        case a(Bool) // { "type": "boolean" }
        case b(Indirect<Schema>) // { "$ref": "#" }
        
        public init(from decoder: Decoder) throws {
            
            
        }
        
        public func encode(to encoder: Encoder) throws {
            
            
        }
    }
    
    public enum Dependencies : Codable {
        
        case a(Indirect<Schema>) // { "$ref": "#" }
        case b([String]) // { "$ref": "#/definitions/stringArray" }
        
        public init(from decoder: Decoder) throws {
            
            
        }
        
        public func encode(to encoder: Encoder) throws {
            
            
        }
    }
    
    public enum ValueType: String {
        
        case object
        case array
        case string
        case integer
        case number
        case boolean
        case null
    }
}

