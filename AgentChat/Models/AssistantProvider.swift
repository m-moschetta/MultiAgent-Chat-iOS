//
//  AssistantProvider.swift
//  AgentChat
//
//  Created by Mario Moschetta on 04/07/25.
//

import Foundation

// MARK: - Provider Type
enum ProviderType: String, Codable, CaseIterable {
    case openai = "openai"
    case anthropic = "anthropic"
    case mistral = "mistral"
    case perplexity = "perplexity"
    case grok = "grok"

    case deepSeek = "deepseek"
    case n8n = "n8n"
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .openai: return "OpenAI"
        case .anthropic: return "Anthropic"
        case .mistral: return "Mistral"
        case .perplexity: return "Perplexity"
        case .grok: return "Grok"

        case .deepSeek: return "DeepSeek"
        case .n8n: return "n8n"
        case .custom: return "Custom"
        }
    }
}

// MARK: - Assistant Provider
struct AssistantProvider: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let type: ProviderType
    let endpoint: String
    let apiKeyRequired: Bool
    let supportedModels: [String]
    let defaultModel: String?
    let icon: String
    let description: String
    let isActive: Bool
    
    init(id: String = UUID().uuidString, name: String, type: ProviderType, endpoint: String, apiKeyRequired: Bool = true, supportedModels: [String], defaultModel: String? = nil, icon: String, description: String, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.type = type
        self.endpoint = endpoint
        self.apiKeyRequired = apiKeyRequired
        self.supportedModels = supportedModels
        self.defaultModel = defaultModel ?? supportedModels.first
        self.icon = icon
        self.description = description
        self.isActive = isActive
    }
    
    static func == (lhs: AssistantProvider, rhs: AssistantProvider) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Helper Methods
extension AssistantProvider {
    static func fromString(_ providerName: String) -> AssistantProvider? {
        return defaultProviders.first { provider in
            provider.name.lowercased() == providerName.lowercased() ||
            provider.type.displayName.lowercased() == providerName.lowercased()
        }
    }
}

// MARK: - Default Providers
extension AssistantProvider {
    static let defaultProviders: [AssistantProvider] = [
        AssistantProvider(
            name: "OpenAI",
            type: .openai,
            endpoint: "https://api.openai.com/v1/chat/completions",
            supportedModels: ["o3", "o4-mini", "gpt-4.1", "gpt-4.1-mini", "gpt-4.1-nano", "gpt-4o", "gpt-4o-mini", "o1", "o1-mini"],
            defaultModel: "o3",
            icon: "brain.head.profile",
            description: "OpenAI's latest models including o3 reasoning and GPT-4.1 series (2025)"
        ),
        AssistantProvider(
            name: "Anthropic",
            type: .anthropic,
            endpoint: "https://api.anthropic.com/v1/messages",
            supportedModels: ["claude-opus-4-20250514", "claude-sonnet-4-20250514", "claude-3-7-sonnet-20250219", "claude-3-5-sonnet-20241022", "claude-3-5-haiku-20241022", "claude-3-opus-20240229", "claude-3-haiku-20240307"],
            defaultModel: "claude-3-5-sonnet-20241022",
            icon: "sparkles",
            description: "Anthropic's Claude models for thoughtful and helpful conversations"
        ),
        AssistantProvider(
            name: "Mistral",
            type: .mistral,
            endpoint: "https://api.mistral.ai/v1/chat/completions",
            supportedModels: ["mistral-medium-2505", "magistral-medium-2506", "codestral-2501", "devstral-medium-2507", "mistral-large-2411", "pixtral-large-2411", "ministral-8b-2410", "ministral-3b-2410", "magistral-small-2506", "mistral-small-2506", "devstral-small-2507", "mistral-nemo-2407", "pixtral-12b-2409", "mistral-embed", "mistral-moderation-2411", "mistral-ocr-2505"],
            defaultModel: "mistral-medium-2505",
            icon: "wind",
            description: "Mistral's efficient and powerful language models with latest 2025 updates"
        ),
        AssistantProvider(
            name: "Perplexity",
            type: .perplexity,
            endpoint: "https://api.perplexity.ai/chat/completions",
            supportedModels: ["sonar-reasoning-pro", "sonar-reasoning", "sonar-pro", "sonar", "sonar-deep-research", "r1-1776", "llama-3.1-sonar-large-128k-online", "llama-3.1-sonar-small-128k-online", "llama-3.1-sonar-large-128k-chat", "llama-3.1-sonar-small-128k-chat", "llama-3.1-8b-instruct", "llama-3.1-70b-instruct"],
            defaultModel: "sonar-pro",
            icon: "magnifyingglass.circle",
            description: "Perplexity's latest search-enhanced AI models with reasoning and deep research (2025)"
        ),
        AssistantProvider(
            name: "Grok",
            type: .grok,
            endpoint: "https://api.x.ai/v1/chat/completions",
            supportedModels: ["grok-3", "grok-2-1212", "grok-2-vision-1212", "grok-2-public", "grok-beta", "grok-vision-beta"],
            defaultModel: "grok-2-1212",
            icon: "bolt.circle",
            description: "xAI's Grok models with reasoning capabilities and real-time information"
        ),

        AssistantProvider(
            name: "DeepSeek",
            type: .deepSeek,
            endpoint: "https://api.deepseek.com/v1/chat/completions",
            supportedModels: ["deepseek-v3-0324", "deepseek-r1-0528", "deepseek-r1-lite-preview", "deepseek-r1-distill-llama-70b", "deepseek-r1-distill-qwen-32b", "deepseek-r1-distill-qwen-14b", "deepseek-r1-distill-qwen-7b", "deepseek-r1-distill-qwen-1.5b", "deepseek-coder-v2-instruct", "deepseek-coder-v2-lite-instruct", "deepseek-math-7b-instruct"],
            defaultModel: "deepseek-v3-0324",
            icon: "brain.filled.head.profile",
            description: "DeepSeek's open-source models with advanced reasoning, coding, and mathematics capabilities"
        ),
        AssistantProvider(
            name: "n8n Blog Creator",
            type: .n8n,
            endpoint: "https://your-n8n-instance.com/webhook/blog-creation",
            apiKeyRequired: false,
            supportedModels: ["blog-workflow"],
            defaultModel: "blog-workflow",
            icon: "doc.text",
            description: "Automated blog creation and publishing workflow via n8n"
        )
    ]
}
