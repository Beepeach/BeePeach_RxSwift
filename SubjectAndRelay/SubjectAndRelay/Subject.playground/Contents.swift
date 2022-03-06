import Foundation
import RxSwift

enum CustomError: Error {
    case error
}

// Subject: Observable + Observer
// 구독 한 이전의 next는 사라지게됩니다.
let disposeBag: DisposeBag = DisposeBag()

let publish = PublishSubject<String>()

publish.onNext("Hello")

let observer1 = publish.subscribe {
    print("#1", $0)
}
observer1.disposed(by: disposeBag)

publish.onNext("Hi?")

let observer2 = publish.subscribe {
    print("#2", $0)
}
observer2.disposed(by: disposeBag)

publish.onNext("안뇽")
//subject.onCompleted()
publish.onError(CustomError.error)

let observer3 = publish.subscribe {
    print("#3", $0)
}
observer3.disposed(by: disposeBag)



// MARK: - Behavior
let behavior = BehaviorSubject<String>(value: "Hello")

behavior.subscribe{ print("Behavior",  $0) }
behavior.disposed(by: disposeBag)

behavior.onNext("Hi")

// 가장 마지막에 전달한 next를 전달합니다.
behavior.subscribe{ print("Behavior2",  $0) }
behavior.disposed(by: disposeBag)

behavior.onCompleted()

// Completed 이후라면 next는 전달되지 않습니다.
behavior.subscribe{ print("Behavior3",  $0) }
behavior.disposed(by: disposeBag)



// MARK: - Replay
// init이 아닌 create 메서드를 사용해서 생성
// buffer 크기만큼 이벤트를 저장합니다.
// 메모리에 저장되므로 버퍼를 크게 하면 좋지 않습니다.
let replay = ReplaySubject<String>.create(bufferSize: 4)

(1...10).forEach { replay.onNext("\($0)") }

replay.subscribe { print("Replay", $0) }.disposed(by: disposeBag)

replay.subscribe { print("Replay2", $0) }.disposed(by: disposeBag)

replay.onNext("11")

replay.subscribe { print("Replay3", $0) }.disposed(by: disposeBag)

replay.onCompleted()

// Completed, Error 이후에도 buffer에 저장된 next가 전달됩니다.
replay.subscribe { print("Replay4", $0) }.disposed(by: disposeBag)



// MARK: - Async
// completed가 전달돼야 최근 next를 하나 전달합니다.

let asyncSub = AsyncSubject<String>()

asyncSub.subscribe { print($0) }
.disposed(by: disposeBag)

asyncSub.onNext("Hello")
asyncSub.onNext("Hi")
asyncSub.onNext("안녕?")

asyncSub.onCompleted()
//asyncSub.onError(CustomError.error)




