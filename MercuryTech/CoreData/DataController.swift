//
//  DataController.swift
//  MercuryTech
//
//  Created by 222 on 7/13/20.
//  Copyright © 2020 222. All rights reserved.
//
//

import UIKit
import CoreData

protocol DataControllerDelegate: class {
    func dataController(_ dataController: DataController, didInsertMessage message: Message)
    func dataController(_ dataController: DataController, didInsertBroadcast message: Broadcast)
    func dataController(_ dataController: DataController, didInsertUser user: User)
}

class DataController: NSObject {
    static let shared = DataController()
    weak var delegate: DataControllerDelegate?
    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "MercuryTech")
        super.init()
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("An error occurred loading persistent store \(error)")
            }
        }
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - Util methods
extension DataController {
    
    func findUser(withId userID: String) -> User? {
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Core Data error: \(error)")
            return nil
        }
    }
    
    func findBroadcast(withId messageID: String) -> Broadcast? {
        do {
            let fetchRequest: NSFetchRequest<Broadcast> = Broadcast.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "messageID == %@", messageID)
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Core Data error: \(error)")
            return nil
        }
    }
    
    func findMessage(withId messageID: String) -> Message? {
        do {
            let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "messageID == %@", messageID)
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Core Data error: \(error)")
            return nil
        }
    }
    
    func insertUser(fromDictionary dictionary: [ String: Any ], context: NSManagedObjectContext) -> User {
        let user = NSEntityDescription.insertNewObject(forEntityName: String(describing: User.self), into: context) as! User
        user.userID = dictionary[UserKeys.userID] as? String
        user.firstName = dictionary[UserKeys.firstName] as? String
        user.lastName = dictionary[UserKeys.lastName] as? String
        user.username = dictionary[UserKeys.username] as? String
        return user
    }
    
    func insertMessage(fromDictionary dictionary: [ String: Any ], context: NSManagedObjectContext) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: String(describing: Message.self), into: context) as! Message
        message.messageID = dictionary[MessageKeys.messageID] as? String
        let time = dictionary[MessageKeys.date] as! Double
        message.time = Double(time)
        message.text = dictionary[MessageKeys.text] as? String
        message.sender = dictionary[MessageKeys.sender] as? String
        message.receiver = dictionary[MessageKeys.receiver] as? String
        message.mesh = dictionary[MessageKeys.mesh] as? Bool ?? true
        message.received = dictionary[MessageKeys.received] as? Bool ?? false
        message.broadcast = dictionary[MessageKeys.broadcast] as? Bool ?? false
        message.deviceType = dictionary[MessageKeys.deviceType] as! Int16
        return message
    }
    
    func insertBroadCast(fromDictionary dictionary: [ String: Any ], context: NSManagedObjectContext) -> Broadcast {
        let message = NSEntityDescription.insertNewObject(forEntityName: String(describing: Broadcast.self), into: context) as! Broadcast
        message.messageID = dictionary[MessageKeys.messageID] as? String
        let time = dictionary[MessageKeys.date] as! Double
        message.time = Double(time)
        message.text = dictionary[MessageKeys.text] as? String
        message.sender = dictionary[MessageKeys.sender] as? String
        message.mesh = dictionary[MessageKeys.mesh] as? Bool ?? true
        message.deviceType = dictionary[MessageKeys.deviceType] as! Int16
        return message
    }
}

extension DataController {
    func getAllBroadCast() -> [Broadcast] {
        let fetchRequest: NSFetchRequest<Broadcast> = Broadcast.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Broadcast.time), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do  {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching blocked user result")
            return [Broadcast]()
        }
    }
    func getAllMessages(_ sender: String, _ receiver:String) -> [Message] {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Message.time), ascending: true)
        fetchRequest.predicate = NSPredicate(format: "sender == %@ AND receiver == %@", sender, receiver)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do  {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching blocked user result")
            return [Message]()
        }
    }
    
    func getAllUsers() -> [User] {
        guard let userID = AppManager.shared.currentUser?.userID else {
            return [User]()
        }
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID != %@", userID)
        do  {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching blocked user result")
            return [User]()
        }
    }
}
// MARK: - Client methods

extension DataController {
    
    func insertOwnMessage(withText text: String, receiver:String, completion: @escaping (_ message: Message?) -> Void){
        persistentContainer.performBackgroundTask { context in
            context.automaticallyMergesChangesFromParent = true
            let message = NSEntityDescription.insertNewObject(forEntityName: String(describing: Message.self), into: context) as! Message
            message.text = text
            message.time = Date().timeIntervalSince1970
            message.mesh = true
            message.broadcast = false
            message.deviceType = Int16(DeviceType.ios.rawValue)
            message.messageID  = "\(Date().timeIntervalSince1970)"
            message.received = false
            message.sender = AppManager.shared.currentUser?.userID
            message.receiver = receiver
            self.saveContext(context: context)
            self.persistentContainer.viewContext.perform {
                let mainMessage = self.persistentContainer.viewContext.object(with: message.objectID) as! Message
                completion(mainMessage)
            }
        }
    }
    
    func processReceivedMessage(withDictionary dictionary: [ String: Any ] ) {
        self.persistentContainer.performBackgroundTask { context in
            context.automaticallyMergesChangesFromParent = true
            
            let message = self.insertMessage(fromDictionary: dictionary, context: context)
            self.saveContext(context: context)
            self.persistentContainer.viewContext.perform {
                let mainMessage = self.persistentContainer.viewContext.object(with: message.objectID) as! Message
                NotificationCenter.default.post(name: .didReceiveMessage, object: nil, userInfo: ["messageNewID":dictionary[MessageKeys.messageID] ?? ""])
                self.delegate?.dataController(self, didInsertMessage: mainMessage)
            }
        }
    }
    
    func insertOwnBroadcast(withText text: String){
        persistentContainer.performBackgroundTask { context in
            context.automaticallyMergesChangesFromParent = true
            let message = NSEntityDescription.insertNewObject(forEntityName: String(describing: Broadcast.self), into: context) as! Broadcast
            message.text = text
            message.time = Date().timeIntervalSince1970
            message.mesh = true
            message.deviceType = Int16(DeviceType.ios.rawValue)
            message.messageID  = "\(Date().timeIntervalSince1970)"
            message.sender = AppManager.shared.currentUser?.userID
            self.saveContext(context: context)
            self.persistentContainer.viewContext.perform {
                let mainMessage = self.persistentContainer.viewContext.object(with: message.objectID) as! Broadcast
                self.delegate?.dataController(self, didInsertBroadcast: mainMessage)
            }
        }
    }
    
    func processReceivedBroadcast(withDictionary dictionary: [ String: Any ] ) {
        self.persistentContainer.performBackgroundTask { context in
            context.automaticallyMergesChangesFromParent = true
            
            let message = self.insertBroadCast(fromDictionary: dictionary, context: context)
            self.saveContext(context: context)
            self.persistentContainer.viewContext.perform {
                let mainMessage = self.persistentContainer.viewContext.object(with: message.objectID) as! Broadcast

                NotificationCenter.default.post(name: .didReceiveBroadcast, object: nil, userInfo: ["broadcastNewID":dictionary[MessageKeys.messageID] ?? ""])
                self.delegate?.dataController(self, didInsertBroadcast: mainMessage)
            }
        }
    }
    
    func processReceiver(withDictionary dictionary: [ String: Any ] ) {
        self.persistentContainer.performBackgroundTask { context in
            context.automaticallyMergesChangesFromParent = true
            
            if self.findUser(withId: dictionary[UserKeys.userID]! as! String) == nil {
                let user = self.insertUser(fromDictionary: dictionary, context: context)
                self.saveContext(context: context)
                self.persistentContainer.viewContext.perform {
                    NotificationCenter.default.post(name: .didReceivedUser, object: nil, userInfo: nil)
                    let mainUser = self.persistentContainer.viewContext.object(with: user.objectID) as! User
                    self.delegate?.dataController(self, didInsertUser: mainUser)
                }
            }
        }
    }
    
    func insertUser(withText name: String, username:String, completion: @escaping (_ user: User?) -> Void){

        var firstName: String = ""
        var lastName: String = ""
        let names = name.components(separatedBy: " ")
        if names.count == 1 {
            firstName = names[0]
        } else if names.count >= 2 {
            firstName = names[0]
            lastName = names[1]
        }
        
        persistentContainer.performBackgroundTask { context in
            context.automaticallyMergesChangesFromParent = true
            let user = NSEntityDescription.insertNewObject(forEntityName: String(describing: User.self), into: context) as! User
            user.userID = BridgefyManager.shared.transmitter?.currentUser
            user.firstName = firstName
            user.lastName = lastName
            user.username = username
            
            self.saveContext(context: context)
            self.persistentContainer.viewContext.perform {
                let mainUser = self.persistentContainer.viewContext.object(with: user.objectID) as! User
                completion(mainUser)
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        saveContext(context: context)
    }
    
    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
