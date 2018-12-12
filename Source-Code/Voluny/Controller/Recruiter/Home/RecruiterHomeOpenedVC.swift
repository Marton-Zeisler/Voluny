//
//  RecruiterHomeOpenedVC.swift
//  Voluny
//


import UIKit
import Cosmos
import SDWebImage
import Firebase

class RecruiterHomeOpenedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var organisationLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var starsView: CosmosView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ageGroupLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedExperiece: RecruiterActiveExperience!
    
    @IBOutlet weak var tableview: UITableView!
    
    var pendingPeople = [Volunteer]()
    var acceptedPeople = [Volunteer]()
    var declinedPeople = [Volunteer]()
    
    var selectedPeople = [Volunteer]()
    var selectedPerson: Volunteer!
    
    // pending
    @IBOutlet weak var pendingView: ManageViews!
    @IBOutlet weak var pendingNumber: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var arrowPendingImageView: UIImageView!
    
    
    // accepted
    @IBOutlet weak var acceptedView: ManageViews!
    @IBOutlet weak var acceptedNumber: UILabel!
    @IBOutlet weak var acceptedLabel: UILabel!
    @IBOutlet weak var arrowAcceptedImageView: UIImageView!
    
    // decline
    @IBOutlet weak var declineView: ManageViews!
    @IBOutlet weak var declineNumber: UILabel!
    @IBOutlet weak var declineLabel: UILabel!
    @IBOutlet weak var arrowDeclinedImageView: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var selectedType = "pendingPeople"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        loadInfo()
        pendingView.isShadowEnabled(enabled: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo), name: Notification.Name("updateInfo"), object: nil)
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPending()
        loadAccepted()
        loadDeclines()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func updateInfo(_ notification: Notification){
        if let data = notification.object as? RecruiterActiveExperience{
            selectedExperiece = data
            loadInfo()
        }
    }
    
    func loadPending(){
        DataService.instance.getPendingPeople(userID: (Auth.auth().currentUser?.uid)!, expID: selectedExperiece.expID) { (pendingArray, isEmpty) in
            if pendingArray.count >= 2{
                self.pendingLabel.text = "Pending"
            }else{
                self.pendingLabel.text = "Pending"
            }
            self.pendingNumber.text = "\(pendingArray.count)"
            self.pendingPeople = pendingArray

            if self.selectedType == "pendingPeople"{
                self.selectedPeople = pendingArray
                self.tableview.reloadData()
            }

            
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
       
        }
    }
    
    func loadAccepted(){
        DataService.instance.getAcceptedPeople(userID: (Auth.auth().currentUser?.uid)!, expID: selectedExperiece.expID) { (acceptedArray, isEmpty) in
            if acceptedArray.count >= 2{
                self.acceptedLabel.text = "Accepted"
            }else{
                self.acceptedLabel.text = "Accepted"
            }
            self.acceptedNumber.text = "\(acceptedArray.count)"
            self.acceptedPeople = acceptedArray
            
            if self.selectedType == "acceptedPeople"{
                self.selectedPeople = acceptedArray
                self.tableview.reloadData()
            }
        }
    }
    
    func loadDeclines(){
        DataService.instance.getDeclinedPeople(userID: (Auth.auth().currentUser?.uid)!, expID: selectedExperiece.expID) { (declinedArray, isEmpty) in
            if declinedArray.count >= 2{
                self.declineLabel.text = "Declined"
            }else{
                self.declineLabel.text = "Declined"
            }
            self.declineNumber.text = "\(declinedArray.count)"
            self.declinedPeople = declinedArray
            
            if self.selectedType == "declinedPeople"{
                self.selectedPeople = declinedArray
                self.tableview.reloadData()
            }
            
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManageCell
        cell.nameLabel.text = selectedPeople[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        
        
        if selectedType == "pendingPeople"{
            selectedPerson = pendingPeople[indexPath.row]
            performSegue(withIdentifier: "user", sender: "pendingPeople")

        }else if selectedType == "acceptedPeople"{
            selectedPerson = acceptedPeople[indexPath.row]
            performSegue(withIdentifier: "user", sender: "acceptedPeople")

        }else{
            selectedPerson = declinedPeople[indexPath.row]
            performSegue(withIdentifier: "user", sender: "declinedPeople")
        }
            
            
    }
    
    func loadInfo(){
        organisationLabel.text = selectedExperiece.organisation
        titleLabel.text = selectedExperiece.title
        starsView.rating = selectedExperiece.rating
        dateLabel.text = selectedExperiece.date
        ageGroupLabel.text = selectedExperiece.age
        locationLabel.text = selectedExperiece.location
        timeLabel.text = selectedExperiece.time
        
    }

    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pendingTapped(_ sender: Any) {
        selectedType = "pendingPeople"
        
        selectedPeople = pendingPeople
        tableview.reloadData()
        
        pendingView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        pendingView.isShadowEnabled(enabled: true)
        pendingNumber.textColor = UIColor.white
        pendingLabel.textColor = UIColor.white
        //pendingImage.image = UIImage(named: "")
        arrowPendingImageView.alpha = 1.0
        
        acceptedView.backgroundColor = UIColor.white
        acceptedView.isShadowEnabled(enabled: false)
        acceptedNumber.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        acceptedLabel.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        arrowAcceptedImageView.alpha = 0.0
        
        
        declineView.backgroundColor = UIColor.white
        declineView.isShadowEnabled(enabled: false)
        declineNumber.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        declineLabel.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        arrowDeclinedImageView.alpha = 0.0
    }
    
    @IBAction func acceptedTapped(_ sender: Any) {
        selectedType = "acceptedPeople"
        
        selectedPeople = acceptedPeople
        tableview.reloadData()
        
        acceptedView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        acceptedView.isShadowEnabled(enabled: true)
        acceptedNumber.textColor = UIColor.white
        acceptedLabel.textColor = UIColor.white
        arrowAcceptedImageView.alpha = 1.0
        
        pendingView.backgroundColor = UIColor.white
        pendingView.isShadowEnabled(enabled: false)
        pendingNumber.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        pendingLabel.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        arrowPendingImageView.alpha = 0.0

        declineView.backgroundColor = UIColor.white
        declineView.isShadowEnabled(enabled: false)
        declineNumber.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        declineLabel.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        arrowDeclinedImageView.alpha = 0.0
        
    }
    
    
    @IBAction func declineTapped(_ sender: Any) {
        selectedType = "declinedPeople"
        
        selectedPeople = declinedPeople
        tableview.reloadData()
        
        declineView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        declineView.isShadowEnabled(enabled: true)
        declineNumber.textColor = UIColor.white
        declineLabel.textColor = UIColor.white
        arrowDeclinedImageView.alpha = 1.0
        
        pendingView.backgroundColor = UIColor.white
        pendingView.isShadowEnabled(enabled: false)
        pendingNumber.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        pendingLabel.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        arrowPendingImageView.alpha = 0.0
        
        acceptedView.backgroundColor = UIColor.white
        acceptedView.isShadowEnabled(enabled: false)
        acceptedNumber.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        acceptedLabel.textColor = #colorLiteral(red: 0.8470588235, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        arrowAcceptedImageView.alpha = 0.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "user"{
            let destination = segue.destination as! RecruiterTappedNameVC
            destination.selectedUser = selectedPerson
            destination.selectedUserPlace = sender as! String
            destination.expID = selectedExperiece.expID
            destination.selectedExperience = selectedExperiece
        }
        
        if segue.identifier == "edit"{
            let destination = segue.destination as! RecruiterPostingVC
            destination.editingExperience = selectedExperiece
            destination.isPosting = false
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: "Delete experience", message: "Are you sure you want to delete this experience?", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            DataService.instance.deleteExperience(userID: (Auth.auth().currentUser?.uid)!, expID: self.selectedExperiece.expID)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
        
    }
    
    @IBAction func editTapped(_ sender: Any) {
        performSegue(withIdentifier: "edit", sender: nil)
    }
    
    @IBAction func delete2Tapped(_ sender: Any) {
        deleteTapped(sender)
    }
    
    @IBAction func edit2Tapped(_ sender: Any) {
        editTapped(sender)
    }
    
    
    
    

}
// vicky is so beautiful

