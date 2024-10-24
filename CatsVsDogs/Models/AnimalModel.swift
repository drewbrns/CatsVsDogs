//
//  AnimalModel.swift
//  CatsVsDogs
//
//  Created by Drew Barnes on 22/10/2024.
//

import SwiftUI

struct PhotoPrediction: Hashable {
    let label: String
    let confidence: Int
}

class AnimalViewModel: ObservableObject {
    private let photo: Photo
    private let predictions: [AnimalClassifierPrediction]

    init(photo: Photo, predictions: [AnimalClassifierPrediction]) {
        self.photo = photo
        self.predictions = predictions
    }

    var image: String {
        photo.name
    }

    var photoPredictions: [PhotoPrediction] {
        predictions.map {
            PhotoPrediction(
                label: $0.identifier.rawValue.capitalized,
                confidence: Int(($0.confidence * 100).rounded())
            )
        }
    }
}
