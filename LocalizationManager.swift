import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()

    
    private init() {
        // Define o idioma do sistema como padrão, apenas na primeira vez
        if UserDefaults.standard.string(forKey: "SelectedLanguage") == nil {
            if let systemLang = Locale.current.languageCode {
                UserDefaults.standard.set(systemLang, forKey: "SelectedLanguage")
            } else {
                UserDefaults.standard.set("en", forKey: "SelectedLanguage")
            }
        }
    }
    
    var selectedLanguage: String {
        get {
            UserDefaults.standard.string(forKey: "SelectedLanguage") ?? Locale.current.languageCode ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SelectedLanguage")
        }
    }

    func localizedString(forKey key: String) -> String {
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }

        return NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
    }
}
