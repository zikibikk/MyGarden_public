//
//  ViewController.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 01.03.2024.
//

import UIKit
import SnapKit

class TagTableViewCell: UITableViewCell {
    
    private let tagCollectionView = TagCollectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TagTableViewCell {
    
    func configure(tagsStruct: [TagStruct]) {
        tagCollectionView.tagsStruct = tagsStruct
        contentView.addSubview(tagCollectionView)
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(33)
        }
        
        contentView.snp.makeConstraints({$0.bottom.equalTo(tagCollectionView)})
        contentView.snp.makeConstraints({$0.width.equalToSuperview()})
    }
}

class TagCollectionView: UIView {
    private let rowSpacing = 7
    private var lineSpacing = 10
    
    var tagsStruct: [TagStruct] = []
    private var tagViews: [[TagView]] = [[]]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagCollectionView {
    func calculateViews() {
        
        let viewWidth = Int(self.bounds.width)
        var freeWidth: [Int] = []
        
        tagViews.removeAll()
        tagsStruct = tagsStruct.sorted { s1, s2 in
            s1.name.count > s2.name.count
        }
        
        for tagStruct in self.tagsStruct {
            let tagViewToInsert = TagView()
            tagViewToInsert.tagStruct = tagStruct
            tagViewToInsert.layoutIfNeeded()
            let needWidth = Int(tagViewToInsert.bounds.width)
            var isInserted = false
            
            for i in 0 ..< freeWidth.count {
                if (freeWidth[i] >= needWidth) {
                    tagViews[i].append(tagViewToInsert)
                    freeWidth[i] -= (needWidth + rowSpacing)
                    isInserted = true
                    break
                }
            }
            
            if (!isInserted) {
                tagViews.append([tagViewToInsert])
                freeWidth.append(viewWidth - needWidth - rowSpacing)
                self.addSubview(tagViewToInsert)
                tagViewToInsert.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.top.equalToSuperview().inset((lineSpacing + Int(tagViewToInsert.bounds.height)) * (tagViews.count - 1))
                }
            }
        }
        
        for i in 0..<tagViews.count {
            for j in 1..<tagViews[i].count {
                self.addSubview(tagViews[i][j])
                tagViews[i][j].snp.makeConstraints { make in
                    make.top.equalTo(tagViews[i][j-1])
                    make.left.equalTo(tagViews[i][j-1].snp.right).offset(rowSpacing)
                }
            }
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(tagViews[tagViews.count-1][0])
        }
        
        printTagViews()
    }
    
    func printTagViews() {
        for i in 0 ..< tagViews.count {
            for j in 0 ..< tagViews[i].count {
                print( "i = \(i), j = \(j)", tagViews[i][j].tagStruct?.name)
            }
        }
    }
}

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension MainViewController {
    func setUp() {
        view.backgroundColor = .white
        
        let tv = TagCollectionView()
        
        tv.tagsStruct = [.init(name: "косточковые", color: .lightGreen),
                   .init(name: "неприхотлива", color: .lightGreen),
                   .init(name: "ягода", color: .lightGreen),
                   .init(name: "все виды удобрений", color: .lightGreen),
                   .init(name: "дневной полив", color: .lightGreen),
                   .init(name: "сладкая", color: .lightGreen)
        ]
        
        
        
        let tag = ReminderButton()
        
        
        view.addSubview(tag)
        view.addSubview(tv)
        
        tv.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(100)
//            make.bottom.equalToSuperview().inset(300)
            make.leading.trailing.equalToSuperview().inset(30)
//            make.width.equalToSuperview().inset(40)
        }
        
        
        tag.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(50)
        }
    }
}

