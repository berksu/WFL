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
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                VideoPlayer(player: viewModel.player)

                //CustomVideoPlayer(player: $viewModel.player)
                
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
                }.padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                    .onReceive(viewModel.timeObserver.publisher) { time in
                        viewModel.updateSubtitle(time: time)
                        viewModel.splitSubtitleString()
                    }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .landscapeLeft // And making sure it stays that way
        }.onDisappear {
            viewModel.stopVideo()
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
        }
    }
    
    var subtitle: some View{
        VStack{
            ForEach(viewModel.subtitleWordsArray, id: \.self){words in
                HStack{
                    ForEach(words, id: \.self){word in
                        Button {
                            viewModel.wordTapped(wordStr: word)
                        } label: {
                            Text("\(word)")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }.background(Color(red: 0, green: 0, blue: 0, opacity: 0.5))
            }
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
