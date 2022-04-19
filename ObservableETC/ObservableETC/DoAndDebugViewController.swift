//
//  DoAndDebugViewController.swift
//  ObservableETC
//
//  Created by JunHeeJo on 4/19/22.
//

import UIKit
import RxSwift

class DoAndDebugViewController: UIViewController {
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Naver
        
        //        Observable<Int>.never().subscribe(onDisposed:  {
        //            print("Disposed")
        //        }).disposed(by: disposeBag)
        
        Observable<Int>.never().do(onNext: {
            print("onNext:", $0)
        }, afterNext: {
            print("afterNext: ", $0)
        }, onError: {
            print("onErorr: ", $0)
        }, afterError: {
            print("afterError", $0)
        }, onCompleted: {
            print("onCompleted")
        }, afterCompleted: {
            print("afterCompleted")
        }, onSubscribe: {
            print("onSubscribe")
        }, onSubscribed: {
            print("onSubscribed")
        }, onDispose: {
            print("onDispose")
        }).subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
        Observable<Int>.never()
            .debug("Debuggg", trimOutput: false)
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
    }
}
