# Camplace Coordinaotr Pattern 적용 내용

1. **AppCoordinator가 존재**
2. **TabbarController를 Coordinator에서 직접 생성**
3. **각 Tab View에 해당하는 Coodinator 생성**


### Folder Tree

<details>
<summary>Tree</summary>  

```bash
├── API_KEY.xcconfig
├── CamPlace
│   ├── APIService
│   │   ├── APIError.swift
│   │   ├── APIService.swift
│   │   └── APIURL.swift
│   ├── App
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── AppCoordinator
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── CamplaceModel.xcdatamodeld
│   │   └── Camplace.xcdatamodel
│   │       └── contents
│   ├── Common
│   │   └── ImageLoader.swift
│   ├── Coordinator
│   │   ├── AppCoordinator.swift
│   │   └── Coordinator.swift
│   ├── CoreData
│   │   ├── Location+CoreDataClass.swift
│   │   ├── Location+CoreDataProperties.swift
│   │   └── Manager
│   │       └── CoreDataManager.swift
│   ├── Custom
│   │   └── Annotation
│   │       └── CustomAnnotation.swift
│   ├── Extension
│   │   ├── Extension+Bundle.swift
│   │   ├── Extension+UIImage.swift
│   │   └── Extension+UIImageView.swift
│   ├── Info.plist
│   ├── Main
│   │   ├── Detail
│   │   │   ├── Cell
│   │   │   │   ├── DetailImageTableViewCell.swift
│   │   │   │   ├── DetailInfoTableViewCell.swift
│   │   │   │   └── DetailMapTableViewCell.swift
│   │   │   ├── PlaceDetailViewController.swift
│   │   │   └── PlaceDetailViewModel.swift
│   │   ├── Faovrite
│   │   │   ├── LocationFavoriteCoordinator.swift
│   │   │   ├── LocationFavoriteViewController.swift
│   │   │   └── LocationFavoriteViewModel.swift
│   │   ├── MainMap
│   │   │   ├── MainMapViewController.swift
│   │   │   ├── MainMapViewCoordinator.swift
│   │   │   └── MainMapViewModel.swift
│   │   └── PlaceList
│   │       ├── PlaceListTableViewCell.swift
│   │       ├── PlaceListViewController.swift
│   │       └── PlaceListViewModel.swift
│   ├── Model
│   │   ├── BasedListModel.swift
│   │   ├── BasedSyncListModel.swift
│   │   ├── ImageListModel.swift
│   │   ├── LocationBasedListModel.swift
│   │   ├── MainResModel.swift
│   │   └── SearchListModel.swift
│   └── Tabbar
│       └── MainTabbarViewController.swift
└── README.md
```
</details>


### 1. Coordinator 프로토콜 생성

```swift
protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    func start()
}
```

### 2. Coodinator를 채택하는 AppCoordinator 생성

```swift
class AppCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    let window: UIWindow?
    
    init(_ window: UIWindow) {
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func start() {
        
    }
}
```

### 3. 각 Tab에 해당하는 ViewController의 Coordinator 생성
- MainMapViewController - Coordinator
```Swift
class MainMapViewCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    var childCoordinator: [Coordinator] = []
    
    
    init(){
        self.navigationController = .init()
    }
    
    func start() {
        
    }
    
 
    func startPush() -> UINavigationController {
        let mapViewController = MainMapViewController()
        mapViewController.delegate = self
        navigationController.setViewControllers([mapViewController], animated: false)
        
        return navigationController
    }
}
```
- LocationFavoriteController - Coordinator
```Swift
class LocationFavoriteCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    var childCoordinator: [Coordinator] = []
    
    
    init(){
        self.navigationController = .init()
    }
    
    func start() {
        
    }
    
 
    func startPush() -> UINavigationController {
        let locationFavoriteVC = LocationFavoriteViewController()
        locationFavoriteVC.delegate = self
        navigationController.setViewControllers([locationFavoriteVC], animated: false)
        
        return navigationController
    }
}
```

- start() 메서드를 사용하지 않고 startPush 메서드를 통해 UINavigationController를 return한 이유
    - AppCoordinator에서 TabbarController를 setup하기 위함
    TabbarController가 진입점이 되고 두개의 탭을 만들기 위해 TabbarController를 return하는 메서드 작성
    ```Swift
    //AppCoordinator 
    func setupTabbarController() -> UITabBarController {
        
        let tabbarController = MainTabbarViewController()
        
        let firstItem = UITabBarItem(title: "Map", 
                                    image: UIImage(systemName: "map"), 
                                    tag: 0)
        let secondItem = UITabBarItem(title: "Favorite", 
                                    image: UIImage(systemName: "star"), 
                                    tag: 1)
        
        let firstViewCoordinator = MainMapViewCoordinator()
        firstViewCoordinator.parentCoordinator = self
        childCoordinator.append(firstViewCoordinator)
        
        let mainMapVC = firstViewCoordinator.startPush()
        mainMapVC.tabBarItem = firstItem
        
        
        
        let secondViewCoordinator = LocationFavoriteCoordinator()
        secondViewCoordinator.parentCoordinator = self
        childCoordinator.append(secondViewCoordinator)
        
        let locationFavoritVC = secondViewCoordinator.startPush()
        locationFavoritVC.tabBarItem = secondItem
        
        tabbarController.viewControllers = [mainMapVC, locationFavoritVC]
        
        return tabbarController
    }

    //start메서드에서 rootViewContoller를 TabbarController로 변경
    func start() {
        self.window?.rootViewController = setupTabbarController()
    }
    ```

### 3. 화면 전환 메서드 작성
- LocationFavoriteViewController에서 DetailViewController로 Push를 통해 화면전환
```Swift
//LocationFavoriteCoordinator
extension LocationFavoriteCoordinator: LocationFavoriteDelegate {
    func pushDetialVC(content: LocationBasedListModel) {
        let viewModel = PlaceDetailViewModel(content: content)
        let vc = PlaceDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

//LocationFavoriteViewController
// - TableView Cell을 터치 할 시 화면전환
extension LocationFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    ...

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content: LocationBasedListModel = LocationBasedListModel(from: viewModel.locations[indexPath.row])

        delegate?.pushDetialVC(content: content)
    }
}

```
- MainMapViewController MainMapViewCoordinator로 Push를 통해 화면전환 및 Location List Present
```Swift

//MainMapViewController
protocol MainMapDelegate: AnyObject {
    func pushDetialVC(content: LocationBasedListModel)
    func presentLocationList(contents: [LocationBasedListModel])
}

class MainMapViewController: UIViewController {
    ...
    weak var delegate: MainMapDelegate?

    @objc private func listButtonTapped() {
        let locationList = viewModel.locationList
        delegate?.presentLocationList(contents: locationList)
    }
    ...
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

    ...
}


//MainMapViewCoordinator
extension MainMapViewCoordinator: MainMapDelegate {
    //상세화면 Push
    func pushDetialVC(content: LocationBasedListModel) {
        let viewModel = PlaceDetailViewModel(content: content)
        let vc = PlaceDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    

    // Location List View Present
    func presentLocationList(contents: [LocationBasedListModel]) {
        let listViewModel = PlaceListViewModel(locationList: contents)
        let listVC = PlaceListViewController(viewModel: listViewModel)
        let vc = UINavigationController(rootViewController: listVC)
        
        let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
            let screenHeight = UIScreen.main.bounds.height
            return screenHeight * 0.878912
        }
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [customDetent]
            sheet.preferredCornerRadius = 30
        }
        
        navigationController.present(vc, animated: true)
    }
}
```

### 느낀점
- 이전 Coordinator Pattern을 학습할 때 각 ViewContorller마다 Coordinator를 갖고 있었는데 이번 프로젝트에서는 모든 ViewControlelr들이 Coordinator를 갖지 않아도 된다라는 생각이 들었다.
    
    모든 ViewController가 Coordinator를 갖는지?

    필요한 ViewConroller만 Coodinator를 갖는지에 대한 **명확한 정답을 아직 잘 모르겠다.**

    <details>
    <summary>Chat GPT의 답변</summary>

    > Coordinator 패턴에서 모든 ViewController들이 Coordinator를 꼭 가져야 하는 것은 아닙니다. 
    >
    > 보통 다음과 같은 경우에 Coordinator를 사용하는 것이 좋습니다
    >    <br></br>
    > **복잡한 네비게이션 로직**    : 만약 ViewController 간의 이동이 복잡하거나 여러 단계로 이루어진다면 Coordinator를 사용하는 것이 유리합니다. 
    >
    >
    > 이를 통해 네비게이션 로직을 ViewController에서 분리하여 관리할 수 있습니다.
    >    <br></br>
    > **유지 보수성**: 네비게이션 로직이 분리되어 있으면 코드의 가독성이 좋아지고 유지 보수가 용이해집니다. 
    >
    >
    > 새로운 ViewController를 추가하거나 네비게이션 흐름을 변경할 때 Coordinator를 통해 쉽게 수정할 수 있습니다.
    >    <br></br>
    > **재사용성**: 네비게이션 로직을 재사용할 수 있습니다. 예를 들어, 동일한 네비게이션 흐름을 여러 곳에서 사용할 때 Coordinator를 통해 이를 중앙에서 관리할 수 있습니다.
    >
    >
    > 그러나 모든 ViewController에 Coordinator를 사용할 필요는 없습니다.
    >
    >
    > 간단한 ViewController의 경우 직접 네비게이션을 관리해도 무방합니다. 일반적인 가이드라인은 다음과 같습니다
    >    <br></br>
    > **간단한 화면 전환**: 간단한 화면 전환이나 단일한 화면으로 구성된 경우, Coordinator를 사용하지 않아도 됩니다.
    >    <br></br>
    > **중복되지 않는 네비게이션 로직**: 만약 특정 네비게이션 로직이 다른 곳에서 재사용되지 않는다면, 그 ViewController에만 해당 로직을 포함시킬 수 있습니다.
    >    <br></br>
    > <span style="color:red"> 따라서 필요한 ViewController에만 Coordinator를 사용하여 관리하는 것이 효율적입니다.  </span>
    >    <br></br>
    > 이러한 접근 방식은 코드의 복잡도를 낮추고, 필요한 경우에만 구조를 확장할 수 있는 유연성을 제공합니다.
    <br></br>
    - GPT의 답변을 모두 믿진 않지만 개인적인 생각과 일치한다고 생각해서 덧붙히게 되었다. 

        현재 해당 프로젝트에서는 복잡한 네비게이션 로직이 있지 않고 간단한 화면전환만 구현하고 있기 때문에 Coordinator Pattern이 적합하지 않을 수 있지만, 
        지속적인 유지보수와 기능 개발을 해야하는 프로젝트라고 한다면 Coordinator Pattern은 유용할 것으로 생각됨.

        다만, 개인적인 생각으로는 Coordinator를 통해 화면전환을 이룬다면 모든 ViewController들이 Coordinator를 갖고 있어야한다고 생각을 하고 있음
        
        (패턴 적용을 통해 기능(화면전환)의 분리를 하였는데 일부만 적용한다면 더욱 혼란스럽고, 해당 패턴을 적용하는 의미가 없어지는 것이라고 생각하기 때문)
    </details>
    
    

