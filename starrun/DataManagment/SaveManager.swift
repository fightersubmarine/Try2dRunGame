//
//  SaveManager.swift
//  starrun
//
//  Created by Александр on 21.12.2023.
//

import Foundation
import UIKit

final class SaveManager {
    //MARK: - File Manager for image
    
    func saveImage(_ image: UIImage) throws -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let name = UUID().uuidString
        let fileURL = directory.appendingPathComponent(name)
        
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        try data.write(to: fileURL)
        
        return name
    }
    
    /// Загружает и возвращает картинку
    func loadImage(_ fileName: String) -> UIImage? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = directory.appendingPathComponent(fileName)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            // Handle or log the error
            return nil
        }
    }
    
    // MARK: Working with user defaults
    
    func getPlayerInfo(completion: @escaping ([PlayerCellModel]?) -> Void) {
        if let loadedData = UserDefaults.standard.data(forKey: KeyForUserDef.keyPLayerData) {
            do {
                let loadedPlayers = try JSONDecoder().decode([PlayerCellModel].self, from: loadedData)
                completion(loadedPlayers)
            } catch {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    func savePlayerName(name: String) {
        
        var existingPlayers = loadExistingPlayers() ?? []
        
        if let existingPlayerIndex = existingPlayers.firstIndex(where: { $0.name == name }) {
            // Игрок с таким именем уже существует
            
            existingPlayers[existingPlayerIndex].name = name
            // Здесь не устанавливаем score в 0, чтобы сохранить текущее значение
        } else {
            // Создаем нового игрока
            
            let newPlayer = PlayerCellModel(name: name, imageName: "", score: 0)
            existingPlayers.append(newPlayer)
        }
        
        savePlayerData(players: existingPlayers)
    }
    
    func savePlayerImageName(imageName: String) {
        if var existingPlayers = loadExistingPlayers() {
            if let lastPlayerIndex = existingPlayers.indices.last {
                // Обновляем изображение последнего игрока
                existingPlayers[lastPlayerIndex].imageName = imageName
            } else {
                // Если нет существующих игроков или последний игрок не имеет имени, создаем нового игрока с изображением
                let newPlayer = PlayerCellModel(name: "Player", imageName: imageName, score: 0)
                existingPlayers.append(newPlayer)
            }
            savePlayerData(players: existingPlayers)
        }
        
    }
    
    func savePlayerRecord(score: Int) {
        var newPlayerName = "Player"
        var newPlayerImage = "avatar"
        
        // Загружаем существующих игроков
        if var existingPlayers = loadExistingPlayers(), let lastPlayer = existingPlayers.last {
            newPlayerName = lastPlayer.name
            newPlayerImage = lastPlayer.imageName ?? "avatar"
            
            // Создаем нового игрока
            let newPlayer = PlayerCellModel(name: newPlayerName, imageName: newPlayerImage, score: score)
            
            // Добавляем нового игрока к существующим игрокам и сохраняем данные
            existingPlayers.append(newPlayer)
            savePlayerData(players: existingPlayers)
        } else {
            // Если массив игроков не существует, создаем новый массив и добавляем в него нового игрока
            let newPlayer = PlayerCellModel(name: newPlayerName, imageName: newPlayerImage, score: score)
            savePlayerData(players: [newPlayer])
        }
    }
}

// MARK: - Private Methods

private extension SaveManager {
    func loadExistingPlayers() -> [PlayerCellModel]? {
        if let existingData = UserDefaults.standard.data(forKey: KeyForUserDef.keyPLayerData) {
            do {
                let existingPlayers = try JSONDecoder().decode([PlayerCellModel].self, from: existingData)
                return existingPlayers
            } catch {
                print("Error decoding existing players: \(error)")
            }
        }
        return nil
    }
    
    func savePlayerData(players: [PlayerCellModel]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(players) {
            UserDefaults.standard.set(encoded, forKey: KeyForUserDef.keyPLayerData)
        }
    }
}
