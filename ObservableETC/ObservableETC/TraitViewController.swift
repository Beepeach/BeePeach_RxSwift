//
//  TraitViewController.swift
//  ObservableETC
//
//  Created by JunHeeJo on 3/23/22.
//

import UIKit
import RxSwift


class TraitViewController: UIViewController {
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Traits
        
        // MARK: Single
        // create 오퍼레이터의 클로저의 파라미터로 SingleObserver를 받습니다.
        // SingleObservser는 (SingleEvent<Element>) -> Void 의 alias입니다.
        // SingleEvent<Element> = Result<Element, Swift.Error> alias입니다. 즉 Result Type으로 되어있습니다.
        // success = next + completed입니다.
        // failure = error 입니다.
        // next + completed이기때문에 한개만 방출하고 종료됩니다.
        // 주로 Download,file읽기에서 사용됩니다.
        Single<Int>.create { single in
            single(.success(2))
            
            // 이건 못받습니다.
            single(.success(3))
            
            return Disposables.create()
        }.subscribe {
            print("Single >>>", $0)
        }.disposed(by: disposeBag)
        
        
        // 예시
        enum FileReadError: Error {
            case fileNotFound
            case unreadable
            case encodingFailed
        }
        
        func loadText(from name: String) -> Single<String> {
            return Single.create { single in
                let disposable = Disposables.create()
                
                guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                    single(.failure(FileReadError.fileNotFound))
                    return disposable
                }
                
                guard let data = FileManager.default.contents(atPath: path) else {
                    single(.failure(FileReadError.unreadable))
                    return disposable
                }
                
                guard let contents = String(data: data, encoding: .utf8) else {
                    single(.failure(FileReadError.encodingFailed))
                    return disposable
                }
                
                single(.success(contents))
                return disposable
            }
        }
        
        loadText(from: "Copyright").subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
        
        
        
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

