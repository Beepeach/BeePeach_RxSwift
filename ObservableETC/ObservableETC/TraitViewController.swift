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
            
            // 이후의 코드는 전달되지 않습니다.
            // success는 completed를 호출한것과 같기 때문입니다.
            single(.success(3))
            
            return Disposables.create()
        }.subscribe {
            print("Single >>>", $0)
        }.disposed(by: disposeBag)
        
        
        // 예시
        enum NumbersError: Error {
            case oddNumber
            case over(number: Int)
        }
        
        func validateNumber(limit: Int) -> Single<Int> {
            return Single<Int>.create { singleObserver in
                let disposable: Disposable = Disposables.create()
                let randomNum: Int = Int.random(in: 1...(limit * 2))
                
                guard !randomNum.isMultiple(of: 2) else {
                    singleObserver(.failure(NumbersError.oddNumber))
                    return disposable
                }
                guard randomNum > limit else {
                    singleObserver(.failure(NumbersError.over(number: limit)))
                    return disposable
                }
                singleObserver(.success(randomNum))
                
                return disposable
            }
        }
        
        validateNumber(limit: 100)
            .debug()
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        
        // FileLoad 예시
        /*
         
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
         */
        
        
        
        // MARK: - Completable
        // completd, error(error) 이벤트를 방출합니다.
        // next 이벤트가 없어서 데이터를 담아 보낼수 없습니다.
        // 주로 File 읽기와 같은 성공, 실패여부만을 확인할때 사용합니다.
        // Single과의 차이는 Single은 성공했다면 데이터를 담아 보낼 수 있고 Completable은 데이터를 담지 않고 성공, 실패만 따집니다.
        // 그리고 ResultType을 사용하지 않았습니다.
        
        Completable.create { observer in
            // 성공이라면 completed
            observer(.completed)
            // 실패하면 error를 담아서
            observer(.error(MyError.error))
            
            return Disposables.create()
        }.subscribe(onCompleted: {
            print("Completable >>> complete")
        }).disposed(by: disposeBag)
        
        
        
        
        // MARK: - Maybe
        // Maybe는 Single과 Completable의 결합입니다.
        // success(value), completed, error(Error) 이벤트를 방출합니다.
        
        Maybe<Int>.create { observer in
            observer(.success(2))
            
            // success이후에 전달되는 이벤트는 전달되지 않습니다.
            // single과 같은 이유입니다.
            
            // observer(.completed)
            // observer(.error(MyError.error))
            
            return Disposables.create()
        }.subscribe {
            print("Maybe >>>", $0)
        }.disposed(by: disposeBag)
    }
}



enum MyError: Error {
    case error
}
