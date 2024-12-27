//
//  FilterItemTableViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 04/12/2024.
//

import UIKit

// Custom UITableViewCell for filter items
class FilterItemTableViewCell: UITableViewCell {
    
    // Checkbox button to indicate selection
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal) // Image for unchecked state
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected) // Image for checked state
        button.tintColor = .systemBlue // Set button tint color
        return button
    }()
    
    // Label to display the item text
    private let itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        return label
    }()
    
    // Closure to handle checkbox tap action
    var checkboxTapped: (() -> Void)?
    
    // Initializer for the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell() // Call setup method to configure cell layout
    }
    
    // Required initializer for decoding from storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // Not implemented
    }
    
    // Method to set up the cell layout and add actions
    private func setupCell() {
        checkboxButton.addTarget(self, action: #selector(checkboxAction), for: .touchUpInside) // Add action for checkbox tap
        contentView.addSubview(checkboxButton) // Add checkbox button to content view
        contentView.addSubview(itemLabel) // Add item label to content view
        
        // Set up Auto Layout constraints for checkboxButton and itemLabel
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16), // Leading constraint
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // Center vertically
            checkboxButton.widthAnchor.constraint(equalToConstant: 24), // Fixed width
            checkboxButton.heightAnchor.constraint(equalToConstant: 24), // Fixed height
            
            itemLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12), // Leading constraint to checkbox
            itemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), // Trailing constraint
            itemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) // Center vertically
        ])
    }
    
    // Action method when the checkbox button is tapped
    @objc private func checkboxAction() {
        checkboxButton.isSelected.toggle() // Toggle the checkbox state
        checkboxTapped?() // Call the closure to notify about the tap
    }
    
    // Configure the cell with item text and selection state
    func configure(with item: String, isSelected: Bool) {
        itemLabel.text = item // Set the item label text
        checkboxButton.isSelected = isSelected // Update checkbox state
    }
}
