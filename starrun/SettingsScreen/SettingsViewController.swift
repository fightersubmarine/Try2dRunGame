//
//  SettingsViewController.swift
//  starrun
//
//  Created by Александр on 28.11.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    //MARK: - Properties
    
    let defaults = UserDefaults.standard
    var settingsView: SettingsView
    var selectedImage: UIImage?
    private let saveManager = SaveManager()

    
    init() {
        self.settingsView = SettingsView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settingsView = SettingsView()
        super.init(coder: aDecoder)
    }
    
    //MARK: - load func
    
    private func loadAvatarImage() {
        if let fileName = UserDefaults.standard.string(forKey: KeyForUserDef.keyFileName) {
            // Load the image using the filename
            if let loadedImage = saveManager.loadImage(fileName) {
                // Use the loaded image in your UI
                settingsView.avatar.image = loadedImage
            }
        }
    }
    
    private func loadSavedName() {
        if let name = defaults.string(forKey: KeyForUserDef.keyName) {
            settingsView.nameTextField.text = name
        }
    }
    
    //MARK: - Ui life cycle
    
    override func loadView() {
        super.loadView()
        settingsView.delegate = self
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAvatarImage()
        loadSavedName()
    }
}

//MARK: - extension

extension SettingsViewController: SettingsViewDelegate {
    
    func nameDidChange(name: String) {
        UserDefaults.standard.set(name, forKey: KeyForUserDef.keyName)
        saveManager.savePlayerName(name: name)
    }
    
    func colorDidChange(color: UIColor) {
        saveColor(color: color)
    }
    
    func onEditButtonTaped(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            do {
                if let fileName = try saveManager.saveImage(pickedImage) {
                    settingsView.avatar.image = pickedImage
                    UserDefaults.standard.set(fileName, forKey: KeyForUserDef.keyFileName)
                    saveManager.savePlayerImageName(imageName: fileName)
                }
            } catch {
                print("Error saving image: \(error)")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - private extension

private extension SettingsViewController {
    func saveColor(color: UIColor) {
        let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        
        if let colorData = colorData {
            UserDefaults.standard.set(colorData, forKey: KeyForUserDef.keyColor)
        }
    }
}
