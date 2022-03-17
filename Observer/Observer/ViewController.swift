//
//  ViewController.swift
//  Observer
//
//  Created by JunHeeJo on 3/17/22.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // subscribe(_:)
        let observable1 = Observable<Int>.of(1, 2, 3)
        observable1.subscribe { event in
            print(event)
        }.disposed(by: bag)
        
        
        // 바로 .으로 이어서 사용도 가능합니다.
        Observable<Int>.create { observer in
            observer.onNext(1)
            return Disposables.create()
        }.subscribe {
            print($0)
        }.disposed(by: bag)
        
        
        // Event에서 element를 추출하는 방법
        observable1.subscribe {
            guard let element = $0.element else {
                return
            }
            
            print(element)
        }.disposed(by: bag)
        
        
        // subscribe(onNext:onError:onCompleted:onDisposed:)
        observable1.subscribe { element in
            print("Next:", element)
        } onError: { error in
            print("Error:", error)
        } onCompleted: {
            print("Completed")
        } onDisposed: {
            print("Disposed")
        }.disposed(by: bag)
    }
}

