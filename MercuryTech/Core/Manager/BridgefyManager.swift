//
//  BridgefyManager.swift
//  MercuryTech
//
//  Created by 222 on 7/13/20.
//  Copyright © 2020 222. All rights reserved.
//

import UIKit

class BridgefyManager: NSObject {
    static let shared = BridgefyManager()
    
    var transmitter: BFTransmitter?
    
    override init() {
        super.init()
    }
    
    func loadBF(){
        transmitter = BFTransmitter(apiKey: Keys.bfApiKey)
        guard let transmit = transmitter else { return }
        if (transmit.hasSession)
        {
            print("he session exists")
        }
        transmit.isBackgroundModeEnabled = true
        transmit.delegate = self
        transmit.start()
    }
    
    func processReceivedBroadcast(_ dictionary: Dictionary<String, Any>, fromUser user: String, byMesh mesh: Bool, asBroadcast broadcast: Bool) {
        let dic = [
            MessageKeys.messageID : dictionary[MessageKeys.messageID],
            MessageKeys.text : dictionary[MessageKeys.text],
            MessageKeys.sender : dictionary[MessageKeys.sender],
            MessageKeys.mesh : mesh,
            MessageKeys.deviceType : dictionary[MessageKeys.deviceType],
            MessageKeys.date : Date().timeIntervalSince1970
        ]
        DataController.shared.processReceivedBroadcast(withDictionary: dic as [String : Any])
        
    }
    
    func processReceivedMessage(_ dictionary: Dictionary<String, Any>, fromUser user: String, byMesh mesh: Bool, asBroadcast broadcast: Bool) {
        let dic = [
            MessageKeys.messageID : dictionary[MessageKeys.messageID],
            MessageKeys.text : dictionary[MessageKeys.text],
            MessageKeys.sender : dictionary[MessageKeys.sender],
            MessageKeys.receiver : dictionary[MessageKeys.receiver],
            MessageKeys.received : dictionary[MessageKeys.received],
            MessageKeys.mesh : mesh,
            MessageKeys.deviceType : dictionary[MessageKeys.deviceType],
            MessageKeys.date : Date().timeIntervalSince1970
        ]
        DataController.shared.processReceivedMessage(withDictionary: dic as [String : Any])
    }
    
    func processReceivedPeerInfo(_ peerInfo: Dictionary<String, Any>, fromUser user: String) {

        DataController.shared.processReceiver(withDictionary: peerInfo)
    }
    
    func sendUser(_ peerInfo: Dictionary<String, Any>) {
        do {
            try self.transmitter!.send(peerInfo,
                                      toUser: nil,
                                      options: [.fullTransmission, .broadcastReceiver])
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func sendMessage(_ message: Dictionary<String, Any>, _ userID:String) {
        do {
            try self.transmitter!.send(message,
                                      toUser: userID,
                                      options: [.encrypted, .directTransmission])
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func sendBroadCast(_ message: Dictionary<String, Any>) {
        do {
            try self.transmitter!.send(message,
                                      toUser: nil,
                                      options: [.fullTransmission, .broadcastReceiver])
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension BridgefyManager: BFTransmitterDelegate {
    func transmitter(_ transmitter: BFTransmitter, didFailConnectingToUser user: String, error: Error) {
        NotificationCenter.default.post(name: .didFailConnectingToUser, object: nil, userInfo: nil)
    }
    
    func transmitter(_ transmitter: BFTransmitter, didSendDirectPacket packetID: String) {
        NotificationCenter.default.post(name: .didSendDirectPacket, object: nil, userInfo: nil)
    }
    
    func transmitter(_ transmitter: BFTransmitter, didFailForPacket packetID: String, error: Error?) {
        NotificationCenter.default.post(name: .didFailForPacket, object: nil, userInfo: nil)
    }
    
    func transmitter(_ transmitter: BFTransmitter, didReceive dictionary: [String : Any]?, with data: Data?, fromUser user: String, packetID: String, broadcast: Bool, mesh: Bool) {
        
        if (dictionary?[MessageKeys.broadcast] != nil) {
            // If it contains a value for the key messageTextKey it's a message
            processReceivedMessage(dictionary! ,
                                   fromUser: user, byMesh: mesh, asBroadcast: broadcast)
        } else if (dictionary?[MessageKeys.text] != nil) {
            // If it contains a value for the key messageTextKey it's a message
            processReceivedBroadcast(dictionary! ,
                                   fromUser: user, byMesh: mesh, asBroadcast: broadcast)
        } else {
            //If it doesn't contain the key messageTextKey it's the device name of the other user.
            processReceivedPeerInfo(dictionary!, fromUser: user)
        }
    }
    
    func transmitter(_ transmitter: BFTransmitter, didDetectNearbyUser user: String) {
        NotificationCenter.default.post(name: .didDetectNearbyUser, object: nil, userInfo: nil)
    }
    
    func transmitter(_ transmitter: BFTransmitter, userIsNotAvailable user: String) {
        NotificationCenter.default.post(name: .userIsNotAvailable, object: nil, userInfo: nil)
    }
    
    func transmitter(_ transmitter: BFTransmitter, didDetectConnectionWithUser user: String) {
        NotificationCenter.default.post(name: .didDetectConnectionWithUser, object: nil, userInfo: nil)
    }
    
    func transmitter(_ transmitter: BFTransmitter, didDetectDisconnectionWithUser user: String) {
        NotificationCenter.default.post(name: .didDetectDisconnectionWithUser, object: nil, userInfo: nil)
    }
    
    func transmitter(_ transmitter: BFTransmitter, didFailAtStartWithError error: Error) {
        NotificationCenter.default.post(name: .didFailAtStartWithError, object: nil, userInfo: nil)
    }
    
    func transmitter(_ transmitter: BFTransmitter, meshDidAddPacket packetID: String) {
        // Packet added to mesh
        // Just called when the option BFSendingOptionMeshTransmission was used
        print("")
    }
    
    func transmitter(_ transmitter: BFTransmitter, didReachDestinationForPacket packetID: String) {
        //Mesh packet reached destiny (no always invoked)
        print("")
    }
    
    func transmitter(_ transmitter: BFTransmitter, meshDidStartProcessForPacket packetID: String) {
        //A message entered in the mesh process (was added).
        // Just called when the option BFSendingOptionFullTransmission was used.
        print("")
    }
    
    public func transmitter(_ transmitter: BFTransmitter, meshDidDiscardPackets packetIDs: [String]) {
        //A mesh message was discared and won't still be transmitted.
        print("")

    }
    
    func transmitter(_ transmitter: BFTransmitter, meshDidRejectPacketBySize packetID: String) {
        print("The packet \(packetID) was rejected from mesh because it exceeded the limit size.");
    }
    
    func transmitter(_ transmitter: BFTransmitter, didOccur event: BFEvent, description: String)
    {
        print("Event reported: \(description)");
    }
    
    func transmitter(_ transmitter: BFTransmitter, shouldConnectSecurelyWithUser user: String) -> Bool {
        print("")
        return true//if True, it will establish connection with encryption capacities.
        // Not necessary for this case.
    }
    
    func transmitter(_ transmitter: BFTransmitter, didDetectSecureConnectionWithUser user: String) {
            // A secure connection was detected,
            print("")
    }
}
