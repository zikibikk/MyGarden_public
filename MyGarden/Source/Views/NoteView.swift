//
//  NoteView.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 29.03.2024.
//
import UIKit
import SnapKit

class NoteView: UIView {
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tv.font = .noteFont
        tv.textColor = .black
        tv.textAlignment = .left
        tv.keyboardType = .default
        tv.backgroundColor = .clear
        tv.isEditable = true
        tv.isScrollEnabled = false
        return tv
    }()
    
    var text: String? {
        set {
            let attributedString = NSMutableAttributedString(string: newValue ?? "")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 13
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttribute(.font, value: UIFont.noteFont, range: NSMakeRange(0, attributedString.length))

            textView.attributedText = attributedString
        }
        get { return textView.text }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NoteView {
    private func setUp() {
        self.backgroundColor = .lightGreen
        self.layer.cornerRadius = 13
        self.addSubview(textView)

        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(textView).offset(10)
        }
    }
}
