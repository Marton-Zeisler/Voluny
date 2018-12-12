//
//  LastStatusConfig.swift
//  Voluny
//


import UIKit
import Firebase

extension HomeVC{
    
    func loadStatusesAnon(){
        status1View.backgroundColor = UIColor.white
        status1View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
        status1View.layer.borderWidth = 1
        status1Image.image = UIImage(named: "No Status: Icon.png")
        status1Title.text = "No Status"
        status1ExperienceLabel.text = "Apply & Volunteer now!"
        status1Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
        status1ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
        
        status2View.backgroundColor = UIColor.white
        status2View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
        status2View.layer.borderWidth = 1
        status2Image.image = UIImage(named: "No Status: Icon.png")
        status2Title.text = "No Status"
        status2ExperienceLabel.text = "Apply & Volunteer now!"
        status2Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
        status2ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
        
        status3View.backgroundColor = UIColor.white
        status3View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
        status3View.layer.borderWidth = 1
        status3Image.image = UIImage(named: "No Status: Icon.png")
        status3Title.text = "No Status"
        status3ExperienceLabel.text = "Apply & Volunteer now!"
        status3Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
        status3ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
    }
    
    
    func loadStatuses(){
        DataService.instance.getLast3Statuses(userID: (Auth.auth().currentUser?.uid)!) { (returnedStatuses) in
            
            switch returnedStatuses.count{
            case 0:
                self.status1View.backgroundColor = UIColor.white
                self.status1View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status1View.layer.borderWidth = 1
                self.status1Image.image = UIImage(named: "No Status: Icon.png")
                self.status1Title.text = "No Status"
                self.status1ExperienceLabel.text = "Apply & Volunteer now!"
                self.status1Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status1ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                
                self.status2View.backgroundColor = UIColor.white
                self.status2View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status2View.layer.borderWidth = 1
                self.status2Image.image = UIImage(named: "No Status: Icon.png")
                self.status2Title.text = "No Status"
                self.status2ExperienceLabel.text = "Apply & Volunteer now!"
                self.status2Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status2ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                
                self.status3View.backgroundColor = UIColor.white
                self.status3View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status3View.layer.borderWidth = 1
                self.status3Image.image = UIImage(named: "No Status: Icon.png")
                self.status3Title.text = "No Status"
                self.status3ExperienceLabel.text = "Apply & Volunteer now!"
                self.status3Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status3ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                
            case 1:
                self.status1View.layer.borderWidth = 1
                self.status1Title.text = returnedStatuses[0].status
                self.status1ExperienceLabel.text = returnedStatuses[0].title
                
                if returnedStatuses[0].status == "pending"{
                    self.status1Image.image = UIImage(named: "Pending: Icon")
                    
                    self.status1View.backgroundColor = UIColor.white
                    self.status1View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1Title.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1ExperienceLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                }else if returnedStatuses[0].status == "accepted"{
                    self.status1Image.image = UIImage(named: "Accepted: Icon.png")
                    
                    self.status1View.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1Title.textColor = UIColor.white
                    self.status1ExperienceLabel.textColor = UIColor.white
                }else{
                    self.status1Image.image = UIImage(named: "Declined: Icon.png")
                    
                    self.status1View.backgroundColor = UIColor.white
                    self.status1View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                    self.status1Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                    self.status1ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                }
                
                
                
                self.status2View.backgroundColor = UIColor.white
                self.status2View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status2View.layer.borderWidth = 1
                self.status2Image.image = UIImage(named: "No Status: Icon.png")
                self.status2Title.text = "No Status"
                self.status2ExperienceLabel.text = "Apply & Volunteer now!"
                self.status2Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status2ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                
                self.status3View.backgroundColor = UIColor.white
                self.status3View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status3View.layer.borderWidth = 1
                self.status3Image.image = UIImage(named: "No Status: Icon.png")
                self.status3Title.text = "No Status"
                self.status3ExperienceLabel.text = "Apply & Volunteer now!"
                self.status3Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status3ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
            case 2:
                self.status1View.layer.borderWidth = 1
                self.status1Title.text = returnedStatuses[0].status
                self.status1ExperienceLabel.text = returnedStatuses[0].title
                
                if returnedStatuses[0].status == "pending"{
                    self.status1Image.image = UIImage(named: "Pending: Icon")
                    
                    self.status1View.backgroundColor = UIColor.white
                    self.status1View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1Title.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1ExperienceLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                }else if returnedStatuses[0].status == "accepted"{
                    self.status1Image.image = UIImage(named: "Accepted: Icon.png")
                    
                    self.status1View.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1Title.textColor = UIColor.white
                    self.status1ExperienceLabel.textColor = UIColor.white
                }else{
                    self.status1Image.image = UIImage(named: "Declined: Icon.png")
                    
                    self.status1View.backgroundColor = UIColor.white
                    self.status1View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                    self.status1Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                    self.status1ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                }
                
                
                
                self.status2View.layer.borderWidth = 1
                self.status2Title.text = returnedStatuses[1].status
                self.status2ExperienceLabel.text = returnedStatuses[1].title
                
                if returnedStatuses[1].status == "pending"{
                    self.status2Image.image = UIImage(named: "Pending: Icon")
                    
                    self.status2View.backgroundColor = UIColor.white
                    self.status2View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status2Title.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status2ExperienceLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                }else if returnedStatuses[1].status == "accepted"{
                    self.status2Image.image = UIImage(named: "Accepted: Icon.png")
                    
                    self.status2View.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status2View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status2Title.textColor = UIColor.white
                    self.status2ExperienceLabel.textColor = UIColor.white
                }else{
                    self.status2Image.image = UIImage(named: "Declined: Icon.png")
                    
                    self.status2View.backgroundColor = UIColor.white
                    self.status2View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                    self.status2Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                    self.status2ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                }
                
                self.status3View.backgroundColor = UIColor.white
                self.status3View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status3View.layer.borderWidth = 1
                self.status3Image.image = UIImage(named: "No Status: Icon.png")
                self.status3Title.text = "No Status"
                self.status3ExperienceLabel.text = "Apply & Volunteer now!"
                self.status3Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status3ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
            case 3:
                self.status1View.layer.borderWidth = 1
                self.status1Title.text = returnedStatuses[0].status
                self.status1ExperienceLabel.text = returnedStatuses[0].title
                
                if returnedStatuses[0].status == "pending"{
                    self.status1Image.image = UIImage(named: "Pending: Icon")
                    
                    self.status1View.backgroundColor = UIColor.white
                    self.status1View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1Title.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1ExperienceLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                }else if returnedStatuses[0].status == "accepted"{
                    self.status1Image.image = UIImage(named: "Accepted: Icon.png")
                    
                    self.status1View.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status1Title.textColor = UIColor.white
                    self.status1ExperienceLabel.textColor = UIColor.white
                }else{
                    self.status1Image.image = UIImage(named: "Declined: Icon.png")
                    
                    self.status1View.backgroundColor = UIColor.white
                    self.status1View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                    self.status1Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                    self.status1ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                }
                
                
                
                self.status2View.layer.borderWidth = 1
                self.status2Title.text = returnedStatuses[1].status
                self.status2ExperienceLabel.text = returnedStatuses[1].title
                
                if returnedStatuses[1].status == "pending"{
                    self.status2Image.image = UIImage(named: "Pending: Icon")
                    
                    self.status2View.backgroundColor = UIColor.white
                    self.status2View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status2Title.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status2ExperienceLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                }else if returnedStatuses[1].status == "accepted"{
                    self.status2Image.image = UIImage(named: "Accepted: Icon.png")
                    
                    self.status2View.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status2View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status2Title.textColor = UIColor.white
                    self.status2ExperienceLabel.textColor = UIColor.white
                }else{
                    self.status2Image.image = UIImage(named: "Declined: Icon.png")
                    
                    self.status2View.backgroundColor = UIColor.white
                    self.status2View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                    self.status2Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                    self.status2ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                }

                
                self.status3View.layer.borderWidth = 1
                self.status3Title.text = returnedStatuses[2].status
                self.status3ExperienceLabel.text = returnedStatuses[2].title
                
                if returnedStatuses[2].status == "pending"{
                    self.status3Image.image = UIImage(named: "Pending: Icon")
                    
                    self.status3View.backgroundColor = UIColor.white
                    self.status3View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status3Title.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status3ExperienceLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                }else if returnedStatuses[2].status == "accepted"{
                    self.status3Image.image = UIImage(named: "Accepted: Icon.png")
                    
                    self.status3View.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status3View.layer.borderColor = #colorLiteral(red: 0.831372549, green: 0.4117647059, blue: 0.5215686275, alpha: 1)
                    self.status3Title.textColor = UIColor.white
                    self.status3ExperienceLabel.textColor = UIColor.white
                }else{
                    self.status3Image.image = UIImage(named: "Declined: Icon.png")
                    
                    self.status3View.backgroundColor = UIColor.white
                    self.status3View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                    self.status3Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                    self.status3ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                }
                
            default:
                self.status1View.backgroundColor = UIColor.white
                self.status1View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status1View.layer.borderWidth = 1
                self.status1Image.image = UIImage(named: "No Status: Icon.png")
                self.status1Title.text = "No Status"
                self.status1ExperienceLabel.text = "Apply & Volunteer now!"
                self.status1Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status1ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                
                self.status2View.backgroundColor = UIColor.white
                self.status2View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status2View.layer.borderWidth = 1
                self.status2Image.image = UIImage(named: "No Status: Icon.png")
                self.status2Title.text = "No Status"
                self.status2ExperienceLabel.text = "Apply & Volunteer now!"
                self.status2Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status2ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                
                self.status3View.backgroundColor = UIColor.white
                self.status3View.layer.borderColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0).cgColor
                self.status3View.layer.borderWidth = 1
                self.status3Image.image = UIImage(named: "No Status: Icon.png")
                self.status3Title.text = "No Status"
                self.status3ExperienceLabel.text = "Apply & Volunteer now!"
                self.status3Title.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
                self.status3ExperienceLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
            }
            self.statusIndicator.stopAnimating()
            self.statusIndicator.isHidden = true
        }
    }
    
    
}
