//
//  ViewController.swift
//  62teknologi-senior-frontend-test
//
//  Created by Gery Ruslandi on 19/05/23.
//

import UIKit

struct SearchResponse: Decodable {
    let businesses: [Business]?
}

struct Business: Decodable {
    let name: String?
    let location: BusinessLocation?
    let rating: Double?
    let coordinates: BusinessCordinates?
    
    init(name: String?, location: BusinessLocation?, rating: Double?, coordinates: BusinessCordinates?) {
        self.name = name
        self.location = location
        self.rating = rating
        self.coordinates = coordinates
    }
}

struct BusinessLocation: Decodable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let zip_code: String?
    let country: String?
    let state: String?
}

struct BusinessCordinates: Decodable {
    let latitude: Double?
    let longitude: Double?
}

struct Review: Decodable {
    let text: String
    let rating: Double
    
    init(text: String, rating: Double) {
        self.text = text
        self.rating = rating
    }
}

// View controller displaying the list of businesses
class BusinessController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BusinessCell")
        }
    }
    let searchController = UISearchController(searchResultsController: nil)
    var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Set up other view controller configurations
        
        // Load businesses
        searchBusinesses(with: "")
    }
    
    // Method to search businesses using Yelp API
    func searchBusinesses(with searchText: String) {
        let apiKey = "Ubf1-f0uqsJUnssqPMGo-tiFeZTT85oFmKfznlPmjDtX8s83jYMoAb-ApuD63wgq6LDZNsUXG6gurZIVYaj2jzxJmmLdCdXbDqIHU_b6KiCEVi8v-YB0OSsW6MWaY3Yx" // Replace with your Yelp API key
        let clientId = "DSj6I8qbyHf-Zm2fGExuug"
        let location = "San Francisco" // Set a default location or obtain the user's location
        
        // Create URL components
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")!
        
        var queryItems: [URLQueryItem] = []
        
        // Add search term query item if not empty
        if !searchText.isEmpty {
            let termQueryItem = URLQueryItem(name: "term", value: searchText)
            queryItems.append(termQueryItem)
        }
        
        // Add location query item
        let locationQueryItem = URLQueryItem(name: "location", value: location)
        queryItems.append(locationQueryItem)
        
        urlComponents.queryItems = queryItems
        
        // Create URL request
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(clientId, forHTTPHeaderField: "X-Yelp-Client-ID")
        
        
        // Send API request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle error
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    print(data)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SearchResponse.self, from: data)
                    print(response)
                    self.businesses = response.businesses ?? []
                    
                    // Print the businesses data
                    for business in self.businesses {
                        print(business.name)
                        print(business.location)
                    }
                    
                    // Update UI on the main thread (if needed)
                    DispatchQueue.main.async {
                        // Reload table view, update UI elements, etc.
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    // Handle JSON decoding error
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath)
        let business = businesses[indexPath.row]

        // Configure the cell with business information
        cell.textLabel?.text = business.name
        cell.detailTextLabel?.text = business.location?.city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "businessDetailViewController") as! BusinessDetailViewController
        controller.business = self.businesses[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension BusinessController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        searchBusinesses(with: searchBar.text ?? "")
    }
}

