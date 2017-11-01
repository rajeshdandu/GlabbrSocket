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
        
        var fw = data
        return Data(bytes: &fw, count: MemoryLayout<GlabbrGateWay>.stride)
    }
}
