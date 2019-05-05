import RxSwift
import RxCocoa

class FiveViewController: UIViewController {

    let viewModel = FiveViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.friends
            .bind(to: tableView
                .rx
                .items(cellIdentifier: FriendTableViewCell.identifier, cellType: FriendTableViewCell.self))
            { (row, element, cell) in
                cell.profilePicture.image = UIImage(named: "prototype-profile")
                cell.nameAgeLabel.text = "\(element.name), \(element.age)"
                cell.phoneNumberLabel.text = element.phoneNumber
                cell.bioTextView.text = element.biography
            }
            .disposed(by: disposeBag)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?
            .rx
            .controlEvent(.valueChanged)
            .subscribe(
                onNext: { [weak self] in
                    self?.viewModel.doRequest()
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.friends
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] (_) in
                    self?.tableView.refreshControl?.endRefreshing()
                },
                onError: { (error) in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.doRequest()
    }
}
