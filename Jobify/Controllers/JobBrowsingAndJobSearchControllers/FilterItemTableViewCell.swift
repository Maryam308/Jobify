//
//  FilterItemTableViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 04/12/2024.
//


import UIKit

class FilterItemTableViewCell: UITableViewCell {
    
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var checkboxTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        checkboxButton.addTarget(self, action: #selector(checkboxAction), for: .touchUpInside)
        contentView.addSubview(checkboxButton)
        contentView.addSubview(itemLabel)
        
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            itemLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            itemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            itemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func checkboxAction() {
        checkboxButton.isSelected.toggle()
        checkboxTapped?()
    }
    
    func configure(with item: String, isSelected: Bool) {
        itemLabel.text = item
        checkboxButton.isSelected = isSelected
    }
}
