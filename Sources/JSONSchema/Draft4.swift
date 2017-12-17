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
    /// [JSON Schema](http://json-schema.org/draft-04/schema#)
    ///
    /// [Validation](http://json-schema.org/draft-04/json-schema-validation.html)
    public enum Draft4: Codable {
        
        public static let type: SchemaType = .draft4
        
        case object(Object)
        case reference(Reference)
        
        public init(from decoder: Decoder) throws {
            
            struct EnumDecodingErrors: Error {
                
                var errors = [Error]()
            }
            
            var decodingErrors = EnumDecodingErrors()
            
            do {
                
                let reference = try Reference(from: decoder)
                
                self = .reference(reference)
                
                return
            }
            
            catch {
                
                decodingErrors.errors.append(error)
            }
            
            do {
                
                let object = try Object(from: decoder)
                
                self = .object(object)
                
                return
            }
            
            catch {
                
                decodingErrors.errors.append(error)
                
                throw DecodingError.typeMismatch(Draft4.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid raw value", underlyingError: decodingErrors))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            
            switch self {
            case let .object(value): try value.encode(to: encoder)
            case let .reference(value): try value.encode(to: encoder)
            }
        }
    }
}

// MARK: BuiltIn

public extension JSONSchema.Draft4 {
    
    public typealias Schema = JSONSchema.Draft4
    
    public typealias SchemaType = JSONSchema
}

public extension JSONSchema.Draft4 {
    
    public struct Reference: RawRepresentable, Codable {
        
        public var rawValue: URL
        
        public init(rawValue: URL) {
            
            self.rawValue = rawValue
        }
        
        private enum CodingKeys: String, CodingKey {
            
            case rawValue = "$ref"
        }
    }
}

public extension JSONSchema.Draft4 {
    
    /**
     Structural validation alone may be insufficient to validate that an instance meets all the requirements of an application. The "format" keyword is defined to allow interoperable semantic validation for a fixed subset of values which are accurately described by authoritative resources, be they RFCs or other external specifications.
     
     The value of this keyword is called a format attribute. It MUST be a string. A format attribute can generally only validate a given set of instance types. If the type of the instance to validate is not in this set, validation for this format attribute and instance SHOULD succeed.
    */
    public struct Format: RawRepresentable, Codable {
        
        public var rawValue: String
        
        public init(rawValue: String) {
            
            self.rawValue = rawValue
        }
        
        /**
         A string instance is valid against this attribute if it is a valid date representation as defined by [RFC 3339, section 5.6](http://json-schema.org/draft-04/json-schema-validation.html#RFC3339) [RFC3339].
        */
        public static let dateTime: Format = "date-time"
        
        /**
         A string instance is valid against this attribute if it is a valid Internet email address as defined by [RFC 5322, section 3.4.1](http://json-schema.org/draft-04/json-schema-validation.html#RFC5322) [RFC5322].
        */
        public static let email: Format = "email"
        
        /**
         A string instance is valid against this attribute if it is a valid representation for an Internet host name, as defined by RFC 1034, section 3.1 [RFC1034].
        */
        public static let hostname: Format = "hostname"
        
        /**
         A string instance is valid against this attribute if it is a valid representation of an IPv4 address according to the "dotted-quad" ABNF syntax as defined in RFC 2673, section 3.2 [RFC2673].
         */
        public static let ipv4: Format = "ipv4"
        
        /**
         A string instance is valid against this attribute if it is a valid representation of an IPv6 address as defined in RFC 2373, section 2.2 [RFC2373].
        */
        public static let ipv6: Format = "ipv6"
        
        /**
         A string instance is valid against this attribute if it is a valid URI, according to [[RFC3986]](http://json-schema.org/draft-04/json-schema-validation.html#RFC3986).
        */
        public static let uri: Format = "uri"
    }
}

extension JSONSchema.Draft4.Format: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        
        self.rawValue = value
    }
}

// MARK: JSON

public extension JSONSchema.Draft4 {
    
    public struct Object: Codable /*, Equatable */ {
        
        public var identifier: URL?
        
        public var schema: SchemaType? // should only be draft-04
        
        public var type: ObjectType?
        
        public var title: String?
        
        public var description: String?
        
        public var `default`: Indirect<Schema>? // Self
        
        public var multipleOf: Double? // minimum: 0, exclusiveMinimum: true
        
        public var maximum: Double?
        
        public var exclusiveMaximum: Bool = false
        
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
        
        public var not: Indirect<Schema>? // { "$ref": "#" }
        
        public init() { }
        
        private enum CodingKeys: String, CodingKey {
            
            case type = "type"
            case identifier = "id"
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

// MARK: Definitions

public extension JSONSchema.Draft4 {
    
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
                else { throw DecodingError.typeMismatch(RawValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid raw value")) }
            
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
     "positiveIntegerDefault0": {
     "allOf": [ { "$ref": "#/definitions/positiveInteger" }, { "default": 0 } ]
     }
     ```
    */
    public struct PositiveIntegerDefault0: RawRepresentable, Codable {
        
        public let rawValue: Int
        
        public init?(rawValue: Int) {
            
            guard rawValue >= 0
                else { return nil }
            
            self.rawValue = rawValue
        }
        
        public init() {
            
            self.rawValue = 0
        }
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
    
    /**
     ```JSON
     "stringArray": {
     "type": "array",
     "items": { "type": "string" },
     "minItems": 1,
     "uniqueItems": true
     }
     ```
     */
    public struct StringArray: RawRepresentable, Codable {
        
        public let rawValue: [String]
        
        public init?(rawValue: [String]) {
            
            guard rawValue.count >= 1,
                rawValue.isUnique
                else { return nil }
            
            self.rawValue = rawValue
        }
        
        public init(from decoder: Decoder) throws {
            
            let singleValue = try decoder.singleValueContainer()
            
            let rawValue = try singleValue.decode(RawValue.self)
            
            guard let value = StringArray.init(rawValue: rawValue)
                else { throw DecodingError.typeMismatch(RawValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid raw value")) }
            
            self = value
        }
        
        public func encode(to encoder: Encoder) throws {
            
            var singleValue = encoder.singleValueContainer()
            
            try singleValue.encode(rawValue)
        }
    }
    
}

// MARK: Property definitions

public extension JSONSchema.Draft4 {
    
    public enum AdditionalProperties : Codable {
        
        case a(Bool) // { "type": "boolean" }
        case b(Indirect<Schema>) // { "$ref": "#" }
        
        public init(from decoder: Decoder) throws {
            
            
        }
        
        public func encode(to encoder: Encoder) throws {
            
            
        }
        /*
        public static let `default`: AdditionalProperties = {
            
            
            
        }()*/
    }
    
    public enum Dependencies: Codable {
        
        case a(Indirect<Schema>) // { "$ref": "#" }
        case b(StringArray) // { "$ref": "#/definitions/stringArray" }
        
        public init(from decoder: Decoder) throws {
            
            
        }
        
        public func encode(to encoder: Encoder) throws {
            
            
        }
    }
    
    public enum AdditionalItems: Codable {
        
        case a(Bool) // { "type": "boolean" }
        case b(Indirect<Schema>) // { "$ref": "#" }
        
        public init(from decoder: Decoder) throws {
            
            
        }
        
        public func encode(to encoder: Encoder) throws {
            
            
        }
    }
    
    /**
     ```JSON
     "items": {
     "anyOf": [
     { "$ref": "#" },
     { "$ref": "#/definitions/schemaArray" }
     ],
     "default": {}
     }
     ```
    */
    public enum Items: Codable {
        
        case a(Indirect<Schema>) // { "$ref": "#" }
        case b(SchemaArray) // { "$ref": "#/definitions/schemaArray" }
        
        public init(from decoder: Decoder) throws {
            
            
        }
        
        public func encode(to encoder: Encoder) throws {
            
            
        }
    }
    
    public enum ObjectType: Codable {
        
        case a(SimpleTypes)
        case b(B)
        
        public struct B: RawRepresentable, Codable {
            
            public let rawValue: [String]
            
            public init?(rawValue: [String]) {
                
                guard rawValue.count >= 1,
                    rawValue.isUnique
                    else { return nil }
                
                self.rawValue = rawValue
            }
            
            public init(from decoder: Decoder) throws {
                
                let singleValue = try decoder.singleValueContainer()
                
                let rawValue = try singleValue.decode(RawValue.self)
                
                guard let value = B.init(rawValue: rawValue)
                    else { throw DecodingError.typeMismatch(RawValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid raw value")) }
                
                self = value
            }
            
            public func encode(to encoder: Encoder) throws {
                
                var singleValue = encoder.singleValueContainer()
                
                try singleValue.encode(rawValue)
            }
        }
        
        public init(from decoder: Decoder) throws {
            
            
        }
        
        public func encode(to encoder: Encoder) throws {
            
            
        }
    }
    
    public struct MultipleOf: RawRepresentable, Codable {
        
        public let rawValue: [String]
        
        public init?(rawValue: [String]) {
            
            guard rawValue.count > 0,
                rawValue.isUnique
                else { return nil }
            
            self.rawValue = rawValue
        }
        
        public init(from decoder: Decoder) throws {
            
            
        }
        
        public func encode(to encoder: Encoder) throws {
            
            
        }
    }
}

