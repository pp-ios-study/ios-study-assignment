//
//  File.swift
//  
//
//  Created by 최승명 on 2023/06/04.
//

import UIKit

extension UITableView {
    
    public func registerCell<T>(_ cellClass: T.Type) where T: UITableViewCell {
        self.register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
}

extension UITableViewCell {
    public static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
