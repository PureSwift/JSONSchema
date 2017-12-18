import XCTest
@testable import JSONSchema

final class JSONSchemaTests: XCTestCase {
    
    static var allTests = [
        ("testDraft4MetaSchemaParse", testDraft4MetaSchemaParse),
        ]
    
    func testReference() {
        
        // invalid strings
        do {
            
            XCTAssertNil(Reference(rawValue: ""))
            XCTAssertNil(Reference(rawValue: "/"))
            XCTAssertNil(Reference(rawValue: "https://google.com"))
            XCTAssertNil(Reference(rawValue: "http://json-schema.org/draft-04/schema"))
            XCTAssertNil(Reference(rawValue: "http://json-schema.org/draft-04/schema"))
            XCTAssertNil(Reference(rawValue: "/definitions/schemaArray"))
        }
        
        do {
            
            let rawValue = "#"
            
            guard let reference = Reference(rawValue: rawValue)
                else { XCTFail("Could not parse"); return }
            
            XCTAssert(reference.path.isEmpty)
            XCTAssert(reference.remote == nil)
            XCTAssert(reference == .selfReference)
            XCTAssert(reference.rawValue == Reference.selfReference.rawValue)
        }
        
        do {
            let rawValue = "http://json-schema.org/draft-04/schema#/properties/title"
            
            guard let reference = Reference(rawValue: rawValue)
                else { XCTFail("Could not parse"); return }
            
            XCTAssert(reference.rawValue == rawValue)
            XCTAssert(reference.path == ["properties", "title"])
            XCTAssert(reference.remote?.absoluteString == "http://json-schema.org/draft-04/schema")
            XCTAssert(reference != .selfReference)
            XCTAssert(reference == "http://json-schema.org/draft-04/schema#/properties/title")
        }
        
        do {
            
            let rawValue = "#/definitions/schemaArray"
            
            guard let reference = Reference(rawValue: rawValue)
                else { XCTFail("Could not parse"); return }
            
            XCTAssert(reference.rawValue == rawValue)
            XCTAssert(reference.path == ["definitions", "schemaArray"])
            XCTAssert(reference.remote == nil)
            XCTAssert(reference != .selfReference, "\(reference)")
            XCTAssert(reference == "#/definitions/schemaArray")
        }
    }
    
    func testDraft4MetaSchemaParse() {
        
        let jsonDecoder = JSONDecoder()
        
        let jsonData = draft4SchemeJSON.data(using: .utf8)!
        
        var scheme: JSONSchema.Draft4!
        
        do { scheme = try jsonDecoder.decode(JSONSchema.Draft4.self, from: jsonData) }
        
        catch {
            dump(error)
            XCTFail()
            return
        }
        
        dump(scheme)
    }    
}

let draft4SchemeJSON = """
{
    "id": "http://json-schema.org/draft-04/schema#",
    "$schema": "http://json-schema.org/draft-04/schema#",
    "description": "Core schema meta-schema",
    "definitions": {
        "schemaArray": {
            "type": "array",
            "minItems": 1,
            "items": { "$ref": "#" }
        },
        "positiveInteger": {
            "type": "integer",
            "minimum": 0
        },
        "positiveIntegerDefault0": {
            "allOf": [ { "$ref": "#/definitions/positiveInteger" }, { "default": 0 } ]
        },
        "simpleTypes": {
            "enum": [ "array", "boolean", "integer", "null", "number", "object", "string" ]
        },
        "stringArray": {
            "type": "array",
            "items": { "type": "string" },
            "minItems": 1,
            "uniqueItems": true
        }
    },
    "type": "object",
    "properties": {
        "id": {
            "type": "string",
            "format": "uri"
        },
        "$schema": {
            "type": "string",
            "format": "uri"
        },
        "title": {
            "type": "string"
        },
        "description": {
            "type": "string"
        },
        "default": {},
        "multipleOf": {
            "type": "number",
            "minimum": 0,
            "exclusiveMinimum": true
        },
        "maximum": {
            "type": "number"
        },
        "exclusiveMaximum": {
            "type": "boolean",
            "default": false
        },
        "minimum": {
            "type": "number"
        },
        "exclusiveMinimum": {
            "type": "boolean",
            "default": false
        },
        "maxLength": { "$ref": "#/definitions/positiveInteger" },
        "minLength": { "$ref": "#/definitions/positiveIntegerDefault0" },
        "pattern": {
            "type": "string",
            "format": "regex"
        },
        "additionalItems": {
            "anyOf": [
            { "type": "boolean" },
            { "$ref": "#" }
            ],
            "default": {}
        },
        "items": {
            "anyOf": [
            { "$ref": "#" },
            { "$ref": "#/definitions/schemaArray" }
            ],
            "default": {}
        },
        "maxItems": { "$ref": "#/definitions/positiveInteger" },
        "minItems": { "$ref": "#/definitions/positiveIntegerDefault0" },
        "uniqueItems": {
            "type": "boolean",
            "default": false
        },
        "maxProperties": { "$ref": "#/definitions/positiveInteger" },
        "minProperties": { "$ref": "#/definitions/positiveIntegerDefault0" },
        "required": { "$ref": "#/definitions/stringArray" },
        "additionalProperties": {
            "anyOf": [
            { "type": "boolean" },
            { "$ref": "#" }
            ],
            "default": {}
        },
        "definitions": {
            "type": "object",
            "additionalProperties": { "$ref": "#" },
            "default": {}
        },
        "properties": {
            "type": "object",
            "additionalProperties": { "$ref": "#" },
            "default": {}
        },
        "patternProperties": {
            "type": "object",
            "additionalProperties": { "$ref": "#" },
            "default": {}
        },
        "dependencies": {
            "type": "object",
            "additionalProperties": {
                "anyOf": [
                { "$ref": "#" },
                { "$ref": "#/definitions/stringArray" }
                ]
            }
        },
        "enum": {
            "type": "array",
            "minItems": 1,
            "uniqueItems": true
        },
        "type": {
            "anyOf": [
            { "$ref": "#/definitions/simpleTypes" },
            {
            "type": "array",
            "items": { "$ref": "#/definitions/simpleTypes" },
            "minItems": 1,
            "uniqueItems": true
            }
            ]
        },
        "allOf": { "$ref": "#/definitions/schemaArray" },
        "anyOf": { "$ref": "#/definitions/schemaArray" },
        "oneOf": { "$ref": "#/definitions/schemaArray" },
        "not": { "$ref": "#" }
    },
    "dependencies": {
        "exclusiveMaximum": [ "maximum" ],
        "exclusiveMinimum": [ "minimum" ]
    },
    "default": {}
}
"""
