//
//  Wordify.swift
//  WFL
//
//  Created by Berksu Kısmet on 24.01.2022.
//

import SwiftUI

struct Wordify: ViewModifier,Animatable {
    
    var rotation: Double
    var wordText: String

    init(isTapped: Bool, word: String){
        rotation = isTapped ? 180:0
        wordText = word
    }
    
    var animatableData: Double{
        set{ rotation = newValue }
        get{ rotation }
    }
    
    func body(content: Content) -> some View{
        ZStack{
            if rotation < 90{
                Text(wordText)
                    .multilineTextAlignment(.center)
                    .rotation3DEffect(.degrees(180), axis: (0,1,0))
            }else{
                content
            }
        }
    }
}
