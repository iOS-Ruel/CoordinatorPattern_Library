//
//  MainMapViewController.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/15/24.
//

import UIKit
import MapKit
import CoreLocation
import Combine

protocol MainMapDelegate: AnyObject {
    func pushDetialVC(content: LocationBasedListModel)
    func presentLocationList(contents: [LocationBasedListModel])
}

class MainMapViewController: UIViewController {
    private let mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.preferredConfiguration = MKStandardMapConfiguration()
        mv.showsUserLocation = true
        mv.register(CustomAnnotationView.self,
                    forAnnotationViewWithReuseIdentifier: "CustomAnnotationView")
        mv.register(CustomClusterAnnotationView.self,
                    forAnnotationViewWithReuseIdentifier: "CustomClusterAnnotationView")
        return mv
    }()
    
    private lazy var listButton: UIButton = {
        let button = createButton(title: "목록 보기", image: "list.bullet", action: #selector(listButtonTapped))
        return button
    }()
    
    private lazy var currentPlaceButton: UIButton = {
        let button = createButton(title: "현재 위치로 이동", image: nil, action: #selector(currentButtonTapped))
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var isFirstLocationUpdate = true
    private let viewModel = MainMapViewModel()
    
    weak var delegate: MainMapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.view.backgroundColor = .white
        setUpMapView()
        setupUI()
        setupLocationManager()
        setupBindings()
    }
    
    private func setUpMapView() {
        self.view.addSubview(mapView)
        mapView.delegate = self
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        self.view.addSubview(listButton)
        NSLayoutConstraint.activate([
            listButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listButton.heightAnchor.constraint(equalToConstant: 40),
            listButton.widthAnchor.constraint(equalToConstant: 120),
            listButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -30)
        ])
        
        self.view.addSubview(currentPlaceButton)
        NSLayoutConstraint.activate([
            currentPlaceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentPlaceButton.heightAnchor.constraint(equalToConstant: 40),
            currentPlaceButton.widthAnchor.constraint(equalToConstant: 120),
            currentPlaceButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func createButton(title: String, image: String?, action: Selector) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        if let imageName = image {
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupBindings() {
        viewModel.$locationList
            .receive(on: DispatchQueue.main)
            .sink {[weak self] lists in
                self?.addPinsToMap(lists)
            }
            .store(in: &cancellables)
    }
    
    private func addPinsToMap(_ items: [BasedItem]) {
        for item in items {
            guard let latitude = Double(item.mapY ?? ""),
                  let longitude = Double(item.mapX ?? "") else {
                print("Invalid coordinates")
                continue
            }
            let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                    longitude: longitude)
            let annotation = CustomAnnotation(coordinate: coordinate, item: item)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func listButtonTapped() {
        let locationList = viewModel.locationList
        delegate?.presentLocationList(contents: locationList)
        
    }
    
    @objc private func currentButtonTapped() {
        guard let coordinator = locationManager.location?.coordinate else {
            return
        }
        
        setRegion(coordinate: coordinator)
    }
}

extension MainMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if isFirstLocationUpdate {

            setRegion(coordinate: location.coordinate)
            isFirstLocationUpdate = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to Fetch Location (\(error))")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined, .denied, .restricted:
            print("Location Auth: Denied")
        default:
            break
        }
    }
}

extension MainMapViewController: MKMapViewDelegate {
    //Annotaion CallOut Touch PushViewController
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let title = view.annotation?.title, let placeName = title {
            if let content = viewModel.getLocationContent(title: placeName) {
                
                delegate?.pushDetialVC(content: content)
                
            }
        }
        
    }
    
    private func setRegion(coordinate: CLLocationCoordinate2D, didSelect: Bool = false) {
            
        if !didSelect {
            mapView.removeAnnotations(mapView.annotations)
            
            viewModel.getLocationList(mapX: "\(coordinate.longitude)",
                                      mapY: "\(coordinate.latitude)",
                                      radius: "20000")
        }
        
        //center: 지도 중심 좌표
        //lati, long Meters: 지도 중심 기준으로 위경도 1000미터 범위 영역 설정 ( 1Km x 1Km )
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)

        //region을 기준으로 지도 업데이트
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let clusterAnnotation = view.annotation as? MKClusterAnnotation {
            if let first = clusterAnnotation.memberAnnotations.first {
                setRegion(coordinate: first.coordinate, didSelect: true)
                mapView.selectAnnotation(clusterAnnotation, animated: true)
            }
        } else {
            guard let coordinate = view.annotation?.coordinate else { return }
            setRegion(coordinate: coordinate, didSelect: true)
            
            if let annotation = view.annotation {
                mapView.selectAnnotation(annotation, animated: true)
            }
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let cluster = annotation as? MKClusterAnnotation {
            //Cluste Annotation일 경우 Custom Cluster Annotation 반환
            return dequeueClusterAnnotationView(for: cluster, on: mapView)
        } else if let customAnnotation = annotation as? CustomAnnotation {
            //Custom Annotation일 경우 Custom Annotation 반환
            return dequeueCustomAnnotationView(for: customAnnotation, on: mapView)
        }
        return nil
    }
    
    private func dequeueClusterAnnotationView(for cluster: MKClusterAnnotation, on mapView: MKMapView) -> CustomClusterAnnotationView? {
        let identifier = "CustomClusterAnnotationView"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomClusterAnnotationView

        annotationView?.annotation = cluster
        
        return annotationView
    }
    
    private func dequeueCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> CustomAnnotationView? {
        let identifier = "CustomAnnotationView"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
        annotationView?.annotation = annotation
        
        return annotationView
    }

}
