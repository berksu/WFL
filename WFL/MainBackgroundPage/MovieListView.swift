//
//  MovieListView.swift
//  WFL
//
//  Created by Berksu Kısmet on 2.01.2022.
//

import SwiftUI
import Kingfisher

struct MovieListView: View {
    var body: some View {
        ScrollView{
            horizontalScrollView(title: "Popular", movieList: [Movie(id: 1, title: "Harry Potter", release_date: "2002", image: "asd", voteAverage: 9.8, voteCount: 12345, overview: "asd", backdropPath: "asd", genreIDs: [1,2])])
        }
        .background(.black)
    }
    
    func horizontalScrollView(title: String, movieList: [Movie]) -> some View{
        return Group{
        HStack{
            Text(title)
                .foregroundColor(.white)
            Spacer()
        }
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(movieList, id: \.id) { movie in
                    NavigationLink(destination: MoviePlayerView()) {
                        KFImage.init(URL(string: "https://www.themoviedb.org/t/p/w1280/sdEOH0992YZ0QSxgXNIGLq1ToUi.jpg"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }.frame(height: 120)
        }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
