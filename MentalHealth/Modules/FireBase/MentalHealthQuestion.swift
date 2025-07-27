//
//  MentalHealthQuestion.swift
//  MentalHealth
//
//

import Foundation

struct MentalHealthQuestion: Codable {
    
    var testQuestions: [TestQuestion]
    
}

struct TestQuestion: Codable {
    var id: Int
    var questionNumber: Int
    var type: String
    var question: String
   
    enum CodingKeys: String, CodingKey {
        case id
        case questionNumber
        case type
        case question
    }
}

struct SurveyData: Codable {
    var userId: String
    var resultScore: [Int]
}
