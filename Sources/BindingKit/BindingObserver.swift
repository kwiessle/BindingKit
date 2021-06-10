//
//  File.swift
//  
//
//  Created by Kiefer Wiessler on 10/06/2021.
//

import UIKit

@propertyWrapper public class BindingObserver<Model> {
    
    public var wrappedValue: Model
    
    public init(wrappedValue: Model) {
        self.wrappedValue = wrappedValue
    }
    
    private var bindings: [AnyBinding] = []
    
    public func snyAll(_ property: AnyKeyPath) {
        self.bindings.filter {
            $0.property == property
        }.forEach {
            $0.update()
        }
    }
    
    public func add(_ binding: AnyBinding) {
        self.bindings.append(binding)
    }
    
}
