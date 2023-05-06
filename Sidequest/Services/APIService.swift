//
//  APIService.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import Foundation

protocol APIService {
    func login(phoneNumber: String) -> User? // Obviously not a viable login function but will do for mocking
    func getUser(userId: UUID) -> User?
    func getFriends(friendIds: [UUID]) -> [User]
    func sendFriendRequest(userId: UUID, friendPhoneNumber: String)
    
    func getQuests(userId: UUID) -> [Quest]
    func getQuest(questId: UUID) -> Quest?
}

class MockAPIService: APIService {
    private var users: [UUID: User] = [:]
    private var quests: [UUID: Quest] = [:]
    
    init() {
        // Populate mock data
        let user0 = User(firstName: "John", lastName: "Smith", phoneNumber: "000", friendIds: [])
        self.users[user0.id] = user0
        let user1 = User(firstName: "Karen", lastName: "Jones", phoneNumber: "111", friendIds: [])
        self.users[user1.id] = user1
        let user2 = User(firstName: "John", lastName: "Denver", phoneNumber: "222", friendIds: [])
        self.users[user2.id] = user2
        
        let quest0 = Quest(title: "Mock Quest", content: "Make a snow man. Your time starts now.", authorId: user0.id, assigned: [], endTime: Date.now)
        self.quests[quest0.id] = quest0
    }
    
    func login(phoneNumber: String) -> User? {
        for (_, user) in self.users {
            if user.phoneNumber == phoneNumber {
                return user
            }
        }
        return nil
    }
    
    func getUser(userId: UUID) -> User? {
        self.users[userId]
    }
    
    func getFriends(friendIds: [UUID]) -> [User] {
        var friends: [User] = []
        for id in friendIds {
            if let user = self.users[id] {
                friends.append(user)
            }
        }
        return friends
    }
    
    func sendFriendRequest(userId: UUID, friendPhoneNumber: String) {
        
    }
    
    func getQuests(userId: UUID) -> [Quest] {
        var foundQuests: [Quest] = []
        for (_, quest) in self.quests {
            for assigned in quest.assigned {
                if assigned == userId {
                    foundQuests.append(quest)
                }
            }
        }
        return foundQuests
    }
    
    func getQuest(questId: UUID) -> Quest? {
        self.quests[questId]
    }
}
