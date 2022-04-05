//
//  ViewController.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import UIKit
final class RFNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    private func configUI() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
    }
}
class RFViewController: UIViewController {

    // MARK: - Override var
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
            return .allButUpsideDown
        } else {
            return .portrait
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    /// Defaults to .lightContent, if you want black status bar set it to .default
    var statusBarStyle: UIStatusBarStyle = .darkContent {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private lazy var statusBarHidden: Bool = {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager!.isStatusBarHidden ?? false)
        } else {
           return UIApplication.shared.isStatusBarHidden
        }
    }()
    
    private lazy var progressIndicator: RFProgressView = {
        return RFProgressView(frame: view.bounds)
    }()
    
    open func showProgress(disableUI: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let welf = self else {return}
            if !welf.isViewLoaded { return }
            if disableUI && welf.view.isUserInteractionEnabled {
                welf.view.isUserInteractionEnabled = false
            }
            welf.progressIndicator.showActivityIndicator(from: welf.view)
        }
    }
    
    open func setText(_ text: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let welf = self else {return}
            if !welf.isViewLoaded { return }
            welf.progressIndicator.setText(text)
        }
    }
    
    open func displayError(_ error: Error, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let welf = self else {return}
            if !welf.isViewLoaded { return }
            welf.progressIndicator.setText(error.localizedDescription)
            runAfter(2) {
                welf.dismissProgress()
                if let completionHandler = completionHandler {
                    completionHandler()
                }
            }
        }
    }
    
    open func displayError(_ message: String, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let welf = self else {return}
            if !welf.isViewLoaded { return }
            welf.progressIndicator.setText(message)
            runAfter(2) {
                welf.dismissProgress()
                if let completionHandler = completionHandler {
                    completionHandler()
                }
            }
        }
    }
    
    open func popProgress() {
        DispatchQueue.main.async { [weak self] in
            guard let welf = self else {return}
            if !welf.view.isUserInteractionEnabled {
                welf.view.isUserInteractionEnabled = true
            }
            welf.progressIndicator.popActivityIndicator(from: welf.view)
        }
    }
    
    open func dismissProgress() {
        DispatchQueue.main.async { [weak self] in
            guard let welf = self else {return}
            if !welf.view.isUserInteractionEnabled {
                welf.view.isUserInteractionEnabled = true
            }
            welf.progressIndicator.dismissActivityIndicator(from: welf.view)
        }
    }
    
    lazy var addButton: UIBarButtonItem = {
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onTouchAddButton))
        return addButton
    }()
    
    @objc func onTouchAddButton() {
        assertionFailure("Override this function")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
   
}

extension RFViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

private class RFProgressView: UIView {
    
    // MARK: - Variables
    private var activityIndicator: UIActivityIndicatorView?
    private var indicatorCount: Int = 0
    private var progressLabel: UILabel?
    
    // MAKR: - UI
    final func showActivityIndicator(from view: UIView) {
        
        if view.subviews.contains(self) {
            indicatorCount += 1
            return
        }
        
        backgroundColor = .clear
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = .black
        indicator.center = CGPoint(x: view.frame.size.width / 2,
                                   y: view.frame.size.height / 3)
        indicator.startAnimating()
        indicator.layer.zPosition = 1
        
        addSubview(indicator)
        
        let label = UILabel(frame: CGRect(x: 0, y: indicator.frame.maxY + 10, width: UIScreen.main.bounds.width, height: 30))
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.isHidden = true
        
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)

        addSubview(label)
        
        view.addSubview(self)
        
        indicatorCount += 1
        activityIndicator = indicator
        progressLabel = label
    }
    
    final func setText(_ text: String?) {
        progressLabel?.text = text
        progressLabel?.isHidden = progressLabel?.text?.count ?? 0 <= 0
        progressLabel?.textColor = UIColor.blackColor
    }
    
    final func dismissActivityIndicator(from view: UIView) {
        indicatorCount = 0
        if view.subviews.contains(self.self) {
            indicatorCount = 0
            removeFromSuperview()
            activityIndicator?.stopAnimating()
            
            progressLabel?.text = nil
            progressLabel?.isHidden = true
        }
    }
    
    final func popActivityIndicator(from view: UIView) {
        
        if indicatorCount > 1 {
            indicatorCount -= 1
            return
        }
        dismissActivityIndicator(from: view)
    }
}

