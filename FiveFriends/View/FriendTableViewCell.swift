import UIKit
import Nuke

class FriendTableViewCell: UITableViewCell {

    static let identifier = "FriendTableViewCell"
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameAgeLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var bioTextView: UITextView!
    
    func configure(with friend: FriendDetail) {
        if let url = friend.photoUrl {
            Nuke.loadImage(with: url, into: profilePicture)
        }
        nameAgeLabel.text = "\(friend.name), \(friend.age)"
        phoneNumberLabel.text = friend.phoneNumber
        bioTextView.text = friend.biography
    }
}
