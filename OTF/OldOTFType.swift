//
//  OTFFeatureType.swift
//  OTF
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation




open class OldOTFType<S: OTFSelectorProtocol>: OTFBase, OTFTypeProtocol {
    
    public typealias Selector = S
    public var selectors: OrderedSet<Selector>
    public var exclusive:Int
    
    
    required public init(name: String,
                nameID: Int,
                identifier: Int,
                exclusive: Int,
                selectors: OrderedSet<Selector>)
    {
        self.exclusive = exclusive
        self.selectors = selectors
        super.init(name: name, nameID: nameID, identifier: identifier)
    }

}

extension OldOTFType: CustomStringConvertible {
    
    public var description:String {
        return "Type \(name)"
    }
    
}
