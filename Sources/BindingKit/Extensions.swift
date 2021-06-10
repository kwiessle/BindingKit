//
//  File.swift
//  
//
//  Created by Kiefer Wiessler on 10/06/2021.
//

import UIKit

public extension UITextField {
    
  
    func bind<Model>(_ observer: BindingObserver<Model>, on property: WritableKeyPath<Model,String>) {
        observer.add(Binding(self, observer: observer, property: property))
    }
    
    func bind<Model>(_ observer: BindingObserver<Model>, on property: WritableKeyPath<Model,String?>) {
        observer.add(Binding(self, observer: observer, property: property))
    }

}

public extension UILabel {
    
    func bind<Model, Value: LosslessStringConvertible>(_ observer: BindingObserver<Model>, on property: WritableKeyPath<Model,Value>, onChange: ((Value)->())? = nil) {
        observer.add(Binding(self, observer: observer, property: property, onChange: onChange))
    }
}

public extension UISlider {
    
    func bind<Model>(_ observer: BindingObserver<Model>, on property: WritableKeyPath<Model,Float>) {
        observer.add(Binding(self, observer: observer, property: property))
    }
    
    func bind<Model>(_ observer: BindingObserver<Model>, on property: WritableKeyPath<Model,Double>) {
        observer.add(Binding(self, observer: observer, property: property))
    }
}


public extension UISwitch {
    
    func bind<Model>(_ observer: BindingObserver<Model>, on property: WritableKeyPath<Model,Bool>) {
        observer.add(Binding(self, observer: observer, property: property))
    }
    
}


public extension UISegmentedControl {
    
    func bind<Model,Value:LosslessStringConvertible>(_ observer: BindingObserver<Model>, on property: WritableKeyPath<Model,[Value]>, onUpdate: @escaping(Value)->()) {
        observer.add(Binding(self, observer: observer, property: property, onUpdate: onUpdate))
    }
    
}

