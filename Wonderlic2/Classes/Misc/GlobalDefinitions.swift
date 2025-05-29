//
//  GlobalDefinitions.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://bank5.apps-by-konstantin.com"
    static let apiKey = "Gob4SCIZNtot1mK3"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "bBe6v3QLZXvuDX2m"
    
    static let applicationTag = "EXAMS_WONDERLIC"
    static let amplitudeApiKey = "8b5138249711d65974423b54fed13562"
    
    static let termsOfServiceUrl = URL(string: "https://apps-by-konstantin.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://apps-by-konstantin.com/policy")!
    static let contactUsUrl = URL(string: "https://apps-by-konstantin.com/contact")!
    
    enum Paygate {
        static let lifetime = "prep.exams.wonderlic.lifetime"
        static let subscription = "prep.exams.wonderlic.monthly"
    }
}
