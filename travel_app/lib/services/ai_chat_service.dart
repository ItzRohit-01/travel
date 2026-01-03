import 'dart:convert';
import 'package:http/http.dart' as http;

class AIChatService {
  // You can use OpenAI, Google Gemini, or any other AI API
  // For this example, I'll create a flexible service that can work with multiple providers
  
  final String apiKey;
  final AIProvider provider;
  
  AIChatService({
    required this.apiKey,
    this.provider = AIProvider.gemini,
  });

  // System context about the travel app
  static const String systemContext = '''
You are a helpful, friendly, and knowledgeable travel assistant for the YATRA travel application. 
Your role is to help users with all aspects of their travel planning and experience.

About YATRA App:
- It's a comprehensive travel planning application
- Users can plan trips, create itineraries, set budgets, and track their travel history
- Features include: trip planning, destination search, itinerary management, budget tracking, previous trips view
- Users can view popular destinations and regional selections
- The app helps with booking recommendations and travel organization

Your capabilities:
1. Trip Planning: Help users plan their trips with detailed suggestions for destinations, dates, activities, and budgets
2. Destination Information: Provide comprehensive information about cities, countries, attractions, culture, and local customs
3. Travel Advice: Offer practical advice on visas, vaccinations, safety, packing, weather, best times to visit
4. Activity Recommendations: Suggest activities, tours, restaurants, hotels, and experiences based on user preferences
5. Budget Planning: Help users plan their travel budget and find cost-effective options
6. Itinerary Creation: Assist in creating day-by-day itineraries with optimal time management
7. Local Insights: Share cultural tips, etiquette, language basics, and local customs
8. Problem Solving: Help troubleshoot travel issues and answer questions

Your personality:
- Friendly, enthusiastic, and encouraging about travel
- Professional and informative
- Empathetic to travel concerns and anxieties
- Proactive in offering helpful suggestions
- Use emojis appropriately to make conversations engaging (but not excessively)

Always:
- Ask clarifying questions when user requests are vague
- Provide specific, actionable advice
- Consider user's budget, time constraints, and preferences
- Mention relevant app features when appropriate
- Be conversational and natural, like a knowledgeable friend
''';

  Future<String> sendMessage(List<Map<String, String>> conversationHistory) async {
    try {
      switch (provider) {
        case AIProvider.gemini:
          return await _sendToGemini(conversationHistory);
        case AIProvider.openai:
          return await _sendToOpenAI(conversationHistory);
        case AIProvider.fallback:
          return _getFallbackResponse(conversationHistory.last['content'] ?? '');
      }
    } catch (e) {
      // If API fails, use intelligent fallback
      return _getFallbackResponse(conversationHistory.last['content'] ?? '');
    }
  }

  Future<String> _sendToGemini(List<Map<String, String>> conversationHistory) async {
    if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY') {
      return _getFallbackResponse(conversationHistory.last['content'] ?? '');
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
    );

    // Build conversation with system context
    final contents = <Map<String, dynamic>>[];
    
    // Add system context as first message
    contents.add({
      'role': 'user',
      'parts': [{'text': systemContext}]
    });
    contents.add({
      'role': 'model',
      'parts': [{'text': 'I understand. I\'m your YATRA travel assistant, ready to help with all your travel planning needs!'}]
    });

    // Add conversation history
    for (var message in conversationHistory) {
      contents.add({
        'role': message['role'] == 'user' ? 'user' : 'model',
        'parts': [{'text': message['content']}]
      });
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];
      return text ?? 'I apologize, but I couldn\'t generate a response. Please try again.';
    } else {
      return _getFallbackResponse(conversationHistory.last['content'] ?? '');
    }
  }

  Future<String> _sendToOpenAI(List<Map<String, String>> conversationHistory) async {
    if (apiKey.isEmpty || apiKey == 'YOUR_OPENAI_API_KEY') {
      return _getFallbackResponse(conversationHistory.last['content'] ?? '');
    }

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    // Build messages with system context
    final messages = <Map<String, String>>[];
    messages.add({'role': 'system', 'content': systemContext});
    messages.addAll(conversationHistory);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 1024,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['choices'][0]['message']['content'];
      return text ?? 'I apologize, but I couldn\'t generate a response. Please try again.';
    } else {
      return _getFallbackResponse(conversationHistory.last['content'] ?? '');
    }
  }

  String _getFallbackResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // Enhanced intelligent fallback responses with context awareness
    
    // Destination and planning
    if (lowerMessage.contains(RegExp(r'\b(where|destination|place|city|country|recommend|suggest)\b'))) {
      return _getDestinationResponse(lowerMessage);
    }

    // Trip planning
    if (lowerMessage.contains(RegExp(r'\b(plan|trip|itinerary|schedule|organize)\b'))) {
      return _getTripPlanningResponse(lowerMessage);
    }

    // Budget
    if (lowerMessage.contains(RegExp(r'\b(budget|cost|price|expensive|cheap|afford|money)\b'))) {
      return _getBudgetResponse(lowerMessage);
    }

    // Activities
    if (lowerMessage.contains(RegExp(r'\b(do|activity|activities|things to do|see|visit|tour)\b'))) {
      return _getActivityResponse(lowerMessage);
    }

    // Food
    if (lowerMessage.contains(RegExp(r'\b(food|eat|restaurant|cuisine|dining|meal)\b'))) {
      return _getFoodResponse(lowerMessage);
    }

    // Accommodation
    if (lowerMessage.contains(RegExp(r'\b(hotel|accommodation|stay|hostel|airbnb|resort)\b'))) {
      return _getAccommodationResponse(lowerMessage);
    }

    // Transportation
    if (lowerMessage.contains(RegExp(r'\b(transport|flight|train|bus|car|taxi|uber)\b'))) {
      return _getTransportResponse(lowerMessage);
    }

    // Documents
    if (lowerMessage.contains(RegExp(r'\b(visa|passport|document|permit|vaccination)\b'))) {
      return _getDocumentResponse(lowerMessage);
    }

    // Safety
    if (lowerMessage.contains(RegExp(r'\b(safe|safety|security|danger|risk)\b'))) {
      return _getSafetyResponse(lowerMessage);
    }

    // Weather
    if (lowerMessage.contains(RegExp(r'\b(weather|climate|season|temperature|rain)\b'))) {
      return _getWeatherResponse(lowerMessage);
    }

    // Packing
    if (lowerMessage.contains(RegExp(r'\b(pack|packing|luggage|bag|carry|bring)\b'))) {
      return _getPackingResponse(lowerMessage);
    }

    // App features
    if (lowerMessage.contains(RegExp(r'\b(app|feature|how to|use|help with app)\b'))) {
      return _getAppFeatureResponse(lowerMessage);
    }

    // Greetings
    if (lowerMessage.contains(RegExp(r'\b(hi|hello|hey|good morning|good evening)\b'))) {
      return "Hello! 👋 I'm your YATRA travel assistant. I can help you with:\n\n🗺️ Planning your perfect trip\n✈️ Finding the best destinations\n💰 Budget optimization\n🎯 Activity recommendations\n🏨 Accommodation advice\n🍽️ Local food experiences\n📋 Creating detailed itineraries\n\nWhat would you like to explore today?";
    }

    // Thanks
    if (lowerMessage.contains(RegExp(r'\b(thank|thanks|appreciate)\b'))) {
      return "You're very welcome! 😊 I'm here whenever you need help planning your adventures. Safe travels, and don't hesitate to ask anything else!";
    }

    // Goodbye
    if (lowerMessage.contains(RegExp(r'\b(bye|goodbye|see you|later)\b'))) {
      return "Goodbye! ✈️ Safe travels and wonderful adventures ahead! Feel free to return anytime you need travel assistance. Bon voyage! 🌍";
    }

    // Default comprehensive response
    return "I'm your YATRA travel assistant! 🌍 I can help you with:\n\n" +
        "✈️ **Trip Planning**: Destinations, dates, itineraries\n" +
        "💰 **Budget**: Cost estimates and money-saving tips\n" +
        "🎯 **Activities**: Things to do, tours, experiences\n" +
        "🏨 **Accommodation**: Hotels, hostels, unique stays\n" +
        "🍽️ **Food**: Local cuisine and restaurant recommendations\n" +
        "🚗 **Transport**: Flights, trains, local transportation\n" +
        "📄 **Documents**: Visas, passports, travel permits\n" +
        "☀️ **Weather**: Best times to visit, climate info\n" +
        "🎒 **Packing**: What to bring for your trip\n" +
        "🛡️ **Safety**: Travel safety and health advice\n\n" +
        "What aspect of your travel would you like to discuss?";
  }

  String _getDestinationResponse(String message) {
    if (message.contains(RegExp(r'\b(beach|island|sea|ocean)\b', caseSensitive: false))) {
      return "🏖️ **Amazing Beach Destinations:**\n\n" +
          "**1. Maldives** - Crystal clear waters, luxury resorts, perfect for honeymoons\n" +
          "**2. Bali, Indonesia** - Beautiful beaches, temples, great food, affordable\n" +
          "**3. Santorini, Greece** - Stunning sunsets, white-washed buildings, romantic\n" +
          "**4. Phuket, Thailand** - Vibrant nightlife, water sports, diverse beaches\n" +
          "**5. Seychelles** - Pristine beaches, unique wildlife, luxury escapes\n\n" +
          "💡 **Tip**: Use the YATRA app to search for specific destinations and compare prices!\n\n" +
          "What's your budget and travel style? I can give more personalized recommendations!";
    }

    if (message.contains(RegExp(r'\b(mountain|hiking|trek|adventure)\b', caseSensitive: false))) {
      return "⛰️ **Top Mountain & Adventure Destinations:**\n\n" +
          "**1. Nepal** - Everest Base Camp, Annapurna Circuit, spiritual experiences\n" +
          "**2. Switzerland** - Swiss Alps, pristine landscapes, excellent infrastructure\n" +
          "**3. Patagonia, Chile/Argentina** - Dramatic landscapes, world-class trekking\n" +
          "**4. New Zealand** - Diverse terrain, adventure capital, stunning scenery\n" +
          "**5. Peru** - Machu Picchu, Inca Trail, unique culture\n\n" +
          "🎯 **Consider**: Fitness level, acclimatization needs, best seasons\n\n" +
          "Would you like help planning a specific trek or mountain adventure?";
    }

    // General destination response
    return "🌍 **Popular Destinations by Region:**\n\n" +
        "**Europe**: Paris, Rome, Barcelona, Amsterdam, Prague\n" +
        "**Asia**: Tokyo, Bali, Bangkok, Singapore, Seoul\n" +
        "**Americas**: New York, San Francisco, Rio, Buenos Aires\n" +
        "**Africa**: Cape Town, Marrakech, Serengeti, Victoria Falls\n" +
        "**Oceania**: Sydney, Auckland, Fiji, Great Barrier Reef\n\n" +
        "Check the **Top Regional Selections** on your dashboard for trending destinations!\n\n" +
        "Tell me about:\n• Your travel style (adventure, culture, relaxation)\n• Budget range\n• Duration\n• Interests\n\n" +
        "I'll suggest the perfect destination for you!";
  }

  String _getTripPlanningResponse(String message) {
    return "📋 **Complete Trip Planning Guide:**\n\n" +
        "**Step 1: Define Your Trip** 🎯\n" +
        "• Destination selection\n" +
        "• Travel dates and duration\n" +
        "• Budget estimation\n" +
        "• Travel companions\n\n" +
        "**Step 2: Use YATRA Features** 📱\n" +
        "• Click 'Plan a trip' on dashboard\n" +
        "• Enter destination and dates\n" +
        "• Set your budget\n" +
        "• Create day-by-day itinerary\n\n" +
        "**Step 3: Book & Organize** ✈️\n" +
        "• Flights and accommodation\n" +
        "• Activities and tours\n" +
        "• Restaurant reservations\n" +
        "• Local transportation\n\n" +
        "**Step 4: Prepare** 🎒\n" +
        "• Visa/documents\n" +
        "• Travel insurance\n" +
        "• Packing checklist\n" +
        "• Emergency contacts\n\n" +
        "Would you like detailed help with any specific step?";
  }

  String _getBudgetResponse(String message) {
    return "💰 **Smart Travel Budgeting:**\n\n" +
        "**Budget Categories:**\n" +
        "• Accommodation: 30-40%\n" +
        "• Food: 20-25%\n" +
        "• Transportation: 15-20%\n" +
        "• Activities: 15-20%\n" +
        "• Miscellaneous: 10-15%\n\n" +
        "**Money-Saving Tips:**\n" +
        "✅ Book 2-3 months in advance\n" +
        "✅ Travel off-season\n" +
        "✅ Use public transportation\n" +
        "✅ Eat at local restaurants\n" +
        "✅ Free walking tours\n" +
        "✅ Cook occasionally (if possible)\n" +
        "✅ Look for combo deals\n\n" +
        "**Daily Budget Estimates:**\n" +
        r"Budget: $30-50/day" + "\n" +
        r"Mid-range: $80-150/day" + "\n" +
        r"Luxury: $200+/day" + "\n\n" +
        "💡 Set your budget in the YATRA trip planner to track expenses!\n\n" +
        "What's your target budget? I can suggest destinations that fit!";
  }

  String _getActivityResponse(String message) {
    return "🎯 **Amazing Travel Activities:**\n\n" +
        "**Cultural Experiences:**\n" +
        "• Museum tours\n" +
        "• Historical site visits\n" +
        "• Cooking classes\n" +
        "• Local festivals\n" +
        "• Art galleries\n\n" +
        "**Adventure Activities:**\n" +
        "• Hiking & trekking\n" +
        "• Water sports\n" +
        "• Zip-lining\n" +
        "• Rock climbing\n" +
        "• Paragliding\n\n" +
        "**Relaxation:**\n" +
        "• Beach time\n" +
        "• Spa treatments\n" +
        "• Yoga retreats\n" +
        "• Scenic cruises\n\n" +
        "**Unique Experiences:**\n" +
        "• Hot air balloon rides\n" +
        "• Wildlife safaris\n" +
        "• Food tours\n" +
        "• Night markets\n" +
        "• Cultural performances\n\n" +
        "📝 Add activities to your itinerary in the YATRA trip planner!\n\n" +
        "What type of activities interest you most?";
  }

  String _getFoodResponse(String message) {
    return "🍽️ **Food & Dining Guide:**\n\n" +
        "**Finding Great Food:**\n" +
        "✅ Ask locals for recommendations\n" +
        "✅ Look for crowded local spots\n" +
        "✅ Try street food (from busy stalls)\n" +
        "✅ Use food apps (TripAdvisor, Yelp)\n" +
        "✅ Join food tours\n\n" +
        "**Must-Try Experiences:**\n" +
        "• Local street food\n" +
        "• Traditional markets\n" +
        "• Cooking classes\n" +
        "• Food festivals\n" +
        "• Farm-to-table restaurants\n\n" +
        "**Dietary Considerations:**\n" +
        "• Learn key phrases in local language\n" +
        "• Research cuisine beforehand\n" +
        "• Carry translation cards\n" +
        "• Check restaurant menus online\n\n" +
        "**Budget Tips:**\n" +
        "💰 Breakfast: Hotel/local cafe\n" +
        "💰 Lunch: Street food/casual spots\n" +
        "💰 Dinner: Mix of nice restaurants & budget options\n\n" +
        "Which destination's cuisine interests you?";
  }

  String _getAccommodationResponse(String message) {
    return "🏨 **Accommodation Guide:**\n\n" +
        "**Types of Stays:**\n" +
        "• **Hotels**: Full service, reliable, various price ranges\n" +
        "• **Hostels**: Budget-friendly, social, shared/private rooms\n" +
        "• **Airbnb**: Local experience, apartments, unique stays\n" +
        "• **Resorts**: All-inclusive, luxury, comprehensive amenities\n" +
        "• **Guesthouses**: Personal touch, local hosts, affordable\n\n" +
        "**Booking Tips:**\n" +
        "✅ Book 2-3 months ahead for best rates\n" +
        "✅ Read recent reviews\n" +
        "✅ Check location carefully\n" +
        "✅ Understand cancellation policies\n" +
        "✅ Compare prices across platforms\n" +
        "✅ Consider proximity to attractions\n\n" +
        "**What to Consider:**\n" +
        "• Location vs. price trade-off\n" +
        "• Transportation access\n" +
        "• Safety of neighborhood\n" +
        "• Amenities needed (WiFi, breakfast, etc.)\n" +
        "• Reviews from recent travelers\n\n" +
        "What's your accommodation preference and budget?";
  }

  String _getTransportResponse(String message) {
    return "🚗 **Transportation Guide:**\n\n" +
        "**Getting There:**\n" +
        "✈️ **Flights**:\n" +
        "• Book 6-8 weeks in advance\n" +
        "• Use flight comparison sites\n" +
        "• Consider nearby airports\n" +
        "• Flexible dates = better prices\n\n" +
        "**Local Transportation:**\n" +
        "🚇 **Public Transit**: Metro, buses, trains\n" +
        "  • Most economical\n" +
        "  • Get day/week passes\n" +
        "  • Download local transit apps\n\n" +
        "🚕 **Ride-sharing**: Uber, Grab, local apps\n" +
        "  • Convenient\n" +
        "  • Know local alternatives\n\n" +
        "🚗 **Car Rental**:\n" +
        "  • Freedom and flexibility\n" +
        "  • Check international license needs\n" +
        "  • Insurance important\n\n" +
        "🚲 **Bikes/Scooters**:\n" +
        "  • Great for short distances\n" +
        "  • Eco-friendly\n" +
        "  • Check local laws\n\n" +
        "**Pro Tips:**\n" +
        "• Download offline maps\n" +
        "• Learn basic phrases\n" +
        "• Keep small change handy\n" +
        "• Screenshot important addresses\n\n" +
        "Which city are you traveling to?";
  }

  String _getDocumentResponse(String message) {
    return "📄 **Travel Documents Checklist:**\n\n" +
        "**Essential Documents:**\n" +
        "✅ **Passport**\n" +
        "  • Valid for 6+ months beyond travel\n" +
        "  • Blank pages for stamps\n" +
        "  • Make 2 copies\n\n" +
        "✅ **Visa**\n" +
        "  • Check requirements early\n" +
        "  • Processing can take weeks\n" +
        "  • Some countries offer e-visa\n" +
        "  • Know validity period\n\n" +
        "✅ **Vaccinations**\n" +
        "  • Yellow fever (Africa/S.America)\n" +
        "  • COVID-19 (check current rules)\n" +
        "  • Routine vaccines up to date\n" +
        "  • Get certificate if required\n\n" +
        "✅ **Travel Insurance**\n" +
        "  • Medical coverage\n" +
        "  • Trip cancellation\n" +
        "  • Lost baggage\n" +
        "  • Emergency evacuation\n\n" +
        "✅ **Other Documents**\n" +
        "  • Flight tickets\n" +
        "  • Hotel confirmations\n" +
        "  • Driver's license (international if needed)\n" +
        "  • Credit/debit cards\n" +
        "  • Emergency contacts\n\n" +
        "**Digital Backups:**\n" +
        "📱 Email scanned copies to yourself\n" +
        "☁️ Store in cloud storage\n" +
        "📸 Photos on your phone\n\n" +
        "Where are you planning to travel?";
  }

  String _getSafetyResponse(String message) {
    return "🛡️ **Travel Safety Guide:**\n\n" +
        "**Before You Go:**\n" +
        "• Research destination safety\n" +
        "• Register with your embassy\n" +
        "• Get travel insurance\n" +
        "• Share itinerary with family\n" +
        "• Check travel advisories\n\n" +
        "**During Your Trip:**\n" +
        "✅ Stay aware of surroundings\n" +
        "✅ Keep valuables secure\n" +
        "✅ Use hotel safe for passports\n" +
        "✅ Avoid isolated areas at night\n" +
        "✅ Trust your instincts\n" +
        "✅ Keep emergency numbers handy\n\n" +
        "**Money Safety:**\n" +
        "💳 Use ATMs in secure locations\n" +
        "💰 Carry minimal cash\n" +
        "🏦 Notify bank of travel plans\n" +
        "📱 Have backup payment methods\n\n" +
        "**Health Safety:**\n" +
        "💊 Bring necessary medications\n" +
        "🏥 Know where hospitals are\n" +
        "💧 Drink bottled water if advised\n" +
        "🍽️ Be cautious with street food initially\n\n" +
        "**Emergency Contacts:**\n" +
        "• Local emergency number (911, 112, etc.)\n" +
        "• Embassy/consulate number\n" +
        "• Hotel contact\n" +
        "• Travel insurance hotline\n\n" +
        "**Scam Awareness:**\n" +
        "⚠️ Too-good-to-be-true offers\n" +
        "⚠️ Unsolicited help\n" +
        "⚠️ Unofficial taxis\n" +
        "⚠️ Distraction tactics\n\n" +
        "Stay safe and enjoy your travels! 🌍";
  }

  String _getWeatherResponse(String message) {
    return "☀️ **Weather & Climate Guide:**\n\n" +
        "**Planning by Season:**\n\n" +
        "**Europe:**\n" +
        "• Summer (Jun-Aug): Warm, peak season, crowded\n" +
        "• Fall (Sep-Nov): Pleasant, fewer tourists\n" +
        "• Winter (Dec-Feb): Cold, festive, skiing\n" +
        "• Spring (Mar-May): Blooming, moderate weather\n\n" +
        "**Southeast Asia:**\n" +
        "• Dry season (Nov-Apr): Best time, sunny\n" +
        "• Wet season (May-Oct): Rain, humid, fewer crowds\n\n" +
        "**Caribbean:**\n" +
        "• Dry (Dec-Apr): Perfect beach weather\n" +
        "• Hurricane season (Jun-Nov): Avoid Aug-Oct\n\n" +
        "**South America:**\n" +
        "• Varies by location (north/south)\n" +
        "• Check specific region\n\n" +
        "**Weather Prep Tips:**\n" +
        "📱 Download weather apps\n" +
        "🎒 Pack for layers\n" +
        "☂️ Always bring rain gear\n" +
        "👟 Appropriate footwear\n" +
        "🧴 Sun protection\n\n" +
        "**Best Times:**\n" +
        "💡 Shoulder seasons = less crowds + good weather + lower prices\n\n" +
        "Which destination's weather would you like to know about?";
  }

  String _getPackingResponse(String message) {
    return "🎒 **Smart Packing Guide:**\n\n" +
        "**Essential Items:**\n" +
        "✅ **Documents**\n" +
        "  • Passport & copies\n" +
        "  • Visa documents\n" +
        "  • Travel insurance info\n" +
        "  • Tickets & confirmations\n\n" +
        "✅ **Electronics**\n" +
        "  • Phone & charger\n" +
        "  • Power bank\n" +
        "  • Travel adapter\n" +
        "  • Camera (optional)\n" +
        "  • Headphones\n\n" +
        "✅ **Clothing** (adjust for weather)\n" +
        "  • Underwear & socks (7-10 pairs)\n" +
        "  • Shirts/tops (5-7)\n" +
        "  • Pants/shorts (3-4)\n" +
        "  • Light jacket\n" +
        "  • Comfortable walking shoes\n" +
        "  • Sandals/flip-flops\n" +
        "  • Sleepwear\n\n" +
        "✅ **Toiletries**\n" +
        "  • Travel-size essentials\n" +
        "  • Medications\n" +
        "  • First aid kit\n" +
        "  • Sunscreen\n" +
        "  • Hand sanitizer\n\n" +
        "✅ **Other Essentials**\n" +
        "  • Reusable water bottle\n" +
        "  • Day backpack\n" +
        "  • Ziplock bags\n" +
        "  • Travel lock\n" +
        "  • Snacks for journey\n\n" +
        "**Packing Tips:**\n" +
        "📦 Roll clothes to save space\n" +
        "🎨 Stick to color scheme\n" +
        "⚖️ Wear heaviest items on plane\n" +
        "📱 Check airline baggage rules\n" +
        "🧴 Liquids in carry-on: 100ml max\n\n" +
        "**Pro Tip:** Make a checklist in your YATRA trip notes!\n\n" +
        "What type of trip are you packing for?";
  }

  String _getAppFeatureResponse(String message) {
    return "📱 **YATRA App Features Guide:**\n\n" +
        "**Dashboard (Home) 🏠**\n" +
        "• View all your trips\n" +
        "• Access quick search\n" +
        "• See previous trips\n" +
        "• Browse top destinations\n" +
        "• Banner promotions\n\n" +
        "**Plan a Trip ✈️**\n" +
        "• Create new trips\n" +
        "• Set destination & dates\n" +
        "• Define budget\n" +
        "• Add trip details\n\n" +
        "**Search 🔍**\n" +
        "• Find destinations\n" +
        "• Explore places\n" +
        "• Filter results\n" +
        "• Save favorites\n\n" +
        "**My Trips 📋**\n" +
        "• View all trips\n" +
        "• Manage itineraries\n" +
        "• Edit trip details\n" +
        "• Track expenses\n\n" +
        "**Itinerary Management 📅**\n" +
        "• Day-by-day planning\n" +
        "• Add activities\n" +
        "• Set timings\n" +
        "• Add notes\n\n" +
        "**Profile 👤**\n" +
        "• Manage account\n" +
        "• View trip history\n" +
        "• Update preferences\n" +
        "• Settings\n\n" +
        "**Smart Features:**\n" +
        "• Group trips by category\n" +
        "• Filter destinations\n" +
        "• Sort by preferences\n" +
        "• Regional recommendations\n\n" +
        "Need help with any specific feature?";
  }
}

enum AIProvider {
  gemini,
  openai,
  fallback, // Uses intelligent pattern matching without API
}
