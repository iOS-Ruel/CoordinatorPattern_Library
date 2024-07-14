# CoordinatorPattern_Sample1

1. **AppCoordinator가 존재**
2. **모든 Coordinator에는 일련의 하위 Coordinator가 있음**

- 기본적으로 위 두가지를 기억하고 시작

##
### 1. Coordinator 프로토콜 생성

```swift
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
```

### 2. Coodinator를 채택하는 AppCoordinator 생성

```swift
class AppCoordinator: Coordinator {
		//Coordinator 프로토콜로 인해 childCoordinators, start() 구현 필요
    var childCoordinators: [Coordinator]
    
    func start() {
    }
}
```

### 3. isLoggedIn이 false면 Login 화면, true면 Main화면으로 이동

```swift
class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController!
    
    var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if self.isLoggedIn {
            self.showMainViewController()
        } else {
            self.showLoginViewController()
        }
    }
    
    private func showMainViewController() {
     
    }
    
    private func showLoginViewController() {
     
    }
}
```

### 4. SceneDelegate설정

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            
            let window = UIWindow(windowScene: windowScene)
            self.window = window

            let navigationController = UINavigationController()
            self.window?.rootViewController = navigationController
            
            let coordinator = AppCoordinator(navigationController: navigationController)
            coordinator.start()
            
            self.window?.makeKeyAndVisible()
        }
    } 
}
```

- window와 UINavigationController 생성
- AppCoordinator에 만든 navigationController를 넘겨주고 start메서드 호출

### 5. showLoginViewController 구현

### 5-1. LoginCoordinator구현

```swift
class LoginCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LoginViewController()        
        viewController.view.backgroundColor = .brown
        self.navigationController.viewControllers = [viewController]
    }
}
```

- LoginCoordinator의 start안에서 LoginViewController를 만들어줌

### 5-2. LoginViewController 구현

```swift
class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: #selector(self.loginButtonDidTap))
        self.navigationItem.rightBarButtonItem = item
    }
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    @objc func loginButtonDidTap() {
    }
}
```

- loginButtonDidTap을 구현해주어야함

### 5-3. LoginViewControllerDelegater구현

![Untitled](https://github.com/user-attachments/assets/d2fab8a2-e930-4980-bd8d-96e513c2ba52)

- LoginVIewController(VC1) 에서 Login 버튼을 누르면 LoginCoordinator(VC1 Coordinator)가 이를 알아야함
- 따라서 Delegate를 구현해주어야함

```swift
protocol LoginViewControllerDelegate {
    func login()
}

class LoginViewController: UIViewController {

    var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: #selector(self.loginButtonDidTap))
        self.navigationItem.rightBarButtonItem = item
    }
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    @objc func loginButtonDidTap() {
        self.delegate?.login()
    }
}
```

### 5-4. LoginCoordinator에서 대리자 설정

```swift
class LoginCoordinator: Coordinator, LoginViewControllerDelegate {

    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LoginViewController()
        viewController.view.backgroundColor = .brown
        viewController.delegate = self // ✅
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func login() {
       // 
    }
}
```

- LoginViewController에서 버튼이 눌리면 LoginCoordinator가 알아야 하기 때문에 delegate를 LoginCoordinator로 지정
- LoginViewControllerDelegate 채택 후 login 메서드 구현

### 5-5. AppCoordinator에게 로그인이 되었다고 알림

![Untitled](https://github.com/user-attachments/assets/61fc6857-0972-4576-80b5-73c79df5cfc1)

- 로그인이 되었다면 AppCoordinator에게 로그인이 되었다는 것을 알려 MainViewController(VC2로 이동시켜주어야함

### 5-6. LoginCoordinatorDelegate구현

```swift
protocol LoginCoordinatorDelegate { // ✅
    func didLoggedIn(_ coordinator: LoginCoordinator)
}

class LoginCoordinator: Coordinator, LoginViewControllerDelegate {

    var childCoordinators: [Coordinator] = []
    var delegate: LoginCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LoginViewController()
        viewController.view.backgroundColor = .brown
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func login() {
        self.delegate?.didLoggedIn(self)// ✅
    }
}
```

- LoginCoordinatorDelgate를 이용하여 LoginCoordinator와 AppCoordinator 연결

### 5-7. **showLoginViewController 구현**

```swift
class AppCoordinator: Coordinator, LoginCoordinatorDelegate {

    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController!
    
    var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if self.isLoggedIn {
            self.showMainViewController()
        } else {
            self.showLoginViewController()
        }
    }
    
    private func showMainViewController() {
        //
    }
    
    private func showLoginViewController() { // ✅
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func didLoggedIn(_ coordinator: LoginCoordinator) {  // ✅
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showMainViewController()
    }
}
```

- showLoginViewController에서 LoginCoordinator의 Delegate를 AppCoordinator로 지정
    - LoginCoordinator를 만들어준 뒤, childCoordinators배열에 만든 coordinator를 넣어줌
- AppCoordinator가 LoginCoordinatorDelegate를 채택하여 didLoggedIn 구현
    - didLoggedIn은 LoginCoordinator파라메터를 받는데 AppCoordinator가 가지고 있는 childeCoordinators에서 LoginCoordinator를 지워주기 위함
- 지워 준 후 MainViewController 메서드 호출

### 6. Main 작업

### 6-1. MainCoordinator 구현

```swift
protocol MainCoordinatorDelegate {
    func didLoggedOut(_ coordinator: MainCoordinator)
}

class MainCoordinator: Coordinator, MainViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var delegate: MainCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = MainViewController()
        viewController.view.backgroundColor = .cyan
        viewController.delegate = self
        self.navigationController.viewControllers = [viewController]
    }
    
    func logout() {
        self.delegate?.didLoggedOut(self)
    }
}
```

### 6-2. MainViewController 구현

```swift
protocol MainViewControllerDelegate {
    func logout()
}

class MainViewController: UIViewController {

    var delegate: MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logoutButtonDidTap))
        self.navigationItem.rightBarButtonItem = item
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    @objc
    func logoutButtonDidTap() {
        self.delegate?.logout()
    }
}
```

- 이와 같이 구현한다면 Coordinator 패턴을 구현하게 된거임

- 앞서 구현한 코드는 push, present 등의 화면 전환이 아니고 화면을 아예 변경하는 방식이기 때문에 push로 화면 전환하는 방식을 추가 구현해보자

### 7. Push 구현

### 7-1. MainViewController

- MainViewController에 push를 할 수 있는 버튼을 생성하고 앞서 만들어둔 MainViewControllerDelegate 프로토콜에 pushNextView() 메서드를 추가

```swift
protocol MainViewControllerDelegate {
    func logout()
    func pushNextView()
}
class MainViewController: UIViewController {
    var delegate: MainViewControllerDelegate?
    
    private lazy var pushButton: UIButton = {
       let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(didPushButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(pushButton)
        pushButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        let item = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logoutButtonDidTap))
        self.navigationItem.rightBarButtonItem = item
    }
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    @objc func logoutButtonDidTap() {
        self.delegate?.logout()
    }
    
    @objc func didPushButton() {
        self.delegate?.pushNextView()
    }
}

```

- 버튼을 터치했을때 pushNextView()가 실행되도록 구현

### 7-2. MainCoordinator

- MainViewController에서 실행된 pushNextView()를 처리하기 위해  MainCoordinator에서 NextViewController로 네비게이션 push가 되는 것을 구현

```swift
protocol MainCoordinatorDelegate {
    func didLoggedOut(_ coordinator: MainCoordinator)
    func didPushButton(_ coordinator: MainCoordinator)
}

func pushNextView() {
    self.delegate?.didPushButton(self)
}
```

- 앞서 만들어둔 MainCoordinatorDelegate 프로토콜에 didPushButton(_:) 메서드를 추가하고 didPushButton()실행

### 7-3. AppCoordinator

- AppCoordinator에 프로토콜을 채택 후 didPushButton(_:) 메서드 구현

```swift
func didPushButton(_ coordinator: MainCoordinator) {
    let coordinator = NextViewCoordinator(navigationController: self.navigationController)
    coordinator.start()
    coordinator.delegate = self
    childCoordinators.append(coordinator)
}
```

### 8. NextView

### 8-1. NextViewController 구현

```swift
protocol NextViewControllerDelegate {
    func popViewController()
}

class NextViewController: UIViewController {

    var delegate: NextViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
     override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate?.popViewController()
    }
    
    
}

```

- NextViewController에서 NextViewControllerDelegate 프로토콜을 구현해주었다. 앞선 ViewController에서 navigation push로 넘어오기때문에 navigation bar 를 통해 pop을 할 수 있지만, 현재 Coordinator를 사용하고 있고, 화면이 전환(pop)이 되는 것을 알리기 위해 프로토콜을 구현해주었다.
- 또한, NextviewController가 pop이 되는 것을 Coordinator에 알리기 위해 viewDidDisappear()에 popViewController()를 구현해주었다.

### 8-2. NextViewCoordinator 생성

```swift
protocol NextViewCoordinatorDelegate {
    func popViewController()
}

class NextViewCoordinator: Coordinator, NextViewControllerDelegate {
 
    var delegate: NextViewControllerDelegate?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let nextView = NextViewController()
        nextView.view.backgroundColor = .darkGray
        nextView.delegate = self
        self.navigationController.pushViewController(nextView, animated: true)
    }
    
    
    func popViewController() {
        self.delegate?.popViewController()
    }
}
```

- 앞서 구현한 방식과 동일하다고 보면된다. 그러나 start() 메서드를 보면 pushViewController()를 하고 있는 것을 볼 수 있다.
- 이전에는 화면을 변경하는 방식이였기 때문에 navigationController.viewControllers에 변경할 viewController를 할당해 주었지만 지금은 navigation push를 할 것이기 때문에 위와 같이 구현해 주었다.
- NextViewControllerDelegate 프로토콜에서 구현한 popViewController()를 구현해주고 NextViewCoordinatorDelegate 프로토콜을 구현하여 AppCoordinator에 NextViewController가 pop되었다는것을 알린다.

### 8-3. AppCoordinator

- NextViewControllerDelegate 프로토콜의 메서드를 구현해준다

```swift
 func popViewController() {
    navigationController.popViewController(animated: true)
    childCoordinators.removeLast()
}
```

- 해당 메서드를 실행하면 popViewController를 실행하고 AppCoordinator의 childCoordinators에서 마지막으로 추가된 coordinator만 지운다.
