//
//  GlobalDefinitions.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

// TODO
final class GlobalDefinitions {
    static let domain = "https://bank.apps-by-konstantin.com"
    static let apiKey = "pkEduxeRFDCrpNqr"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "zQXiEyvoC13Tws4c"
    
    static let applicationTag = "EXAMS_VTNE"
    static let amplitudeApiKey = "8b5138249711d65974423b54fed13562"
    
    static let termsOfServiceUrl = URL(string: "https://apps-by-konstantin.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://apps-by-konstantin.com/policy")!
    static let contactUsUrl = URL(string: "https://apps-by-konstantin.com/contact")!
    
    enum Paygate {
        static let lifetime = "prep.exams.vtne.lifetime"
        static let subscription = "prep.exams.vtne.monthly"
    }
}
