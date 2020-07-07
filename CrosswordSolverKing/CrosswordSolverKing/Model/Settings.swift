//
//  Settings.swift
//  CrosswordSolverKing
//
//  Created by Mark Bailey on 07/07/2020.
//  Copyright © 2020 Mark Bailey. All rights reserved.
//

import Foundation
import SwiftUtils

class Settings
{
    private let definitionKey = "definition"
    private let highlightKey = "highlight"
    private let showKeyboardKey = "showKeyboard"
    private let longPressEnabledKey = "longPressEnabled"
    private let useMonospacedFontKey = "useMonospacedFont"
    private let wordListKey = "wordList"
    private let showSubAnagramsKey = "showSubAnagrams"
    private let resultsLimitKey = "resultsLimit"
    private let isProKey = "isProFlag"
    private let useNonPersonalizedAdsKey = "useNonPersonalisedAds"
    private let showEUConsentDialogKey = "showEUConsentDialog"
    
    private let defaultWordList = "words"
    
    let darkGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
    
    var highlight : UIColor {
        get {
            if let colorString = UserDefaults.standard.string(forKey: highlightKey){
                switch colorString {
                case "black":
                    return UIColor.black
                case "blue":
                    return UIColor.blue
                case "green":
                    return self.darkGreen
                default:
                    break
                }
            }
            return UIColor.red
        }
    }

    var useMonospacedFont : Bool {
        get {
            return UserDefaults.standard.bool(forKey: useMonospacedFontKey)
        }
    }
    
    var showKeyboard : Bool {
        get {
            return UserDefaults.standard.bool(forKey: showKeyboardKey)
        }
    }
    
    var isLongPressEnabled : Bool {
        get {
            return UserDefaults.standard.bool(forKey: longPressEnabledKey)
        }
    }
    
    var isProMode : Bool{
        get{
            return UserDefaults.standard.bool(forKey: isProKey)
        }
        set(flag) {
            let defaults = UserDefaults.standard
            defaults.set(flag, forKey: isProKey)
            defaults.synchronize()
        }
    }
    
    func getDefinitionUrl(word : String) -> String {
        if let website = UserDefaults.standard.string(forKey: definitionKey) {
            switch website {
                case "cambridge":
                    return WordSearch.getCambridgeUrl(word: word)
                case "chambers":
                    return WordSearch.getChambersUrl(word: word)
                case "collins":
                    return WordSearch.getCollinsUrl(word: word)
                case "dictionary.com":
                    return WordSearch.getDictionaryComUrl(word: word)
                case "google define":
                    return WordSearch.getGoogleDefineUrl(word: word)
                case "google":
                    return WordSearch.getGoogleUrl(word: word)
                case "lexico":
                    return WordSearch.getLexicoUrl(word: word)
                case "merriam-webster":
                    return WordSearch.getMerriamWebsterUrl(word: word)
                case "merriam-webster thesaurus":
                    return WordSearch.getMWThesaurusUrl(word: word)
                case "thesaurus.com":
                    return WordSearch.getThesaurusComUrl(word: word)
                case "wiktionary":
                    return WordSearch.getWiktionaryUrl(word: word)
                case "wikipedia":
                    return WordSearch.getWikipediaUrl(word: word)
                case "word game dictionary":
                    return WordSearch.getWordGameDictionaryUrl(word: word)
            default:
                break
            }
        }
        return WordSearch.getGoogleUrl(word: word)
    }
    
    var resultsLimit : Int {
        get {
            return UserDefaults.standard.integer(forKey: resultsLimitKey)
        }
    }
    
    var wordList : String {
        get { return UserDefaults.standard.string(forKey: wordListKey) ?? defaultWordList}
    }
    
    var showSubAnagrams : Bool {
        get {
            return UserDefaults.standard.bool(forKey: showSubAnagramsKey)
        }
    }
    
    var useNonPersonalizedAds : Bool {
        get{
            return UserDefaults.standard.bool(forKey: useNonPersonalizedAdsKey)
        }
        set(flag) {
            if flag != useNonPersonalizedAds {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: useNonPersonalizedAdsKey)
                defaults.synchronize()
            }
        }
    }
    
    var showEUConsentDialog : Bool {
        get{
            return UserDefaults.standard.bool(forKey: showEUConsentDialogKey)
        }
        set(flag) {
            if flag != showEUConsentDialog {
                let defaults = UserDefaults.standard
                defaults.set(flag, forKey: showEUConsentDialogKey)
                defaults.synchronize()
            }
        }
    }

    func registerDefaultSettings() {
        let defaultSettings : [ String : Any] = [definitionKey : "google define",
                               highlightKey : "red",
                               showKeyboardKey : false,
                               longPressEnabledKey : true,
                               wordListKey : defaultWordList,
                               isProKey : false,
                               showSubAnagramsKey : true,
                               resultsLimitKey : 5000,
                               showEUConsentDialogKey : true,
                               useNonPersonalizedAdsKey : false]
        UserDefaults.standard.register(defaults: defaultSettings)
    }
}
