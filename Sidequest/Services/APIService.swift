//
//  APIService.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import Foundation

protocol APIService {
    func login(phoneNumber: String) -> User? // Obviously not a viable login function but will do for mocking
    func login(phoneNumber: String, password: String) async -> String?
    func register(registration: RegisterDto) async -> String?
    func getUser() async -> UserResponse?
    func getUser(userId: UUID) -> User?
    func getFriends(friendIds: [UUID]) -> [User]
    func getFriends() async -> [UserResponse]
    func addFriend(userId: UUID, friendFullName: String, friendPhoneNumber: String)
    func sendFriendRequest(phoneNumber: String) async
    func getFriendRequests() async -> [FriendRequest]
    func acceptFriendRequest(friendId: UUID) async
    func declineFriendRequest(friendId: UUID) async
    func addUser(_ user: User)
    func getQuests(userId: UUID) -> [Quest]
    func getQuests() async -> [QuestResponse]
    func getQuest(questId: UUID) -> Quest?
//    func getQuest(questId: UUID) async -> QuestResponse?
    func addQuest(_ quest: Quest) async
    func updateQuest(_ quest: Quest) async
    func deleteQuest(questId: UUID) async
    func completeQuest(questId: UUID) async
}

class LiveAPIService: APIService {
    let session = URLSession(configuration: .default)
    
    
    func login(phoneNumber: String) -> User? {
        fatalError("Don't use this login method.")
    }
    
    func login(phoneNumber: String, password: String) async -> String? {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/auth/login") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        
        let parameters = ["phoneNumber": phoneNumber, "password": password]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let token = String(data: data, encoding: .utf8)
                    return token?.trimmingCharacters(in: CharacterSet(charactersIn: "\"\\"))
                }
                return nil
            }
            return nil
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func register(registration: RegisterDto) async -> String? {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/auth/register") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let jsonEncoder = JSONEncoder()
        let jsonObject = try! jsonEncoder.encode(registration)
        request.httpBody = jsonObject

        do {
            let (data, _) = try await session.data(for: request)
            let token = String(data: data, encoding: .ascii)
            return token
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func getUser() async -> UserResponse? {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/user") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let user = try JSONDecoder().decode(UserResponse.self, from: data)
                    return user
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return nil
            }
            return nil
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func getUser(userId: UUID) -> User? {
        return nil
    }
    
    func getFriends(friendIds: [UUID]) -> [User] {
        return []
    }
    
    func getFriends() async -> [UserResponse] {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/friends") else { return [] }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let friends = try JSONDecoder().decode([UserResponse].self, from: data)
                    return friends
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return []
            }
            return []
        } catch let error {
            print(error)
            return []
        }
    }
    
    func addFriend(userId: UUID, friendFullName: String, friendPhoneNumber: String) {
        return
    }
    
    func sendFriendRequest(phoneNumber: String) async {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/friends/request") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        let parameters = ["phoneNumber": phoneNumber]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        do {
            let (_, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return
            }
            return
        } catch let error {
            print(error)
            return
        }
    }
    
    func getFriendRequests() async -> [FriendRequest] {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/friends/request") else { return [] }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return try JSONDecoder().decode([FriendRequest].self, from: data)
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return []
            }
            return []
        } catch let error {
            print(error)
            return []
        }
    }
    
    func acceptFriendRequest(friendId: UUID) async {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/friends/request/accept/\(friendId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return
            }
            return
        } catch let error {
            print(error)
            return
        }
    }
    
    func declineFriendRequest(friendId: UUID) async {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/friends/request/decline/\(friendId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return
            }
            return
        } catch let error {
            print(error)
            return
        }
    }
    
    func addUser(_ user: User) {
    }
    
    func getQuests(userId: UUID) -> [Quest] {
        return []
    }
    
    func getQuests() async -> [QuestResponse] {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/quests") else { return [] }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return try JSONDecoder().decode([QuestResponse].self, from: data)
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return []
            }
            return []
        } catch let error {
            print(error)
            return []
        }
    }
    
    func getQuest(questId: UUID) -> Quest? {
        return nil
    }
    
//    func getQuest(questId: UUID) async -> Quest? {
//        guard let url = URL(string: "http://sidequest.peterdevroom.com/friends/request") else { return [] }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
//
//        do {
//            let (data, response) = try await session.data(for: request)
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                    return try JSONDecoder().decode([QuestResponse].self, from: data)
//                } else if httpResponse.statusCode == 401 {
//                    AppState.shared.token = nil
//                }
//                return []
//            }
//            return []
//        } catch let error {
//            print(error)
//            return []
//        }
//    }
    
    func addQuest(_ quest: Quest) async {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/quests") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let formattedDate = formatter.string(from: quest.endTime)
        
        let parameters = [
            "title": quest.title,
            "content": quest.content,
            "authorId": quest.authorId.uuidString,
            "assignedId": quest.assigned.count > 0 ? quest.assigned[0].uuidString : nil,
            "endTime": formattedDate
        ] as [String : Any?]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        do {
            let (_, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return
            }
            return
        } catch let error {
            print(error)
            return
        }
    }
    
    func updateQuest(_ quest: Quest) async {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/quests") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let formattedDate = formatter.string(from: quest.endTime)
        
        let parameters = [
            "id": quest.id.uuidString,
            "title": quest.title,
            "content": quest.content,
            "authorId": quest.authorId.uuidString,
            "assignedId": quest.assigned.count > 0 ? quest.assigned[0].uuidString : nil,
            "endTime": formattedDate
        ] as [String : Any?]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        do {
            let (_, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return
            }
            return
        } catch let error {
            print(error)
            return
        }
    }
    
    func deleteQuest(questId: UUID) async {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/quests/\(questId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return
            }
            return
        } catch let error {
            print(error)
            return
        }
    }
    
    func completeQuest(questId: UUID) async {
        guard let url = URL(string: "http://sidequest.peterdevroom.com/quests/complete/\(questId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AppState.shared.token!)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return
                } else if httpResponse.statusCode == 401 {
                    AppState.shared.token = nil
                }
                return
            }
            return
        } catch let error {
            print(error)
            return
        }
        
    }
}

class MockAPIService: APIService {
    func completeQuest(questId: UUID) async {
    }
    
    func getQuests() async -> [QuestResponse] {
        []
    }
    
    func getFriends() async -> [UserResponse] {
        []
    }
    
    func acceptFriendRequest(friendId: UUID) async {
    }
    
    func declineFriendRequest(friendId: UUID) async {
    }
    
    func getFriendRequests() async -> [FriendRequest] {
        []
    }
    
    func sendFriendRequest(phoneNumber: String) async {
    }
    
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
    
    func login(phoneNumber: String, password: String) async -> String? {
        return nil
    }
    
    func register(registration: RegisterDto) async -> String? {
        return nil
    }
    
    func getUser() async -> UserResponse? {
        UserResponse()
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
    
    func addQuest(_ quest: Quest) async {
        self.quests[quest.id] = quest
    }
    
    func updateQuest(_ quest: Quest) async {
        self.quests[quest.id] = quest
    }
    
    func deleteQuest(questId: UUID) async {
        self.quests.removeValue(forKey: questId)
    }
}
