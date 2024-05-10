//
//  TagCollectionView.swift
//  MyGarden
//
//  Created by Alina Bikkinina on 04.05.2024.
//

import UIKit
import SnapKit

class TagCollectionView: UIView {
    private let rowSpacing = 7
    private var lineSpacing = 10
    
    var tagsStruct: [TagStruct] = []
    private var tagViews: [[TagView]] = [[]]
    var hasLayoutedSubviews = false
//    private var finalTag: TagView = {
//        let tag = TagView()
//        tag.tagStruct = .init(name: "  +  ", color: .lightGreen)
//        return tag
//    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!hasLayoutedSubviews) { calculateViews() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagCollectionView {
    private func calculateViews() {
        
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
        hasLayoutedSubviews = true
        addBottomConstraints()
        printTagViews()
    }
    
    private func printTagViews() {
        for i in 0 ..< tagViews.count {
            for j in 0 ..< tagViews[i].count {
                print( "i = \(i), j = \(j)", tagViews[i][j].tagStruct.name)
            }
        }
    }
    
    func addBottomConstraints() {
        self.snp.makeConstraints { make in
            make.bottom.equalTo(tagViews[tagViews.count-1][0])
        }
    }
}
