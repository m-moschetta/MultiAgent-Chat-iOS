# AgentChat iOS

Un'applicazione iOS per chat con assistenti AI multipli, sviluppata in SwiftUI.

## 🚀 Caratteristiche

- **Provider AI Multipli**: Supporta OpenAI, Anthropic, Mistral, Perplexity, Grok, n8n e provider personalizzati
- **Gestione Sicura delle API Key**: Utilizza il Keychain di iOS per memorizzare le chiavi API
- **Interfaccia Moderna**: Sviluppata con SwiftUI per iOS
- **Configurazione Flessibile**: Possibilità di aggiungere provider personalizzati
- **Gestione Chat**: Creazione, visualizzazione e gestione di multiple conversazioni
- **Multi-Agent System**: Supporto per agenti specializzati e chat di gruppo

## 📱 Piattaforme Supportate

- **iOS 17.0+** (iPhone e iPad)
- Ottimizzato per dispositivi mobili
- Interfaccia responsive per iPhone e iPad

## 🏗️ Struttura del Progetto

```
AgentChat/
├── Models/
│   ├── Agent.swift                 # Modelli agenti AI
│   ├── AgentConfiguration.swift    # Configurazione agenti
│   ├── AssistantProvider.swift     # Modelli provider AI
│   ├── Chat.swift                  # Modelli chat
│   └── ProviderModels.swift        # Modelli richiesta/risposta
├── Services/
│   ├── AgentManager.swift          # Gestione agenti
│   ├── ChatService.swift           # Servizio chat
│   ├── KeychainService.swift       # Gestione sicura API key
│   ├── OpenAIService.swift         # Servizio OpenAI
│   ├── AnthropicService.swift      # Servizio Anthropic
│   ├── GrokService.swift           # Servizio Grok
│   └── UniversalAssistantService.swift # Servizio unificato
├── Views/
│   ├── ChatListView.swift          # Lista chat
│   ├── ChatDetailView.swift        # Dettaglio chat
│   ├── AgentConfigurationView.swift # Configurazione agenti
│   ├── SettingsView.swift          # Impostazioni
│   └── NewChatView.swift           # Nuova chat
└── AgentChatApp.swift              # Entry point
```

## 🤖 Provider AI Supportati

1. **OpenAI**: GPT-4, GPT-3.5-turbo, GPT-4-turbo
2. **Anthropic**: Claude-3-opus, Claude-3-sonnet, Claude-3-haiku
3. **Grok**: grok-beta
4. **Mistral**: mistral-large, mistral-medium, mistral-small
5. **Perplexity**: llama-3.1-sonar-large, llama-3.1-sonar-small
6. **n8n**: Workflow personalizzati
7. **Provider Personalizzati**: Endpoint API configurabili

## ✨ Funzionalità Principali

### 🔧 Gestione Agenti
- Creazione agenti personalizzati
- Configurazione system prompt
- Gestione parametri (temperatura, max tokens)
- Attivazione/disattivazione agenti

### 💬 Chat Multi-Agent
- Chat individuali con agenti specifici
- Chat di gruppo con più agenti
- Cronologia conversazioni
- Interfaccia intuitiva iOS

### 🔐 Sicurezza
- API key memorizzate nel Keychain iOS
- Nessuna persistenza in chiaro delle credenziali
- Validazione input utente
- Gestione errori robusta

## 📋 Requisiti

- **iOS 17.0+**
- **Xcode 15.0+**
- **Swift 5.9+**
- iPhone o iPad

## 🚀 Installazione

1. Clona il repository:
```bash
git clone https://github.com/m-moschetta/MultiAgent-Chat-iOS.git
```

2. Apri `AgentChat.xcodeproj` in Xcode

3. Seleziona il tuo dispositivo iOS o simulatore

4. Compila ed esegui il progetto (⌘+R)

## ⚙️ Configurazione

1. Avvia l'applicazione su iOS
2. Vai nelle **Impostazioni** (icona ingranaggio)
3. Configura le **API key** per i provider desiderati
4. **Attiva** i provider che vuoi utilizzare
5. Crea **agenti personalizzati** o usa quelli predefiniti
6. Inizia una **nuova chat** selezionando agente e provider

## 🏗️ Architettura

- **Pattern MVVM** con SwiftUI
- **Dependency Injection** tramite ServiceContainer
- **ObservableObject** per reattività
- **Async/Await** per operazioni asincrone
- **Keychain** per sicurezza credenziali
- **Modular Design** per estensibilità

## 📝 Note di Sviluppo

Questa versione è stata ottimizzata esclusivamente per iOS, rimuovendo tutte le dipendenze macOS per garantire:
- Compilazione pulita su iOS
- Interfaccia ottimizzata per mobile
- Funzionalità specifiche iOS (condivisione, notifiche)
- Preparazione per App Store

Per dettagli sulle modifiche, vedi [CONFIGURAZIONE_IOS_ONLY.md](CONFIGURAZIONE_IOS_ONLY.md)

## 🤝 Contributi

I contributi sono benvenuti! Per favore:
1. Fai un fork del progetto
2. Crea un branch per la tua feature
3. Commit le tue modifiche
4. Push al branch
5. Apri una Pull Request

## 📄 Licenza

Questo progetto è sviluppato per scopi educativi e di ricerca.

## 🔗 Link Utili

- [Documentazione OpenAI](https://platform.openai.com/docs)
- [Documentazione Anthropic](https://docs.anthropic.com)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [iOS Development Guide](https://developer.apple.com/ios/)
