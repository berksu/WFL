//
//  File.swift
//  WFL
//
//  Created by Berksu Kısmet on 24.12.2021.
//

import Foundation

struct WordCardModel {
    let id: String
    let videoUrl: String
    let word: String
    let meanings: [String]
    let startTime: Float64
    let movieID: String
    var isDraggable =  true
    var isTapped = false
    
    static var exampleCard: WordCardModel {
        WordCardModel(id: UUID().uuidString, videoUrl: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8", word: "spell", meanings: ["büyü", "sihir"], startTime: 10, movieID: "1")
    }
}
