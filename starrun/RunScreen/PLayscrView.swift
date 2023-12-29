//
//  PLayscrView.swift
//  starrun
//
//  Created by Александр on 15.12.2023.
//

import UIKit
import PureLayout

final class PlayscrView: UIView, CAAnimationDelegate {
    // MARK: - Properties
    
    weak var viewController: PlayscrViewController?
    let initialPlayerViewPosition = CGPoint(x: 160, y: 550)
    let starCount = 100
    var movePlayerTimer: Timer?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.addSubviews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VIEW Hierarchie
    
    func addSubviews() {
        self.addSubview(enemiesSpott)
        self.addSubview(player)
        self.addSubview(leftMoveButton)
        self.addSubview(rightMoveButton)
        self.addSubview(scoreLabell)
    }
    
    // MARK: - VIEW
    
    var player: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 96.0, height: 96.0)
        view.layer.borderWidth = 3.0
        view.backgroundColor = .white
        view.alpha = 1
        
        // Create a triangular mask
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 96))
        path.addLine(to: CGPoint(x: 96, y: 96))
        path.addLine(to: CGPoint(x: 48, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 96))
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
        
        return view
    }()
    
    var scoreLabell: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.backgroundColor = .orange
        label.textColor = .white
        label.textAlignment = .center
        
        label.autoSetDimension(.width, toSize:  Constants.sizeDef)
        label.autoSetDimension(.height, toSize: Constants.scoreHeight)
        
        return label
    }()
    
    var enemiesSpott: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var leftMoveButton: UIButton = {
        let button = UIButton()
        
        // Set button properties
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = Constants.borderWidh
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "left"), for: .normal)
        
        // Set button dimensions
        button.autoSetDimension(.width, toSize:  Constants.sizeDef)
        button.autoSetDimension(.height, toSize:  Constants.sizeDef)
        
        return button
    }()
    
    var rightMoveButton: UIButton = {
        let button = UIButton()
        
        // Set button properties
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = Constants.borderWidh
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "right"), for: .normal)
        
        // Set button dimensions
        button.autoSetDimension(.width, toSize: Constants.sizeDef)
        button.autoSetDimension(.height, toSize:  Constants.sizeDef)
        
        return button
    }()
    
    // MARK: - OBJC move func
    
    @objc func leftMoveButtonPress() {
        movePlayerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            // Declare playerView here
            let playerView = self.player
            
            let minX: CGFloat = 0
            // Calculate the maximum x-coordinate based on the screen width
            let maxX: CGFloat = (self.frame.width ) - (player.frame.width )
            let newX = min(maxX, max(minX, (playerView.frame.origin.x ) - 20))
            self.animatePlayerMovement(to: CGPoint(x: newX, y: playerView.frame.origin.y ))
        }
    }
    
    @objc func rightMoveButtonPress() {
        movePlayerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate() // Invalidate the timer if self is nil
                return
            }
            // Declare playerView here
            let playerView = self.player
            
            let minX: CGFloat = 0
            // Calculate the maximum x-coordinate based on the screen width
            let maxX: CGFloat = (self.frame.width ) - (playerView.frame.width )
            let newX = min(maxX, max(minX, (playerView.frame.origin.x) + 20))
            self.animatePlayerMovement(to: CGPoint(x: newX, y: playerView.frame.origin.y))
        }
    }
    
    @objc func moveButtonNotPressed() {
        movePlayerTimer?.invalidate()
        movePlayerTimer = nil
    }
    
    // MARK: - Star animation
    
    func createStarryFall() {
        let starContainerLayer = CALayer()
        starContainerLayer.frame = bounds
        
        for _ in 0..<starCount {
            let starLayer = CALayer()
            let starSize = CGFloat.random(in: 1.0...3.0)
            starLayer.frame = CGRect(
                x: CGFloat.random(in: 0..<bounds.width),
                y: -starSize, // Start stars at the top of the screen
                width: starSize,
                height: starSize
            )
            
            starLayer.cornerRadius = starSize / 2.0
            starLayer.backgroundColor = UIColor.white.cgColor
            
            starContainerLayer.addSublayer(starLayer)
            
            let speed = TimeInterval.random(in: 2.0...5.0) // Random speed for each star's animation
            let delay = TimeInterval.random(in: 0...2.0)
            
            // Gradually decrease the duration, making stars move faster over time
            let duration = speed - delay
            
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.fromValue = -starSize
            animation.toValue = bounds.height + starSize // Move stars to the bottom
            animation.duration = duration
            animation.beginTime = CACurrentMediaTime() + delay
            animation.delegate = self
            animation.setValue(starLayer, forKey: "starLayer")
            
            starLayer.add(animation, forKey: "positionYAnimation")
        }
        
        layer.addSublayer(starContainerLayer)
    }
    
    func removingStars(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.value(forKey: "starLayer") as? CALayer, flag {
            layer.removeFromSuperlayer()
        }
    }
    
    // MARK: - Player animation
    
    func animatePlayerMovement(to position: CGPoint) {
        UIView.animate(withDuration: 0.1) {
            self.player.frame.origin = position
        }
    }
    
    func animatePlayer() {
        UIView.animate(withDuration: 2) {
            self.player.frame.origin = self.initialPlayerViewPosition
        }
    }
    
    // MARK: - Constraints
    
    func setupConstraints() {
        // scoreLabel constraints
        scoreLabell.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.insert)
        scoreLabell.autoPinEdge(toSuperviewEdge: .left, withInset: Constants.secondInsert)
        
        // button constraints
        leftMoveButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.insert)
        leftMoveButton.autoPinEdge(toSuperviewEdge: .left, withInset: Constants.secondInsert)
        
        rightMoveButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.insert)
        rightMoveButton.autoPinEdge(toSuperviewEdge: .right, withInset: Constants.secondInsert)
        
        //player
        player.center = center
        
        //enemiesSpot view
        enemiesSpott.frame = bounds
    }
}

// MARK: - Private extension

private extension PlayscrView {
    enum Constants {
        static let scoreHeight: CGFloat = 56.0
        static let sizeDef: CGFloat = 112.0
        static let cornerRadius: CGFloat = 48
        static let borderWidh: CGFloat = 1
        static let insert: CGFloat = 80.0
        static let secondInsert: CGFloat = 40.0
    }
}
