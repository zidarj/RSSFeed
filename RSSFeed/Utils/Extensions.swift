//
//  Extensions.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
extension UICollectionViewCell: ReusableView {}

protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: NibLoadableView {}
extension UITableViewHeaderFooterView: NibLoadableView {}
extension UICollectionViewCell: NibLoadableView {}

extension UITableView {
    
    func registerCellClass<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func registerNib<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            return T()
        }
        
        return cell
    }
    
    func registerHeaderFooterNib<T: UITableViewHeaderFooterView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            debugPrint("Could not dequeue header/footer view with identifier: \(T.defaultReuseIdentifier)")
            return T()
        }
        return headerFooterView
    }
}

extension UICollectionView {
    func registerCellClass<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            debugPrint("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
            return T()
        }
        return cell
    }
}

extension Date {
    private static let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    var dateToString: String {
        return Date.dateFormater.string(from: self)
    }
}
extension String {
    var stringToDate: Date {
        if let timeStamp = Int(self) {
            let time = TimeInterval(timeStamp)
            return Date(timeIntervalSince1970: time)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)!
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
protocol ControllerIdentifierProtocol: AnyObject {
    static var controllerID: String { get }
}

extension ControllerIdentifierProtocol where Self: UIViewController {
    static var controllerID: String {
        return String(describing: self)
    }
}

extension UIViewController: ControllerIdentifierProtocol {}

extension UIStoryboard {
    
    func getController<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: T.controllerID) as! T
    }
}

extension UIColor {
    static var blackColor: UIColor = UIColor(named: "Black") ?? .black
}
