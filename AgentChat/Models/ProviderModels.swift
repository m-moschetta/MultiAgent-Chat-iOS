//
//  ProviderModels.swift
//  AgentChat
//
//  Created by Mario Moschetta on 04/07/25.
//

import Foundation

// MARK: - OpenAI Models
struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let maxTokens: Int?
    let temperature: Double?
    let stream: Bool?
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stream
        case maxTokens = "max_tokens"
    }
}

struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [OpenAIChoice]
    let usage: OpenAIUsage?
}

struct OpenAIChoice: Codable {
    let index: Int
    let message: OpenAIMessage
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct OpenAIUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Anthropic Models
struct AnthropicRequest: Codable {
    let model: String
    let messages: [AnthropicMessage]
    let maxTokens: Int
    let temperature: Double?
    let system: String?
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, system
        case maxTokens = "max_tokens"
    }
}

struct AnthropicMessage: Codable {
    let role: String
    let content: String
}

struct AnthropicResponse: Codable {
    let id: String
    let type: String
    let role: String
    let content: [AnthropicContent]
    let model: String
    let stopReason: String?
    let stopSequence: String?
    let usage: AnthropicUsage
    
    enum CodingKeys: String, CodingKey {
        case id, type, role, content, model, usage
        case stopReason = "stop_reason"
        case stopSequence = "stop_sequence"
    }
}

struct AnthropicContent: Codable {
    let type: String
    let text: String
}

struct AnthropicUsage: Codable {
    let inputTokens: Int
    let outputTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case inputTokens = "input_tokens"
        case outputTokens = "output_tokens"
    }
}

// MARK: - Mistral Models
struct MistralRequest: Codable {
    let model: String
    let messages: [MistralMessage]
    let temperature: Double?
    let maxTokens: Int?
    let topP: Double?
    let randomSeed: Int?
    let stream: Bool?
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stream
        case maxTokens = "max_tokens"
        case topP = "top_p"
        case randomSeed = "random_seed"
    }
}

struct MistralMessage: Codable {
    let role: String
    let content: String
}

struct MistralResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [MistralChoice]
    let usage: MistralUsage
}

struct MistralChoice: Codable {
    let index: Int
    let message: MistralMessage
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct MistralUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Perplexity Models
struct PerplexityRequest: Codable {
    let model: String
    let messages: [PerplexityMessage]
    let maxTokens: Int?
    let temperature: Double?
    let topP: Double?
    let topK: Int?
    let stream: Bool?
    let presencePenalty: Double?
    let frequencyPenalty: Double?
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stream
        case maxTokens = "max_tokens"
        case topP = "top_p"
        case topK = "top_k"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
    }
}

struct PerplexityMessage: Codable {
    let role: String
    let content: String
}

struct PerplexityResponse: Codable {
    let id: String
    let model: String
    let created: Int
    let usage: PerplexityUsage
    let object: String
    let choices: [PerplexityChoice]
}

struct PerplexityChoice: Codable {
    let index: Int
    let finishReason: String
    let message: PerplexityMessage
    let delta: PerplexityMessage?
    
    enum CodingKeys: String, CodingKey {
        case index, delta, message
        case finishReason = "finish_reason"
    }
}

struct PerplexityUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Grok Models
struct GrokRequest: Codable {
    let model: String
    let messages: [GrokMessage]
    let temperature: Double?
    let maxTokens: Int?
    let topP: Double?
    let stream: Bool?
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stream
        case maxTokens = "max_tokens"
        case topP = "top_p"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(messages, forKey: .messages)
        try container.encode(stream, forKey: .stream)
        
        if let temperature = temperature {
            try container.encode(temperature, forKey: .temperature)
        }
        if let maxTokens = maxTokens {
            try container.encode(maxTokens, forKey: .maxTokens)
        }
        if let topP = topP {
            try container.encode(topP, forKey: .topP)
        }
    }
}

struct GrokMessage: Codable {
    let role: String
    let content: String
}

struct GrokResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [GrokChoice]
    let usage: GrokUsage
}

struct GrokChoice: Codable {
    let index: Int
    let message: GrokMessage
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct GrokUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - N8N Models (moved to N8NWorkflow.swift)

// MARK: - Generic Response
struct GenericAIResponse {
    let content: String
    let model: String?
    let usage: TokenUsage?
    let metadata: [String: Any]?
}

// TokenUsage is defined in BaseHTTPService.swift

// MARK: - Error Models
struct AIProviderError: Codable, Error {
    let code: String
    let message: String
    let type: String?
    let param: String?
}

struct AIErrorResponse: Codable {
    let error: AIProviderError
}
