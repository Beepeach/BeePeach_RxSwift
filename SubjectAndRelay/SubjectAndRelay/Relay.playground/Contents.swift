import UIKit
import RxSwift
import RxCocoa

// Relay
// Next만 전달합니다.
// dispose되기전까지 계속 동작
// 주로 UI에 사용

let bag = DisposeBag()

let publishRelay = PublishRelay<String>()
publishRelay.subscribe { print("Publish", $0) }
.disposed(by: bag)

// onNext대신 accept
publishRelay.accept("Hi")


// MARK: - Behavior

let behaviorRelay = BehaviorRelay<String>(value: "Hello")

behaviorRelay.accept("안녕")

behaviorRelay.subscribe { print("Behavior", $0) }
.disposed(by: bag)

behaviorRelay.accept("안뇽?")

print(behaviorRelay.value)
// read only


// MARK: - Replay
let replayRelay = ReplayRelay<String>.create(bufferSize: 5)

(0...10).forEach { replayRelay.accept("\($0)") }

replayRelay.subscribe { print("Replay", $0) }.disposed(by: bag)
