# CoordinatorPattern_Library
-  Coordinator Pattern에 대한 학습과 학습을 통한 샘플 프로젝트 모음

## Coordinator Pattern
여러 공부를 하면서 여러 디자인 패턴을 보게 되었는데, MVC-C, MVVM-C 등 처럼 C가 붙는 디자인 패턴들을 보게 되었다.

여기서 C는 Coordinaotr를 의미하고 있다고 한다.

## Coordinator 패턴이 생겨난 이유?
[**Soroush Khanlou의 The Coordinator**](https://khanlou.com/2015/01/the-coordinator/)를 보면 뷰컨트롤러에 많은 flow logic, view logic, business logic을 갖고 있어 큰문제로 얽혀있다고 말한다.

> One of the biggest problems with the big view controllers is that they entangle your flow logic, view logic, and business logic.

따라서, 이러한 logic들의 분리를 위해 Coordinator pattern이 생겼다고 볼 수 있을 것 같다.

## Coordinator를 사용하는 이유?
객체지향 설계 원칙(SOLID) 중 단일 책임의 원칙(Single Responsibility Principle)이 있다.

아키텍쳐를 설계할 때 객체는 하나의 책임만 가지고 있을 때 좋은 아키텍쳐라고 할 수 있는데, Coordinator 패턴은 이러한 관점에서 볼 수 있다.

기존에는 ViewController가 화면 전환을 담당하고 있었다. 따라서 부모 VC는 자식 VC를 알아야하고, 자식 VC에 필요한 객체, 인스턴스들을 부모 VC에서 생성해주어야 하기 때문에 서로간의 결합도가 높아질 수 밖에 없다.

이렇게 결합도가 높아지게 된다면 유지보수에 아주 불리하게 된다.

그러나 Coordinator 패턴을 사용하게 된다면 부모VC는 자식 VC를 알 필요가 없어진다.

자식 VC의 의존성을 주입하고 객체를 생성하여 화면을 전환하는 역할을 Coordinator가 담당하기 때문이다.

- VC가 직접 자식VC를 호출하는 것이 아닌 VC가 자기 자신의 Coordinator에게 자식 VC로 화면 전환을 시켜준다.

따라서 ViewController는 화면 전환에 대한 역할을 분리 할 수 있다.

## Coordinator의 역할?
앞서 언급한 것 처럼 Coordinator의 역할은 화면 전환을 담당하고 있다고 볼 수 있다.

1. 자신이 담당하는 VC의 필요한 인스턴스를 생성해서 주입
2. 의존성이 주입된 VC 인스턴스를 화면에 표시

위와 같은 역할을 수행하게 된다. ( ~~그러나 단일 책임의 원칙에 의하면 한가지 역할만 수행해야하는데 2가지 역할을 수행하고 있다 …~~)

## 느낀점
→ 개인적으로 느낀점

- Coordinator 패턴만 사용하고 있지만 타 디자인 패턴과 함께 한다면 더욱 효과적일 것이라고 생각된다. 그러나 Delegate 패턴이 모든 화면에 사용되다 보니 프로젝트가 커진다면 굉장히 코드가 복잡해질것(?)이라고 예상된다.
- 화면 전환에 관해서만 Delegate 패턴을 사용하는 것이 아니기 때문에 프로토콜을 구현했을 때 공용을 사용할 수 있도록 구현해야할 것 같다.

## 장단점 
- 앞서 느낀점이 있기 때문에 장단점을 추가로 더 찾아보았다.

Khanluou의 말에 의하면 장점은 아래와 같다.

1. 각 ViewController가 고립된다.
2. ViewController를 재사용할 수 있다.
3. 앱의 모든 작업과 하위 작업에 전용 캡슐화 방식이 적용된다.
4. Coordinator가 side effect로부터 display-binding을 분리한다.
5. Coordinator는 완전히 제어할 수 있는 객체이다.
- 개인적으로는 Khanluou가 언급한 장점에 대해 정확하게 장점이라고 이해되진 않는다.

- 단점이라고 한다면 개인적으로 느낀점에 단점이 포함되어있는 것 같다.
1. 수많은 Delegate 사용으로 인해 복잡성 증가
2. 작은 프로젝트에서는 필요 외로 규모가 커질가능성이 있다.


> 🌟 https://zeddios.medium.com/coordinator-pattern-bf4a1bc46930
> - zedd님의 포스팅 참고

