//
//  PhotosViewController.swift
//  codignTest
//
//  Created by Pawan Dhull on 23/02/21.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    
    var titleArray = [String]()
    var albumId = [Int]()
    var id = [Int]()
    var imageURL = [String]()
    var photoArray = [Photos]()
    
    
    @IBOutlet weak var sideView: UIView!
    
    @IBOutlet weak var sideTableView: UITableView!
   
    var isSidebarEnabled : Bool = false
    
    var sideMenuArray = ["Dashboard", "Logout"]
    var sideMenuImgArray = [#imageLiteral(resourceName: "Mask Group 21"),#imageLiteral(resourceName: "Mask Group -1"),#imageLiteral(resourceName: "Mask Group 22")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.separatorStyle = .none
        getPhotos2()
        let userEmail = "Email: \(UserDefaults.standard.value(forKey: "email")!)"
        self.sideMenuArray.insert(userEmail , at: 0)

        sideView.isHidden = true
        sideTableView.isHidden = true
        
    }
    
   
    
    //Side menu code
    @IBAction func sideMenu(_ sender: Any) {
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
            count = self.titleArray.count
        }
        if tableView == self.sideTableView {
            count = 3
        }
        return count!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heigth : CGFloat?
        if tableView == self.tblView {
            heigth = 140.0
        }
        if tableView == self.sideTableView {
            heigth = 45.0
        }
        return heigth!

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if tableView == self.tblView {
            let photoCell : PhotosCardTableViewCell?
            
            photoCell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell" ) as? PhotosCardTableViewCell
            
            photoCell!.titleLbl.text = titleArray[indexPath.row]
            photoCell!.albumId.text  = String(albumId[indexPath.row])
            photoCell!.Id.text       = String(id[indexPath.row])
            photoCell!.cellImage.image = getImage(url: imageURL[indexPath.row]) ?? #imageLiteral(resourceName: "Mask Group 23")
            photoCell!.selectionStyle = .none
            cell = photoCell
            
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
            if sideMenuArray[indexPath.row] == "Logout" {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let VC          = storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.dismiss(animated: true) {
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "loginStatus")
                }
            }else {
                print("other menu")
            }
        }
    }
    
    
    func getImage(url : String) -> UIImage? {
        // Create URL
        var image = UIImage()
        let url = URL(string: url)!
        
        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                
                image = UIImage(data: data)!
                
            }
        }
        return image
    }
    
    
    func getPhotos2() {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
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
                        self.albumId.append(dict.value(forKey: "albumId") as! Int)
                        self.id.append(dict.value(forKey: "id") as! Int)
                        self.imageURL.append(dict.value(forKey: "url") as! String)
                        
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

