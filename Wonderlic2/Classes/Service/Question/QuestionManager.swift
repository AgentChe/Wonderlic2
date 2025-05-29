//
//  QuestionManager.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import RxSwift

protocol QuestionManagerProtocol {
    func obtainTestsKit(courseId: Int) -> Single<TestsKit?>
    func obtainTest(courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?>
    func obtainTenTest(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainFailedTest(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainQotdTest(courseId: Int, activeSubscription: Bool, forceUpdate: Bool) -> Single<QotdTest?>
    func obtainRandomTest(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainSavedTest(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainQuickTest(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainCustomTest(
        courseId: Int,
        activeSubscription: Bool,
        subjectsIds: [Int],
        includeMissedQuestions: Bool,
        includeAnsweredQuestions: Bool,
        questionsCount: Int
    ) -> Single<Test?>
    func obtainPlanTest(testId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainOnboardingTest(courseId: Int, forceUpdate: Bool) -> Single<Test?>
    func obtainReview(courseId: Int, mode: Int, offset: Int) -> Single<[Review]>
    func saveQuestion(questionId: Int) -> Single<Void>
    func removeSavedQuestion(questionId: Int) -> Single<Void>
    func obtainAgainTest(userTestId: Int) -> Single<Test?>
    func finishTest(userTestId: Int) -> Single<Void>
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?>
}

final class QuestionManager: QuestionManagerProtocol {
    enum Constants {
        static func qotdTestKey(courseId: Int) -> String {
            String(format: "%@_%i", "question_manager_qotd_test_key", courseId)
        }
        static let onboardingSetKey = "question_manager_onboarding_test_key"
    }
    
    private lazy var xorRequestWrapper = XORRequestWrapper()
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension QuestionManager {
    func obtainTestsKit(courseId: Int) -> Single<TestsKit?> {
        let request = GetTestsKitRequest(
            userToken: sessionManager.internalId,
            courseId: courseId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetTestsKitResponse.map(from: $0) }
    }
    
    func obtainTest(courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?> {
        let request = GetTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            testId: testId,
            time: time,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func obtainTenTest(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetTenTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func obtainFailedTest(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetFailedTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func obtainQotdTest(
        courseId: Int,
        activeSubscription: Bool,
        forceUpdate: Bool
    ) -> Single<QotdTest?> {
        if forceUpdate {
            return loadQotdTest(courseId: courseId, activeSubscription: activeSubscription)
        }
        
        return cachedQotdTest(courseId: courseId)
            .flatMap { [weak self] test -> Single<QotdTest?> in
                guard let self = self else {
                    return .never()
                }
                
                if let test = test, Calendar.current.isDateInToday(test.creation) {
                    return .just(test)
                }
                
                return self.loadQotdTest(courseId: courseId, activeSubscription: activeSubscription)
            }
    }
    
    func obtainRandomTest(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetRandomTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func obtainSavedTest(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetSavedTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            activeSubscription: activeSubscription
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetTestResponseMapper.map(from: $0) }
    }
    
    func obtainQuickTest(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetCustomTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            activeSubscription: activeSubscription,
            subjects: [],
            includeMissedQuestions: true,
            includeAnsweredQuestions: true,
            questionsCount: 10
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func obtainCustomTest(
        courseId: Int,
        activeSubscription: Bool,
        subjectsIds: [Int],
        includeMissedQuestions: Bool,
        includeAnsweredQuestions: Bool,
        questionsCount: Int
    ) -> Single<Test?> {
        let request = GetCustomTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            activeSubscription: activeSubscription,
            subjects: subjectsIds,
            includeMissedQuestions: includeMissedQuestions,
            includeAnsweredQuestions: includeAnsweredQuestions,
            questionsCount: questionsCount
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func obtainPlanTest(testId: Int, activeSubscription: Bool) -> Single<Test?> {
        let request = GetPlanTestRequest(
            userToken: sessionManager.internalId,
            testId: testId,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func obtainOnboardingTest(courseId: Int, forceUpdate: Bool) -> Single<Test?> {
        forceUpdate ? loadOnboardingTest(courseId: courseId) : cachedOnboardingTest()
    }
    
    func obtainReview(courseId: Int, mode: Int, offset: Int) -> Single<[Review]> {
        let request = GetReviewRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            mode: mode,
            offset: offset
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetReviewResponse.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func saveQuestion(questionId: Int) -> Single<Void> {
        let request = SaveQuestionRequest(
            userToken: sessionManager.internalId,
            questionId: questionId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func removeSavedQuestion(questionId: Int) -> Single<Void> {
        let request = RemoveSavedQuestionRequest(
            userToken: sessionManager.internalId,
            questionId: questionId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func obtainAgainTest(userTestId: Int) -> Single<Test?> {
        let request = AgainTestRequest(
            userToken: sessionManager.internalId,
            userTestId: userTestId
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
    }
    
    func finishTest(userTestId: Int) -> Single<Void> {
        let request = FinishTestRequest(
            userToken: sessionManager.internalId,
            userTestId: userTestId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?> {
        let request = SendAnswerRequest(
            userToken: sessionManager.internalId,
            questionId: questionId,
            answerIds: answerIds,
            userTestId: userTestId
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { SendAnswerResponseMapper.map(from: $0) }
            .do(onSuccess: { isEndOfTest in
                if isEndOfTest == true {
                    QuestionMediator.shared.notidyAboutTestPassed()
                }
            })
    }
}

// MARK: Private
private extension QuestionManager {
    func loadOnboardingTest(courseId: Int) -> Single<Test?> {
        let request = GetOnboardingTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
            .do(onSuccess: { test in
                guard let test = test, let data = try? JSONEncoder().encode(test) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.onboardingSetKey)
            })
    }
    
    func cachedOnboardingTest() -> Single<Test?> {
        Single<Test?>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.onboardingSetKey),
                    let test = try? JSONDecoder().decode(Test.self, from: data)
                else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                event(.success(test))
                
                return Disposables.create()
            }
    }
    
    func loadQotdTest(courseId: Int, activeSubscription: Bool) -> Single<QotdTest?> {
        let request = GetQotdTestRequest(
            userToken: sessionManager.internalId,
            courseId: courseId,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request, key: GlobalDefinitions.apiKey)
            .map { GetTestResponseMapper.map(from: $0, key: GlobalDefinitions.apiKey) }
            .map { test -> QotdTest? in
                guard let test = test else {
                    return nil
                }
                
                return QotdTest(creation: Date(), test: test)
            }
            .do(onSuccess: { test in
                guard let test = test, let data = try? JSONEncoder().encode(test) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.qotdTestKey(courseId: courseId))
            })
    }
    
    func cachedQotdTest(courseId: Int) -> Single<QotdTest?> {
        Single<QotdTest?>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.qotdTestKey(courseId: courseId)),
                    let test = try? JSONDecoder().decode(QotdTest.self, from: data)
                else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                event(.success(test))
                
                return Disposables.create()
            }
    }
}
