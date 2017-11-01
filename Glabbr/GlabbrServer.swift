//
//  GlabbrServer.swift
//  Glabbr
//
//  Created by Rajesh Dandu on 31/10/17.
//  Copyright © 2017 Rajesh Dandu. All rights reserved.
//

import Foundation


private let host = "37.247.116.67"

protocol GlabberServerDelegate:class {
    func didReceivedMessage(message:String)
}

class GlabbrServer:NSObject {
    
    weak var delegate : GlabberServerDelegate?
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    let maxReadLength = 1024
    
    
    //Opens a Persistent network connection between cleint and server.
    func setupNetworkCommunication(){
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           host as CFString,
                                           5224,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .main, forMode: .commonModes)
        outputStream.schedule(in: .main, forMode: .commonModes)
        
        inputStream.open()
        outputStream.open()

    }
    
    // closes the existing connection to the server.
   fileprivate func stopNetworkSession() {
        inputStream.close()
        outputStream.close()
    }
    
    //Converts the recevied bytes into readable message.
    // Parameters: InputStream object.
   fileprivate  func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            if numberOfBytesRead < 0 {
                if let _ = inputStream.streamError {
                    break
                }
            }
            
            guard let stringArray = String(bytesNoCopy: buffer,
                                           length: numberOfBytesRead,
                                           encoding: .ascii,
                                           freeWhenDone: true)?.components(separatedBy: ":"),
        
                let message = stringArray.first else {
                    return
            }
            delegate?.didReceivedMessage(message: message)
            }
        
    }
    
    
    // Data will be sent to the Connected server in the form of bytes.
    // Parameters: Data object.
    func sendMessage(data: Data) {
     
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
}

extension GlabbrServer:StreamDelegate{
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            print("new message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            stopNetworkSession()
        case Stream.Event.errorOccurred:
            print("error occurred")
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
            break
        }
    }
    
    
}
