//import UIKit
//
//// Define your data models
//class GroupData {
//    var title: String
//    var topics: [TopicData]
//    var isExpanded: Bool = false
//    
//    init(title: String, topics: [TopicData]) {
//        self.title = title
//        self.topics = topics
//    }
//}
//
//class TopicData {
//    var title: String
//    var details: DetailData
//    var isExpanded: Bool = false
//    
//    init(title: String, details: DetailData) {
//        self.title = title
//        self.details = details
//    }
//}
//
//class DetailData {
//    var days: String
//    var marks: String
//    
//    init(days: String, marks: String) {
//        self.days = days
//        self.marks = marks
//    }
//}
//
//// Custom UITableViewCell subclasses
//class GroupCell: UITableViewCell {
//    // Customize your group cell
//}
//
//class TopicCell: UITableViewCell {
//    // Customize your topic cell
//}
//
//class DetailCell: UITableViewCell {
//    // Customize your detail cell
//}
//
//class HierarchicalTableViewController: UITableViewController {
//    
//    var groups: [GroupData] = [
//            GroupData(title: "Working with Ingredients", topics: [
//                TopicData(title: "Grades & Properties of Wheat Flour", details: DetailData(days: "1 Day", marks: "30 Marks")),
//                TopicData(title: "Role of Yeast & other Ingredients", details: DetailData(days: "1 Day", marks: "30 Marks")),
//                TopicData(title: "Fermentation & Proofing of Dough", details: DetailData(days: "3 Days", marks: "30 Marks"))
//            ]),
//            GroupData(title: "Oven & Baking Processes", topics: [
//                TopicData(title: "Baking Process", details: DetailData(days: "7 Days", marks: "70 Marks"))
//            ]),
//            GroupData(title: "Hygiene & Sanitation Part", topics: [
//                TopicData(title: "Sanitation", details: DetailData(days: "3 Days", marks: "20 Marks"))
//            ])
//        ]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
//        tableView.register(TopicCell.self, forCellReuseIdentifier: "TopicCell")
//        tableView.register(DetailCell.self, forCellReuseIdentifier: "DetailCell")
//        
//        // Initialize your data here...
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return groups.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let group = groups[section]
//                if group.isExpanded {
//                    return group.topics.reduce(0) { count, topic in
//                        // Add 1 for the topic cell, and if the topic is expanded, add 1 for the detail cell
//                        return count + 1 + (topic.isExpanded ? 1 : 0)
//                    }
//                } else {
//                    return 0
//                }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let group = groups[indexPath.section]
//                let topicIndex = self.indexForTopic(at: indexPath.row, in: group)
//                
//                if let topicIndex = topicIndex {
//                    // We have a topic index, so we return a TopicCell
//                    let topic = group.topics[topicIndex]
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! TopicCell
//                    // Configure your cell with topic.name
//                    // cell.textLabel?.text = topic.title
//                    return cell
//                } else {
//                    // We do not have a topic index, so we must be in a detail row
//                    let detailIndex = self.indexForDetail(at: indexPath.row, in: group)
//                    let detail = group.topics[detailIndex].details
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
//                    // Configure your cell with detail data
//                    // cell.textLabel?.text = "Days: \(detail.days), Marks: \(detail.marks)"
//                    return cell
//                }
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return groups[section].title
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let group = groups[indexPath.section]
//        
//        // Check if the first cell in the section was tapped, which represents the group header
//        if indexPath.row == 0 {
//            // Toggle expansion of the group
//            group.isExpanded.toggle()
//            if group.isExpanded {
//                // If we are expanding the group, set all topics to expanded as well
//                group.topics.forEach { $0.isExpanded = true }
//            } else {
//                // If we are collapsing the group, set all topics to collapsed
//                group.topics.forEach { $0.isExpanded = false }
//            }
//            // Animate the changes in the table view
//            tableView.reloadSections([indexPath.section], with: .automatic)
//        } else {
//            // If a topic cell was tapped, proceed with topic expansion/collapsing logic
//            // Calculate the actual index of the topic in the array
//            if let topicIndex = indexForTopic(at: indexPath.row, in: group) {
//                let topic = group.topics[topicIndex]
//                topic.isExpanded.toggle()
//                // Reload specific rows related to the topic
//                let topicIndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
//                tableView.reloadRows(at: [topicIndexPath], with: .automatic)
//            }
//        }
//    }
//    
//    private func indexForTopic(at rowIndex: Int, in group: GroupData) -> Int? {
//           var currentRow = 0
//           for (index, topic) in group.topics.enumerated() {
//               if currentRow == rowIndex {
//                   return index
//               }
//               currentRow += 1 + (topic.isExpanded ? 1 : 0)
//           }
//           return nil
//       }
//       
//       private func indexForDetail(at rowIndex: Int, in group: GroupData) -> Int {
//           var currentRow = 0
//           for (index, topic) in group.topics.enumerated() {
//               if currentRow == rowIndex - 1 {
//                   return index
//               }
//               currentRow += 1 + (topic.isExpanded ? 1 : 0)
//           }
//           fatalError("Should never reach here.")
//       }
//
//       // ... (rest of the HierarchicalTableViewController code)
//   }
//
//
