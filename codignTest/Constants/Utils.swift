//
//  Utils.swift
//  codignTest
//
//  Created by Pawan Dhull on 23/02/21.
//

import UIKit

import SwiftMessages

class Utils: NSObject {
    
    /* Can't init is singleton */
    private override init() { }
    
    /* MARK:  Shared Instance  */
    static let shared = Utils()
    
    
    //MARK: -  Save User Info  -
    func setUserDetails( info : LoggedUserInfoData ){

        let encoder         = JSONEncoder()
        if let encoded      = try? encoder.encode(info) {
            let defaults    = UserDefaults.standard
            defaults.set(encoded, forKey: "userInfo")
        }
    }
    
    //    MARK:-  Email Validation  -
    func isValidEmail( emailAddress : String) -> Bool {
        
        let emailRegEx      = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPredicate.evaluate(with: emailAddress) {
            return true
        }
        return false
    }
    
    //    MARK:-  Password Validation  -
    func isValidPassword(_ password: String) -> Bool {
//        Use this for proper password validation with minimum 8 charcter length
//        let passwordRegEx = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        //Used for the give credentials...
        let passwordRegEx = "^(?=.*[A-Za-z]).{6,}$"

        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    //MARK: -  Display Swift Message  -
    func showSwiftSuccessMessage( body : String ){
        
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        warning.configureContent(title: "", body: body, iconImage: #imageLiteral(resourceName: "Mask Group 23.png"))
        warning.button?.isHidden        = true
        SwiftMessages.show(view: warning)
    }
    
    
    //    MARK:-  LoginField validation Alert  -
        func loginAlert(Status : Int)  {
            if Status == 0 {
                showSwiftSuccessMessage(body: "Enter Email and Password")
            } else if Status == 1 {
                showSwiftSuccessMessage(body: "Enter a Email.")
            } else if Status == 2 {
                showSwiftSuccessMessage(body: "Enter a valid Email.")
            } else if Status == 3 {
                showSwiftSuccessMessage(body: "Enter a Password.")
            } else if Status == 4 {
                showSwiftSuccessMessage(body: "Enter a valid Password.")
            }
        }
    
    
}
