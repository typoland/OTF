//
//  NSFont + extensionOTF.swift
//  FindFontFeatures
//
//  Created by Łukasz Dziedzic on 10/04/16.
//  Copyright © 2016 Łukasz Dziedzic. All rights reserved.
//

import Foundation

public typealias OTFFeatureTypeSet = OrderedSet <OTFFeatureType>



extension NSFont {
    
    @objc var OTFFeaturesTypeCount:Int {
        get {
            return self.OTFFeaturesTypes.types.count
        }
    }
    
    var axesDict: [[String:Any]] {
        return axes.map { $0.dict }
    }
    
    var axes:[OTFAxis] {
        
        var result :[OTFAxis] = []
        
        let variation = CTFontCopyVariation(self as CTFont) as? [Int:Double] ?? [:]
        //print ("VARIATION", variation)
        if let descriptor = CTFontCopyVariationAxes(self as CTFont) as? [[String:Any]] { //CTLine
            for axisDescription in descriptor {
                let identifier = axisDescription[OTFAxis.Keys.id.rawValue] as? Int ?? 0
                let axis = OTFAxis(identifier: identifier,
                                name: axisDescription[OTFAxis.Keys.name.rawValue] as? String ?? "no name",
                                min: axisDescription[OTFAxis.Keys.minValue.rawValue] as? Double ?? 0,
                                default: variation[identifier] ?? axisDescription["NSCTVariationAxisDefaultValue"] as? Double ?? 0,
                                max: axisDescription[OTFAxis.Keys.maxValue.rawValue] as? Double ?? 0)
                //print(axis)
                result.append(axis)
            }
        }
        return result
    }
    
    var OTFFeaturesTypes : OrderedSet<OTFFeatureType> {
        
        get {
            
            var result: OrderedSet<OTFFeatureType> = []
            
            let descriptor = self.fontDescriptor

            if let featureDescriptions = CTFontDescriptorCopyAttribute(descriptor, kCTFontFeaturesAttribute) {

                for featureType in featureDescriptions  as! [[String:AnyObject]]{
                    
                    let name = featureType["CTFeatureTypeName"] as? String ?? "No Name"
                    let nameID = featureType["CTFeatureTypeNameID"] as? Int ?? 0
                    let identifier = featureType["CTFeatureTypeIdentifier"]  as? Int ?? 0
                    let exclusive = featureType["CTFeatureTypeExclusive"] as? Int ?? 0

                    let otfType = OTFFeatureType(name:name,
                                          nameID: nameID,
                                          identifier: identifier,
                                          exclusive: exclusive)
                    
                    result.append(otfType)
                    //MARK: TO DO tu dołączał font co by
                    
                    for feature in featureType["CTFeatureTypeSelectors"] as! [[String:AnyObject]] {
                        
                        var name = feature["CTFeatureSelectorName"] as? String
                        if name == nil {
                            
                            name = String(format: "<no name feature>" )
                            
                            
                        }
                        
                        let fea = OTFFeature(name:name!,
                                            parent: otfType,
                                            nameID: feature["CTFeatureSelectorNameID"] as? Int,
                                            identifier: feature["CTFeatureSelectorIdentifier"] as! Int,
                                            defaultSelector: feature["CTFeatureSelectorDefault"] as? Int)
                        result.addFeature(fea, fromFont: self)
                    }
                }
            }
            return result
        }
    }
    

    
    var allChars:String {
        get {
            print("getting AllChars")
            let allFontChars = self.coveredCharacterSet.intersection(CharacterSet.controlCharacters.inverted)
            var result = ""
            for plane : UInt8 in 0...16 {
                if allFontChars.hasMember(inPlane: plane) {
                    
                    for c : UInt32 in UInt32( plane ) << 16 ..< (UInt32(plane)+1) << 16 {
                        if let scalar = UnicodeScalar(c)  {
                            if allFontChars.contains(scalar) {
                                var c1 = c.littleEndian // To make it byte-order safe
                                
                                let s = NSString(bytes: &c1, length: 4, encoding: String.Encoding.utf32LittleEndian.rawValue);
                                
                                result += (s != nil ? s! as String : "")
                            }
                        }
                    }
                }
            }
            return result
        }
        
    }
    @objc func setAllChars (_ sender:Any) {
        print ("setting allchars")
    }
}
