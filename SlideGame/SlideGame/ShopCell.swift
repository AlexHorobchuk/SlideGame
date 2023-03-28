//
//  TableViewCell.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/15/23.
//

import UIKit

class ShopCell: UITableViewCell {
    var action: (() -> ()?)?
    var bonusImageView = UIImageView()
    var bonusDescriptionLabel = UILabel()
    var bonusPriceLabel = UILabel()
    var buyButton = UIButton()
    var vStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureBonusImageLabel()
        configureBonusDescriptionLabel()
        configureBuyButton()
        setupVStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(bonusImage: UIImage, description: String, price: String, action: @escaping (() -> ()?)) {
        self.action = action
        self.backgroundColor = .clear
        bonusImageView.image = bonusImage
        bonusDescriptionLabel.text = description
        buyButton.setTitle("Buy: $\(price)", for: .normal)
    }
    
    @objc func buyButtonTapped() {
        SoundManager.shared.playSound(for: .click)
        guard let action = action else {
            return print("close wasn`t found")
        }
        action()
    }
    
    func configureBuyButton() {
        contentView.addSubview(buyButton)
        buyButton.titleLabel?.textAlignment = .center
        buyButton.setTitleColor( UIColor.white, for: .normal)
        buyButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        buyButton.backgroundColor = .systemBlue
        buyButton.layer.cornerRadius = 10
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buyButton.widthAnchor.constraint(equalToConstant: 100),
            buyButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    func configureBonusImageLabel() {
        addSubview(bonusImageView)
        bonusImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bonusImageView.widthAnchor.constraint(equalToConstant: 100),
            bonusImageView.heightAnchor.constraint(equalToConstant: 100)])
    }
   
    func configureBonusDescriptionLabel() {
        addSubview(bonusDescriptionLabel)
        bonusDescriptionLabel.textColor = .systemBlue
        bonusDescriptionLabel.backgroundColor = .clear
        bonusDescriptionLabel.font = .systemFont(ofSize: 20)
        bonusDescriptionLabel.numberOfLines = 0
        bonusDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bonusDescriptionLabel.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    func setupVStack() {
        addSubview(vStack)
        vStack.backgroundColor = .clear
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.alignment = .center
        vStack.distribution = .equalSpacing
        [bonusImageView, bonusDescriptionLabel, buyButton].forEach { subview in
            vStack.addArrangedSubview(subview)
        }
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            vStack.leftAnchor.constraint(equalTo: leftAnchor),
            vStack.rightAnchor.constraint(equalTo: rightAnchor)])
        
    }
}
