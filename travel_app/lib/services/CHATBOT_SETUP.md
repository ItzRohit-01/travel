# AI Chatbot Configuration

This chatbot can work in multiple modes:

## Mode 1: Intelligent Fallback (Default - No API Key Needed)
- Uses advanced pattern matching and contextual responses
- Fully functional without any API keys
- Great for development and testing
- Handles all common travel queries intelligently

**Configuration:**
```dart
_aiService = AIChatService(
  apiKey: '',
  provider: AIProvider.fallback,
);
```

## Mode 2: Google Gemini AI (Recommended)
- Free tier available
- Most advanced responses
- Natural conversation flow
- Remembers context throughout conversation

**Setup:**
1. Visit https://makersuite.google.com/app/apikey
2. Create a free API key
3. Update in `chatbot.dart`:
```dart
_aiService = AIChatService(
  apiKey: 'YOUR_GEMINI_API_KEY_HERE',
  provider: AIProvider.gemini,
);
```

## Mode 3: OpenAI ChatGPT
- Requires paid API key
- Excellent conversation quality
- Context-aware responses

**Setup:**
1. Visit https://platform.openai.com/api-keys
2. Create an API key (requires payment method)
3. Update in `chatbot.dart`:
```dart
_aiService = AIChatService(
  apiKey: 'YOUR_OPENAI_API_KEY_HERE',
  provider: AIProvider.openai,
);
```

## Features
- ✅ Full conversation memory (remembers entire chat history)
- ✅ Context-aware responses specific to YATRA app
- ✅ Travel domain expertise
- ✅ Intelligent fallback if API fails
- ✅ Quick suggestions
- ✅ Clear chat functionality
- ✅ Professional UI with typing indicators

## Security Note
For production apps, never hardcode API keys. Use:
- Environment variables
- Secure storage (flutter_secure_storage)
- Backend proxy to hide API keys
