//
//  PlayscrController.swift
//  starrun
//
//  Created by Алина on 17.10.2023.
//

import Foundation
import UIKit

class GameController {
    var model: GameModel
    weak var viewController: PlayscrViewController?
    var obstacleTimer: Timer?

    init(model: GameModel) {
        self.model = model
    }

    // Start the game
    func startGame() {
        viewController?.createStarryFall()
        startObstacleTimer()
    }

    // Start the timer to create obstacles
    func startObstacleTimer() {
        obstacleTimer = Timer.scheduledTimer(withTimeInterval: model.obstacleSpeed, repeats: true) { [weak self] _ in
            self?.viewController?.createRandomObstacle()
        }
    }

    // Increase the obstacle speed
    func increaseObstacleSpeed() {
        model.obstacleSpeed -= 0.5
        // You can update the UI or game logic as needed when the obstacle speed increases.
    }

    // Stop the game
    func stopGame() {
        obstacleTimer?.invalidate()
    }

    // Handle player movement to the left
    func movePlayerLeft() {
        guard let playerView = viewController?.playerView else { return }
        let minX: CGFloat = 0
        let newX = max(minX, playerView.frame.origin.x - 20)
        animatePlayerMovement(to: CGPoint(x: newX, y: playerView.frame.origin.y))
    }

    // Handle player movement to the right
    func movePlayerRight() {
        guard let playerView = viewController?.playerView else { return }
        let maxX: CGFloat = viewController?.enemiesSpot.frame.maxX ?? 0
        let newX = min(maxX - playerView.frame.width, playerView.frame.origin.x + 20)
        animatePlayerMovement(to: CGPoint(x: newX, y: playerView.frame.origin.y))
    }

    // Helper method to animate player's movement
    private func animatePlayerMovement(to position: CGPoint) {
        UIView.animate(withDuration: 0.1) {
            self.viewController?.playerView?.frame.origin = position
        }
    }
}
