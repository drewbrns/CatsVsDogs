//
//  CustomClassifier.swift
//  CatsVsDogs
//
//  Created by Drew Barnes on 22/10/2024.
//

import CoreML
import UIKit
import Vision


final class KaggleAnimalClassifier: AnimalClassifier {

    let name = "Kaggle Animal Classifier"
    private let model: VNCoreMLModel?

    init() {
        let defaultConfig = MLModelConfiguration()

        let animalClassifierWrapper = try? CatsVsDogs(configuration: defaultConfig)

        guard let animalClassifier = animalClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        let animalClassifierModel = animalClassifier.model

        guard let model = try? VNCoreMLModel(for: animalClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        self.model = model
    }


    func classify(image: UIImage) async throws -> [AnimalClassifierPrediction] {
        guard let model else {
            throw AnimalClassifierError.modelCreationFailed
        }

        guard let cgImage = image.cgImage else {
            throw AnimalClassifierError.cgImageCreationFailed
        }

        let results = try await performCoreMLRequest(model, on: cgImage)
        return try handleResults(results)
    }

    private func performCoreMLRequest(_ model: VNCoreMLModel, on image: CGImage) async throws -> [VNClassificationObservation] {
        return try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false

            let request = VNCoreMLRequest(model: model) { request, error in
                if hasResumed { return }

                if let error = error {
                    continuation.resume(throwing: error)
                    hasResumed = true
                    return
                }

                if let observations = request.results as? [VNClassificationObservation] {
                    continuation.resume(returning: observations)
                    hasResumed = true
                } else {
                    continuation.resume(throwing: AnimalClassifierError.classificationFailed)
                    hasResumed = true
                }
            }
            request.imageCropAndScaleOption = .centerCrop

            let handler = VNImageRequestHandler(cgImage: image, options: [:])

            do {
                try handler.perform([request])
            } catch {
                if !hasResumed {
                    continuation.resume(throwing: error)
                    hasResumed = true
                }
            }
        }
    }

    private func handleResults(_ observations: [VNClassificationObservation]) throws -> [AnimalClassifierPrediction] {

        return observations
            .map { observation in
                AnimalClassifierPrediction(
                    identifier: .init(rawValue: observation.identifier) ?? .unknown,
                    confidence: observation.confidence
                )
            }
    }
}
