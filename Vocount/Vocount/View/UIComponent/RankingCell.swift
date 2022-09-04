//
//  RankingCell.swift
//  Vocount
//
//  Created by 지준용 on 2022/08/28.
//

import UIKit

class RankingCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "RankingCell"
    
    // MARK: - View

    let mainTitle: UILabel = {
        $0.text = "금주 사용 어휘 순위"
        $0.textColor = .softWhite
        $0.font = UIFont.systemFont(ofSize: 20,
                                    weight: .bold)

        return $0
    }(UILabel())
    
    let hStack: UIStackView = {
        return $0
    }(UIStackView())
    
    let vocaRankingLabel: UILabel = {
//        $0.text = "1. 안녕하세요"
        $0.font = UIFont.systemFont(ofSize: 16,
                                    weight: .semibold)
        $0.textColor = .softWhite
        return $0
    }(UILabel())
    
    let vocaRankingCount: UILabel = {
//        $0.text = "100회"
        $0.font = UIFont.systemFont(ofSize: 16,
                                    weight: .semibold)
        $0.textColor = .softWhite
        return $0
    }(UILabel())
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func layout() {
        addSubview(hStack)
        hStack.addArrangedSubview(vocaRankingLabel)
        hStack.addArrangedSubview(vocaRankingCount)
    
        hStack.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingLeft: 20,
            paddingRight: 20
        )
        
        vocaRankingLabel.anchor(
            top: hStack.topAnchor,
            left: hStack.leftAnchor,
            bottom: hStack.bottomAnchor,
            right: vocaRankingCount.leftAnchor,
            paddingRight: 180
        )
        
        vocaRankingCount.anchor(
            top: hStack.topAnchor,
            bottom: hStack.bottomAnchor,
            right: hStack.rightAnchor
        )
    }
}
