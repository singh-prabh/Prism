//
//  IPv6.swift
//  Prism
//
//  Created by Tomoyuki Sahara on 9/15/15.
//  Copyright (c) 2015 Tomoyuki Sahara. All rights reserved.
//

import Foundation

class IPv6 : BaseProtocol {
    override var name: String { get { return "IPv6" } }
    override var isNetworkProtocol: Bool { get { return true } }
    
    override class func parse(context: ParseContext) -> Protocol {
        let p = IPv6()

        let reader = context.reader
        if (reader.length < 40) {
            p.broken = true
            return p
        }
        
        // version:4
        // traffic-class:8
        // Flow Label: 20
        // Payload Length: 16
        // Next Header: 8
        // Hop Limit: 8
        // Source Address: 128
        // Destination Address: 128
       
        reader.u32()
        let len = Int(reader.read_u16be())
        if (reader.length < 40 + len) {
            p.broken = true
        }
        
        let nxthdr = reader.read_u8()
        switch nxthdr {
        case 58:
            context.parser = ICMP6.parse
        default:
            context.parser = UnknownProtocol.parse
        }
        return p
    }

}