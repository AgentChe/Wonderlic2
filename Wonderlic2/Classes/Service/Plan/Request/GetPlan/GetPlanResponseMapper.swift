//
//  GetPlanResponseMapper.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

final class GetPlanResponseMapper {
    static func map(from response: Any) throws -> Plan? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let code = json["_code"] as? Int
        else {
            throw ContentError(.notContent)
        }
        
        guard code == 200 else {
            throw ContentError(.notContent)
        }
        
        guard
            let plan = data["plan"] as? [String: Any],
            let stepsArray = plan["steps"] as? [[String: Any]],
            let passRate = plan["pass_rate"] as? Int,
            let goal = plan["goal"] as? String,
            let finalStepJSON = plan["final_exam"] as? [String: Any],
            let finalStep = map(finalStepJSON: finalStepJSON)
        else {
            return nil
        }
        
        let steps = map(stepsArray: stepsArray)
        
        return Plan(progress: passRate,
                    goal: goal,
                    steps: steps,
                    finalStep: finalStep)
    }
}

// MARK: Private
private extension GetPlanResponseMapper {
    static func map(stepsArray: [[String: Any]]) -> [PlanStep] {
        return stepsArray.compactMap { stepElement -> PlanStep? in
            guard
                let name = stepElement["name"] as? String,
                let sort = stepElement["sort"] as? Int,
                let progress = stepElement["progress"] as? Int,
                let testsArray = stepElement["tests"] as? [[String: Any]]
            else {
                return nil
            }
            
            let tests = testsArray.compactMap { testElement -> PlanTest? in
                guard
                    let id = testElement["id"] as? Int,
                    let name = testElement["name"] as? String,
                    let sort = testElement["sort"] as? Int,
                    let questionsCount = testElement["questions"] as? Int,
                    let paid = testElement["paid"] as? Bool,
                    let progress = testElement["progress"] as? Int
                else {
                    return nil
                }
                
                return PlanTest(id: id,
                                name: name,
                                sort: sort,
                                questionsCount: questionsCount,
                                paid: paid,
                                progress: progress)
            }
            
            return PlanStep(name: name,
                     sort: sort,
                     progress: progress,
                     tests: tests)
        }
    }
    
    static func map(finalStepJSON: [String: Any]) -> PlanFinalStep? {
        func status(code: Int) -> PlanFinalStep.Status? {
            switch code {
            case 0:
                return .intact
            case 1:
                return .inProgress
            case 2:
                return .completed
            default:
                return nil
            }
        }
        
        guard
            let statusCode = finalStepJSON["status"] as? Int,
            let status = status(code: statusCode)
        else {
            return nil
        }
        
        let progress = finalStepJSON["score"] as? Int
        
        return PlanFinalStep(status: status,
                             progress: progress)
    }
}
