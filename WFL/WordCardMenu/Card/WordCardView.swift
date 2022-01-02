//
//  WordCardView.swift
//  WFL
//
//  Created by Berksu Kısmet on 24.12.2021.
//

import SwiftUI
import AVKit

struct WordCardView: View {
    @Binding var card: WordCardModel
    var removal: (() -> Void)? = nil
    
    @StateObject var viewModel = WordCardViewModel()

    @State private var offset = CGSize.zero
    @State var flashCardRotation = 0.0
    @State var contentRotation = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.red)
                    .overlay(RoundedRectangle(cornerRadius: 30)
                                .strokeBorder(.black,lineWidth: 5))
                    .frame(width: geometry.size.width*0.85,
                           height: geometry.size.height*0.9)
                    .rotationEffect(.degrees(Double(offset.width / 5)))
                    .offset(x: offset.width * 5, y: 0)
                    .opacity(2-Double(abs(offset.width / 50)))
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                viewModel.player.pause()
                                withAnimation(.spring()){
                                    self.offset = self.card.isDraggable ? gesture.translation:self.offset
                                }
                            }
                            .onEnded{ _ in
                                if(abs(self.offset.width) > 150){
                                    withAnimation(.spring()){
                                        self.removal?()
                                    }
                                }else{
                                    withAnimation(.spring()){
                                        self.offset = .zero
                                        viewModel.player.play()
                                    }
                                }
                            }
                    )
                    .onTapGesture {
                        flipCard()
                    }

                if(!card.isTapped){
                    wordText
                }else{
                    player
                        .frame(width: geometry.size.width*0.8,
                               height: geometry.size.height*0.7)
                        .onReceive(viewModel.timeObserver.publisher) { time in
                            viewModel.pauseVideoWhenItReaches(time: time, cardTime: card.startTime)
                        }
                }
            }
            .onAppear {
                viewModel.playerInit(videoUrl: card.videoUrl, startTime: card.startTime)
            }
            
            .rotation3DEffect(.degrees(contentRotation), axis: (x:0, y:1, z:0))
            .rotation3DEffect(.degrees(flashCardRotation), axis: (x:0, y:1, z:0))
        }
    }

    
    var wordText: some View{
        Text(card.word)
            .rotationEffect(.degrees(Double(offset.width / 5)))
            .offset(x: offset.width * 5, y: 0)
            .opacity(2-Double(abs(offset.width / 50)))
    }
    
    var player: some View{
        ZStack{
            VideoPlayer(player: viewModel.player){
                VStack{
                    Spacer()
                    //scrolledTextView(meanings: card.meanings)
                    //    .padding(.bottom, 40)
                }
            }
            
            VStack{
                subtitle
                Spacer()
                    .onReceive(viewModel.timeObserver.publisher) { time in
                        viewModel.updateSubtitle(time: time)
                        viewModel.splitSubtitleString()
                    }
            }
            
            VStack{
                Spacer()
                scrolledTextView(meanings: card.meanings)
                    .padding(.bottom, 40)
            }
        }
            .rotationEffect(.degrees(Double(offset.width / 5)))
            .offset(x: offset.width * 5, y: 0)
            .opacity(2-Double(abs(offset.width / 50)))
    }
    
    func flipCard(){
        let animationTime = 0.5
        withAnimation(Animation.linear(duration: animationTime)){
            flashCardRotation += 180
            viewModel.player.pause()

        }
        
        withAnimation(Animation.linear(duration: 0.001).delay(animationTime/2)){
            contentRotation += 180
            self.card.isTapped.toggle()
        }
    }
    
    
    var subtitle: some View{
        ForEach(viewModel.subtitleWordsArray, id: \.self){words in
            HStack{
                ForEach(words, id: \.self){word in
                    Text("\(word)")
                        .font(.system(size: 12))
                        .foregroundColor(viewModel.isWordChosen(wordFromDatabase: card.word, wordInSubtitle: word) ? .blue:.white)
                }
            }.background(.clear)
        }
    }
}


struct scrolledTextView: View{
    @State var meanings: [String]
    
    var body: some View{
        ScrollView(.horizontal,showsIndicators: false){
            LazyHStack(spacing: 10){
                ForEach(meanings, id: \.self){ meaning in
                    Text(meaning)
                        .font(.system(size: 14))
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.8)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
            }.padding(.leading)
        }.frame(height: 40)
        .background(.black)
    }
}









// Better way to Do it


//struct FlashCard<Front, Back>:View where Front: View, Back: View{
//    var front: () -> Front
//    var back: () -> Back
//
//    @State var flipped: Bool = false
//    @State var flashCardRotation = 0.0
//    @State var contentRotation = 0.0
//    init(@ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back){
//        self.front = front
//        self.back = back
//    }
//
//    var body: some View{
//        ZStack{
//            if(flipped){
//                front()
//            }else{
//                back()
//            }
//        }
//        .rotation3DEffect(.degrees(contentRotation), axis: (x:0, y:1, z:0))
//        .onTapGesture {
//            flipFlashCard()
//        }
//        .rotation3DEffect(.degrees(flashCardRotation), axis: (x:0, y:1, z:0))
//    }
//
//    func flipFlashCard(){
//        let animationTime = 0.5
//        withAnimation(Animation.linear(duration: animationTime)){
//            flashCardRotation += 180
//        }
//
//        withAnimation(Animation.linear(duration: 0.001).delay(animationTime/2)){
//            contentRotation += 180
//            flipped.toggle()
//        }
//    }
//}
