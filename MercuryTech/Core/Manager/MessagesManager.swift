//
//  MessagesManager.swift
//  WithinUS
//
//  Created by 222 on 2019/7/9.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

let Messages = "Messages"

class MessagesManager: NSObject {
    static let shared = MessagesManager()
    
    func createMessage(_ message: Message, completion: @escaping (_ chat: MockMessage?) -> Void) {
        guard let currentUser = AppManager.shared.currentUser else { return }
        guard let currentUserID = currentUser.userID else { return }
        
//        let commentRep = rootR.child(Messages).child(postID).childByAutoId()
//        let commentID = commentRep.key!
//        comment.commentID = commentID
//        commentRep.setValue(comment.toJSON())
        
        let mockUser = MockUser.init(senderId: currentUserID, displayName: currentUser.fullName ?? "user")
        guard let messageStr = message.text, messageStr.count > 0 else { return }
        let mockMessage = MockMessage(text: messageStr, user: mockUser, messageId: message.messageID!, date: message.date)
        completion(mockMessage)
    }
    
    
    func removeMessage(_ id: String) {
        
    }
    
    func getAllMessages(completion: @escaping (_ mockMessages: [MockMessage]?, _ messages: [Message]?) -> Void) {
//        guard let currentUser = AppManager.shared.currentUser else { return }
//        guard let currentUserID = currentUser.userID else { return }
        
//        rootR.child(Comments).child(postID).queryOrderedByKey().observe(.value) { snapchat in
//            var chatLogs: [MockMessage] = []
//            var comments: [Comment] = []
//            for message in snapchat.children {
//                let messageData = message as! DataSnapshot
//                guard let commentModel = Comment(JSON: messageData.value as! [String:Any]) else { continue }
//                guard let sender = commentModel.sender else { continue }
//                
//                comments.append(commentModel)
//                
//                var mockUser = MockUser.init(senderId: sender.userID!, displayName: sender.fullName!)
//                if sender.userID == currentUserID {
//                    mockUser = MockUser.init(senderId: currentUserID, displayName: currentUser.fullName!)
//                }
//                if let messageStr = commentModel.messsage, messageStr.count > 0 {
//                    let mockMessage = MockMessage(text: messageStr, user: mockUser, messageId: commentModel.commentID!, date: commentModel.date!)
//                    chatLogs.append(mockMessage)
//                } else {
//                    let mockMessage = MockMessage(imageURL: commentModel.fileUrl!, user: mockUser, messageId: commentModel.commentID!, date: commentModel.date!)
//                    chatLogs.append(mockMessage)
//                }
//            }
//            completion(chatLogs, comments)
//        }
    }
    
}
