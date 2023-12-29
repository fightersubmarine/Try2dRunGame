//
//  PlayerTableViewCell.swift
//  starrun
//
//  Created by Александр on 23.12.2023.
//

import UIKit
import PureLayout

final class PlayerTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static var identifier: String {"\(Self.self)"}
    
    private let saveManager = SaveManager()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLable)
        contentView.addSubview(recordLable)
        contentView.addSubview(avatarImage)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Creating UI
    
    lazy var nameLable: UILabel = {
        var lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: Constants.nameTextSize)
        lable.numberOfLines = 0
        
        return lable
    }()
    
    lazy var recordLable: UILabel = {
        var lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: Constants.recordTextSize)
        lable.numberOfLines = 0
        
        return lable
    }()
    
    lazy var avatarImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = Constants.borderWidh
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        imageView.autoSetDimensions(to: CGSize(width: Constants.avatarImageSize, height: Constants.avatarImageSize))
        return imageView
    }()
    
    func setupConstraints() {
        avatarImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        avatarImage.autoPinEdge(toSuperviewEdge: .left, withInset: Constants.insert)
        avatarImage.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.offset)
        
        nameLable.autoAlignAxis(toSuperviewAxis: .horizontal)
        nameLable.autoPinEdge(.leading, to: .trailing, of: avatarImage, withOffset: Constants.offset)
        
        recordLable.autoAlignAxis(toSuperviewAxis: .horizontal)
        recordLable.autoPinEdge(toSuperviewEdge: .right, withInset: Constants.insert)
    }
    
    // MARK: - Configure and prepareForReuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLable.text = nil
        recordLable.text = nil
        avatarImage.image = nil
    }
    
    func configure(with model: PlayerCellModel){
        nameLable.text = model.name
        recordLable.text = "\(model.score)"
        if let image = saveManager.loadImage(model.imageName ?? "avatar"){
            avatarImage.image = image
        } else {
            avatarImage.image = UIImage(named: "avatar")
        }
    }
}

// MARK: - Private Extension

private extension PlayerTableViewCell {
    enum Constants {
        static let recordTextSize: CGFloat = 30.0
        static let nameTextSize: CGFloat = 20.0
        static let avatarImageSize: CGFloat = 54.0
        static let cornerRadius: CGFloat = 27.0
        static let borderWidh: CGFloat = 3.0
        static let offset: CGFloat = 8.0
        static let insert: CGFloat = 16.0
    }
}
