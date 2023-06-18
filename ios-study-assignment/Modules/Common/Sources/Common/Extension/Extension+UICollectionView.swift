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

extension UICollectionView {
    /// 콜렉션 뷰의 값이 없을 때 메시지 설정
    /// - parameter message: 보여줄 메시지
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.bounds.size.width,
                height: self.bounds.size.height
            )
        )
        
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.setTextWithLetterSpacing(
            text: message,
            letterSpacing: -0.43,
            lineSpacing: 22,
            font: UIFont(name: "AppleSDGothicNeo-Bold", size: 17)!,
            color: .black
        )
        
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    /// 콜렉션 뷰의  메시지 제거
    func restore() {
        self.backgroundView = nil
    }
}
