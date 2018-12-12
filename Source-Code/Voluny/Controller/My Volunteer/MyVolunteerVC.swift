//
//  MyVolunteerVC.swift
//  Voluny
//


import UIKit
import Firebase

class MyVolunteerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var acceptedCountLabel: UILabel!
    @IBOutlet weak var pendingCountLabel: UILabel!
    @IBOutlet weak var declinedCountLabel: UILabel!
    
    var acceptedExperiences = [MyVolunteerExperience]()
    var pendingExperiences = [MyVolunteerExperience]()
    var declinedExperiences = [MyVolunteerExperience]()
    
    var selectedOption = "" // Either Accepted or Pending depending on what kind of status the user taps on when hits reviews in the options menu
    var selectedAccepted: MyVolunteerExperience! // We store the accepted experience when the user hits on reviews in the options menu to get the date of the experience to see if it's in the past now, if it is, he can write reviews
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        indicator.startAnimating()
        
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets.init(top: -dummyViewHeight, left: 0, bottom: 30, right: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginClosed), name: Notification.Name("loginClosed"), object: nil)
    }
    
    @objc func loginClosed(_ notification: Notification){
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAccepted()
        loadPending()
        loadDeclined()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if Auth.auth().currentUser?.isAnonymous == true{ // If user is not logged in yet, we need to present the login screens first
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "login", sender: nil)
            })
        }else{
            //loadUserInfo() // This produces crash after signing in, maybe consider viewdidappear
        }
    }
    
    // MARK: Loading the statuses
    func loadAccepted(){
        DataService.instance.getExperiencesForStatus(userID: (Auth.auth().currentUser?.uid)!, status: "acceptedExperiences") { (returnedExperiences) in
            self.acceptedExperiences = returnedExperiences
            self.acceptedCountLabel.text = String(returnedExperiences.count)
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }
    
    func loadPending(){
        DataService.instance.getExperiencesForStatus(userID: (Auth.auth().currentUser?.uid)!, status: "pendingExperiences") { (returnedExperiences) in
            self.pendingExperiences = returnedExperiences
            self.pendingCountLabel.text = String(returnedExperiences.count)
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }
    
    func loadDeclined(){
        DataService.instance.getExperiencesForStatus(userID: (Auth.auth().currentUser?.uid)!, status: "declinedExperiences") { (returnedExperiences) in
            self.declinedExperiences = returnedExperiences
            self.declinedCountLabel.text = String(returnedExperiences.count)
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }
    
    // MARK: Option Menu Actions
    @objc func optionTapped(sender: UIButton){
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! MyVolunteerCell
        cell.optionsMenu.isHidden = false
    }
    
    @objc func requestTapped(sender: UIButton){
        print("rquest tapped")
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! MyVolunteerCell
        cell.optionsMenu.isHidden = true
        print("indexPath: ", indexPath.row)
        print("uid: ", (Auth.auth().currentUser?.uid)!)
        print("expID: ", acceptedExperiences[sender.tag].expID)
        
        DataService.instance.deleteUserApplication(uid: (Auth.auth().currentUser?.uid)!, expID: acceptedExperiences[sender.tag].expID, recruiterID: acceptedExperiences[sender.tag].recruiterID)
        loadAccepted()
        loadPending()
        loadDeclined()
    }
    
    @objc func reviewTapped(sender: UIButton){
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! MyVolunteerCell
        cell.optionsMenu.isHidden = true
        print("expID: ", acceptedExperiences[sender.tag].expID)
        selectedOption = "accepted"
        selectedAccepted = acceptedExperiences[sender.tag]
        performSegue(withIdentifier: "review", sender: acceptedExperiences[sender.tag].expID)
    }
    
    @objc func PendingoptionTapped(sender: UIButton){
        let indexPath = IndexPath.init(row: sender.tag, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as! MyVolunteerNonCell
        cell.optionsMenu.isHidden = false
    }
    
    @objc func PendingrequestTapped(sender: UIButton){
        print("rquest tapped")
        let indexPath = IndexPath.init(row: sender.tag, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as! MyVolunteerNonCell
        cell.optionsMenu.isHidden = true
        print("indexPath: ", indexPath.row)
        print("uid: ", (Auth.auth().currentUser?.uid)!)
        print("expID: ", pendingExperiences[sender.tag].expID)
        
        DataService.instance.deleteUserApplication(uid: (Auth.auth().currentUser?.uid)!, expID: pendingExperiences[sender.tag].expID, recruiterID: pendingExperiences[sender.tag].recruiterID)
        loadAccepted()
        loadPending()
        loadDeclined()
    }
    
    @objc func PendingreviewTapped(sender: UIButton){
        let indexPath = IndexPath.init(row: sender.tag, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as! MyVolunteerNonCell
        cell.optionsMenu.isHidden = true
        print("expID: ", pendingExperiences[sender.tag].expID)
        selectedOption = "pending"
        performSegue(withIdentifier: "review", sender: pendingExperiences[sender.tag].expID)
    }
    
    @objc func redDotsTapped(sender: UIButton){
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! MyVolunteerCell
        cell.optionsMenu.isHidden = true
    }
    
    @objc func whiteDotsTapped(sender: UIButton){
        let indexPath = IndexPath.init(row: sender.tag, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as! MyVolunteerNonCell
        cell.optionsMenu.isHidden = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "review"{
            let destination = segue.destination as! OpenedExperienceReviewsVC
            destination.experienceID = sender as? String
            
            if selectedOption == "accepted"{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                let date = dateFormatter.date(from: "\(selectedAccepted.date) \(selectedAccepted.time)")
                print(date!)
                if date! > Date(){ // If the accepted experience didn't happen yet, the user cannot reviews yet, only when it's in the past
                    destination.isWriteMode = false
                }else{
                    destination.isWriteMode = true
                }
            }else{ // User wants to read reviews of a pending experience, so the user cannot post new reviews yet
                destination.isWriteMode = false
            }
            
            
        }
    }
    
}

// MARK: TableView delegate methods
extension MyVolunteerVC{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return acceptedExperiences.count
        }
        
        if section == 1{
            return pendingExperiences.count
        }
        
        if section == 2{
            return declinedExperiences.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFilled") as! MyVolunteerCell
            cell.configureCell(experience: acceptedExperiences[indexPath.row])
            
            cell.optionButton.tag = indexPath.row
            cell.optionButton.addTarget(self, action: #selector(optionTapped(sender:)), for: .touchUpInside)
            
            cell.requestButton.tag = indexPath.row
            cell.requestButton.addTarget(self, action: #selector(requestTapped(sender:)), for: .touchUpInside)
            
            cell.reviewsButton.tag = indexPath.row
            cell.reviewsButton.addTarget(self, action: #selector(reviewTapped(sender:)), for: .touchUpInside)
            
            cell.redDotsButton.tag = indexPath.row
            cell.redDotsButton.addTarget(self, action: #selector(redDotsTapped), for: .touchUpInside)
            return cell
        }
        
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUnfilled") as! MyVolunteerNonCell
            cell.configureCell(experience: pendingExperiences[indexPath.row], section: 1)
            cell.iconImage.image = UIImage(named: "Pending: Icon")
            cell.optionsButton.isHidden = false
            
            cell.optionsButton.tag = indexPath.row
            cell.optionsButton.addTarget(self, action: #selector(PendingoptionTapped(sender:)), for: .touchUpInside)
            
            cell.requestButton.tag = indexPath.row
            cell.requestButton.addTarget(self, action: #selector(PendingrequestTapped(sender:)), for: .touchUpInside)
            
            cell.reviewButton.tag = indexPath.row
            cell.reviewButton.addTarget(self, action: #selector(PendingreviewTapped(sender:)), for: .touchUpInside)
            
            cell.whiteDotsButton.tag = indexPath.row
            cell.whiteDotsButton.addTarget(self, action: #selector(whiteDotsTapped), for: .touchUpInside)
            
            return cell
        }
        
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUnfilled") as! MyVolunteerNonCell
            cell.configureCell(experience: declinedExperiences[indexPath.row], section: 2)
            cell.iconImage.image = UIImage(named: "Declined: Icon")
            
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUnfilled") as! MyVolunteerNonCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! MyHeaderCell
        switch section{
        case 0:
            if acceptedExperiences.count > 0{
                cell.titleLabel.text = "ACCEPTED"
            }
        case 1:
            if pendingExperiences.count > 0{
                cell.titleLabel.text = "PENDING"
            }
        case 2:
            if declinedExperiences.count > 0{
                cell.titleLabel.text = "DECLINED"
            }
        default:
            cell.titleLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            if acceptedExperiences.count > 0{
                return 50
            }else{
                return 0
            }
        case 1:
            if pendingExperiences.count > 0{
                return 50
            }else{
                return 0
            }
        case 2:
            if declinedExperiences.count > 0{
                return 50
            }else{
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat(integerLiteral: 156)
        }else{
            return CGFloat(integerLiteral: 80)
        }
    }
}
