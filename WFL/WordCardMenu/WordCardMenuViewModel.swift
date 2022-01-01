//
//  WordCardMenuViewModel.swift
//  WFL
//
//  Created by Berksu Kısmet on 26.12.2021.
//

import Foundation

final class WordCardMenuViewModel: ObservableObject{
    @Published var wordCards: [WordCardModel] = []
    
    init(){
        FirebaseFirestoreApi().getWordCollectionFor(movieID: "1", completion: { allWordCards in
            self.wordCards = allWordCards
        })
    }
}
