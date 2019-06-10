//
//  OTFFeatureBaseObject.swift
//  OTF
//
//  Created by Łukasz Dziedzic on 10/06/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

open class OTFBase: OTFBaseProtocol {

    @objc public var name: String = ""
    public var nameID: Int = 0
    @objc public var identifier: Int = 0
    
    init(name:String, nameID:Int?, identifier:Int) {
        self.name = name
        self.nameID = nameID ?? 0
        self.identifier = identifier
    }
}


