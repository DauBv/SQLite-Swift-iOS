//
//  MyCell.swift
//  SQLite-Swift-iOS
//

import UIKit

class MyCell: UITableViewCell {
    
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbMath: UILabel!
    @IBOutlet weak var lbPhysic: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
