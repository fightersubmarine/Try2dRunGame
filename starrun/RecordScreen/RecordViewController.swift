//
//  RecordViewController.swift
//  starrun
//
//  Created by Александр on 20.12.2023.
//

import UIKit

final class RecordViewController: UIViewController {
    // MARK: - Properties
    
    var playersData: [PlayerCellModel] = []
    private let saveManager = SaveManager()
    
    // MARK: - Creating Ui
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Records"
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.textSize)
        label.autoSetDimension(.width, toSize: Constants.labelWidth)
        label.autoSetDimension(.height, toSize: Constants.labelHeight)
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = .leastNonzeroMagnitude
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    func setupConstraints() {
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.insert)
        
        tableView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: Constants.offset)
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    // MARK: Ui view hierarchy
    func addSubviews() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
    }
    
    // MARK: - Ui life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        DispatchQueue.main.async {
            self.updateTableView()
        }
    }
    
    // MARK: - Update TableView func
    
    func updateTableView() {
        saveManager.getPlayerInfo { [weak self] loadedPlayers in
            if let loadedPlayers = loadedPlayers {
                var uniquePlayers: [PlayerCellModel] = []
                
                for newPlayer in loadedPlayers {
                    // Проверяем, нет ли уже игрока с таким именем и счетом
                    let hasDuplicate = uniquePlayers.contains { $0.name == newPlayer.name && $0.score == newPlayer.score }
                    
                    // Проверяем, что счет не равен нулю перед добавлением в массив
                    if !hasDuplicate && newPlayer.score != 0 {
                        uniquePlayers.append(newPlayer)
                    }
                }
                // Добавляем уникальные данные в массив
                self?.playersData = uniquePlayers
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Extension

extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as? PlayerTableViewCell 
        else {
            return UITableViewCell()
        }
        
        let sortedPlayersData = playersData.sorted { $0.score > $1.score }
        
        let playerModel = sortedPlayersData[indexPath.row]
        cell.configure(with: playerModel)
        return cell
    }
}

// MARK: - Private extension

private extension RecordViewController {
    enum Constants {
        static let textSize: CGFloat = 40.0
        static let labelWidth: CGFloat = 224.0
        static let labelHeight: CGFloat = 64.0
        
        static let offset: CGFloat = 16.0
        static let insert: CGFloat = 16.0
    }
}
