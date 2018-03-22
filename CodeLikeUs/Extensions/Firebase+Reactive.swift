//
//  Firebase+Reactive.swift
//  CodeLikeUs
//
//  Created by Dominik Vesely on 20/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import Foundation
import ReactiveSwift
import Firebase
import FirebaseDatabase
import Result

extension DatabaseReference {
    func observe(event: DataEventType) -> SignalProducer<DataSnapshot,NoError> {
        return SignalProducer { sink, disp in
            let handle = self.observe(event, with: { (snapshot) in
                sink.send(value: snapshot)
            },  withCancel: { (err) in
                print(err)
            })
            
            disp.observeEnded {
                self.removeObserver(withHandle: handle)
            }
            
            
        }
    }
}
