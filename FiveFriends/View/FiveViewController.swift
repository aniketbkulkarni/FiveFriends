import RxSwift
import RxCocoa

class FiveViewController: UIViewController {

    private let viewModel = FiveViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshControl()
        viewModel.performRequest()
    }
    
    private func setupTableView() {
        
        // Bind data to our tableView
        viewModel.friends
            .bind(to: tableView
                .rx
                .items(cellIdentifier: FriendTableViewCell.identifier,
                       cellType: FriendTableViewCell.self)) { (_, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        
        // Get more data on pull-to-refresh
        tableView.refreshControl?
            .rx
            .controlEvent(.valueChanged)
            .subscribe(
                onNext: { [weak self] in
                    self?.viewModel.performRequest()
                }
            )
            .disposed(by: disposeBag)
        
        // Perform a UI action based on result from view model
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
    }
}
