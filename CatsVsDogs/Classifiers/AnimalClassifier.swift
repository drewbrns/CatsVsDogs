//
//  ImageClassifier.swift
//  CatsVsDogs
//
//  Created by Drew Barnes on 21/10/2024.
//

import UIKit
import Vision


protocol AnimalClassifier {
    var name: String { get }
    func classify(image: UIImage) async throws -> [AnimalClassifierPrediction]
}

enum AnimalClassIdentifier: String {
    case cat
    case dog
    case unknown

    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "cat":
            self = .cat
        case "dog":
            self = .dog
        default:
            self = .unknown
        }
    }
}

struct AnimalClassifierPrediction {
    let identifier: AnimalClassIdentifier
    let confidence: VNConfidence
}

enum AnimalClassifierError: Error {
    case cgImageCreationFailed
    case classificationFailed
    case modelCreationFailed
    case neitherCatNorDog
}

