//
//  ViewController.swift
//  SubjectAndRelay
//
//  Created by JunHeeJo on 4/29/22.
//

import UIKit
import RxSwift

class SubjectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let disposeBag = DisposeBag()
        
        // MARK: - Subject
        // Observable이면서 Observer입니다.
        
        
        // MARK: - PublishSubject
        // 가장 기본적인 subject입니다.
        // init()을 이용해서 생성합니다.
        let publishSubject = PublishSubject<Int>()
        
        // ObserverType이기때문에 on(_:)을 이용해서 이벤트를 전달할 수 있습니다.
        // 하지만 지금은 subscriber가 존재하지 않기때문에 이 이벤트는 전달되지 않습니다.
        publishSubject.onNext(10)
        
        // 구독을 시작하면 이전에 전달한 이벤트는 버려집니다.
        publishSubject
            .subscribe {
                print("PublishSubject >>>", $0)
            }
            .disposed(by: disposeBag)
        
        // 구독자가 생긴 이후에 전달하면 전달됩니다.
        publishSubject.onNext(20)
        
        // Completed, Error가 전달되면 그 이후 이벤트는 전달되지 않습니다.
        publishSubject.onCompleted()
        publishSubject.onNext(30)
        
        // 만약 Completed, Error가 전달된 후에 subscriber가 추가된다면 바로 completed, error가 전달됩니다.
        publishSubject
            .subscribe {
                print("PubishSubject2 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        
        
        
        // MARK: - Behavior Subject
        // 구독을 하면 가장 최근 이벤트를 전달합니다.
        // 기본값이 있기때문에 init(value:)로 생성합니다.
        let behaviorSubject = BehaviorSubject<String>(value: "RxSwift")
        
        // 구독을 하면 기본값이 전달됩니다.
        behaviorSubject
            .subscribe {
                print("BehaviorSubject >>>", $0)
            }
            .disposed(by: disposeBag)
        
        behaviorSubject.onNext("RxCocoa")
        
        // 가장 최근 이벤트를 전달하기 때문에 전달된 값이 달라졌습니다.
        behaviorSubject
            .subscribe {
                print("BehaviorSubject2 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        // Completed, Error가 전달된 이후에 구독을 추가하면 기본값을 전달하지 않고 바로 completed, error가 전달됩니다.
        behaviorSubject.onCompleted()
        
        behaviorSubject
            .subscribe {
                print("BehaviorSubject3 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        
        
        // MARK: - Replay Subject
        
        // 여러개의 Next이벤트를 저장하고싶을떄 사용합니다.
        // init으로 생성하지 않고 create(bufferSize:) 메서드를 이용합니다.
        let replaySubject = ReplaySubject<Int>.create(bufferSize: 3)
        
        // 기본값이 없기때문에 바로 구독한다해서 이벤트가 전달되지는 않습니다.
        replaySubject
            .subscribe {
                print("ReplaySubject >>>", $0)
            }
            .disposed(by: disposeBag)
        
        replaySubject.onNext(1)
        replaySubject.onNext(2)
        replaySubject.onNext(3)
        
        replaySubject
            .subscribe {
                print("ReplaySubject2 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        
        // 새로운 이벤트가 전달되면 오래된 순서로 buffer에서 사라집니다.
        replaySubject.onNext(4)
        replaySubject.onNext(5)
        
        replaySubject
            .subscribe {
                print("ReplaySubject3 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        
        // Completed나 Error가 전달된 후에 구독을 하면 buffer에 저장된 이벤트를 모두 방출하고 completed, error가 전달됩니다.
        replaySubject.onCompleted()
        replaySubject
            .subscribe {
                print("ReplaySubject4 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        
        // 만약 dispose 시키고 나서 구독을 추가하면 에러가 전달됩니다.
        replaySubject.dispose()
        replaySubject
            .subscribe {
                print("ReplaySubject5 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        
        // MARK: - Async Subject
        // 잘 사용하지 않는 subject입니다.
        // 전달된 이벤트를 바로 전달하지 않고 Completed가 되면 전달합니다.
        
        // init()으로 생성합니다.
        let asyncSubject = AsyncSubject<Int>()
        
        asyncSubject
            .subscribe {
                print("AsyncSubject >>>", $0)
            }
            .disposed(by: disposeBag)
        
        // 구독자가 추가되도 전달되지 않습니다.
        asyncSubject.onNext(100)
        asyncSubject.onNext(200)
        
        // Completed가 전달되면 가장 최근 이벤트 1개를 방출하고 completed 됩니다.
        asyncSubject.onCompleted()
        
        // Error가 전달되면 next이벤트를 전달하지 않습니다. Completed되어야만 next를 전달합니다.
        asyncSubject.onError(CustomError.error)
    }
}


enum CustomError: Error {
    case error
}
