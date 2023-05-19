//
//  ReviewCell.swift
//  62teknologi-senior-frontend-test
//
//  Created by Gery Ruslandi on 19/05/23.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet private weak var reviewTextLabel: UILabel!
        @IBOutlet private weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with review: Review) {
        reviewTextLabel.text = review.text
        ratingLabel.text = "\(review.rating)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
