//
//  MoviePlayerViewModel.swift
//  WFL
//
//  Created by Berksu Kısmet on 20.12.2021.
//

import Foundation
import AVKit

final class MoviePlayerViewModel:ObservableObject{
    
    var moviePlayerModel = MoviePlayerModel()
    var videoUrl: String
        
    @Published var player = AVPlayer()
    @Published var timeObserver:PlayerTimeObserver = PlayerTimeObserver(player: AVPlayer(), observingTime: 1)
    @Published var subtitleWordsArray:[[String]] = []
    @Published var isWordTapped = false

    @Published var subtitleText = ""
    var meanings:[String] = []
    
    var parser: Subtitles
    var oldSubtitleText = ""
    
    init(){
        videoUrl = moviePlayerModel.videoUrl
        parser = Subtitles(file:  URL(fileURLWithPath: Bundle.main.path(forResource: moviePlayerModel.subtitleFileName, ofType: "srt")!), encoding: .utf8)
        FirebaseAuthApi().anonymousLogin { isLoggedIn in
            if(isLoggedIn){
                self.player = AVPlayer(url: URL(string: self.videoUrl)!)
                self.timeObserver = PlayerTimeObserver(player: self.player, observingTime: 0.1)
            }
        }
    }
    
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
    
    func wordTapped(wordStr: String){
        isWordTapped = true
        //player.pause()
        let clearWord = removeSpecialCharactersFromString(word: wordStr)

        let url = URL(string: moviePlayerModel.dictionaryUrl + clearWord)!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let stringData = String(data: data, encoding: .utf8)!
            //self.meanings = self.htmlParserTureng(data: stringData)
            self.meanings = self.htmlParserCambridge(data: stringData)

            print(self.meanings)
            if(self.meanings.count > 0){
                FirebaseFirestoreApi().addCollectionToDatabase(collection: WordCardModel(id: UUID().uuidString,
                                                                                         videoUrl: self.videoUrl,
                                                                                         word: clearWord,
                                                                                         meanings: self.meanings,
                                                                                         startTime: CMTimeGetSeconds(self.player.currentTime()),
                                                                                         movieID: "1"))
            }
        }
        task.resume()
    }
    
    func removeSpecialCharactersFromString(word: String) -> String{
        var searchedWord = word
        let vowels: Set<Character> = [".", "-", "!", "?", ","]
        searchedWord.removeAll(where: { vowels.contains($0) })
        
        searchedWord = searchedWord.replacingOccurrences(of: "<i>", with: "")
        return searchedWord
    }
    
    func htmlParserCambridge(data: String) -> [String]{
        var results:[String] = []

        let wordsPos = data.endIndices(of: "lang=\"tr\">")
        let toValue = wordsPos.count < 3 ? wordsPos.count:3
        
        for i in 0..<toValue{
            let newData = data[wordsPos[i]...]
            let endPos = newData.index(of: "<")!
            let tempWords = newData[..<endPos].components(separatedBy: ", ")
            results.append(contentsOf: tempWords)
        }
        
        for i in 0..<results.count{
            results[i] = removeSpecialCharacters(str: results[i])
        }
        return results
    }
    
    func removeSpecialCharacters(str: String) -> String{
        var word = str
        if(word.contains("&ccedil;")){
            word = word.replacingOccurrences(of: "&ccedil;", with: "ç")
        }
        if(word.contains("&uuml;")){
            word = word.replacingOccurrences(of: "&uuml;", with: "ü")
        }
        if(word.contains("&ouml;")){
            word = word.replacingOccurrences(of: "&ouml;", with: "ö")
        }
        if(word.contains("&#305;")){
            word = word.replacingOccurrences(of: "&#305;", with: "ı")
        }
        if(word.contains("&#351;")){
            word = word.replacingOccurrences(of: "&#351;", with: "ş")
        }
        if(word.contains("&#287;")){
            word = word.replacingOccurrences(of: "&#287;", with: "ğ")
        }
        
        return word
    }
    
    func playerSeekTo(seconds: Int64){
        player.seek(to: CMTimeMake(value: seconds, timescale: 10))
    }
    
    func wordUntapped(){
        isWordTapped = false
        meanings = []
    }
    
    func stopVideo(){
        player.pause()
    }
}


//func htmlParserTureng(data: String) -> [String]{
//    var results:[String] = []
//
//    if let _ = data.index(of: "Maybe the correct one is"){
//        return []
//    }else{
//        let oneTEst = data.indices(of: "turkish-english")
//        let toValue = oneTEst.count < 18 ? (oneTEst.count - 1):15
//        for i in 9..<toValue{
//            if(i % 2 == 0){
//                continue
//            }else{
//                let tempData = String(data[oneTEst[i]...])
//                guard let startIndex = tempData.endIndex(of: ">") else{ break }
//                guard let endIndex = tempData.index(of: "<") else{ break }
//
//                var word = String(tempData[startIndex..<endIndex])
//                word = removeSpecialCharacters(str: word)
//                results.append(word)
//            }
//        }
//        return results
//    }
//}
