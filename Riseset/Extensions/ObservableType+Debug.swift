//
//  ObservableType+Debug.swift
//  Riseset
//
//  Created by Spiros Gerokostas on 07/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import RxSwift

extension ObservableType {
    func debugOnlyInDebugMode(identifier:String) -> Observable<E> {
        #if DEBUG
            return self.debug(identifier)
        #else
            return self.asObservable()
        #endif
    }
}
