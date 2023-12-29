//
//  GameView.swift
//  starrun
//
//  Created by Александр on 15.12.2023.
//

import UIKit
import PureLayout

final class GameView: UIView {
    
    // MARK: - Properties
    
    weak var viewController: GameViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        self.addSubviews()
        self.setupConstraints()
    }
    
    // MARK: -Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VIEW Hierarchie
    
    func addSubviews() {
        addSubview(playButton)
        addSubview(settingsButton)
        addSubview(recordButton)
    }
    
    // MARK: - VIEW
    
    var playButton: UIButton = {
        let button = UIButton()
        
        // Set button properties
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = Constants.borderWidh
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "playbb"), for: .normal)
        
        // Set button dimensions
        button.autoSetDimensions(to: CGSize(width: Constants.sizePlayButton, height: Constants.sizePlayButton))
        
        return button
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton()
        
        // Set button properties
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = Constants.borderWidh
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "settb"), for: .normal)
        
        // Set button dimensions
        button.autoSetDimension(.width, toSize: Constants.sizeSettingButton)
        button.autoSetDimension(.height, toSize: Constants.sizeSettingButton)
        
        return button
    }()
    
    var recordButton: UIButton = {
        let button = UIButton()
        
        // Set button properties
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = Constants.borderWidh
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "topbb"), for: .normal)
        
        // Set button dimensions
        button.autoSetDimension(.width, toSize: Constants.sizeRecordButton)
        button.autoSetDimension(.height, toSize: Constants.sizeRecordButton)
        
        return button
    }()
    
    func setupConstraints() {
        playButton.autoAlignAxis(toSuperviewAxis: .vertical)
        playButton.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.insert)
        
        settingsButton.autoAlignAxis(toSuperviewAxis: .vertical)
        settingsButton.autoPinEdge(.top, to: .bottom, of: playButton, withOffset: Constants.offset)
        
        recordButton.autoAlignAxis(toSuperviewAxis: .vertical)
        recordButton.autoPinEdge(.top, to: .bottom, of: settingsButton, withOffset: Constants.offset)
    }
}

private extension GameView {
    enum Constants {
        static let sizePlayButton: CGFloat = 256.0
        static let sizeRecordButton: CGFloat = 96.0
        static let sizeSettingButton: CGFloat = 160.0
        static let offset: CGFloat = 32.0
        static let insert: CGFloat = 128.0
        static let cornerRadius: CGFloat = 48
        static let borderWidh: CGFloat = 1
    }
}
