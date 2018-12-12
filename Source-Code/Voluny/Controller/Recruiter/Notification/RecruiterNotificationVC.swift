//
//  RecruiterNotificationVC.swift
//  Voluny
//


import UIKit
import Firebase

class RecruiterNotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var notifications = [RecruiterNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loadNotifications()
    }
    
    func loadNotifications(){
        indicator.startAnimating()
        DataService.instance.getRecruiterNotifications(userID: (Auth.auth().currentUser?.uid)!) { (notifics) in
            self.notifications = notifics
            self.notifications.sort { $0.nsDate > $1.nsDate }

            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            
            if notifics.count == 0{
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecruiterNotificCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(notific: notifications[indexPath.row])
        cell.viewDetailsButton.addTarget(self, action: #selector(self.viewTapped(sender:)), for: .touchUpInside)
        cell.viewDetailsButton.tag = indexPath.row
        
        if indexPath.row % 2 == 0{
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 0.9)
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
        
        
        DataService.instance.getDateFromExpID(expID: notifications[indexPath.row].expID) { (date) in
            if date < Date(){
                cell.buttonView.isHidden = true
            }else{
                cell.buttonView.isHidden = false
            }
        }
        

        return cell
    }
    
    @objc func viewTapped(sender: UIButton){
        DataService.instance.getActiveExperienceFromID(expID: notifications[sender.tag].expID) { (experience) in
            self.performSegue(withIdentifier: "more", sender: experience)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "more"{
            let destination = segue.destination as! RecruiterHomeOpenedVC
            destination.selectedExperiece = sender as! RecruiterActiveExperience
        }
    }


    



}
