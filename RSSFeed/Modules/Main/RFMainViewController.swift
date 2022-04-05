//
//  RFMainViewController.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import UIKit

final class RFMainViewController: RFViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: RFMainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.registerNib()
    }
    
    private func setupUI() {
        title = "RSS Feed List"
        self.navigationItem.rightBarButtonItem = addButton
        viewModel = RFMainViewModel(delegate: self)
    }
    
    private func registerNib() {
        tableView.registerNib(RFFeedTableViewCell.self)
    }
    
    override func onTouchAddButton() {
        RFFeedsControllerHelper.createFeed(from: self, delegate: viewModel)
    }
}
extension RFMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RFFeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let feed = viewModel.feeds[indexPath.row]
        cell.config(feed: feed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = viewModel.feeds[indexPath.row]
        let aletrController = UIAlertController(title: "Open RSS Feed", message: "Select option", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        let inApp = UIAlertAction(title: "In app", style: .default) { _ in
            RFWebViewControllerHelper.openRSSFeed(from: self, feed: feed)
        }
        let externalBrowser = UIAlertAction(title: "In Browser", style: .default) { _ in
            guard let url = URL(string: feed.url) else { return }
            UIApplication.shared.open(url)
        }
        aletrController.addAction(inApp)
        aletrController.addAction(externalBrowser)
        aletrController.addAction(cancel)
        self.present(aletrController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let welf = self else { return }
            welf.viewModel.removeFeed(at: indexPath.row)
        }
       return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
extension RFMainViewController: RFNetworkRequestableDelegate {
    func didPerformRequest() {
        self.showProgress()
    }
    
    func didFetch() {
        self.dismissProgress()
        self.tableView.reloadData()
    }
    
    func didReceiveError(_ error: Error) {
        self.displayError(error)
        self.tableView.reloadData()
    }
}
