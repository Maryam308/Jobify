import UIKit

protocol FilterHeaderViewDelegate: AnyObject {
    func toggleSection(header: FilterHeaderView, section: Int)
}

class FilterHeaderView: UITableViewHeaderFooterView {
    static let identifier = "FilterHeaderView"
    weak var delegate: FilterHeaderViewDelegate?
    
    private var section: Int = 0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white // Set text color to white
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal) // Set button text color to white
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Set the background color of contentView using the hex color 1D2D44
        contentView.backgroundColor = UIColor(hex: "1D2D44")
        
        // Add the title label and toggle button
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleButton)
        
        // Set up Auto Layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Add toggle button action
        toggleButton.addTarget(self, action: #selector(toggleSectionAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, section: Int, isExpanded: Bool) {
        titleLabel.text = title
        self.section = section
        toggleButton.setTitle(isExpanded ? "-" : "+", for: .normal)
    }
    
    @objc private func toggleSectionAction() {
        delegate?.toggleSection(header: self, section: section)
    }
}
