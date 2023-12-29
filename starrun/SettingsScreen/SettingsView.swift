//
//  SettingsView.swift
//  starrun
//
//  Created by Александр on 17.12.2023.
//

import UIKit
import PureLayout

protocol SettingsViewDelegate: AnyObject {
    func colorDidChange(color: UIColor)
    func nameDidChange(name: String)
    func onEditButtonTaped()
}

final class SettingsView: UIView, UITextFieldDelegate{
    // MARK: -Properties
    
    weak var settingsViewCnt: SettingsViewController?
    weak var delegate: SettingsViewDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect ) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        self.addSubviews()
        self.setupConstraints()
        self.targetSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Сreating a view
    
    lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.title = "Rocket color"
        return colorWell
    }()
    
    lazy var avatar: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "avatar.jpg")
        imageView.autoSetDimensions(to: CGSize(width: Constants.defSize, height: Constants.defSize))
        imageView.layer.borderWidth = Constants.borderWidhForAvatar
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = Constants.cornerRadiusForAvatar
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var upperView: UIView = {
        let view = UIView()
        view.autoSetDimension(.height, toSize: Constants.defSize)
        view.backgroundColor = .gray
        view.alpha = 0.5
        return view
    }()
    
    lazy var changeColorLabel: UILabel = {
        let label = UILabel()
        label.text = "Сhange rocket color"
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.autoSetDimension(.width, toSize: Constants.colorLableWidth)
        label.autoSetDimension(.height, toSize: Constants.colorLableHeight)
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit photo", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = Constants.borderWidh
        button.tintColor = .white
        button.backgroundColor = .clear
        button.autoSetDimension(.width, toSize: Constants.editButSize)
        button.autoSetDimension(.height, toSize: Constants.editButSize)
        return button
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.borderStyle = .roundedRect
        textField.delegate = self // Ensure to conform to UITextFieldDelegate
        return textField
    }()
    
    // MARK: - Func
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.nameDidChange(name: textField.text ?? "")
    }
    
    @objc func changeColor(_ sender: UIColorWell) {
        if let selectedColor = sender.selectedColor {
            delegate?.colorDidChange(color: selectedColor)
        }
    }
    
    @objc func editButtonTapped() {
        delegate?.onEditButtonTaped()
    }
    
    func targetSetup() {
        colorWell.addTarget(self, action: #selector(changeColor(_:)), for: .valueChanged)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - VIEW Hierarchie
    
    func addSubviews() {
        self.addSubview(upperView)
        self.addSubview(avatar)
        self.addSubview(editButton)
        self.addSubview(nameTextField)
        self.addSubview(changeColorLabel)
        self.addSubview(colorWell)
    }
    
    // MARK: - VIEW setupConstraints
    
    func setupConstraints() {
        //Constraints for avatar
        avatar.autoAlignAxis(toSuperviewAxis: .vertical)
        avatar.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.avatarInsert)
        
        //Constraints for upperView
        upperView.autoPinEdge(toSuperviewEdge: .left)
        upperView.autoPinEdge(toSuperviewEdge: .right)
        upperView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        //Constraints for editButton
        editButton.autoAlignAxis(toSuperviewAxis: .vertical)
        editButton.autoPinEdge(.top, to: .bottom, of: nameTextField, withOffset: Constants.editBoffset)
        
        //Constraints for changeColorLabel
        changeColorLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        changeColorLabel.autoPinEdge(.top, to: .bottom, of: editButton, withOffset: Constants.offset)
        
        
        //Constraints for colorWell
        colorWell.autoAlignAxis(toSuperviewAxis: .vertical)
        colorWell.autoPinEdge(.top, to: .bottom, of: changeColorLabel, withOffset: Constants.offset)
        
        //Constraints for nameTextField
        nameTextField.autoPinEdge(.top, to: .bottom, of: avatar, withOffset: Constants.offset)
        nameTextField.autoPinEdge(toSuperviewEdge: .left, withInset: Constants.insert)
        nameTextField.autoPinEdge(toSuperviewEdge: .right, withInset: Constants.insert)
    }
}

// MARK: - Private extension

private extension SettingsView {
    enum Constants {
        static let colorLableHeight: CGFloat = 56.0
        static let colorLableWidth: CGFloat = 164.0
        static let editButSize: CGFloat = 96.0
        static let defSize: CGFloat = 128.0
        static let cornerRadiusForAvatar: CGFloat = 64
        static let borderWidhForAvatar: CGFloat = 3
        static let cornerRadius: CGFloat = 48
        static let borderWidh: CGFloat = 1
        static let editBoffset: CGFloat = 36.0
        static let avatarInsert: CGFloat = 64.0
        static let offset: CGFloat = 16.0
        static let insert: CGFloat = 16.0
    }
}
