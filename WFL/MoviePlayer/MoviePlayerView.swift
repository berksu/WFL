//
//  ContentView.swift
//  WFL
//
//  Created by Berksu Kısmet on 20.12.2021.
//

import SwiftUI
import AVKit


struct MoviePlayerView: View {

    @StateObject var viewModel = MoviePlayerViewModel()
    @State private var orientation = UIDevice.current.orientation

    var body: some View {
        GeometryReader{geometry in
            ZStack{
                VideoPlayer(player: viewModel.player)
                
                HStack{
                    VStack(alignment: .leading){
                        if(viewModel.isWordTapped){
                            ForEach(viewModel.meanings, id: \.self){meaning in
                                Text("\(meaning)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .background(Color(red: 0, green: 0, blue: 0, opacity: 0.5))
                                    .onAppear(perform: delayText)
                            }
                        }
                    }
                    Spacer()
                }.padding(.leading,50)
                
                VStack{
                    subtitle
                    Spacer()
                }.padding(orientation.isPortrait ?
                          EdgeInsets(top: geometry.size.height * 0.3, leading: 0, bottom: 0, trailing: 0):EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    .onReceive(viewModel.timeObserver.publisher) { time in
                        viewModel.updateSubtitle(time: time)
                        viewModel.splitSubtitleString()
                    }
            }
            .ignoresSafeArea()
            .onRotate { newOrientation in
                orientation = newOrientation
            }
        }
    }
    
    var subtitle: some View{
        ForEach(viewModel.subtitleWordsArray, id: \.self){words in
            HStack{
                ForEach(words, id: \.self){word in
                    Button {
                        viewModel.wordTapped(wordStr: word)
                    } label: {
                        Text("\(word)")
                            .font(.system(size: orientation.isPortrait ? 18:26, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }.background(Color(red: 0, green: 0, blue: 0, opacity: 0.5))
        }
    }

    private func delayText() {
        // Delay of 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            viewModel.wordUntapped()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviePlayerView()
    }
}
