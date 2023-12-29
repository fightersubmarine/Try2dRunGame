//
//  PlayscrViewController.swift
//  starrun
//
//  Created by Александр on 12.10.2023.
//

import UIKit

final class PlayscrViewController: UIViewController, CAAnimationDelegate {
    // MARK: - Properties
    
    private let saveManager = SaveManager()
    
    weak var playscrView: PlayscrView? {
        guard isViewLoaded else { return nil }
        return (view as! PlayscrView)
    }
    
    var obstacles: [UIImageView] = []
    let starCount = 100
    var model = GameModel()
    var obstacleTimer: Timer?
    var starTimer: Timer?
    private var displayLink: CADisplayLink?
    
    // MARK: - Game control func
    
    func startGame() {
        setupSettings()
        model.score = 0
        startStarryFallTimer()
        startObstacleTimer()
        startDisplayLink()
        targerEvent()
        playscrView?.scoreLabell.text = "Score: \(model.score )"
    }
    
    func stopGame() {
        pauseObstacleAnimations()
        obstacleTimer?.invalidate()
        starTimer?.invalidate()
        playscrView?.movePlayerTimer?.invalidate()
    }
    
    func restartGame() {
        playscrView?.player.frame.origin = playscrView?.initialPlayerViewPosition ?? CGPoint(x: 160, y: 550) // Reset player's position
        playscrView?.enemiesSpott.subviews.forEach { $0.removeFromSuperview() } // Remove all obstacles
        startGame() // Start the game again
    }
    
    func setupSettings(){
        if let savedColorData = UserDefaults.standard.data(forKey: KeyForUserDef.keyColor),
           let savedColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
            self.playscrView?.player.backgroundColor = savedColor
        }
    }
    
    // MARK: - Obstacle func and their processing
    
    // Create random obstacles
    func createRandomObstacle() {
        let obstacleImageNames = ["war1.png", "war2.png", "war3.png"]
        let randomImageName = obstacleImageNames.randomElement() ?? "default.png"
        
        let obstacleWidth = model.obstacleWidth
        let obstacleX = CGFloat.random(in: 0...(((playscrView?.enemiesSpott.frame.size.width)!) - obstacleWidth))
        let obstacleFrame = CGRect(x: obstacleX, y: -obstacleWidth, width: obstacleWidth, height: obstacleWidth)
        
        let obstacle = UIImageView(frame: obstacleFrame)
        obstacle.image = UIImage(named: randomImageName)
        
        // Add obstacle to the view's layer
        playscrView?.enemiesSpott.layer.addSublayer(obstacle.layer)
        
        // Animate the obstacle's position
        animeObstacle(obstacle)
    }
    
    func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateGameObjects))
        displayLink?.add(to: .current, forMode: .default)
    }
    
    @objc func updateGameObjects() {
        if isCollision() {
            stopGameAndShowAlert()
        }
    }
    
    func isCollision() -> Bool {
        guard let playerLayer = playscrView?.player.layer.presentation() else { return false }
        
        let playerFrame = playerLayer.frame
        
        for obstacleLayer in playscrView?.enemiesSpott.layer.sublayers ?? [] {
            if let obstacleLayerPresentation = obstacleLayer.presentation() {
                let obstacleFrame = obstacleLayerPresentation.frame
                
                // Check for collision by testing if the player's frame intersects with the obstacle's frame
                if playerFrame.intersects(obstacleFrame) {
                    return true
                }
            }
        }
        return false
    }
    
    func pauseObstacleAnimations() {
        for obstacleLayer in playscrView?.enemiesSpott.layer.sublayers ?? [] {
            obstacleLayer.speed = 0.0
            obstacleLayer.removeFromSuperlayer()
        }
    }
    
    func updateScoreLabel() {
        playscrView?.scoreLabell.text = "Score: \(model.score )"
    }
    
    // MARK: - Timers
    
    // Start the timer to create star background
    func startStarryFallTimer() {
        starTimer = Timer.scheduledTimer(withTimeInterval: model.starSpam, repeats: true) {
            [weak self] _ in
            self?.playscrView?.createStarryFall()
        }
    }
    
    // Start the timer to create obstacles
    func startObstacleTimer() {
        obstacleTimer = Timer.scheduledTimer(withTimeInterval: model.obstacleSpeed, repeats: true) { [weak self] _ in
            self?.createRandomObstacle()
        }
    }
    
    // MARK: - Player movements funс
    
    func targerEvent() {
        playscrView?.leftMoveButton.addTarget(playscrView, action: #selector(playscrView?.leftMoveButtonPress), for: .touchDown)
        playscrView?.leftMoveButton.addTarget(playscrView, action: #selector(playscrView?.moveButtonNotPressed), for: .touchUpInside)
        playscrView?.rightMoveButton.addTarget(playscrView, action: #selector(playscrView?.rightMoveButtonPress), for: .touchDown)
        playscrView?.rightMoveButton.addTarget(playscrView, action: #selector(playscrView?.moveButtonNotPressed), for: .touchUpInside)
    }
    
    // MARK: - Ui life cycle
    
    override func loadView() {
        self.view = PlayscrView(frame: UIScreen.main.bounds)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        playscrView?.animatePlayer()
    }
    
    // MARK: - Animation func
    
    func animeObstacle(_ obstacle: UIImageView) {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = -obstacle.frame.size.height
        animation.toValue = playscrView?.enemiesSpott.frame.size.height
        animation.duration = model.obstacleSpeed
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Remove the obstacle when the animation is complete
            obstacle.removeFromSuperview()
            // Increment the count
            self.model.score += 1
            self.updateScoreLabel()
        }
        obstacle.layer.add(animation, forKey: "positionYAnimation")
        CATransaction.commit()
    }
    
    func returnToMainMenu() {
        self.dismiss(animated: true)
    }
    
    func saveScore(){
        let score = model.score
        UserDefaults.standard.set(score, forKey: KeyForUserDef.keyScore)
        saveManager.savePlayerRecord(score: score)
    }
}

// MARK: Extension

private extension PlayscrViewController {
    func stopGameAndShowAlert() {
        stopGame()
        saveScore()
        
        let alert = UIAlertController(title: "Game Over", message: "Score: \(model.score)", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.restartGame()
        }
        
        let mainMenuAction = UIAlertAction(title: "Main Menu", style: .default) { [weak self] _ in
            self?.returnToMainMenu()
        }
        alert.addAction(restartAction)
        alert.addAction(mainMenuAction)
        present(alert, animated: true, completion: nil)
    }
}
