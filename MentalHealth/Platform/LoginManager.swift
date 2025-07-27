//
//  LoginManager.swift
//  MentalHealth
//
//

import Foundation
import UIKit
import FirebaseAnalytics
import CoreData
import CryptoKit

enum Gender: String {
    case male
    case female
    case other
    
    var localized: String {
        guard let localizationKey = SoliULocalizationKey(rawValue: self.rawValue) else { return "" }
        return .localized(localizationKey)
    }
}

enum WorkStatus: String {
    case student
    case employed
    case other
    
    var localized: String {
        guard let localizationKey = SoliULocalizationKey(rawValue: self.rawValue) else { return "" }
        return .localized(localizationKey)
    }
}

enum Ethnicity: String {
    case americanIndian
    case alaskaNative
    case asian
    case black
    case africanAmerican
    case nativeHawaiian
    case otherPacificIslander
    case white
    case other

    var localized: String {
        guard let localizationKey = SoliULocalizationKey(rawValue: self.rawValue) else { return "" }
        return .localized(localizationKey)
    }
}

///Usage: LoginManager.shared.checkLoggedIn
public final class LoginManager {
    static let shared = LoginManager()

    static var guestUser: UserInformation {
//        let context = CoreDataManager.shared.starPersistentContainer.viewContext
//        let starCount = Int(StarCount.getStarCount(from: context))
        let starCount = 0
        
        return UserInformation(
            email: "guest@gmail.com",
            password: "guest!",
            nickName: .localized(.guest),
            gender: "None",
            age: "0",
            workStatus: "None",
            ethnicity: "None",
            surveyResultsList: [],
            dailyMoodList: [],
            adviceItemList: [],
            progressStar: starCount
        )
    }
    
    // Continue as Guest option will be false as default
    private var logInState: Bool = false
    private var currentUser: UserInformation = guestUser
    private var isDetoxed: String = ""
    private var tempPassword: String = ""
    private var tempDetox: String = ""
    private init() {}

    // MARK: - User Information
    func getUserInfo() -> UserInformation {
        return self.currentUser
    }
    
    func setTempDetox(isDetoxed: String) {
        self.tempDetox = isDetoxed
    }
    
    func getTempDetox() -> String {
        return self.tempDetox
    }
    
    func saveSurveyRecentResultTemp(_ surveyResult: SurveyResult) {
        if let encodedData = try? JSONEncoder().encode(surveyResult) {
            UserDefaults.standard.set(encodedData, forKey: "RecentTestResult")
        }
    }
    
    private func getTemporarySurveyResult() -> SurveyResult? {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "RecentTestResult") {
            if let decodedResult = try? JSONDecoder().decode(SurveyResult.self, from: savedData) {
                return decodedResult
            }
        }
        return nil
    }
    
    func getMostRecentTestScore() -> SurveyResult? {
        if let tempResult = getTemporarySurveyResult() {
//            print("Debug - \(tempResult)")
            return tempResult
        }

        let dateFormatter = ISO8601DateFormatter()
        let sortedResults = currentUser.surveyResultsList.sorted { result1, result2 in
            guard let date1 = dateFormatter.date(from: result1.surveyDate),
                  let date2 = dateFormatter.date(from: result2.surveyDate) else {
                return false
            }
            return date1 > date2
        }
        return sortedResults.first
    }
    
    
    func setMostRecentTestScore(surveyResult: SurveyResult)  {
        currentUser.surveyResultsList.append(surveyResult)
    }

    func setMyUserInformation(_ userInfo: UserInformation) {
        self.currentUser = userInfo
    }

    func getDailyMoodList() -> [MyDay] {
        return self.currentUser.dailyMoodList
    }
    
    func getSurveyResult() -> [SurveyResult] {
        return self.currentUser.surveyResultsList
    }
    
    func getDiaryEntriesList() -> [AdviceItem] {
        return self.currentUser.adviceItemList
    }
    
    func setDiaryEntriesList(_ adviceItemList: [AdviceItem]) {
        self.currentUser.adviceItemList = adviceItemList
    }


    func setSurveyResult(_ surveyResult: [SurveyResult]) {
        self.currentUser.surveyResultsList = surveyResult
    }
    
//    func getProgressStar() -> Int {
//        return self.currentUser.progressStar
//    }
//    
//    func setProgressStar(_ progressStar: Int) {
//        StarCount.saveStarCount(Int16(progressStar), in: CoreDataManager.shared.starPersistentContainer.viewContext)
//        self.currentUser.progressStar = progressStar
//    }

    // MARK: - Login State

    func isLoggedIn() -> Bool {
        return self.logInState
    }
    
    func setupDetoxInformation(isDetoxed: String) {
        self.isDetoxed = isDetoxed
    }
    
    func getDetoxInformation() -> String {
        return self.isDetoxed
    }

    func setLoggedIn(_ loggedIn: Bool) {
        self.logInState = loggedIn
    }

    // MARK: - Guest Flow

    func continueAsGuest() {
        self.currentUser = LoginManager.guestUser
        self.logInState = false
    }

    // MARK: - Login Flow

    func loginSucessFetchInformation(userInformation: UserInformation) {
        // Implement actual login logic here
        // Simulating successful login
        let fetchedUser = userInformation
        self.currentUser = fetchedUser
        self.logInState = true
    }

    // MARK: - Signup Flow

    func signUpUser(userInfo: UserInformation, completion: (Bool) -> Void) {
        // Implement actual signup logic here
        // Simulating successful signup
        self.currentUser = userInfo
        self.logInState = true
        completion(true)
    }

    // MARK: - Helper Methods

    func setEmail(_ email: String) {
        self.currentUser.email = email
    }
    
    func getEmail() -> String {
        return logInState ? self.currentUser.email : "guest@gmail.com"
    }
    
    func getMyTestAverageScore() -> Double {
        let surveyResultList = self.currentUser.surveyResultsList

        guard !surveyResultList.isEmpty else { return 0.0 }
        let sortedResults = surveyResultList.sorted { $0.surveyDate > $1.surveyDate }
        let selectedResults = sortedResults.count > 10 ? Array(sortedResults.prefix(10)) : sortedResults
        let allAnswers = selectedResults.flatMap { $0.surveyAnswer }
        
        let totalCount = allAnswers.count
        let totalSum = allAnswers.reduce(0, +)
        guard totalCount > 0 else { return 0.0 }
        let rawAverage = Double(totalSum) / Double(totalCount)

        return (rawAverage * 10).rounded() / 10.0
    }

    func setNickName(_ nickName: String) {
        self.currentUser.nickName = nickName
    }
    
    func getNickName() -> String {
        return currentUser.nickName
    }

    func setGender(_ gender: Gender) {
        self.currentUser.gender = gender.localized
    }
    
    func getGender() -> String {
        return currentUser.gender
    }

    func setAge(_ age: Int) {
        self.currentUser.age = "\(age)"
    }
    
    func getAge() -> String {
        return currentUser.age
    }

    func setWorkStatus(_ workStatus: WorkStatus) {
        self.currentUser.workStatus = workStatus.localized.capitalized
    }
    
    func getWorkStatus() -> String {
        return currentUser.workStatus
    }

    func setEthnicity(_ ethnicity: Ethnicity) {
        self.currentUser.ethnicity = ethnicity.localized.capitalizedEachWord()
    }
    
    func getEthnicity() -> String {
        return currentUser.ethnicity
    }
}
// MARK: - Guest User Flag Handling

extension LoginManager {
    var isGuestUser: Bool {
        return !isLoggedIn()
    }

    func markAsGuestUser() {
        UserDefaults.standard.set(true, forKey: "isGuestUser")
        Analytics.setUserProperty("true", forName: "is_guest_user")
    }

    func clearGuestUserFlag() {
        UserDefaults.standard.removeObject(forKey: "isGuestUser")
        Analytics.setUserProperty("false", forName: "is_guest_user")
    }
    
    func completeRegistration(userEmail: String) {
        UserDefaults.standard.set(false, forKey: "isGuestUser")
        Analytics.setUserProperty("false", forName: "is_guest_user")
        Analytics.setUserID(userEmail)
    }
}

extension LoginManager {
    func hashedUUID(for email: String?) -> String {
        guard let email else { return "UnKnown" }
        // Hash the email using SHA256
        let data = Data(email.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
