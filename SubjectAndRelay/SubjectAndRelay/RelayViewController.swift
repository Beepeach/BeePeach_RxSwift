//
//  RelayViewController.swift
//  SubjectAndRelay
//
//  Created by JunHeeJo on 4/29/22.
//

import UIKit
import RxSwift
import RxRelay


class RelayViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Relay
        // RxCocoa 또는 RxRelay를 import해야합니다.
        // Subject와 동일하지만 next이벤트를 제외한 나머지 이벤트는 전달하지 않습니다.
        // Subject를 내부적으로 가지고 있습니다.
        // accept를 이용해서 이벤트를 전달합니다.
        // 나머지 이벤트를 전달하는 방법은 없습니다.
        
        
        // MARK: - Publish Relay
        // 내부적으로 Publish Subject를 가지고 있습니다.
        // init()으로 생성합니다.
        
        let publishRelay = PublishRelay<Int>()
        publishRelay
            .subscribe {
                print("Publish Relay >>>", $0)
            }
            .disposed(by: disposeBag)
        
        publishRelay.accept(10)
        
        // completed, error는 전달할 수 없습니다.
        // publishRelay.accept(.completed)
        
        
        // 이벤트 방출후 구독을 시작했으므로 전달받지 못합니다.
        publishRelay
            .subscribe {
                print("Publish Relay2 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        
        // MARK: - Behavior Relay
        // 내부적으로 Behavior Subject를 가지고 있습니다.
        let behaviorRelay = BehaviorRelay(value: 100)
        
        behaviorRelay
            .subscribe {
                print("Behavior Relay >>>", $0)
            }
            .disposed(by: disposeBag)
        
        behaviorRelay.accept(200)
        
        // 이벤트 방출 이후에 구독을 시작해도 최근 이벤트를 전달받습니다.
        behaviorRelay
            .subscribe {
                print("Behavior Relay2 >>>", $0)
            }
            .disposed(by: disposeBag)
        
        
        // value 프로퍼티로 현재 저장된 값을 알 수 있습니다.
        // behavior relay를 기존의 변수처럼 활용할 수 있습니다.
        print("Behavior Currnet Value >>>", behaviorRelay.value)
        
        
        
        
        // MARK: - Replay Relay
        // 내부적으로 Replay subject를 가지고 있습니다.
        
        let replayRelay = ReplayRelay<Int>.create(bufferSize: 3)
        
        replayRelay
            .subscribe {
                print("Replay Relay >>>", $0)
            }
            .disposed(by: disposeBag)
        
        replayRelay.accept(1)
        replayRelay.accept(2)
        replayRelay.accept(3)
        replayRelay.accept(4)
        
        
        // 이벤트 방출 이후에 구독을 시작해도 buffer size만큼의 이벤트를 전달 받습니다.
        replayRelay
            .subscribe {
                print("Replay Relay2 >>>", $0)
            }
            .disposed(by: disposeBag)
    }
}
