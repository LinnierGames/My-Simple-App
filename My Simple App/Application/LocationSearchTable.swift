//
//  LocationSearchTable.swift
//  My Simple App
//
//  Created by Samuel Folledo on 3/2/21.
//  Copyright © 2021 Erick Sanchez. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    
    weak var handleAddAddressDelegate: HandleAddAddress?
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tableView.register(LocationSearchCell.self, forCellReuseIdentifier: String(describing: LocationSearchCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        let streetNumber = selectedItem.subThoroughfare
        let streetName = selectedItem.thoroughfare
        let cityName = selectedItem.locality
        var streetAddress: String?
        if let streetNumber = streetNumber,
           let name = streetName {
            streetAddress = "\(streetNumber) \(name)"
        } else if let areaName = selectedItem.name, areaName != cityName {
            streetAddress = areaName
        }
//        let countyName = selectedItem.subAdministrativeArea
        let stateName = selectedItem.administrativeArea
        // put a comma between street and city/state
        let comma = streetAddress != nil && cityName != nil ? ", " : ""
        // put a comma between city and state
        let secondComma = (cityName != nil &&
                            stateName != nil) ? ", " : ""
        let addressLine = "\(streetAddress ?? "")\(comma)\(cityName ?? "")\(secondComma)\(stateName ?? "")"
        return addressLine
    }
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard //let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        //request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = Array(NSOrderedSet(array: response.mapItems)) as! [MKMapItem] //filter duplicates
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationSearchCell.self), for: indexPath) as! LocationSearchCell
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        print("Selected item is \(selectedItem)")
        handleAddAddressDelegate?.addNewItem(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
