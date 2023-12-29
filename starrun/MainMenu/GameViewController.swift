//
//  GameViewController.swift
//  starrun
//
//  Created by Александр on 15.12.2023.
//

import UIKit

final class GameViewController: UIViewController {
    // MARK: - Propirties
    
    weak var gameView: GameView? {
        guard isViewLoaded else { return nil }
        return (view as! GameView)
    }
    
    // MARK: - Ui life cycle
    
    override func loadView() {
        self.view = GameView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        self.targetEvents()
    }
    
    // MARK: - OBJC navigation func
    
    @objc func playButtonPress() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "PlayscrViewController") as? PlayscrViewController else {
            return
        }
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    @objc func settingsButtonPress() {
        guard let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        present(settingsVC, animated: true, completion: nil)
    }
    
    @objc func recordButtonPress() {
        guard let recordVC = storyboard?.instantiateViewController(withIdentifier: "RecordViewController") as? RecordViewController else {
            return
        }
        present(recordVC, animated: true, completion: nil)
    }
    
    // MARK: - Target Events
    
    func targetEvents() {
        //play button
        gameView?.playButton.addTarget(self, action: #selector(playButtonPress), for: .touchUpInside)
        //setting button
        gameView?.settingsButton.addTarget(self, action: #selector(settingsButtonPress), for: .touchUpInside)
        //record Button
        gameView?.recordButton.addTarget(self, action: #selector(recordButtonPress), for: .touchUpInside)
    }
}
