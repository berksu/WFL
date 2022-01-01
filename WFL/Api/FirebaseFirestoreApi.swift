//
//  FirebaseFirestoreApi.swift
//  WFL
//
//  Created by Berksu Kısmet on 26.12.2021.
//

import Foundation
import Firebase

struct FirebaseFirestoreApi{
    func getAllCollections(completion: @escaping ([WordCardModel]) -> Void){
        var collections:[WordCardModel] = []
        if let userID = Auth.auth().currentUser?.uid{
            let db = Firestore.firestore()
            
            db.collection("\(userID)_words").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion([])
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        let tempCollection = WordCardModel(id: data["id"] as! String,
                                                           videoUrl: data["videoUrl"]! as! String,
                                                           word: data["word"]! as! String,
                                                           meanings: data["meanings"]! as! [String],
                                                           startTime: data["startTime"]! as! Float64,
                                                           movieID: data["movieID"]! as! String)
                        collections.append(tempCollection)
                    }
                    completion(collections)
                }
            }
        } else{
            print("Cannot reach firebase")
            return
        }
    }
    
    
    func getWordCollectionFor(movieID:String, completion: @escaping ([WordCardModel]) -> Void){
        var collections:[WordCardModel] = []
        if let userID = Auth.auth().currentUser?.uid{
            let db = Firestore.firestore()
        
            db.collection("\(userID)_words").whereField("movieID", isEqualTo: movieID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let data = document.data()
                            let tempCollection = WordCardModel(id: data["id"] as! String,
                                                               videoUrl: data["videoUrl"]! as! String,
                                                               word: data["word"]! as! String,
                                                               meanings: data["meanings"]! as! [String],
                                                               startTime: data["startTime"]! as! Float64,
                                                               movieID: data["movieID"]! as! String)
                            collections.append(tempCollection)
                        }
                        completion(collections)
                    }
            }
        }else{
            print("Cannot reach firebase")
            return
        }
    }
    
    
    func addCollectionToDatabase(collection: WordCardModel){
        guard let userID = Auth.auth().currentUser?.uid else { return}
        let db = Firestore.firestore()
        
        db.collection("\(userID)_words").document(String(collection.id)).setData([
            "id": collection.id,
            "videoUrl": collection.videoUrl,
            "word": collection.word,
            "meanings": collection.meanings,
            "startTime": collection.startTime,
            "movieID": collection.movieID
        ]){err in
            if let err = err{
                print("Add data error \(err)")
            }else{
                print("Document added")
            }
        }
    }
    
    
    func removeCollectionFromDatabase(collection: WordCardModel){
        guard let userID = Auth.auth().currentUser?.uid else { return}
        let db = Firestore.firestore()
        
        db.collection("\(userID)_words").document(String(collection.id)).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
