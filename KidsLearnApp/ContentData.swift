//
//  ContentData.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import Foundation

enum ContentData {
    
    static func letters(for lang: AppLanguage) -> [LetterItem] {
        switch lang {
        case .english:
            return [
                .init(symbol: "A", exampleWord: "Apple",    exampleEmoji: "🍎", audioName: "en_A"),
                .init(symbol: "B", exampleWord: "Ball",     exampleEmoji: "🏀", audioName: "en_B"),
                .init(symbol: "C", exampleWord: "Cat",      exampleEmoji: "🐱", audioName: "en_C"),
                .init(symbol: "D", exampleWord: "Dog",      exampleEmoji: "🐶", audioName: "en_D"),
                .init(symbol: "E", exampleWord: "Elephant", exampleEmoji: "🐘", audioName: "en_E"),
                .init(symbol: "F", exampleWord: "Fish",     exampleEmoji: "🐟", audioName: "en_F"),
                .init(symbol: "G", exampleWord: "Goat",     exampleEmoji: "🐐", audioName: "en_G"),
                .init(symbol: "H", exampleWord: "House",    exampleEmoji: "🏠", audioName: "en_H"),
                .init(symbol: "I", exampleWord: "Ice cream",exampleEmoji: "🍦", audioName: "en_I"),
                .init(symbol: "J", exampleWord: "Juice",    exampleEmoji: "🧃", audioName: "en_J"),
                .init(symbol: "K", exampleWord: "Kite",     exampleEmoji: "🪁", audioName: "en_K"),
                .init(symbol: "L", exampleWord: "Lion",     exampleEmoji: "🦁", audioName: "en_L"),
                .init(symbol: "M", exampleWord: "Monkey",   exampleEmoji: "🐒", audioName: "en_M"),
                .init(symbol: "N", exampleWord: "Nest",     exampleEmoji: "🪺", audioName: "en_N"),
                .init(symbol: "O", exampleWord: "Orange",   exampleEmoji: "🍊", audioName: "en_O"),
                .init(symbol: "P", exampleWord: "Parrot",   exampleEmoji: "🦜", audioName: "en_P"),
                .init(symbol: "Q", exampleWord: "Queen",    exampleEmoji: "👑", audioName: "en_Q"),
                .init(symbol: "R", exampleWord: "Rabbit",   exampleEmoji: "🐰", audioName: "en_R"),
                .init(symbol: "S", exampleWord: "Sun",      exampleEmoji: "☀️", audioName: "en_S"),
                .init(symbol: "T", exampleWord: "Tiger",    exampleEmoji: "🐯", audioName: "en_T"),
                .init(symbol: "U", exampleWord: "Umbrella", exampleEmoji: "☂️", audioName: "en_U"),
                .init(symbol: "V", exampleWord: "Van",      exampleEmoji: "🚐", audioName: "en_V"),
                .init(symbol: "W", exampleWord: "Wolf",     exampleEmoji: "🐺", audioName: "en_W"),
                .init(symbol: "X", exampleWord: "Xylophone",exampleEmoji: "🎼", audioName: "en_X"),
                .init(symbol: "Y", exampleWord: "Yak",      exampleEmoji: "🐃", audioName: "en_Y"),
                .init(symbol: "Z", exampleWord: "Zebra",    exampleEmoji: "🦓", audioName: "en_Z")
            ]
            
        case .telugu:
            return [
                // Vowels (Acchulu)
                .init(symbol: "అ", exampleWord: "అమ్మ",     exampleEmoji: "👩‍👧", audioName: "te_అ"),
                .init(symbol: "ఆ", exampleWord: "ఆవు",      exampleEmoji: "🐄", audioName: "te_ఆ"),
                .init(symbol: "ఇ", exampleWord: "ఇల్లు",    exampleEmoji: "🏠", audioName: "te_ఇ"),
                .init(symbol: "ఈ", exampleWord: "ఈగ",      exampleEmoji: "🪰", audioName: "te_ఈ"),
                .init(symbol: "ఉ", exampleWord: "ఉడుత",     exampleEmoji: "🐿️", audioName: "te_ఉ"),
                .init(symbol: "ఊ", exampleWord: "ఊయల",     exampleEmoji: "🪢", audioName: "te_ఊ"),
                .init(symbol: "ఋ", exampleWord: "ఋషి",      exampleEmoji: "🧘", audioName: "te_ఋ"),
                .init(symbol: "ౠ", exampleWord: "ౠతువు",    exampleEmoji: "📅", audioName: "te_ౠ"), // rare
                .init(symbol: "ఎ", exampleWord: "ఎలుక",     exampleEmoji: "🐭", audioName: "te_ఎ"),
                .init(symbol: "ఏ", exampleWord: "ఏనుగు",    exampleEmoji: "🐘", audioName: "te_ఏ"),
                .init(symbol: "ఐ", exampleWord: "ఐరావతం",   exampleEmoji: "🐘", audioName: "te_ఐ"),
                .init(symbol: "ఒ", exampleWord: "ఒంటె",     exampleEmoji: "🐫", audioName: "te_ఒ"),
                .init(symbol: "ఓ", exampleWord: "ఓడ",      exampleEmoji: "🚢", audioName: "te_ఓ"),
                .init(symbol: "ఔ", exampleWord: "ఔషధం",     exampleEmoji: "💊", audioName: "te_ఔ"),
                .init(symbol: "అం", exampleWord: "అంబలి",    exampleEmoji: "🥣", audioName: "te_అం"),
                .init(symbol: "అః", exampleWord: "అఃకారం",   exampleEmoji: "😤", audioName: "te_అః"),
                
                // Consonants (Hallulu)
                .init(symbol: "క", exampleWord: "కాకి",     exampleEmoji: "🐦", audioName: "te_క"),
                .init(symbol: "ఖ", exampleWord: "ఖడ్గం",    exampleEmoji: "⚔️", audioName: "te_ఖ"),
                .init(symbol: "గ", exampleWord: "గజం",      exampleEmoji: "🐘", audioName: "te_గ"),
                .init(symbol: "ఘ", exampleWord: "ఘటం",      exampleEmoji: "🏺", audioName: "te_ఘ"),
                .init(symbol: "ఙ", exampleWord: "ఙకారం",    exampleEmoji: "🔤", audioName: "te_ఙ"),
                .init(symbol: "చ", exampleWord: "చేప",      exampleEmoji: "🐟", audioName: "te_చ"),
                .init(symbol: "ఛ", exampleWord: "ఛత్రం",    exampleEmoji: "☂️", audioName: "te_ఛ"),
                .init(symbol: "జ", exampleWord: "జంతువు",    exampleEmoji: "🐾", audioName: "te_జ"),
                .init(symbol: "ఝ", exampleWord: "ఝరి",      exampleEmoji: "💧", audioName: "te_ఝ"),
                .init(symbol: "ఞ", exampleWord: "ఞకారం",    exampleEmoji: "🔤", audioName: "te_ఞ"),
                .init(symbol: "ట", exampleWord: "టమాట",     exampleEmoji: "🍅", audioName: "te_ట"),
                .init(symbol: "ఠ", exampleWord: "ఠీవి",      exampleEmoji: "👑", audioName: "te_ఠ"),
                .init(symbol: "డ", exampleWord: "డమరుకం",    exampleEmoji: "🥁", audioName: "te_డ"),
                .init(symbol: "ఢ", exampleWord: "ఢంకా",      exampleEmoji: "🥁", audioName: "te_ఢ"),
                .init(symbol: "ణ", exampleWord: "ణగణం",      exampleEmoji: "🔔", audioName: "te_ణ"),
                .init(symbol: "త", exampleWord: "తాబేలు",     exampleEmoji: "🐢", audioName: "te_త"),
                .init(symbol: "థ", exampleWord: "థాళం",       exampleEmoji: "🥘", audioName: "te_థ"),
                .init(symbol: "ద", exampleWord: "దంతం",       exampleEmoji: "🦷", audioName: "te_ద"),
                .init(symbol: "ధ", exampleWord: "ధనువు",      exampleEmoji: "🏹", audioName: "te_ధ"),
                .init(symbol: "న", exampleWord: "నక్క",       exampleEmoji: "🦊", audioName: "te_న"),
                .init(symbol: "ప", exampleWord: "పిల్లి",      exampleEmoji: "🐱", audioName: "te_ప"),
                .init(symbol: "ఫ", exampleWord: "ఫలం",        exampleEmoji: "🍎", audioName: "te_ఫ"),
                .init(symbol: "బ", exampleWord: "బాతు",       exampleEmoji: "🦆", audioName: "te_బ"),
                .init(symbol: "భ", exampleWord: "భల్లూకం",     exampleEmoji: "🐻", audioName: "te_భ"),
                .init(symbol: "మ", exampleWord: "మయూరం",      exampleEmoji: "🦚", audioName: "te_మ"),
                .init(symbol: "య", exampleWord: "యానకం",      exampleEmoji: "✈️", audioName: "te_య"),
                .init(symbol: "ర", exampleWord: "రాజు",        exampleEmoji: "👑", audioName: "te_ర"),
                .init(symbol: "ల", exampleWord: "లేడి",        exampleEmoji: "🦌", audioName: "te_ల"),
                .init(symbol: "వ", exampleWord: "వానరం",       exampleEmoji: "🐒", audioName: "te_వ"),
                .init(symbol: "శ", exampleWord: "శంఖం",        exampleEmoji: "🐚", audioName: "te_శ"),
                .init(symbol: "ష", exampleWord: "షట్కోణం",      exampleEmoji: "⬡", audioName: "te_ష"),
                .init(symbol: "స", exampleWord: "సింహం",        exampleEmoji: "🦁", audioName: "te_స"),
                .init(symbol: "హ", exampleWord: "హంస",         exampleEmoji: "🦢", audioName: "te_హ"),
                .init(symbol: "ళ", exampleWord: "ళకుమారం",      exampleEmoji: "🌟", audioName: "te_ళ"),
                .init(symbol: "క్ష", exampleWord: "క్షీరం",      exampleEmoji: "🥛", audioName: "te_క్ష"),
                .init(symbol: "ఱ", exampleWord: "ఱెక్క",        exampleEmoji: "🪶", audioName: "te_ఱ")
            ]
            
        case .hindi:
            return [
                // Vowels (Swar)
                .init(symbol: "अ", exampleWord: "अनार",   exampleEmoji: "🍎", audioName: "hi_अ"),
                .init(symbol: "आ", exampleWord: "आम",     exampleEmoji: "🥭", audioName: "hi_आ"),
                .init(symbol: "इ", exampleWord: "इमली",   exampleEmoji: "🌿", audioName: "hi_इ"),
                .init(symbol: "ई", exampleWord: "ईख",     exampleEmoji: "🎋", audioName: "hi_ई"),
                .init(symbol: "उ", exampleWord: "उल्लू",   exampleEmoji: "🦉", audioName: "hi_उ"),
                .init(symbol: "ऊ", exampleWord: "ऊंट",     exampleEmoji: "🐫", audioName: "hi_ऊ"),
                .init(symbol: "ऋ", exampleWord: "ऋषि",     exampleEmoji: "🧘", audioName: "hi_ऋ"),
                .init(symbol: "ए", exampleWord: "एक",      exampleEmoji: "1️⃣", audioName: "hi_ए"),
                .init(symbol: "ऐ", exampleWord: "ऐनक",     exampleEmoji: "👓", audioName: "hi_ऐ"),
                .init(symbol: "ओ", exampleWord: "ओखली",    exampleEmoji: "🍚", audioName: "hi_ओ"),
                .init(symbol: "औ", exampleWord: "औरत",     exampleEmoji: "👩", audioName: "hi_औ"),
                .init(symbol: "अं", exampleWord: "अंगूर",   exampleEmoji: "🍇", audioName: "hi_अं"),
                .init(symbol: "अः", exampleWord: "अःकार",   exampleEmoji: "😤", audioName: "hi_अः"),
                
                // Consonants (Vyanjan)
                .init(symbol: "क", exampleWord: "कबूतर",   exampleEmoji: "🕊️", audioName: "hi_क"),
                .init(symbol: "ख", exampleWord: "खरगोश",   exampleEmoji: "🐰", audioName: "hi_ख"),
                .init(symbol: "ग", exampleWord: "गाय",     exampleEmoji: "🐄", audioName: "hi_ग"),
                .init(symbol: "घ", exampleWord: "घड़ी",    exampleEmoji: "⌚", audioName: "hi_घ"),
                .init(symbol: "ङ", exampleWord: "ङकार",    exampleEmoji: "🔤", audioName: "hi_ङ"),
                .init(symbol: "च", exampleWord: "चम्मच",   exampleEmoji: "🥄", audioName: "hi_च"),
                .init(symbol: "छ", exampleWord: "छाता",    exampleEmoji: "☂️", audioName: "hi_छ"),
                .init(symbol: "ज", exampleWord: "जहाज",    exampleEmoji: "✈️", audioName: "hi_ज"),
                .init(symbol: "झ", exampleWord: "झंडा",    exampleEmoji: "🚩", audioName: "hi_झ"),
                .init(symbol: "ञ", exampleWord: "ञकार",    exampleEmoji: "🔤", audioName: "hi_ञ"),
                .init(symbol: "ट", exampleWord: "टमाटर",   exampleEmoji: "🍅", audioName: "hi_ट"),
                .init(symbol: "ठ", exampleWord: "ठंडाई",   exampleEmoji: "🥤", audioName: "hi_ठ"),
                .init(symbol: "ड", exampleWord: "डमरू",    exampleEmoji: "🥁", audioName: "hi_ड"),
                .init(symbol: "ढ", exampleWord: "ढोल",     exampleEmoji: "🥁", audioName: "hi_ढ"),
                .init(symbol: "ण", exampleWord: "णकार",    exampleEmoji: "🔤", audioName: "hi_ण"),
                .init(symbol: "त", exampleWord: "तोता",    exampleEmoji: "🦜", audioName: "hi_त"),
                .init(symbol: "थ", exampleWord: "थैला",    exampleEmoji: "👜", audioName: "hi_थ"),
                .init(symbol: "द", exampleWord: "दवाई",    exampleEmoji: "💊", audioName: "hi_द"),
                .init(symbol: "ध", exampleWord: "धनुष",    exampleEmoji: "🏹", audioName: "hi_ध"),
                .init(symbol: "न", exampleWord: "नल",      exampleEmoji: "🚰", audioName: "hi_न"),
                .init(symbol: "प", exampleWord: "पंखा",    exampleEmoji: "🪭", audioName: "hi_प"),
                .init(symbol: "फ", exampleWord: "फूल",     exampleEmoji: "🌸", audioName: "hi_फ"),
                .init(symbol: "ब", exampleWord: "बंदर",    exampleEmoji: "🐒", audioName: "hi_ब"),
                .init(symbol: "भ", exampleWord: "भालू",    exampleEmoji: "🐻", audioName: "hi_भ"),
                .init(symbol: "म", exampleWord: "मछली",    exampleEmoji: "🐟", audioName: "hi_म"),
                .init(symbol: "य", exampleWord: "यज्ञ",    exampleEmoji: "🔥", audioName: "hi_य"),
                .init(symbol: "र", exampleWord: "रस्सी",    exampleEmoji: "🪢", audioName: "hi_र"),
                .init(symbol: "ल", exampleWord: "लट्टू",    exampleEmoji: "🪀", audioName: "hi_ल"),
                .init(symbol: "व", exampleWord: "वाघ",      exampleEmoji: "🐯", audioName: "hi_व"),
                .init(symbol: "श", exampleWord: "शेर",      exampleEmoji: "🦁", audioName: "hi_श"),
                .init(symbol: "ष", exampleWord: "षट्कोण",   exampleEmoji: "⬡", audioName: "hi_ष"),
                .init(symbol: "स", exampleWord: "सांप",     exampleEmoji: "🐍", audioName: "hi_स"),
                .init(symbol: "ह", exampleWord: "हाथी",     exampleEmoji: "🐘", audioName: "hi_ह"),
                
                // Additional common conjuncts
                .init(symbol: "क्ष", exampleWord: "क्षत्रिय", exampleEmoji: "⚔️", audioName: "hi_क्ष"),
                .init(symbol: "त्र", exampleWord: "त्रिशूल", exampleEmoji: "🔱", audioName: "hi_त्र"),
                .init(symbol: "ज्ञ", exampleWord: "ज्ञान",   exampleEmoji: "📚", audioName: "hi_ज्ञ")
            ]
        }
    }
    
    static func numbers(for lang: AppLanguage) -> [NumberItem] {
        switch lang {
        case .english:
            return (1...20).map { n in
                let words = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
                            "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
                            "Eighteen", "Nineteen", "Twenty"]
                return .init(number: n, display: "\(n)", word: words[n-1], audioName: "en_num_\(n)")
            }
            
        case .telugu:
            let digits = ["౧", "౨", "౩", "౪", "౫", "౬", "౭", "౮", "౯", "౧౦",
                         "౧౧", "౧౨", "౧౩", "౧౪", "౧౫", "౧౬", "౧౭", "౧౮", "౧౯", "౨౦"]
            let words  = ["ఒకటి", "రెండు", "మూడు", "నాలుగు", "ఐదు", "ఆరు", "ఏడు", "ఎనిమిది",
                         "తొమ్మిది", "పది", "పదకొండు", "పన్నెండు", "పదమూడు", "పద్నాలుగు",
                         "పదిహేను", "పదహారు", "పదిహేడు", "పద్దెనిమిది", "పందొమ్మిది", "ఇరవై"]
            return (1...20).map { n in
                .init(number: n, display: digits[n-1], word: words[n-1], audioName: "te_num_\(n)")
            }
            
        case .hindi:
            let digits = ["१", "२", "३", "४", "५", "६", "७", "८", "९", "१०",
                         "११", "१२", "१३", "१४", "१५", "१६", "१७", "१८", "१९", "२०"]
            let words  = ["एक", "दो", "तीन", "चार", "पाँच", "छह", "सात", "आठ",
                         "नौ", "दस", "ग्यारह", "बारह", "तेरह", "चौदह", "पंद्रह",
                         "सोलह", "सत्रह", "अठारह", "उन्नीस", "बीस"]
            return (1...20).map { n in
                .init(number: n, display: digits[n-1], word: words[n-1], audioName: "hi_num_\(n)")
            }
        }
    }
}
