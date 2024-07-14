//
//  DetailMapTableViewCell.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/19/24.
//

import UIKit
import MapKit

class DetailMapTableViewCell: UITableViewCell {
    
    private var mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.preferredConfiguration = MKStandardMapConfiguration()
        mv.showsUserLocation = true
        mv.isZoomEnabled = false
        mv.isZoomEnabled = false
        mv.isPitchEnabled = false
        mv.isRotateEnabled = false
        mv.showsUserLocation = false
        return mv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            mapView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            mapView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    func setupCell(mapX: String, mapY: String, title: String) {
        //꺼꾸리됨
        guard let latitude = Double(mapX), let longitude = Double(mapY) else {
            print("Invalid coordinates")
            return
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: longitude, longitude: latitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01,
                                    longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        
        mapView.addAnnotation(annotation)
    }
    
}
