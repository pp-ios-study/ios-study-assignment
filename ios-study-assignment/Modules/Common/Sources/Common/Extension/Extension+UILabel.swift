//
//  Extension+UILabel.swift
//  
//
//  Created by 최승명 on 2023/06/18.
//

import UIKit

extension UILabel {
    /// 라벨의 AttributedText 설정
    /// - parameter text: 보여줄 메시지
    /// - parameter letterSpacing: 문자 간격
    /// - parameter lineHeight: 줄 간격
    /// - parameter font: 적용할 폰트
    /// - parameter color: 적용할 색상
    func setTextWithLetterSpacing(
        text: String,
        letterSpacing: CGFloat,
        lineSpacing: CGFloat,
        font: UIFont,
        color: UIColor
    ) {
        let style = NSMutableParagraphStyle()
        style.alignment = self.textAlignment
        style.lineSpacing = lineSpacing - font.lineHeight
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .kern, value: letterSpacing,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .font, value: font,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: NSRange(location: 0, length: attributedString.length)
        )
        self.attributedText = attributedString
    }
}
