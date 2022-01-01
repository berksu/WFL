//
//  FirebaseApi.swift
//  WFL
//
//  Created by Berksu Kısmet on 26.12.2021.
//

import Foundation
import Firebase

struct FirebaseAuthApi{
    func anonymousLogin(completion: @escaping (Bool) -> Void){
        Auth.auth().signInAnonymously { authResult, error in
            if let _ = authResult?.user{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    func getUserID() -> String{
        guard let uid =  Auth.auth().currentUser?.uid else{return ""}
        return uid
    }
}
