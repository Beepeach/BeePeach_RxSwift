//
//  ViewController.swift
//  Disposable
//
//  Created by JunHeeJo on 3/19/22.
//

import UIKit
import RxSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Dispose를 호출하여 메모리에서 해제하기
        Observable<Int>
            .of(1, 2, 3)
            .subscribe {
                print("Next:", $0)
            } onError: {
                print("Error", $0)
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }.dispose()
        
        
        // MARK: - DisposeBag을 이용해서 한번에 해제하기
        
        var bag: DisposeBag = DisposeBag()
        Observable<Int>
            .from([1, 2,  3])
            .subscribe {
                print($0)
            }.disposed(by: bag)

        bag = DisposeBag()
        // 원하는 시점에 disposebag을 하려면 새로운 bag을 할당하거나 nil을 할당하면 됩니다.
        
        
        
        
        
        // MARK: - dispose 호출하기
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe {
                print("Next:", $0)
            } onError: {
                print("Error", $0)
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }.dispose()
        
        let intervalObservable =  Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe {
                print("Next:", $0)
            } onError: {
                print("Error", $0)
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 4) {
            intervalObservable.dispose()
        }
        
        
        // MARK: - crete 이용해서 정의하기
        Observable<String>.create { observer in
            observer.onNext("Hello")
            observer.onNext("RxSwift")
            
            observer.onCompleted()
            
            return Disposables.create {
                print("Observable Disposed!!")
            }
        }.subscribe {
            print($0)
        }.disposed(by: bag)
        
        
        // MARK: - MemortLeak
            Observable<String>.create { observer in
            observer.onNext("Hello")
            observer.onNext("RxSwift")
            
            return Disposables.create {
                print("Observable Disposed!!")
            }
        }.subscribe {
            print($0)
        }
    }
}

