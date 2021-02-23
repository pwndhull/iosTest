//
//  LoginViewController.swift
//  codignTest
//
//  Created by Pawan Dhull on 23/02/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func LoginAction(_ sender: Any) {
        let utils = Utils.shared
        
        //        if !(email.text!.isEmpty) {
        //            let isValidEmail = utils.isValidEmail(emailAddress: email.text!)
        //            if isValidEmail {
        //                if !(password.text!.isEmpty) {
        //                    let isvalidPass = utils.isValidPassword(password.text!)
        //                    (isvalidPass  && self.password.text!.count > 6) ? login() : utils.loginAlert(Status: 4)
        //                    password.text!.count > 6 ? login() :utils.loginAlert(Status: 4)
        //                } else {
        //                    utils.loginAlert(Status: 3)
        //                }
        //            } else {
        //                utils.loginAlert(Status: 2)
        //            }
        //        } else {
        //            if (password.text!.isEmpty){
        //                utils.loginAlert(Status: 0)
        //            }
        //            utils.loginAlert(Status: 1)
        //        }
        
        
        login()
        
        
    }
    
    
    func login()  {
//        ShowLoader(show: true)
        
        //        [ "email": self.email.text!,
        //                            "password": self.password.text!
        //        ]
        let parameters  =  [ "email": "eve.holt@reqres.in",
                             "password": "pistol"
        ]  as [String: AnyObject]
        
        let url =  URL(string: "https://reqres.in/api/login")
        ServiceManager._requestPost(url!, method: "POST", parameters: parameters) { (data, response, error) in
            if (error != nil) {
//                self.ShowLoader(show: false)
                
                print( "Error" , (error?.localizedDescription)! )
                Utils.shared.showSwiftSuccessMessage(body: (error?.localizedDescription)!)
            }
            else{
//                self.ShowLoader(show: false)
                
                do {
                    let decoder     = JSONDecoder()
                    let info        = try decoder.decode(InfoLoggedUser.self, from: data!)
                    
                    
                    if (info != nil && error == nil) {
                        let token = info.token!
                        //save token to user defaults
//                        UserDefaults.standard.setValue(self.email.text!, forKey: "email")
                        UserDefaults.standard.setValue("test@gmail.com", forKey: "email")

                        UserDefaults.standard.setValue(token, forKey: "token")
                        
                        // change Logged status to true.
                        UserDefaults.standard.set(true, forKey: "loginStatus")
                        
                        // Change App Root Controller To Main ViewController
                        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
                        let VC          = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                        self.present(VC, animated: true, completion: nil)
                    } else {
//                        self.ShowLoader(show: false)
                        print("error in parsing.")
                        
                    }
                } catch let _error {
                    
                    print( "Error" , _error )
                    Utils.shared.showSwiftSuccessMessage(body: (_error.localizedDescription))
                }
            }
        }
    }
    
    //    MARK:-   Show Loader  -
    func ShowLoader(show : Bool) {
        
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        if show {
            present(alert, animated: true, completion: nil)
        }else{
            dismiss(animated: false, completion: nil)
        }
        
    }
}
