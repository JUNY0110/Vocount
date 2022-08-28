//
//  ViewController.swift
//  Vocount
//
//  Created by 지준용 on 2022/08/28.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - View
    
    let roundButton: UIButton = {
        return $0
    }(UIButton())
    
    let buttonVstack: UIStackView = {
        return $0
    }(UIStackView())
    
    let buttonTitle: UILabel = {
        $0.text = "이번 주 사용 어휘"
        return $0
    }(UILabel())
    
    let buttonContent: UILabel = {
        return $0
    }(UILabel())
    
    let mainTitle: UILabel = {
        $0.text = "금주 사용 어휘 순위"
        return $0
    }(UILabel())
    
    let vStack: UIStackView = {
        return $0
    }(UIStackView())
    
    let hStack: UIStackView = {
        return $0
    }(UIStackView())
    
    let vocaRankingLabel: UILabel = {
        return $0
    }(UILabel())
    
    let vocaRankingCount: UILabel = {
        return $0
    }(UILabel())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }

    // MARK: - Layout

    func layout() {
        view.addSubview(roundButton)
        roundButton.addSubview(buttonVstack)

        buttonVstack.addArrangedSubview(buttonTitle)
        buttonVstack.addArrangedSubview(buttonContent)

        view.addSubview(mainTitle)
        view.addSubview(vStack)
        vStack.addArrangedSubview(hStack)

        hStack.addArrangedSubview(vocaRankingLabel)
        hStack.addArrangedSubview(vocaRankingCount)

        view.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )

        view.setFourthGradient(
            startColor: .topDarkBlue,
            secondColor: .mediumDarkBlue,
            thirdColor: .mediumBlue,
            lastColor: .bottomBlue
        )

        roundButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingTop: 100,
            paddingLeft: 98,
            paddingRight: 98
        )
    }
}

