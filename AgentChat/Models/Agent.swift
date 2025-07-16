//
//  Agent.swift
//  AgentChat
//
//  Created by OpenAI on 04/07/25.
//

import Foundation

// MARK: - Agent Model
struct Agent: Codable, Identifiable, Equatable {
    let id: String
    var name: String
    var provider: AssistantProvider
    var systemPrompt: String
    var avatar: String
    var isActive: Bool
    var isDefault: Bool

    init(id: String = UUID().uuidString,
         name: String,
         provider: AssistantProvider,
         systemPrompt: String = "",
         avatar: String = "🤖",
         isActive: Bool = true,
         isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.provider = provider
        self.systemPrompt = systemPrompt
        self.avatar = avatar
        self.isActive = isActive
        self.isDefault = isDefault
    }

    static func == (lhs: Agent, rhs: Agent) -> Bool {
        lhs.id == rhs.id
    }
}
