//
//  RecruiterNotificCell.swift
//  Voluny
//


import UIKit

class RecruiterNotificCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var viewDetailsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(notific: RecruiterNotification){
        messageLabel.text = "\(notific.volunteer) applied to \(notific.title)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = dateFormatter.date(from: notific.date)
        timeLabel.text = timeAgoSince(date!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
