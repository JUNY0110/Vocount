//
//  ViewController.swift
//  Vocount
//
//  Created by 지준용 on 2022/08/28.
//

import AVFoundation
import UIKit

import googleapis

let SAMPLE_RATE = 16000

class ViewController: UIViewController, AudioControllerDelegate {
    
    var isRecording = false
    var audioData: NSMutableData!
    var wordDictionary: [String: Int] = [:]
    
    // MARK: - View
    
    let collectionView: UICollectionView = {
        return $0
    }(UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
    ))
    
    let testLBL: UITextView = {
        $0.text = "testLBL"
        $0.textColor = .black
        $0.textAlignment = .center
        return $0
    }(UITextView())
    
    let spokenLBL: UITextView = {
        $0.text = "spokenLBL"
        $0.textColor = .black
        $0.textAlignment = .center
        return $0
    }(UITextView())
    
    let circleButton: UIImageView = {
        $0.image = UIImage(named: "circleButton")
        return $0
    }(UIImageView())
    
    let buttonStart: UILabel = {
        $0.text = "Start"
        $0.font = UIFont.systemFont(ofSize: 30,
                                    weight: .semibold)
        $0.textColor = .softWhite
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let buttonVstack: UIStackView = {
        //        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    let buttonTitle: UILabel = {
        $0.text = "이번 주 사용 어휘"
        $0.font = UIFont.systemFont(ofSize: 18,
                                    weight: .semibold)
        $0.textColor = .softWhite
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let buttonContent: UILabel = {
        $0.text = "12345회"
        $0.font = UIFont.systemFont(ofSize: 30,
                                    weight: .bold)
        $0.textColor = .softWhite
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioController.sharedInstance.delegate = self

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(RankingCell.self,
                                     forCellWithReuseIdentifier: RankingCell.identifier)
        self.collectionView.register(RankingCellHeader.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: RankingCellHeader.headerIdentifier)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapStart))
        circleButton.addGestureRecognizer(tapGR)
        circleButton.isUserInteractionEnabled = true
        
        self.buttonVstack.isHidden = true
        self.buttonStart.isHidden = false
        
//        self.collectionView.reloadData()

        
        layout()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    // MARK: - Layout
    
    private func layout() {
        self.view.setFourColorsGradient(
            startColor: .topDarkBlue,
            secondColor: .mediumDarkBlue,
            thirdColor: .mediumBlue,
            lastColor: .bottomBlue
        )

        view.addSubview(circleButton)
        view.addSubview(collectionView)
        circleButton.addSubview(buttonStart)
        circleButton.addSubview(buttonVstack)
        
        buttonVstack.addArrangedSubview(buttonTitle)
        buttonVstack.addArrangedSubview(buttonContent)
        
        circleButton.anchor(
            top: view.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: collectionView.topAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingTop: 100,
            paddingLeft: 98,
            paddingBottom: 80,
            paddingRight: 98,
            width: UIScreen.main.bounds.width / 2,
            height: UIScreen.main.bounds.width / 2
        )
        
        buttonStart.anchor(
            top: circleButton.topAnchor,
            left: circleButton.leftAnchor,
            bottom: circleButton.bottomAnchor,
            right: circleButton.rightAnchor
        )
        
        buttonVstack.anchor(
            top: circleButton.topAnchor,
            left: circleButton.leftAnchor,
            bottom: circleButton.bottomAnchor,
            right: circleButton.rightAnchor
        )
        
        buttonTitle.anchor(
            top: buttonVstack.topAnchor,
            left: buttonVstack.leftAnchor,
            bottom: buttonContent.bottomAnchor,
            right: buttonVstack.rightAnchor,
            paddingTop: -40,
            paddingLeft: 0,
            paddingBottom: 60,
            paddingRight: 0
        )

        buttonContent.anchor(
            left: buttonVstack.leftAnchor,
            bottom: buttonVstack.bottomAnchor,
            right: buttonVstack.rightAnchor
        )

        collectionView.anchor(
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor
        )
        collectionView.backgroundColor = .clear
    }

    // MARK: - Function

    @objc func didTapStart() {
        if !isRecording {
            self.buttonVstack.isHidden = false
            self.buttonStart.isHidden = true
            GoogleSpeechManager.startRecording()

            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.record)
            } catch {

            }
            audioData = NSMutableData()
        } else {
            self.buttonVstack.isHidden = true
            self.buttonStart.isHidden = false
            GoogleSpeechManager.stopRecording()
            self.collectionView.reloadData()

        }
        isRecording.toggle()
    }

    func stopAudio(_ sender: NSObject) {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }

    func processSampleData(_ data: Data) -> Void {
        audioData.append(data)
        let chunkSize: Int = Int(0.1 * Double(SAMPLE_RATE) * 2);
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData, completion: { [weak self] (response, error) in
                guard let strongSelf = self else {
                    return
                }
                
                if let error = error {
                    strongSelf.testLBL.text = error.localizedDescription
                } else if let response = response {
                    var finished = false

//                    print(response.description)

                    for result in response.resultsArray! {
                        if let result = result as? StreamingRecognitionResult {
                            if result.isFinal {
                                finished = true

                                for alternative in result.alternativesArray {
                                    if let alternative = alternative as? SpeechRecognitionAlternative {

                                        for voca in alternative.wordsArray {
                                            if let voca = voca as? WordInfo {
                                                let condition: ((String, Int)) -> Bool = {
                                                    $0.0.contains(voca.word)
                                                }
                                                
                                                strongSelf.wordDictionary[String(voca.word), default: 0] += 1
                                                
//                                                if strongSelf.wordDictionary.contains(where: condition) {
//                                                    strongSelf.wordDictionary[String(voca.word)]! += 1
//                                                } else {
//                                                    strongSelf.wordDictionary[String(voca.word)] = 1
//                                                }
                                                print(strongSelf.wordDictionary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if finished {
                        strongSelf.stopAudio(strongSelf)
                    }
                }
            })
            self.audioData = NSMutableData()
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordDictionary.count
    }
    
    // TODO: 셀 내용 추가
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingCell.identifier, for: indexPath) as! RankingCell
        var sortedDictionary = self.wordDictionary.sorted{ $0.value > $1.value }
        cell.vocaRankingLabel.text = sortedDictionary[indexPath.row].key
        cell.vocaRankingCount.text = String(sortedDictionary[indexPath.row].value) + "회"
        print("여기에요 여기 여기보세요")
        print(sortedDictionary)
//        cell.vocaRankingLabel.text = wordDictionary.sorted(by: va)
        

//        for rankingLabel in wordDictionary.keys {
//            cell.vocaRankingLabel.text = rankingLabel
//        }
        print(wordDictionary.keys)
        print("asdf")
//        for rankingCount in wordDictionary.values {
//            cell.vocaRankingCount.text = String(ra)
//        }
//        cell.vocaRankingLabel.text = "1. 안녕하세요."
//        cell.vocaRankingCount.text = "100"

        return cell
    }
    
    // 셀 상하 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width
        let cellHeight = 25
        
        return CGSize(width: Int(cellWidth), height: Int(cellHeight))
    }
    
    // 섹션 헤더 내용
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RankingCellHeader.headerIdentifier, for: indexPath) as! RankingCellHeader
            
            header.mainTitle.text = "금주 사용 어휘 순위"
            
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}
