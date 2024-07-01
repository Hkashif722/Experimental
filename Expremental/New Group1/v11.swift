//import UIKit
//
//struct Topic {
//    var name: String
//    var groups: [Group]
//    var isExpanded: Bool
//}
//
//struct Group {
//    var name: String
//    var details: [String]
//    var isExpanded: Bool
//}
//
//class VC10: UITableViewController {
//    var topics = [Topic]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureTopics()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
//        tableView.register(HierarchicalTableViewCell.self, forCellReuseIdentifier: "HierarchicalTableViewCell")
//        //        HierarchicalTableViewCell
//    }
//    
//    private func configureTopics() {
//        // Dummy Data
//        let group1 = Group(name: "Grades & Properties of Wheat Flour", details: ["Different types of flours & grading", "Learning about pH Value, Gluten", "Understanding diastatic capacity"], isExpanded: false)
//        let group2 = Group(name: "Grades & Properties of Wheat Flour", details: ["Different types of flours & grading", "Learning about pH Value, Gluten", "Understanding diastatic capacity"], isExpanded: false)
//        let topic1 = Topic(name: "Working with Ingredients", groups: [group1,group2], isExpanded: false)
//        let topic2 = Topic(name: "Working with Prople", groups: [group1], isExpanded: false)
//        topics.append(topic1)
//        topics.append(topic2)
//        // Add more topics here
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return topics.count
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let topic = topics[section]
//        if topic.isExpanded {
//            return topic.groups.reduce(1) { $0 + ($1.isExpanded ? $1.details.count + 1 : 1) }
//        }
//        return 1
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // ... the logic for determining the topic and group
//        let topic = topics[indexPath.section]
//        
//        // Instead of using `firstIndex(of:)`, calculate the index manually.
//        if indexPath.row == 0 {
//            // ... configuration for the first cell as a topic header
//            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
//                // Handle the failure to dequeue the custom cell
//                // You can return a default UITableViewCell if the cast fails
//                return UITableViewCell()
//            }
//            cell1.titleLabel.text = topic.name
//            cell1.iconImageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
//            cell1.indentationLevel = 0
//            return cell1
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HierarchicalTableViewCell", for: indexPath) as? HierarchicalTableViewCell else {
//                return UITableViewCell()
//            }
//            var cumulativeRows = 1
//            var groupIndex = -1 // Start from an invalid index
//            for (index, group) in topic.groups.enumerated() {
//                let groupRow = cumulativeRows
//                let nextCumulativeRows = cumulativeRows + (group.isExpanded ? group.details.count : 0) + 1
//                
//                if indexPath.row == groupRow {
//                    groupIndex = index
//                    cell.textLabel?.text = group.name
//                    cell.indentationLevel = 1
//                    break
//                } else if indexPath.row < nextCumulativeRows {
//                    groupIndex = index
//                    let detailIndex = indexPath.row - groupRow - 1
//                    cell.textLabel?.text = group.details[detailIndex]
//                    cell.indentationLevel = 2
//                    break
//                }
//                cumulativeRows = nextCumulativeRows
//            }
//            
//            // If groupIndex is valid, configure the cell
//            if groupIndex >= 0 {
//                let isLastChild = indexPath.row == cumulativeRows
//                cell.configureCell(indentationLevel: cell.indentationLevel, isLastChild: isLastChild)
//            }
//            
//            cell.selectionStyle = .none
//            return cell
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let section = indexPath.section
//        let row = indexPath.row
//        
//        if row == 0 {
//            // Toggle expansion for the section header
//            topics[section].isExpanded.toggle()
//        } else {
//            // Calculate the target row within the section based on expansion states
//            var targetRow = 1
//            for i in 0..<topics[section].groups.count {
//                if targetRow == row {
//                    // Found the group corresponding to the tapped row, toggle expansion
//                    topics[section].groups[i].isExpanded.toggle()
//                    break
//                }
//                // Update targetRow to point to the next group's header row
//                targetRow += (topics[section].groups[i].isExpanded ? topics[section].groups[i].details.count : 0) + 1
//            }
//        }
//        
//        // Efficiently reload only the affected sections
//        tableView.reloadSections([section], with: .automatic)
//    }
//    
//    
//    
//    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    //        if indexPath.row == 0 {
//    //            topics[indexPath.section].isExpanded.toggle()
//    //        } else {
//    //            var cumulativeRows = 1
//    //            for i in 0..<topics[indexPath.section].groups.count {
//    //                let groupRow = cumulativeRows
//    //                let group = topics[indexPath.section].groups[i]
//    //                cumulativeRows += 1 + (group.isExpanded ? group.details.count : 0)
//    //
//    //                if indexPath.row == groupRow {
//    //                    topics[indexPath.section].groups[i].isExpanded.toggle()
//    //                    break
//    //                }
//    //            }
//    //        }
//    //        tableView.reloadData()
//    //    }
//}
//
//
//
////MARK: - Table View Custom cells
//
//
//class HierarchicalTableViewCell: UITableViewCell {
//    
//    let hierarchyIndicator = UIView()
//    let lineLayer = CAShapeLayer()
//    var lineIndentationConstraint: NSLayoutConstraint = NSLayoutConstraint()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupHierarchyIndicator()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupHierarchyIndicator()
//    }
//    
//    private func setupHierarchyIndicator() {
//        hierarchyIndicator.backgroundColor = .clear // Set the background to clear
//        contentView.addSubview(hierarchyIndicator)
//        
//        // Set up the constraints for hierarchyIndicator
//        hierarchyIndicator.translatesAutoresizingMaskIntoConstraints = false
//        lineIndentationConstraint = hierarchyIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
//        lineIndentationConstraint.isActive = true
//        NSLayoutConstraint.activate([
//           
//            hierarchyIndicator.topAnchor.constraint(equalTo: contentView.topAnchor),
//            hierarchyIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            hierarchyIndicator.widthAnchor.constraint(equalToConstant: 20) // Set your desired width
//        ])
//        
//        // Draw the line and arrow
//        hierarchyIndicator.layer.addSublayer(lineLayer)
//    }
//    func configureCell(indentationLevel: Int, isLastChild: Bool) {
//        let lineWidth: CGFloat = 2
//        let path = UIBezierPath()
//        let lineStartX: CGFloat = 10 // starting x for line within the hierarchyIndicator
//        let additionalLineIndent: CGFloat = CGFloat(indentationLevel - 1) * 20.0 // Indent for additional levels
//
//        // Vertical line
//        path.move(to: CGPoint(x: lineStartX, y: 0))
//        path.addLine(to: CGPoint(x: lineStartX, y: contentView.bounds.height))
//
//        // Horizontal line and arrow for the last child
//        if isLastChild {
//            let lineEndX = lineStartX + 20 // end x for horizontal line within the hierarchyIndicator
//            let arrowStartX = lineEndX - 5 // start x for arrow
//
//            path.move(to: CGPoint(x: lineStartX, y: contentView.frame.midY))
//            path.addLine(to: CGPoint(x: lineEndX, y: contentView.frame.midY))
//
//            // Arrow pointing right
//            path.move(to: CGPoint(x: arrowStartX, y: contentView.frame.midY - 5))
//            path.addLine(to: CGPoint(x: lineEndX, y: contentView.frame.midY))
//            path.addLine(to: CGPoint(x: arrowStartX, y: contentView.frame.midY + 5))
//        }
//
//        lineLayer.path = path.cgPath
//        lineLayer.strokeColor = UIColor.black.cgColor
//        lineLayer.lineWidth = lineWidth
//        lineLayer.fillColor = nil // No fill for arrows and lines
//
//        // Update the constraint for indentation
//        lineIndentationConstraint.constant = additionalLineIndent
//
//        setNeedsLayout()
//    }
//}
//
//import UIKit
//
//class CustomTableViewCell: UITableViewCell {
//    // Define UI elements
//    let titleLabel = UILabel()
//    let iconImageView = UIImageView()
//    
//    // Custom initializer
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // Setup views
//    private func setupViews() {
//        // Add the image view
//        self.contentView.applyCardViewStyle()
//        iconImageView.contentMode = .scaleAspectFit
//        contentView.addSubview(iconImageView)
//        
//        // Add the label
//        titleLabel.font = .systemFont(ofSize: 16)
//        titleLabel.textColor = .black
//        contentView.addSubview(titleLabel)
//    }
//    
//    // Setup constraints
//    private func setupConstraints() {
//        iconImageView.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            // Constraints for the iconImageView
//            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            iconImageView.widthAnchor.constraint(equalToConstant: 30),
//            iconImageView.heightAnchor.constraint(equalToConstant: 30),
//            
//            // Constraints for the titleLabel
//            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//    }
//}
//
//
//
////MARK: - Extensions
//
//extension UIView {
//    
//    func applyCardViewStyle(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 10.0, shadowOpacity: Float = 0.3, shadowRadius: CGFloat = 5.0, shadowOffset: CGSize = CGSize(width: 0, height: 1), borderWidth: CGFloat = 0.0, borderColor: UIColor = .clear) {
//        // Set background color
//        self.backgroundColor = backgroundColor
//        
//        // Rounded corners
//        layer.cornerRadius = cornerRadius
//        clipsToBounds = false // Important for shadow to appear
//        
//        // Shadow properties
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = shadowOffset
//        layer.shadowRadius = shadowRadius
//        layer.shadowOpacity = shadowOpacity
//        
//        // Optional: Border
//        layer.borderWidth = borderWidth
//        layer.borderColor = borderColor.cgColor
//        
//        // Improve performance by rasterizing the layer
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
//    }
//}
