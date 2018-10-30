//
//  ABCodable.swift
//
//  Created by Abhijit KG on 19/09/17.//

import Foundation

typealias ABStaticCodable = ABDecodable & ABEncodable

protocol ABDecodable: Decodable {
    static func decodeFromData(_ data: Data) -> Decodable?
}

protocol ABEncodable: Encodable {
    static func encodeFromObject<T>(_ object: T) -> Data? where T: Encodable
}

extension ABDecodable {
    static func decodeFromData(_ data: Data) -> Decodable? {
        do {
            return try JSONDecoder().decode(self, from: data)
        }
        catch {
            print(error)
        }
        return nil
    }
}

extension ABEncodable {
    static func encodeFromObject<T>(_ object: T) -> Data? where T: Encodable {
        do {
            return try JSONEncoder().encode(object)
        }
        catch {
            return nil
        }
    }
}


//MARK: Decode mapper class
//Send jsonString or data to decode it into an required Object
final class Decode<T: Decodable> {
    private func decodeData(_ data: Data) -> T? {
        if let klass = T.self as? ABDecodable.Type {
            if let object = klass.decodeFromData(data) as? T {
                return object
            }
        }
        else {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            }
            catch {
                print(error)
            }
        }
        return nil
    }
    
    func fromJsonString(_ json: String) -> T? {
        guard let data = json.data(using: String.Encoding.utf8) else { return nil }
        
        if let object = decodeData(data) {
            return object
        }
        return nil
    }
    func fromData(_ data: Data) -> T? {
        if let object = decodeData(data) {
            return object
        }
        return nil
    }
}

//MARK: Encode mapper class
//Send jsonString or data to decode it into an required Object

final class Encode<N:Encodable> {
    
    private func encodeObject(_ object: N) -> Data? {
        if let klass = N.self as? ABEncodable.Type {
            if let data = klass.encodeFromObject(object) {
                return data
            }
        }
        else {
            do {
                return try JSONEncoder().encode(object)
            }
            catch {
                print(error)
            }
        }
        
        return nil
    }
    
    func toJsonString(_ object: N) -> String? {
        if let data = encodeObject(object) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func toData(_ object: N) -> Data? {
        if let data = encodeObject(object) {
            return data
        }
        return nil
    }
}
