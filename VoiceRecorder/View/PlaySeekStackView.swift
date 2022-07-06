//
//  PlaySeekView.swift
//  VoiceRecorder
//
//  Created by rae on 2022/07/05.
//

import UIKit

// TODO: - final 붙이지 않는 이유
class PlaySeekStackView: UIStackView {
    // 버튼 생성 기능 구현 합치기
    // private
    // public한 함수를 통해서 바꿔주는 것이 좋다. delegate 사용
    let backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 32.0), forImageIn: .normal)
        button.isEnabled = false
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "goforward"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 32.0), forImageIn: .normal)
        button.isEnabled = false
        return button
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 32.0), forImageIn: .normal)
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Function

private extension PlaySeekStackView {
    func configure() {
        addSubViews()
        setup()
    }
    
    func addSubViews() {
        [backwardButton, playPauseButton, forwardButton].forEach {
            addArrangedSubview($0)
        }
    }
    
    func setup() {
        distribution = .fillEqually
    }
}
