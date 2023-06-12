//
//  File.swift
//  
//
//  Created by 최승명 on 2023/06/12.
//

import UIKit

extension UICollectionView {
    
    public func registerCell<T>(_ cellClass: T.Type) where T: UICollectionViewCell {
        self.register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func registerResuableView<T>(_ cellClass: T.Type) where T: UICollectionReusableView {
        self.register(cellClass.self, forSupplementaryViewOfKind: cellClass.reuseIdentifier, withReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
    
    public func dequeReusableView<T>(_ headerClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableSupplementaryView(
            ofKind: headerClass.reuseIdentifier,
            withReuseIdentifier: headerClass.reuseIdentifier,
            for: indexPath
        ) as? T
    }
}

extension UICollectionReusableView {
    public static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
