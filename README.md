# 우리집 AI 냉장고
<div align = "left">
<img src="https://user-images.githubusercontent.com/108998071/231517002-0fde2e36-4d14-4cec-8dd5-2c60042acb54.png" height=200>
  </div>
  
<div align = "left">
  <a href="https://apps.apple.com/app/id6447197252" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-US?size=250x83&amp" alt="Download on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>
  </div>

## ✨ 프로젝트 소개

- 개인적으로 간단한 요리를 시작하게 되면서 식재료별로 유통기한도 다르고 보관방법이 다름에 따라 버려지는 식재료들이 많았습니다.
- 문득 누군가 보관방법과 유통기한을 알려주면 좋겠다 라는 생각에 추진한 프로젝트입니다.
- 개인 프로젝트로써 기획, 디자인, 개발을 혼자 진행했으며 4월 초 앱스토어에 런칭 완료했습니다.

💡 주요 활용 기술: `Swift`, `Code Based UIKit`, `Firebase`, `Reactive Programming`, `MVVM`, `SPM`

<div align = "center">
  <img width="25%" src="https://user-images.githubusercontent.com/108998071/231510260-57cca02f-a0cb-4fbd-9595-73d5d53fa1af.png">
  <img width="25%" src="https://user-images.githubusercontent.com/108998071/231510465-67750f4b-550b-4492-8e57-431ec1591c2d.png">
  <img width="25%" src="https://user-images.githubusercontent.com/108998071/231510550-7660eb6a-660f-4bed-96b5-0814bdd6a007.png">
</div>

<div align = "center">
  <img width="25%" src="https://user-images.githubusercontent.com/108998071/231510828-7e2153ce-2e72-4bfd-8c11-f108010c288a.png">
  <img width="25%" src="https://user-images.githubusercontent.com/108998071/231510928-fa8eb77e-20e7-4f5e-a4e0-add45108d993.png">
  <img width="25%" src="https://user-images.githubusercontent.com/108998071/231511055-211ad5af-6c88-4b8d-a580-0ad07c996694.png">
</div>





## 💡 주요 기능

### 1. 식재료를 관리할 수 있어요
![무제 2 001](https://user-images.githubusercontent.com/108998071/231511992-95d3add9-05c9-4f56-939a-9b4085f83a01.jpeg)
- 냉장고에 들어간 식재료를 한눈에 볼 수 있는 기능
- 등록한 식재료는 냉장실과 냉동실로 나뉘어져서 들어감
💡 UX 고민 결과, 한눈에 볼 수 있는 UI로 냉장실과 냉동실을 구분하도록 함

### 2. 간편하게 식재료를 등록할 수 있어요
![무제 2 002](https://user-images.githubusercontent.com/108998071/231512213-70af40bd-5852-4b5b-a6fa-3e98088c6321.jpeg)
- 등록 버튼을 누를 경우, 첫번째 대분류 이후에 식재료를 바로 선택해 간편하게 등록할 수 있도록 앱 구성
- 카테고리별로 자주 등록하는 식재료들을 미리 구성해둠
- 상세 등록 페이지(우측)로 이동시, AI가 추천한 유통기한이 자동으로 입력됨
냉장실 / 냉동실 변경시 추천 유통기한도 함께 변경됨

### 3. 냉장고 내부 식재료로 요리를 제안받아요
![무제 2 003](https://user-images.githubusercontent.com/108998071/231512304-7d6a27e8-38c6-4c37-a10a-52444cc430b7.jpeg)
- 내 냉장고 안에 있는 식재료들을 이용한 요리를 추천받을 수 있음
- AI의 답변은 복사하여 메모장 등에 붙여넣을 수 있음

### 4. 식재료 상세 관리를 할 수 있어요
![무제 2 004](https://user-images.githubusercontent.com/108998071/231512389-77e1be44-4777-4916-b9e0-dee753d19052.jpeg)
- 내 냉장고에 있는 식재료들의 상세정보를 볼 수 있음
- 남은 유통기한이 얼마인지 알 수 있으며, 남은 유통기한에 따라 경고 메시지가 달라짐
- AI에게 식재료의 보관방법, 레시피 등을 물어볼 수 있음

### 5. 소셜로그인
![무제 2 005](https://user-images.githubusercontent.com/108998071/231512468-2de304fb-2056-4e4b-b172-52530ccde7f3.jpeg)
- 카카오, 네이버, 구글, 애플 다양한 로그인 옵션을 지원함

---

## 📕 기술소개

### 1. MVVM + Combine
![Untitled](https://user-images.githubusercontent.com/108998071/231512574-8db914df-86a2-4e2e-80f1-15ea1ca48d12.png)
- ViewController와 ViewModel을 분리한 MVVM 디자인 패턴 사용함
- ViewController는 View와 유저인터랙션에 집중할 수 있는 코드 구성(Model을 모르도록)
- ViewModel은 비즈니스로직을 담당하도록 코드를 구성함
💡 추후, Input과 Output을 분리하여 관리하는 로직으로 리팩토링 예정

### 2. Firebase
- 유저 인증과 데이터 저장을 위해 빠르게 구현 가능한 Firebase를 활용함
- Firebase Authentication을 통한 4개의 소셜 로그인 구현
- FireStore를 활용한 유저 데이터, 아이템 데이터 저장 구현
    - 유저데이터: 이메일, 닉네임, 프로필이미지
    - 아이템데이터: 이름, 카테고리, 유통기한, 메모 등

---

## 🤔 나의 도전

### 1. 미리 입력하는 식재료의 데이터를 어떻게 저장할까
<img width="815" alt="스크린샷 2023-04-12 21 13 56" src="https://user-images.githubusercontent.com/108998071/231512702-f17fba0f-5004-4a78-8387-4d576e06a53d.png">

- 원격 데이터베이스와 로컬데이터베이스 그리고 enum을 고민하다가, 내부 코드로 관리할 수 있도록 enum의 case 내부에 데이터를 저장하도록 구성함
- 이 경우, 데이터들이 메모리에 위치한다는 단점이 있음
- 추후 데이터베이스로 해당 부분을 다시 구현할 예정

### 2. 채팅 UI 구현, 할일이 많다
<img width="1163" alt="스크린샷 2023-04-12 21 52 21" src="https://user-images.githubusercontent.com/108998071/231512773-becd9dd2-ac68-47d0-9714-fb877cad7704.png">

- 채팅 UI 구현에는 여러 고민해야 할 부분이 있었으며, 답변 복사 버튼도 존재함
    1. 비즈니스 로직과 View의 분리 - MVVM 적극 활용
        - 위 그림과 같은 MVVM 패턴으로 View 구현하기도 바쁜 ViewController의 부담을 덜어줌
        - viewModel은 AI의 답변으로 만든 AIChatModel에 의존성을 가짐
    2. 유동적인 말풍선 사이즈 구현
        - 채팅의 내용에 따른 유동적인 사이즈를 구현해야 함
        - ChatViewController에서는 Cell의 viewModel을 만들어 전달
        - FlowLayoutDelegate에서 viewModel 내부 함수 호출하여 CellSize를 리턴받아 활용
        
        
        ```swift
        func getCellSize(text: String? = nil) -> CGSize {
                var offsetText = ""
                
                if let text = text {
                    offsetText = text
                } else {
                    offsetText = self.content
                }
                
                let measurementLabel = UILabel(frame: .zero)
                measurementLabel.text = offsetText
                measurementLabel.font = .systemFont(ofSize: 14)
                measurementLabel.numberOfLines = 0
                measurementLabel.lineBreakMode = .byWordWrapping
                measurementLabel.translatesAutoresizingMaskIntoConstraints = false
                
                // 최대 가로 길이
                measurementLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
                
                let measurementLabelSize = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                let width = measurementLabelSize.width + CGFloat(30)
                var height = measurementLabelSize.height + CGFloat(20)
                // 버튼 높이 추가
                if type == .ai {
                    height += 45
                }
                return CGSize(width: width, height: height)
            }
        ```
        
        
    3. 채팅의 종류별 UI레이아웃 변경, 답변 복사하기 버튼 구현
        - enum으로 3개의 case를 만들어 관리(.ai, .my, .greeting)
        - 각 case별로 cell의 레이아웃이 달라지도록 분기처리 진행

### 3. ChatGPT API 호출 횟수 제한
- ChatGPT API는 저렴하지만, 유저 중 누군가 악의적으로 API를 너무 많이 호출하게 된다면, 비용적 부담이 될 수 있는 상황
- UserDefaults를 통해 API 호출 가능 횟수를 지정하고, 다음날이 되면 횟수가 초기화되도록 구현

```swift
class ApiCallCounter {
    static let shared = ApiCallCounter()
    private init() {}
    
    //MARK: - API 호출 제한
    // 호출 제한을 저장하는 UserDefault 키
    let apiCallCountKey = "apiCallCount"
    
    // 호출 제한
    let apiCallLimit = 25
    
    // 호출 제한 확인하기
    func checkShouldCallApi() -> Bool {
        let currentCount = getAPICallCount()
        if currentCount > 0 {
            return true
        } else {
            return false
        }
    }
    
    // 호출 횟수 가져오기
    func getAPICallCount() -> Int {
        return UserDefaults.standard.integer(forKey: apiCallCountKey)
    }
    
    // 호출 횟수 증가하기
    func decreaseAPICallCount() {
        let currentCount = getAPICallCount()
        UserDefaults.standard.set(currentCount - 1, forKey: apiCallCountKey)
    }
    
    //MARK: - API 호출 횟수 초기화
    // 새로운 날이 되면 호출 제한 초기화하기
    func resetAPICallCountIfNeeded() {
        let currentDate = Date()
        let userDefaults = UserDefaults.standard
        
        // 마지막으로 초기화한 날짜 가져오기
        let lastResetDate = userDefaults.object(forKey: "lastResetDate") as? Date ?? Date(timeIntervalSinceNow: -86400)
        
        let calendar = Calendar.current
        let currentDateComponent = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let lastResetDateComponent = calendar.dateComponents([.year, .month, .day], from: lastResetDate)
        
        // 마지막으로 초기화한 날짜가 없거나, 다음 날이 되었으면 초기화하기
        if currentDateComponent != lastResetDateComponent {
            resetAPICallCount()
            userDefaults.set(currentDate, forKey: "lastResetDate")
        }
    }
    // 호출 제한 초기화 함수
    func resetAPICallCount() {
        UserDefaults.standard.set(apiCallLimit, forKey: apiCallCountKey)
    }
}
```

### 4. 원격 알림이 아닌 로컬 알림, 관리는 어떻게?
![스크린샷 2023-04-13 00 31 09](https://user-images.githubusercontent.com/108998071/231512900-760ff68a-2956-4371-ac5a-5860d53ecd54.png)
- 우리집 냉장고에서는 유통기한이 임박했을 때 알림을 주는 서비스임
- 데이터베이스를 Firebase로 사용하기 때문에 원격 알림이면 좋겠지만, 빠른 구현을 위해 로컬 알림으로 진행
(Firebase에서도 방법은 있는 것 같으나, pass)
- 로컬 알림 관리를 위한 크게 두가지 경우가 있음
    1. 단일 식재료를 추가 / 제거할 때 - 알림 추가 및 등록
    2. 사용중인 계정으로 로그인 / 로그아웃
- a의 경우는 간단했지만, b의 경우 구현을 위해 UserDefault를 활용하기로 함
- 로그인시에 `ThisAccountFirstLogin: Bool` 을 관리하여, 첫 로그인시에는 fetch한 item들의 알림을 등록하도록 구현함
- 마찬가지로 로그아웃시에는 등록한 모든 알림을 제거함
