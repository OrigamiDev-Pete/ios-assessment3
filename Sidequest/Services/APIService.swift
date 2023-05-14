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
    func addFriend(userId: UUID, friendFullName: String, friendPhoneNumber: String)
    func addUser(_ user: User)
    func getQuests(userId: UUID) -> [Quest]
    func getQuest(questId: UUID) -> Quest?
    func addQuest(_ quest: Quest)
    func updateQuest(_ quest: Quest)
    func deleteQuest(questId: UUID)
}

class MockAPIService: APIService {
    private var users: [UUID: User] = [:]
    private var quests: [UUID: Quest] = [:]
    
    init() {
        // Populate mock data
        let user0 = User(firstName: "John", lastName: "Smith", phoneNumber: "000", friendIds: [])
        self.users[user0.id] = user0
        let user1 = User(firstName: "Karen", lastName: "Jones", phoneNumber: "111", friendIds: [user0.id])
        self.users[user1.id] = user1
        let user2 = User(firstName: "John", lastName: "Denver", phoneNumber: "222", friendIds: [])
        self.users[user2.id] = user2
        
        let quest0 = Quest(title: "Mock Quest", content: "Make a snow man. Your time starts now.", authorId: user0.id, assigned: [], completedBy: user0.id, endTime: Date.now)
        self.quests[quest0.id] = quest0
        let quest1 = Quest(title: "Mock Quest 2", content: "Do 10,000 steps.", authorId: user0.id, assigned: [], completedBy: nil, endTime: Date.now)
        self.quests[quest1.id] = quest1
        let quest2 = Quest(title: "Mock Quest 3", content: "Finish Assessment 3", authorId: user1.id, assigned: [user0.id], completedBy: nil, endTime: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!)
        self.quests[quest2.id] = quest2
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
    
    func addUser(_ user: User) {
        self.users[user.id] = user
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
    
    func addFriend(userId: UUID, friendFullName: String, friendPhoneNumber: String) {
        let currentUser = self.users[userId]
        guard let currentUser = currentUser else { return }
        
        for (_, user) in self.users {
            if user.fullName == friendFullName && user.phoneNumber == friendPhoneNumber {
                currentUser.friendIds.append(user.id)
                return
            }
        }
    }
   
    func getQuests(userId: UUID) -> [Quest] {
        var foundQuests: [Quest] = []
        for (_, quest) in self.quests {
            if quest.authorId == userId {
                foundQuests.append(quest)
                continue
            }
            
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
    
    func addQuest(_ quest: Quest) {
        self.quests[quest.id] = quest
    }
    
    func updateQuest(_ quest: Quest) {
        self.quests[quest.id] = quest
    }
    
    func deleteQuest(questId: UUID) {
        self.quests.removeValue(forKey: questId)
    }
}
