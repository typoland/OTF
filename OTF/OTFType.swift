//
//  OTFFeatureType.swift
//  OTF
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation



public protocol OTFTypeProtocol: OTFBaseProtocol {
    
    associatedtype Selector: OTFSelectorProtocol
    associatedtype Selectors: Sequence where Selectors.Element == Selector
    var selectors: Selectors {get}
    var exclusive: Int {get}
}

open class OTFType<Selector: OTFSelectorProtocol>: OTFBase, OTFTypeProtocol {
    
    public typealias Selector = Selector
    
    public var exclusive:Int
    public var selectors: OrderedSet<Selector>
    
    public init(name: String,
                nameID: Int,
                identifier: Int,
                exclusive: Int,
                selectors: OrderedSet<Selector> = [])
    {
        self.exclusive = exclusive
        self.selectors = selectors
        super.init(name: name, nameID: nameID, identifier: identifier)
    }
}

extension OTFType: CustomStringConvertible {
    
    public var description:String {
        return "Type \(name)"
    }
    
}
