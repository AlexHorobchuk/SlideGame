//
//  StoreVC.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/15/23.
//

import Foundation
import UIKit

class ShopVC: UIViewController {
    init(game: SlideGame) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var closeButton = UIButton()
    var game: SlideGame
    var tableView = UITableView()
    var bonuses = Bonus.allCases.filter { $0 != Bonus.money}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.8))
        setupCloseButton()
        setupStoreScreen()
    }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.textAlignment = .center
        closeButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        closeButton.backgroundColor = .systemBlue
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.layer.cornerRadius = 12
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.1),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 90),
            closeButton.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func setupStoreScreen() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(ShopCell.self, forCellReuseIdentifier: "Bonus")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: view.frame.height * 0.02),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height * -0.10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func buyButtonTapped(bonus: Bonus) {
        SoundManager.shared.playSound(for: .click)
        let money = game.bonuses[.money] ?? 0
        let price = bonus.getBonusPrice()
        if price <= money {
            game.bonuses[.money]! -= price
            game.bonuses[bonus]! += 1
        } else {
            let alert = UIAlertController(title: "Error", message: "Not enough money to buy", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    
    
    
}

extension ShopVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bonus") as! ShopCell
        cell.selectionStyle = .none
        let bonus = bonuses[indexPath.row]
        let bonusImage = UIImage.createImageForBonus(bonus: bonus)
        let description = bonus.getBonusDescription()
        let price = String(bonus.getBonusPrice())
        let action = { [weak self] in self?.buyButtonTapped(bonus: bonus) }
        cell.set(bonusImage: bonusImage, description: description, price: price, action: action)
        return cell
    }
}
