//
//  PostsViewController.swift
//  codignTest
//
//  Created by Pawan Dhull on 23/02/21.
//

import UIKit

class PostsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideTableView: UITableView!
    
    
    var titleArray = [String]()
    var userID = [Int]()
    var id = [Int]()
    var body = [String]()
    var photoArray = [Posts]()
    
    var isSidebarEnabled : Bool = false
    
    var sideMenuArray = ["Dashboard", "Logout"]
    var sideMenuImgArray = [#imageLiteral(resourceName: "Mask Group 21"),#imageLiteral(resourceName: "Mask Group -1"),#imageLiteral(resourceName: "Mask Group 22")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.separatorStyle = .none

        let userEmail = "Email: \(UserDefaults.standard.value(forKey: "email")!)"
        self.sideMenuArray.insert(userEmail , at: 0)
        self.tblView.estimatedRowHeight = 150.0
        self.tblView.rowHeight = UITableView.automaticDimension

        sideView.isHidden = true
        sideTableView.isHidden = true
        self.tblView.reloadData()
        self.sideTableView.reloadData()
        getPosts()
        
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        if isSidebarEnabled {
            sideView.isHidden = true
            sideTableView.isHidden = true
            UIView.animate(withDuration: 0.2) {
                self.sideView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.bounds.height)
                self.sideTableView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.bounds.height)
                
                self.isSidebarEnabled = false
            }
        } else {
            self.sideTableView.reloadData()
            UIView.animate(withDuration: 0.2) {
                self.sideView.isHidden = false
                self.sideTableView.isHidden = false
                
                self.sideView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width / 1.5, height: self.view.bounds.height)
                self.sideTableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width / 1.5, height: self.view.bounds.height)
                
                self.isSidebarEnabled = true
            }
           
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count  : Int?
        if tableView == self.tblView {
            count = self.id.count
        }
        if tableView == self.sideTableView {
            count = 3
        }
        return count!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heigth : CGFloat?
        if tableView == self.tblView {
            heigth = 150.0
        }
        if tableView == self.sideTableView {
            heigth = 45.0
        }
        return heigth!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if tableView == self.tblView {
            let postCell : PostsCell!
            
            postCell = tableView.dequeueReusableCell(withIdentifier: "PostsCell" ) as? PostsCell
            
            postCell!.titleLbl.text = titleArray[indexPath.row]
            postCell!.userId.text  = String(userID[indexPath.row])
            postCell!.Id.text       = String(id[indexPath.row])
            postCell!.body.text       = String(body[indexPath.row])
            postCell!.selectionStyle = .none
            cell = postCell
            
        }
        if tableView == self.sideTableView {
            let sideCell : UITableViewCell!
            sideCell = tableView.dequeueReusableCell(withIdentifier: "SideCell", for: indexPath)
            sideCell.textLabel?.text = sideMenuArray[indexPath.row]
            
            sideCell.selectionStyle = .none
            cell = sideCell
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.sideTableView {
            if sideMenuArray[indexPath.row] == "Email" {
                print("email")
            }else {
                print("other menu")
            }
        }
    }
    
    
    
    func getPosts() {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            //                print(error)
            //                print(response)
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    print("jsonResonse is :")
                    print(jsonResult)
                    for photo in jsonResult{
                        let dict = photo as! NSDictionary
                        self.titleArray.append(dict.value(forKey: "title") as! String)
                        self.userID.append(dict.value(forKey: "userId") as! Int)
                        self.id.append(dict.value(forKey: "id") as! Int)
                        self.body.append(dict.value(forKey: "body") as! String)
                        
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                        }
                    }
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
        
        
    }
    
}
