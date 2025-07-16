//
//  ChatService.swift
//  AgentChat
//
//  Created by Mario Moschetta on 04/07/25.
//

import Foundation
import Combine
import SwiftUI

// Import the protocol and error definitions
// ChatServiceProtocol is defined in Protocols/ChatServiceProtocol.swift
// ChatServiceError is defined in Models/ChatServiceError.swift

// Import required models
// These imports are needed for the types used in this file

// MARK: - Chat Manager
class ChatManager: ObservableObject {
    static let shared = ChatManager()
    
    @Published var chats: [Chat] = []
    private let serviceFactory = ServiceFactory()
    private let agentOrchestrator = AgentOrchestrator.shared
    
    private init() {
        // Carica le chat salvate all'avvio dell'applicazione
        chats = ChatPersistenceManager.shared.loadChats()
    }
    
    /// Crea una nuova chat basata su un provider e un modello specifici.
    func createNewChat(with provider: AssistantProvider, model: String?, workflow: N8NWorkflow? = nil) {
        let agentType: AgentType = {
            switch provider.type {
            case .openai:
                return .openAI
            case .anthropic:
                return .claude
            case .mistral:
                return .mistral
            case .perplexity:
                return .perplexity
            case .grok:
                return .grok
            case .deepSeek:
                return .deepSeek
            case .n8n:
                return .n8n
            case .custom:
                return .custom
            }
        }()
        
        let newChat = Chat(
            agentType: agentType,
            provider: provider,
            selectedModel: model,
            n8nWorkflow: workflow
        )
        
        chats.append(newChat)
        ChatPersistenceManager.shared.saveChats(chats)
    }
    
    /// Crea una nuova chat basata su una configurazione di agente personalizzata.
    func createNewChat(with agentConfiguration: AgentConfiguration) {
        let newChat = Chat(agentConfiguration: agentConfiguration)
        chats.append(newChat)
        ChatPersistenceManager.shared.saveChats(chats)
    }
    
    /// Elimina una o più chat in base ai loro indici.
    func deleteChat(at offsets: IndexSet) {
        chats.remove(atOffsets: offsets)
        ChatPersistenceManager.shared.saveChats(chats)
    }

    /// Aggiunge un nuovo messaggio a una chat esistente.
    func addMessage(to chat: Chat, message: Message) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].messages.append(message)
            ChatPersistenceManager.shared.saveChats(chats)
        }
    }

    // MARK: - Import/Export
    
    /// Esporta tutte le chat in un file e restituisce l'URL del file.
    func exportChats() -> URL? {
        return ChatPersistenceManager.shared.exportChats(chats)
    }

    /// Importa le chat da un file JSON e sovrascrive quelle correnti.
    func importChats(from url: URL) {
        if let imported = ChatPersistenceManager.shared.importChats(from: url) {
            chats = imported
            ChatPersistenceManager.shared.saveChats(chats)
        }
    }
    
    /// Restituisce l'istanza del servizio di chat per un dato tipo di agente (legacy).
    func getChatService(for agentType: AgentType) -> ChatServiceProtocol? {
        return serviceFactory.createChatService(for: agentType)
    }
    
    /// Restituisce l'istanza del servizio di chat per un dato provider (identificato da una stringa) (legacy).
    func getChatService(for provider: String) -> ChatServiceProtocol? {
        return serviceFactory.createChatService(for: provider)
    }
    
    /// Restituisce l'istanza del servizio agente per una configurazione specifica.
    func getAgentService(for configuration: AgentConfiguration) -> AgentServiceProtocol? {
        return serviceFactory.createAgentService(for: configuration)
    }
    
    /// Restituisce l'istanza del servizio agente per un tipo di agente.
    func getAgentService(for agentType: AgentType, configuration: AgentConfiguration? = nil) -> AgentServiceProtocol? {
        return serviceFactory.createAgentService(for: agentType, configuration: configuration)
    }
    
    /// Restituisce l'orchestratore degli agenti.
    func getAgentOrchestrator() -> AgentOrchestrator {
        return agentOrchestrator
    }
}

// MARK: - Chat Service Utilities
extension ChatManager {
    /// Restituisce tutti i servizi disponibili.
    func getAllServices() -> [ChatServiceProtocol] {
        let agentTypes: [AgentType] = [.openAI, .claude, .mistral, .perplexity, .grok, .n8n, .custom, .hybridMultiAgent, .agentGroup, .productTeam]
        return agentTypes.compactMap { serviceFactory.createChatService(for: $0) }
    }
    
    /// Verifica se un provider è disponibile e configurato correttamente (legacy).
    func isProviderAvailable(_ agentType: AgentType) async -> Bool {
        guard let service = serviceFactory.createChatService(for: agentType) else {
            return false
        }
        
        do {
            try await service.validateConfiguration()
            return true
        } catch {
            return false
        }
    }
    
    /// Verifica se un agente è disponibile e configurato correttamente.
    func isAgentAvailable(_ configuration: AgentConfiguration) async -> Bool {
        guard let service = serviceFactory.createAgentService(for: configuration) else {
            return false
        }
        
        do {
            try await service.validateConfiguration()
            return true
        } catch {
            return false
        }
    }
    
    /// Restituisce i modelli supportati per un tipo di agente (legacy).
    func getSupportedModels(for agentType: AgentType) -> [String] {
        guard let service = serviceFactory.createChatService(for: agentType) else {
            return []
        }
        return service.supportedModels
    }
    
    /// Restituisce i modelli supportati per una configurazione di agente.
    func getSupportedModels(for configuration: AgentConfiguration) -> [String] {
        guard let service = serviceFactory.createAgentService(for: configuration) else {
            return []
        }
        return service.supportedModels
    }
    
    // MARK: - Agent Session Management
    
    /// Crea una nuova sessione di agente singolo.
    func createSingleAgentSession(with configuration: AgentConfiguration) -> String? {
        do {
            let chatId = UUID()
            let session = try agentOrchestrator.createSession(for: configuration.id, chatId: chatId, sessionType: .single)
            return session.id.uuidString
        } catch {
            return nil
        }
    }
    
    /// Crea una nuova sessione multi-agente.
    func createMultiAgentSession(with configurations: [AgentConfiguration], taskType: TaskType = .collaboration) -> String? {
        // Per ora creiamo una sessione con il primo agente, in futuro implementeremo il multi-agente completo
        guard let firstConfig = configurations.first else { return nil }
        do {
            let chatId = UUID()
            let session = try agentOrchestrator.createSession(for: firstConfig.id, chatId: chatId, sessionType: .group)
            return session.id.uuidString
        } catch {
            return nil
        }
    }
    
    /// Invia un messaggio a una sessione di agente.
    func sendMessageToSession(_ sessionId: String, message: String, context: [ChatMessage] = []) async throws -> String {
        guard let uuid = UUID(uuidString: sessionId) else {
            throw ChatServiceError.invalidSessionId
        }
        return try await agentOrchestrator.processMessage(message, for: uuid)
    }
    
    /// Termina una sessione di agente.
    func endAgentSession(_ sessionId: String) {
        guard let uuid = UUID(uuidString: sessionId) else { return }
        agentOrchestrator.endSession(uuid)
    }
    
    /// Ottiene lo stato di una sessione di agente.
    func getSessionStatus(_ sessionId: String) -> (isActive: Bool, type: SessionType?) {
        guard let uuid = UUID(uuidString: sessionId) else {
            return (false, nil)
        }
        if let session = agentOrchestrator.getSession(for: uuid) {
            return (true, session.sessionType)
        }
        return (false, nil)
    }
}

// MARK: - Legacy Support
// ChatServiceFactory is now defined in ChatServiceFactory.swift
// This extension provides backward compatibility through ChatManager.shared
