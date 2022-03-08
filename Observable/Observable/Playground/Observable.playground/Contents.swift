import UIKit
import RxSwift

// MARK: - Create
Observable<Int>.create { observer -> Disposable in
    observer.on(.next(10))
    observer.onNext(100)
    
    observer.on(.completed)
    observer.onCompleted()
    
    observer.on(.error(CustomError.error))
    observer.onError(CustomError.error)
    
    return Disposables.create()
}


// MARK: - Just
Observable<Int>.just(1)
Observable.just(1)


// MARK: - Of
Observable<Int>.of(1, 2, 3)
Observable<[Int]>.of([1, 2, 3])


// MARK: - From
Observable.from([1, 2, 3])

