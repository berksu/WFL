//
//  WordCardViewModel.swift
//  WFL
//
//  Created by Berksu Kısmet on 24.12.2021.
//

import Foundation
import AVKit

final class WordCardViewModel: ObservableObject {
    @Published var player = AVPlayer()
    @Published var timeObserver:PlayerTimeObserver = PlayerTimeObserver(player: AVPlayer(), observingTime: 1)
    
    let parser = Subtitles(file:  URL(fileURLWithPath: Bundle.main.path(forResource: "subtitle", ofType: "srt")!), encoding: .utf8)
    var oldSubtitleText = ""
    @Published var subtitleText = ""
    @Published var subtitleWordsArray:[[String]] = []
    fileprivate var parsedPayload: NSDictionary?

    func playerInit(videoUrl: String, startTime: Float64){
        if let videoURL = URL(string: videoUrl){
            player = AVPlayer(url: videoURL)
            player.seek(to: CMTimeMake(value: Int64(startTime - 3), timescale: 1))
            timeObserver = PlayerTimeObserver(player: self.player, observingTime: 0.1)
        }
    }
    
    func pauseVideoWhenItReaches(time: Double, cardTime: Float64){
        if(time >= cardTime + 3){
            player.pause()
        }
    }
    
    
    // Subtitle Part
    func updateSubtitle(time: TimeInterval){
        guard let subtitle = parser.searchSubtitles(at: time) else{
            subtitleText = ""
            return
        }
        subtitleText = subtitle
    }
    
    func splitSubtitleString(){
        if(oldSubtitleText != subtitleText){
            subtitleWordsArray = []
            let lines = subtitleText.components(separatedBy: "\n")
            
            lines.forEach{ line in
                let words = line.components(separatedBy: " ")
                subtitleWordsArray.append(words)
            }
        }
        oldSubtitleText = subtitleText
    }
    
    func show(subtitles string: String) {
        var dictionary:[String:Any] = [:]
            // Parse
            parsedPayload = Subtitles.parseSubRip(string)
            //addPeriodicNotification(parsedPayload: parsedPayload!)
        guard let subtitles = parsedPayload?.swiftDictionary else{
            return
        }
        let sortedKeys = subtitles.keys.sorted(by: {$0.localizedStandardCompare($1) == .orderedAscending})


        for key in sortedKeys {
           // Ordered iteration over the dictionary
           let val = subtitles[key]
            dictionary[key] = val
        }
    }

    func open(fileFromLocal filePath: URL, encoding: String.Encoding = String.Encoding.utf8) {
        let contents = try! String(contentsOf: filePath, encoding: encoding)
        show(subtitles: contents)
    }
    
    func isWordChosen(wordFromDatabase: String, wordInSubtitle:String) -> Bool{
        if(wordFromDatabase == removeSpecialCharactersFromString(word: wordInSubtitle)){
            return true
        }
        return false
    }
    
    
    func removeSpecialCharactersFromString(word: String) -> String{
        var searchedWord = word
        let vowels: Set<Character> = [".", "-", "!", "?", ","]
        searchedWord.removeAll(where: { vowels.contains($0) })
        
        searchedWord = searchedWord.replacingOccurrences(of: "<i>", with: "")
        return searchedWord
    }
}

