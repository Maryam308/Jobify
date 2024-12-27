import UIKit

// Protocol that defines the delegate methods for the FilterHeaderView
protocol FilterHeaderViewDelegate: AnyObject {
    func toggleSection(header: FilterHeaderView, section: Int) // Method to toggle section
}

// Custom UITableViewHeaderFooterView for filter header
class FilterHeaderView: UITableViewHeaderFooterView {
    static let identifier = "FilterHeaderView" // Identifier for dequeuing
    weak var delegate: FilterHeaderViewDelegate? // Delegate to communicate with the view controller
    
    private var section: Int = 0 // Section index
    
    // Title label for the header
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold) // Set font size and weight
        label.textColor = .white // Set text color to white
        return label
    }()
    
    // Button to toggle the section expansion
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal) // Set button text color to white
        return button
    }()
    
    // Initializer for the header view
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Set the background color of contentView using the hex color 1D2D44
        contentView.backgroundColor = UIColor(hex: "1D2D44")
        
        // Add the title label and toggle button to the content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleButton)
        
        // Set up Auto Layout constraints for titleLabel and toggleButton
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16), // Leading constraint for titleLabel
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // Center vertically
            
            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), // Trailing constraint for toggleButton
            toggleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) // Center vertically
        ])
        
        // Add action for toggle button press
        toggleButton.addTarget(self, action: #selector(toggleSectionAction), for: .touchUpInside)
    }
    
    // Required initializer for decoding from storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // Not implemented
    }
    
    // Configure the header view with title, section index, and expansion state
    func configure(with title: String, section: Int, isExpanded: Bool) {
        titleLabel.text = title // Set the title text
        self.section = section // Store the section index
        toggleButton.setTitle(isExpanded ? "-" : "+", for: .normal) // Set button title based on expansion state
    }
    
    // Action method when the toggle button is pressed
    @objc private func toggleSectionAction() {
        delegate?.toggleSection(header: self, section: section) // Notify the delegate to toggle the section
    }
}
