//
//  NotificationCell.swift
//  Voluny
//


import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(notific: ExperienceNotification){
        if notific.status == "accepted"{
            statusImage.image = UIImage(named: "AcceptedNotifc")
            messageLabel.text = "You just got accepted to volunteer at \(notific.title)"
        }
        
        if notific.status == "pending"{
            statusImage.image = UIImage(named: "Pending: Icon")
            messageLabel.text = "Your application is being reviewed. Thanks for applying for \(notific.title)"
            timeLabel.text = notific.date
        }
        
        if notific.status == "declined"{
            statusImage.image = UIImage(named: "DeclinedNotifc")
            messageLabel.text = "Your application is being declined. Thanks for applying for \(notific.title)"
            timeLabel.text = notific.date
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = dateFormatter.date(from: notific.date)
        timeLabel.text = timeAgoSince(date!)
    
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
