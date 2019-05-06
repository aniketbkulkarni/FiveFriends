import UIKit
import Nuke

class FriendTableViewCell: UITableViewCell {

    static let identifier = "FriendTableViewCell"
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameAgeLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var bioTextView: UITextView!
    
    /**
     Sets up fields for this UITableViewCell using an item from our view model.
     
     - Parameter friend: Contains information about particular user.
    */
    func configure(with friend: FriendDetail) {
        if let url = friend.photoUrl {
            
            // TODO: Move image loading call to somewhere else.
            Nuke.loadImage(with: url, into: profilePicture)
        }
        nameAgeLabel.text = "\(friend.name), \(friend.age)"
        phoneNumberLabel.text = friend.phoneNumber
        bioTextView.text = friend.biography
    }
}
