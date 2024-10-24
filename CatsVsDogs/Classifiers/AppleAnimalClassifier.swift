//
//  AnimalClassifier.swift
//  CatsVsDogs
//
//  Created by Drew Barnes on 20/10/2024.
//

import UIKit
import Vision


final class AppleAnimalClassifier: AnimalClassifier {

    let name = "Apple Animal Classifier"

    func classify(image: UIImage) async throws -> [AnimalClassifierPrediction] {
        guard let cgImage = image.cgImage else {
            throw AnimalClassifierError.cgImageCreationFailed
        }

        let request = RecognizeAnimalsRequest()
        let result = try await request.perform(on: cgImage)
        return try handleResult(result)
    }

}

extension AppleAnimalClassifier {

    private func handleResult(_ result: RecognizeAnimalsRequest.Result) throws -> [AnimalClassifierPrediction] {

        let predictions = result
            .filter { !$0.labels.isEmpty }
            .map {
                AnimalClassifierPrediction(
                    identifier: .init(rawValue: $0.labels.first!.identifier) ?? .unknown,
                    confidence: $0.confidence)
            }

        if predictions.isEmpty {
            return [AnimalClassifierPrediction(identifier: .unknown, confidence: 0)]
        } else {
            return predictions
        }
    }
}
