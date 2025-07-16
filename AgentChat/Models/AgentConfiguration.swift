//
//  AgentConfiguration.swift
//  AgentChat
//
//  Created by Mario Moschetta on 04/07/25.
//

import Foundation
import SwiftUI

// MARK: - Agent Configuration
struct AgentConfiguration: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var systemPrompt: String
    var personality: String
    var role: String
    var icon: String
    var preferredProvider: String
    var temperature: Double
    var maxTokens: Int
    var isActive: Bool
    var memoryEnabled: Bool
    var contextWindow: Int // Numero di messaggi da ricordare
    
    // Nuove proprietà per il sistema di agenti avanzato
    var agentType: AgentType {
        return AgentType(rawValue: preferredProvider) ?? .openAI
    }
    var model: String
    var capabilities: [AgentCapability]
    var parameters: AgentParameters
    var customConfig: [String: String]?
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, name, systemPrompt, personality, role, icon
        case preferredProvider, temperature, maxTokens, isActive
        case memoryEnabled, contextWindow, model, capabilities
        case parameters, customConfig
        // agentType è escluso perché è una proprietà computata
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        systemPrompt: String,
        personality: String,
        role: String,
        icon: String,
        preferredProvider: String,
        temperature: Double = 0.7,
        maxTokens: Int = 2000,
        isActive: Bool = true,
        memoryEnabled: Bool = true,
        contextWindow: Int = 10,
        model: String? = nil,
        capabilities: [AgentCapability] = [],
        parameters: AgentParameters? = nil,
        customConfig: [String: String]? = nil
    ) {
        self.id = id
        self.name = name
        self.systemPrompt = systemPrompt
        self.personality = personality
        self.role = role
        self.icon = icon
        self.preferredProvider = preferredProvider
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.isActive = isActive
        self.memoryEnabled = memoryEnabled
        self.contextWindow = contextWindow
        
        // Imposta il modello predefinito basato sul provider
        let agentType = AgentType(rawValue: preferredProvider) ?? .openAI
        self.model = model ?? agentType.defaultModel
        self.capabilities = capabilities.isEmpty ? agentType.defaultCapabilities : capabilities
        self.parameters = parameters ?? AgentParameters(
            temperature: temperature,
            maxTokens: maxTokens
        )
        self.customConfig = customConfig
    }
    
    // MARK: - Default Agents
    static let defaultAgents: [AgentConfiguration] = [
        AgentConfiguration(
            name: "Assistente Generale",
            systemPrompt: "Sei un assistente AI utile e cordiale. Rispondi sempre in modo chiaro e preciso. Mantieni un tono professionale ma amichevole.",
            personality: "Cordiale, professionale, preciso",
            role: "Assistente Generale",
            icon: "🤖",
            preferredProvider: "OpenAI",
            temperature: 0.7,
            maxTokens: 2000,
            isActive: true,
            memoryEnabled: true,
            contextWindow: 10
        ),
        AgentConfiguration(
            name: "Esperto di Codice",
            systemPrompt: "Sei un esperto programmatore senior con anni di esperienza. Fornisci sempre codice pulito, ben commentato e seguendo le best practices. Spiega il tuo ragionamento e suggerisci miglioramenti quando possibile.",
            personality: "Tecnico, preciso, orientato alle soluzioni",
            role: "Sviluppatore Senior",
            icon: "👨‍💻",
            preferredProvider: "OpenAI",
            temperature: 0.3,
            maxTokens: 4000,
            isActive: true,
            memoryEnabled: true,
            contextWindow: 15
        ),
        AgentConfiguration(
            name: "Creativo",
            systemPrompt: "Sei un direttore creativo innovativo con una vasta esperienza nel design e nel marketing. Pensa fuori dagli schemi e proponi sempre idee originali e creative. Non aver paura di essere audace nelle tue proposte.",
            personality: "Creativo, visionario, innovativo",
            role: "Direttore Creativo",
            icon: "🎨",
            preferredProvider: "Claude",
            temperature: 0.9,
            maxTokens: 3000,
            isActive: true,
            memoryEnabled: true,
            contextWindow: 8
        ),
        AgentConfiguration(
            name: "Analista Business",
            systemPrompt: "Sei un analista business esperto con forte background in strategia aziendale. Fornisci analisi dettagliate, considera sempre il ROI e l'impatto sul business. Usa dati concreti quando possibile.",
            personality: "Analitico, strategico, orientato ai risultati",
            role: "Business Analyst",
            icon: "📊",
            preferredProvider: "OpenAI",
            temperature: 0.4,
            maxTokens: 3000,
            isActive: true,
            memoryEnabled: true,
            contextWindow: 12
        ),
        AgentConfiguration(
            name: "Tutor Educativo",
            systemPrompt: "Sei un tutor educativo paziente e competente. Spiega concetti complessi in modo semplice e comprensibile. Adatta il tuo linguaggio al livello dell'utente e fornisci esempi pratici.",
            personality: "Paziente, didattico, incoraggiante",
            role: "Tutor",
            icon: "👨‍🏫",
            preferredProvider: "Claude",
            temperature: 0.6,
            maxTokens: 2500,
            isActive: true,
            memoryEnabled: true,
            contextWindow: 10
        )
    ]
    
    // MARK: - Helper Methods
    var displayName: String {
        return "\(icon) \(name)"
    }
    
    func buildContextualPrompt(userMessage: String, conversationHistory: [Message] = []) -> String {
        var prompt = systemPrompt + "\n\n"
        
        // Aggiungi contesto della conversazione se disponibile
        if !conversationHistory.isEmpty && memoryEnabled {
            let recentMessages = conversationHistory.suffix(contextWindow)
            if !recentMessages.isEmpty {
                prompt += "Contesto conversazione precedente:\n"
                for message in recentMessages {
                    let sender = message.isUser ? "User" : "Assistant"
                    prompt += "\(sender): \(message.content)\n"
                }
                prompt += "\n"
            }
        }
        
        prompt += "User: \(userMessage)\nAssistant:"
        
        return prompt
    }
}

// MARK: - Agent Parameters

/// Parametri di configurazione per un agente
struct AgentParameters: Codable, Hashable {
    let temperature: Double
    let maxTokens: Int?
    let topP: Double?
    let frequencyPenalty: Double?
    let presencePenalty: Double?
    let stopSequences: [String]?
    let timeout: TimeInterval
    let retryAttempts: Int
    
    init(
        temperature: Double = 0.7,
        maxTokens: Int? = nil,
        topP: Double? = nil,
        frequencyPenalty: Double? = nil,
        presencePenalty: Double? = nil,
        stopSequences: [String]? = nil,
        timeout: TimeInterval = 30.0,
        retryAttempts: Int = 3
    ) {
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.topP = topP
        self.frequencyPenalty = frequencyPenalty
        self.presencePenalty = presencePenalty
        self.stopSequences = stopSequences
        self.timeout = timeout
        self.retryAttempts = retryAttempts
    }
}

// MARK: - Agent Configuration Extensions
extension AgentConfiguration {
    static func createCustomAgent(
        name: String,
        systemPrompt: String,
        role: String,
        icon: String = "🤖",
        provider: String = "OpenAI"
    ) -> AgentConfiguration {
        return AgentConfiguration(
            name: name,
            systemPrompt: systemPrompt,
            personality: "Personalizzato",
            role: role,
            icon: icon,
            preferredProvider: provider
        )
    }
    
    /// Crea una configurazione per il nuovo sistema di agenti
    static func createAgentConfiguration(
        name: String,
        agentType: AgentType,
        model: String? = nil,
        systemPrompt: String? = nil,
        capabilities: [AgentCapability] = [],
        parameters: AgentParameters? = nil
    ) -> AgentConfiguration {
        let finalModel = model ?? agentType.defaultModel
        let finalCapabilities = capabilities.isEmpty ? agentType.defaultCapabilities : capabilities
        let finalSystemPrompt = systemPrompt ?? "Sei un assistente AI utile e competente."
        
        return AgentConfiguration(
            name: name,
            systemPrompt: finalSystemPrompt,
            personality: "Professionale",
            role: "Assistente",
            icon: agentType.defaultIcon,
            preferredProvider: agentType.rawValue,
            model: finalModel,
            capabilities: finalCapabilities,
            parameters: parameters
        )
    }
    
    /// Valida la configurazione dell'agente
    func validate() throws {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw AgentConfigurationError.invalidName
        }
        
        if model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw AgentConfigurationError.invalidModel
        }
        
        if parameters.temperature < 0 || parameters.temperature > 2 {
            throw AgentConfigurationError.invalidTemperature
        }
        
        if let maxTokens = parameters.maxTokens, maxTokens <= 0 {
            throw AgentConfigurationError.invalidMaxTokens
        }
        
        if parameters.timeout <= 0 {
            throw AgentConfigurationError.invalidTimeout
        }
        
        if parameters.retryAttempts < 0 {
            throw AgentConfigurationError.invalidRetryAttempts
        }
    }
}

// MARK: - Configuration Errors

enum AgentConfigurationError: LocalizedError {
    case invalidName
    case invalidModel
    case invalidTemperature
    case invalidMaxTokens
    case invalidTimeout
    case invalidRetryAttempts
    
    var errorDescription: String? {
        switch self {
        case .invalidName:
            return "Il nome dell'agente non può essere vuoto"
        case .invalidModel:
            return "Il modello specificato non è valido"
        case .invalidTemperature:
            return "La temperatura deve essere compresa tra 0 e 2"
        case .invalidMaxTokens:
            return "Il numero massimo di token deve essere positivo"
        case .invalidTimeout:
            return "Il timeout deve essere positivo"
        case .invalidRetryAttempts:
            return "Il numero di tentativi deve essere non negativo"
        }
    }
}

// MARK: - AgentType Extensions

extension AgentType {
    var defaultModel: String {
        switch self {
        case .openAI:
            return "gpt-4"
        case .claude:
            return "claude-3-5-sonnet-20241022"
        case .mistral:
            return "mistral-large-latest"
        case .perplexity:
            return "llama-3.1-sonar-large-128k-online"
        case .grok:
            return "grok-beta"
        case .deepSeek:
            return "deepseek-v3-0324"
        case .n8n:
            return "workflow"
        case .custom:
            return "custom-model"
        case .hybridMultiAgent:
            return "hybrid-balanced"
        case .agentGroup:
            return "group-collaborative"
        case .group:
            return "group-standard"
        case .productTeam:
            return "product-team"
        case .brainstormingSquad:
            return "brainstorming"
        case .codeReviewPanel:
            return "code-review"
        }
    }
    
    var defaultCapabilities: [AgentCapability] {
        switch self {
        case .openAI, .claude, .mistral, .grok, .deepSeek:
            return [.textGeneration, .codeGeneration, .dataAnalysis]
        case .perplexity:
            return [.textGeneration, .webSearch, .dataAnalysis]
        case .n8n:
            return [.workflowAutomation, .collaboration]
        case .custom:
            return [.textGeneration]
        case .hybridMultiAgent:
            return [.textGeneration, .codeGeneration, .dataAnalysis, .collaboration, .memoryRetention]
        case .agentGroup, .group:
            return [.textGeneration, .collaboration, .memoryRetention]
        case .productTeam:
            return [.textGeneration, .dataAnalysis, .collaboration]
        case .brainstormingSquad:
            return [.textGeneration, .collaboration]
        case .codeReviewPanel:
            return [.textGeneration, .codeGeneration, .collaboration]
        }
    }
    
    var defaultIcon: String {
        switch self {
        case .openAI:
            return "🤖"
        case .claude:
            return "🧠"
        case .mistral:
            return "🌪️"
        case .perplexity:
            return "🔍"
        case .grok:
            return "🚀"
        case .deepSeek:
            return "🧠"
        case .n8n:
            return "⚙️"
        case .custom:
            return "🔧"
        case .hybridMultiAgent:
            return "🔀"
        case .agentGroup:
            return "👥"
        case .group:
            return "🏢"
        case .productTeam:
            return "📱"
        case .brainstormingSquad:
            return "💡"
        case .codeReviewPanel:
            return "👨‍💻"
        }
    }
}
