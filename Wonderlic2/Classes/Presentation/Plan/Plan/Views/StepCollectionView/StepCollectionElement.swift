//
//  StepCollectionElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 04.05.2022.
//

enum StepCollectionElement {
    case tests(StepCollectionTestsElement)
    case final(StepCollectionFinalElement)
}

struct StepCollectionTestsElement {
    let step: PlanStep
    let locked: Bool
}

struct StepCollectionFinalElement {
    let finalStep: PlanFinalStep
    let locked: Bool
}

// MARK: Public
extension StepCollectionElement {
    static func from(steps: [PlanStep], finalStep: PlanFinalStep) -> [StepCollectionElement] {
        guard !steps.isEmpty else {
            return []
        }
        
        var result = [StepCollectionElement]()
        
        var lastStepProgress: Int = 100
        
        steps.enumerated().forEach { index, step in
            let locked = lastStepProgress < 100
            let test = StepCollectionTestsElement(step: step, locked: locked)
            result.append(.tests(test))
            
            lastStepProgress = step.progress
        }
        
        let finalStepLocked = steps.contains(where: { $0.progress < 100 })
        
        let final = StepCollectionFinalElement(finalStep: finalStep,
                                               locked: finalStepLocked)
        result.append(.final(final))
        
        return result
    }
    
    static func currentIndex(in elements: [StepCollectionElement]) -> Int? {
        guard !elements.isEmpty else {
            return nil
        }
        
        let index = elements.firstIndex(where: { element -> Bool in
            switch element {
            case .tests(let testElement):
                return testElement.step.progress != 100
            case .final:
                return true
            }
        })
        
        return index ?? elements.count - 1
    }
    
    func name() -> String {
        switch self {
        case .tests(let element):
            return element.step.name
        case .final:
            return "Plan.FinalStep".localized
        }
    }
}
