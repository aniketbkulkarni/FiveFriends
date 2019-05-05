import UIKit

class FriendTableViewCell: UITableViewCell {

    static let identifier = "FriendTableViewCell"
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameAgeLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var bioTextView: UITextView!
}
