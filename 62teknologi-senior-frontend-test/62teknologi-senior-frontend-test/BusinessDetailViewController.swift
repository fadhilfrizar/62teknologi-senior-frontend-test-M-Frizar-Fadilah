//
//  BusinessDetailViewController.swift
//  62teknologi-senior-frontend-test
//
//  Created by Gery Ruslandi on 19/05/23.
//

import UIKit

class BusinessDetailViewController: UIViewController {
    // MARK: - Properties
    
    var business: Business?
    
    @IBOutlet private weak var photoSlideshow: UIImageView!
    @IBOutlet private weak var reviewsTableView: UITableView! {
        didSet {
            reviewsTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
            reviewsTableView.rowHeight = UITableView.automaticDimension
            reviewsTableView.estimatedRowHeight = 80

        }
    }
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var mapViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        guard let business = business else {
            return
        }
        
        // Set up photo slideshow
        photoSlideshow.image = UIImage(named: "placeholderImage") // Replace with your own placeholder image
        // You can use a third-party library like SDWebImage to load images asynchronously from URLs
        
        // Set up reviews table view
        reviewsTableView.dataSource = self
        reviewsTableView.delegate = self
        reviewsTableView.reloadData()
        
        // Configure UI elements with business data
//        photoSlideshow.image = UIImage(named: business.photos.first ?? "")
        ratingLabel.text = "Rating: \(business.rating ?? 0)"
        
        // Set up map view button
        mapViewButton.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
    }
    
    @objc private func openMaps() {
        guard let business = business,
              let latitude = business.coordinates?.latitude,
              let longitude = business.coordinates?.longitude,
              let url = URL(string: "https://maps.google.com/maps?q=\(latitude),\(longitude)") else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension BusinessDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension BusinessDetailViewController: UITableViewDelegate {
    // Implement any additional delegate methods as needed
}
