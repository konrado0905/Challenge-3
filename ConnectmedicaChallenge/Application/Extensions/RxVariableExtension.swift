//
//  RxVariableExtension.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 18/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import RxSwift

extension Variable {
    public func twoWayBind<O: ObserverType & ObservableType>(observer: O) -> RxSwift.Disposable where O.E == E {
        let d1 = self.asObservable().bindTo(observer)
        let d2 = observer
            .skip(1)
            .subscribe(onNext: { [unowned self] (next) in
                self.value = next
            })
        return CompositeDisposable(d1, d2)
    }
}
