//
//  NotificationVC.swift
//  Voluny
//


import UIKit
import Firebase

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var notifications = [ExperienceNotification]()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginClosed), name: Notification.Name("loginClosed"), object: nil)
    }
    
    @objc func loginClosed(_ notification: Notification){
        self.tabBarController?.selectedIndex = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if Auth.auth().currentUser?.isAnonymous == true{
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "login", sender: nil)
            })
        }else{
            loadNotifications()
        }
    }
    
    func loadNotifications(){
        indicator.startAnimating()
        DataService.instance.getNotifications(userID: (Auth.auth().currentUser?.uid)!) { (notificationArray) in
            //dates.sort { $0 < $1 }
            self.notifications = notificationArray
            self.notifications.sort { $0.nsDate > $1.nsDate }
            
            self.tableview.reloadData()
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            if notificationArray.count == 0{
                self.noLabel.isHidden = false
            }else{
                self.noLabel.isHidden = true
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NotificationCell else{
            return UITableViewCell()
        }
        
        if indexPath.row % 2 == 0{
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 0.9)
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
        
        cell.configureCell(notific: notifications[indexPath.row])
        
        return cell
        
    }



}
