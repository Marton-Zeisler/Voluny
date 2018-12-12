//
//  AuthService.swift
//  Voluny
//


import Foundation
import Firebase

class AuthService{
    static let instance = AuthService()
    
    func signUpUser(email: String, password: String, userData: [String: Any], userImage: UIImage, userCreationComplete: @escaping(_ status: Bool, _ error: Error?) ->() ){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else{
                userCreationComplete(false, error)
                return
            }
            
            DataService.instance.createUser(uid: user.uid, userData: userData, userImage: userImage, handler: {
                userCreationComplete(true, nil)
            })
        }
    }
    
    func signInUser(email: String, password: String, logincomplete: @escaping(_ status: Bool, _ error: Error?) ->() ){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                logincomplete(false, error)
            }else{
                logincomplete(true, nil)
            }
        }
    }
    
    func signUpRecruiter(email: String, password: String, userData: [String: Any], handler: @escaping(_ status: Bool, _ error: Error?) ->() ){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else{
                handler(false, error)
                return
            }
            
            DataService.instance.createRecruiter(uid: user.uid, userData: userData)
            handler(true, nil)
        }
    }
    
}
