//
//  Photo.swift
//  CatsVsDogs
//
//  Created by Drew Barnes on 21/10/2024.
//

import Foundation

struct Photo: Identifiable, Hashable {
    let id: UUID
    let name: String
}

extension Photo {

    static var all: [Photo] {
        [
            .init(id: UUID(), name: "1"),
            .init(id: UUID(), name: "2"),
            .init(id: UUID(), name: "3"),
            .init(id: UUID(), name: "4"),
            .init(id: UUID(), name: "5"),
            .init(id: UUID(), name: "6"),
            .init(id: UUID(), name: "7"),
            .init(id: UUID(), name: "8"),
            .init(id: UUID(), name: "9"),
            .init(id: UUID(), name: "10"),
            .init(id: UUID(), name: "11"),
            .init(id: UUID(), name: "12"),
            .init(id: UUID(), name: "13"),
            .init(id: UUID(), name: "14"),
        ]
    }
}
