//
//  GlabbrStream.swift
//  Glabbr
//
//  Created by Rajesh Dandu on 31/10/17.
//  Copyright © 2017 Rajesh Dandu. All rights reserved.
//

import Foundation


class GlabbrStream {
    
    
    // Serializes the struct data into bytes.
    //Parameter: GlabberGateWay struct.
    func serialize(data:GlabbrGateWay) -> Data{
        
        let ary_bytes = NSMutableArray()
        
        
        
        var cuid = UInt32(littleEndian: UInt32(data.cuid))
        let array = withUnsafeBytes(of: &cuid) { Array($0) }
        ary_bytes.addObjects(from: array)
        
        var i = UInt32(littleEndian: UInt32(data.i))
        let array_i = withUnsafeBytes(of: &i) { Array($0) }
          ary_bytes.addObjects(from: array_i)
        
        var l = UInt64(littleEndian: UInt64(data.l))
        let array_l = withUnsafeBytes(of: &l) { Array($0) }
         ary_bytes.addObjects(from: array_l)
        
        
        let s = [UInt8](data.s.utf8)
          ary_bytes.addObjects(from: s)
        
        print(ary_bytes)
        
      let data = NSKeyedArchiver.archivedData(withRootObject: ary_bytes)
        return data
        
  
    }
}
