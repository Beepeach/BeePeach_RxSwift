//
//  ViewController.swift
//  ObservableETC
//
//  Created by JunHeeJo on 3/23/22.
//

import UIKit
import RxSwift


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Factory
        // 각각 구독자에 대해 새로운 observable을 생성하는 observable factory를 생성 가능
        // deferred 오퍼레이터를 이용하면 됩니다.
        let disposeBag: DisposeBag = DisposeBag()
        var isOdd: Bool = false

        let factory: Observable<Int> = Observable.deferred {
            isOdd.toggle()
            
            if isOdd {
                return Observable.of(1, 3, 5)
            } else {
                return Observable.of(2, 4, 6)
            }
        }

        // 외부적으로는 observable factory는 observable과 구별이 가지 않습니다.
        for _ in 0...3 {
            factory.subscribe(onNext: {
                print($0, terminator: " ")
            }).disposed(by: disposeBag)
            
            print()
        }
    }
}

