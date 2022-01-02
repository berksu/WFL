//
//  WordCardMenuView.swift
//  WFL
//
//  Created by Berksu Kısmet on 24.12.2021.
//

import SwiftUI

struct WordCardMenuView: View {
    @State var offset_val = CGSize.zero
    
    //@State private var cards = [Card](repeating: Card.example, count: 10)
    //@State private var cards = [WordCardModel.exampleCard, WordCardModel.exampleCard, WordCardModel.exampleCard, WordCardModel.exampleCard, WordCardModel.exampleCard]
    @ObservedObject var viewModel = WordCardMenuViewModel()
    
    var body: some View {
            VStack{
                cardsView
                    .padding()
                //buttonsSection
                //    .padding()
            }
            
        .background(.black)
    }
    
    var cardsView: some View {
        GeometryReader { geometry in
            ZStack(){
                let minusVal = viewModel.wordCards.count - 3
                let loopMinVal = minusVal > 0 ? minusVal:0
                ForEach(loopMinVal..<viewModel.wordCards.count, id: \.self) { index in
                    WordCardView(card: self.$viewModel.wordCards[index]){
                        withAnimation(.spring()){
                            if(index != 0){
                                viewModel.wordCards[index-1].isDraggable = true
                            }
                            removeCard(at: index)
                        }
                    }
                    .stacked(at: index > 1 ? (index-minusVal):index, in: (viewModel.wordCards.count > 3) ? 3:viewModel.wordCards.count)
                    .opaced(at: index > 1 ? (index-minusVal):index, in: (viewModel.wordCards.count > 3) ? 3:viewModel.wordCards.count)
                    .scaled(at: index > 1 ? (index-minusVal):index, in: (viewModel.wordCards.count > 3) ? 3:viewModel.wordCards.count)
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    
    func singleCardView(offset_x: CGFloat, opacity: CGFloat, scaleRate: CGFloat, geometry:GeometryProxy ) -> some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundColor(.red)
            .overlay(RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(.black,lineWidth: 5))
            .frame(width: geometry.size.width*0.85,
                   height: geometry.size.height*0.8)
            .offset(x:offset_x,y:0)
            .opacity(opacity)
            .scaleEffect(scaleRate)
    }
    
    
    var buttonsSection: some View {
        HStack(spacing:50){
            buttonView(imageName: "mic.slash")
            buttonView(imageName: "bubble.left")
            buttonView(imageName: "phone")
        }
    }
    
    
    func removeCard(at index: Int) {
        viewModel.wordCards.remove(at: index)
    }
    
    
}

struct buttonView:View{
    @State var imageName: String
    var body: some View{
        Button {
            print("\(imageName)")
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.black)
        }
        
    }
}


struct test_Previews: PreviewProvider {
    static var previews: some View {
        WordCardMenuView()
    }
}




