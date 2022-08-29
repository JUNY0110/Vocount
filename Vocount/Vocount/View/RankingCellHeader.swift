//
//  RankingCellHeader.swift
//  Vocount
//
//  Created by 지준용 on 2022/08/29.
//

import UIKit

class RankingCellHeader: UICollectionViewCell {
    
    // MARK: - Property
    
    static let headerIdentifier = "RankingCellHeader"
    
    // MARK: - View
    
    let mainTitle: UILabel = {
        $0.text = "금주 사용 어휘 순위"
        $0.textColor = .softWhite
        $0.font = UIFont.systemFont(ofSize: 20,
                                    weight: .bold)
        return $0
    }(UILabel())
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func layout() {
        addSubview(mainTitle)
        mainTitle.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 0,
            paddingLeft: 20,
            paddingBottom: 0,
            paddingRight: 20
        )
    }
}
