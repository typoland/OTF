//
//  OTFFeatureProtocol.swift
//  OTF
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

public protocol OTFBaseProtocol : Hashable {
    var name: String {get}
    var nameID: Int {get}
    var identifier: Int {get}
    
    //init (name: String, nameID: Int, identifier: Int)
}

extension OTFBaseProtocol {
    public static func == <F2:OTFBaseProtocol>(lhs: Self, rhs: F2) -> Bool {
        return lhs.name == rhs.name
    }
}

extension OTFBaseProtocol {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(name)
    }
}

public protocol OTFSelectorProtocol: OTFBaseProtocol {
    var defaultSelector: Int {get}
    init (name: String, nameID: Int, identifier: Int, defaultSelector: Int)
}

public extension OTFSelectorProtocol {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(defaultSelector)
    }
}

public protocol OTFTypeProtocol: OTFBaseProtocol {
    
    associatedtype Selector: OTFSelectorProtocol
    associatedtype Selectors: Sequence where Selectors.Element == Selector
    var selectors: Selectors {get}
    var exclusive: Int {get}
    init (name: String, nameID: Int, identifier: Int, exclusive: Int, selectors: Selectors)
}

extension OTFTypeProtocol {
    static func type (name: String, nameID: Int, identifier: Int, exclusive: Int, selectors: [(name:String, nameID:Int, identifier:Int, defaultSelector:Int)]) -> Self {
        let _selectors: Selectors =  selectors.map {
            Selector.init(name: $0.name,
                          nameID: $0.nameID,
                          identifier: $0.identifier,
                          defaultSelector: $0.defaultSelector)} as! Self.Selectors
        
        return Self.init (name: name,
                          nameID: nameID,
                          identifier: identifier,
                          exclusive: exclusive,
                          selectors: _selectors)
    }
}
