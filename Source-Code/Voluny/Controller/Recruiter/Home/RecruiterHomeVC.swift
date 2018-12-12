//
//  RecruiterHomeVC.swift
//  Voluny
//


import UIKit
import Firebase

class RecruiterHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pastIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var activeTableview: UITableView!
    
    @IBOutlet weak var pastCollectionview: UICollectionView!
    
    var activeExperiences = [RecruiterActiveExperience]()
    
    var pastExperiences = [RecruiterActiveExperience]()
    
    @IBOutlet weak var noLabel: UILabel!
    
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeTableview.delegate = self
        activeTableview.dataSource = self

        pastCollectionview.delegate = self
        pastCollectionview.dataSource = self
        
        activeIndicator.startAnimating()
        pastIndicator.startAnimating()
    
    
        DataService.instance.isUserVolunteer(uid: (Auth.auth().currentUser?.uid)!) { (isVolunteer) in
            if isVolunteer == true{
                print("volunteer")
            }else{
                print("recruiter")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        let x = Double(UIScreen.main.bounds.width / 4.0 )
        //let y = Double(UIScreen.main.bounds.height * 0.123) //Double(UIScreen.main.bounds.height * 0.08831521739)
        var y = 0.0
        
        if UIScreen.main.bounds.height == 667{ // iphone 8
            y = 65.0
        }else if UIScreen.main.bounds.height >= 812{ // iphone x
            y = 100.0
        }else if UIScreen.main.bounds.height == 736{
            y = 65.0
        }else if UIScreen.main.bounds.height == 568{
            y = 55.0
        }else{
            y = 65.0
        }
        
        // Setting the background color of tab bar
        let tabBarImg = UIImage(named: "tabBarImage")?.resizeImage(CGSize(width: x, height: y))
        self.tabBarController?.tabBar.selectionIndicatorImage =  tabBarImg
        
    }
    
    func imageSet(from color: UIColor, for size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        autoreleasepool {
            UIGraphicsBeginImageContext(rect.size)
        }
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadActive()
        //loadPast()
    }
    
//    func loadPast(){
//        DataService.instance.getPastExperiences(userID: (Auth.auth().currentUser?.uid)!) { (experiences) in
//            self.pastExperiences = experiences
//            self.pastIndicator.stopAnimating()
//            self.pastIndicator.isHidden = true
//            self.pastCollectionview.reloadData()
//        }
//    }
    
    func loadActive(){
        DataService.instance.getActiveExperiencesHome(userID: (Auth.auth().currentUser?.uid)!) { (experiences, pastExps) in
            self.activeExperiences = experiences
            self.activeIndicator.stopAnimating()
            self.activeIndicator.isHidden = true
            self.activeTableview.reloadData()
            if experiences.count == 0{
                self.postButton.isHidden = false
            }else{
                self.postButton.isHidden = true
            }
            
            self.pastExperiences = pastExps
            self.pastIndicator.stopAnimating()
            self.pastIndicator.isHidden = true
            self.pastCollectionview.reloadData()
            if pastExps.count == 0{
                self.noLabel.isHidden = false
            }else{
                self.noLabel.isHidden = true
            }
        }
    }
    
    @IBAction func postTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeExperiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecruiterHomeCell
        cell.configureCell(exp: activeExperiences[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height >= 345 ? tableView.frame.height / 3 : tableView.frame.height / 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastExperiences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecruiterPastCell

        cell.layer.cornerRadius = 8

        cell.configureCell(exp: pastExperiences[indexPath.row])
    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.86, height: pastCollectionview.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == activeTableview{
            self.hidesBottomBarWhenPushed = true
            performSegue(withIdentifier: "tapped", sender: indexPath.row)
            self.hidesBottomBarWhenPushed = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tapped"{
            let destination = segue.destination as? RecruiterHomeOpenedVC
            destination?.selectedExperiece = activeExperiences[sender as! Int]
        }
    }
    

    @IBAction func signOutTapped(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            let firstVC = storyboard?.instantiateViewController(withIdentifier: "start")
            DispatchQueue.main.async {
                self.present(firstVC!, animated: false, completion: nil)
            }
            print("Firebase: Successfully signed out!")
        }catch let signOutError as NSError{
            print("Error signing out: \(signOutError)")
        }
    }
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        do{
            try Auth.auth().signOut()
            let firstVC = storyboard?.instantiateViewController(withIdentifier: "start")
            DispatchQueue.main.async {
                self.present(firstVC!, animated: false, completion: nil)
            }
            print("Firebase: Successfully signed out!")
        }catch let signOutError as NSError{
            print("Error signing out: \(signOutError)")
        }
    }
    


}





