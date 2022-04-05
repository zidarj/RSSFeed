//
//  RFFeedViewController.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import UIKit
protocol RFFeedViewControllerDelegate: AnyObject {
    func createFeed(feed: RFFeed)
}
final class RFFeedViewController: RFViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: RFFeedViewModel!
    private weak var delegate: RFFeedViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerNib()
    }
    
    private func setupUI() {
        title = "Create RSS Feed"
        tableView.delegate = self
        tableView.dataSource = self
        hideKeyboardWhenTappedAround()
    }
    
    private func registerNib() {
        tableView.registerNib(RFImageTableViewCell.self)
        tableView.registerNib(RFInputFieldTableViewCell.self)
        tableView.registerNib(RFDescriptionTableViewCell.self)
        tableView.registerNib(RFButtonTableViewCell.self)
    }
    
    final func config(feed: RFFeed?, delegate: RFFeedViewControllerDelegate) {
        viewModel = RFFeedViewModel(feed: feed)
        self.delegate = delegate
    }

}
extension RFFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.structure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.structure[indexPath.row] {
        case .image:
            let cell: RFImageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.config(image: viewModel.feed?.image,
                        delegate: self)
            return cell
            
        case .name:
            let cell: RFInputFieldTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.config(title: "RSS Feed name",
                        placeholder: "RSS Feed name",
                        value: viewModel.feed?.name,
                        type: .name,
                        delegate: viewModel)
            return cell
            
        case .url:
            let cell: RFInputFieldTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.config(title: "RSS Feed url",
                        placeholder: "RSS Feed url",
                        value: viewModel.feed?.url,
                        keyboardType: .webSearch,
                        type: .url,
                        delegate: viewModel)
            return cell
            
        case .description:
            let cell: RFDescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.config(description: viewModel.feed?.description,
                        title: "Description",
                        delegate: viewModel)
            return cell
            
        case .saveButton:
            let cell: RFButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.config(title: "Save", delegate: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.structure[indexPath.row] {
        case .image:
            return RFImageTableViewCell.height
            
        case .name, .url, .saveButton:
            return UITableView.automaticDimension
            
        case .description:
            return RFDescriptionTableViewCell.height
        }
    }
}
extension RFFeedViewController: RFImageTableViewCellDelegate {
    func removeImage() {
        viewModel.removeImage()
        self.tableView.reloadData()
    }
    
    func selectImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            OnMainThread {
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
}
extension RFFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewModel.saveImage(image: image)
        }
        picker.dismiss(animated: true) {
            self.tableView.reloadData()
        }
    }
    
}
extension RFFeedViewController: RFButtonTableViewCellDelegate {
    func onTouchButton() {
        self.showProgress()
        guard let feed = viewModel.feed else {
            self.displayError("Fill required fields")
            return
        }
        
        if feed.name.isEmpty {
            self.displayError("Name is required!")
            return
        }
        if feed.url.isEmpty {
            self.displayError("Url is required!")
            return
        } else if URL(string: feed.url) == nil {
            self.displayError("Url is invalid!")
            return
        }
        if feed.description.isEmpty {
            self.displayError("Description is required!")
            return
        }
        
        if feed.image == nil {
            self.displayError("Select Image!")
            return
        }
        self.dismissProgress()
        delegate.createFeed(feed: feed)
        self.navigationController?.popViewController(animated: true)
    }
}
