import UIKit


public protocol AnyBinding {
    var update: () ->() { get }
    var property: AnyKeyPath? { get }
}


public final class Binding<Model>: AnyBinding {
    
    private(set) weak public var property: AnyKeyPath?

    public var update: ()  -> ()
    var syncAll: (AnyKeyPath) -> ()
    
    
    init(_ textField: UITextField, observer: BindingObserver<Model>, property: WritableKeyPath<Model,String>) {
        self.property = property
        self.syncAll = observer.snyAll
        
        self.update = { [weak textField, weak observer, weak property] in
            guard let textField = textField,
                  let observer = observer,
                  let property = property
            else { return }
            observer.wrappedValue[keyPath: property] = textField.text ?? ""
        }
        textField.addTarget(self, action: #selector(self.onChange), for: .editingChanged)
        textField.text = observer.wrappedValue[keyPath: property]
    }
    
    init(_ textField: UITextField, observer: BindingObserver<Model>, property: WritableKeyPath<Model,String?>) {
        self.property = property
        self.syncAll = observer.snyAll
        
        self.update = { [weak textField, weak observer, weak property] in
            guard let textField = textField,
                  let observer = observer,
                  let property = property
            else { return }
            observer.wrappedValue[keyPath: property] = textField.text
        }
        textField.addTarget(self, action: #selector(self.onChange), for: .editingChanged)
        textField.text = observer.wrappedValue[keyPath: property]
    }
    
    init<Value:LosslessStringConvertible>(_ label: UILabel, observer: BindingObserver<Model>, property: WritableKeyPath<Model,Value>, onChange: ((Value)->())?) {
        self.syncAll = observer.snyAll
        self.property = property
        if let onChange = onChange {
            self.update = { [weak observer, weak property] in
                guard let observer = observer,
                      let property = property
                else { return }
                onChange(observer.wrappedValue[keyPath: property])
            }
            onChange(observer.wrappedValue[keyPath: property])
        } else {
            self.update = { [weak observer, weak label, weak property] in
                guard let observer = observer,
                      let label = label,
                      let property = property
                else { return }
                label.text = String(observer.wrappedValue[keyPath: property])
            }
            label.text = String(observer.wrappedValue[keyPath: property])
        }
        
        
    }
    
    init(_ slider: UISlider, observer: BindingObserver<Model>, property: WritableKeyPath<Model,Float>) {
        self.syncAll = observer.snyAll
        self.property = property
        self.update = { [weak slider, weak observer, weak property] in
            guard let observer = observer,
                  let slider = slider,
                  let property = property
            else { return }
            observer.wrappedValue[keyPath: property] = slider.value
        }
        slider.addTarget(self, action: #selector(self.onChange), for: .valueChanged)
        slider.value = observer.wrappedValue[keyPath: property]
    }

    init(_ slider: UISlider, observer: BindingObserver<Model>, property: WritableKeyPath<Model,Double>) {
        self.syncAll = observer.snyAll
        self.property = property
        self.update = { [weak slider, weak observer, weak property] in
            guard let slider = slider,
                  let observer = observer,
                  let property = property
            else { return }
            observer.wrappedValue[keyPath: property] = Double(slider.value)
        }
        slider.addTarget(self, action: #selector(self.onChange), for: .valueChanged)
        slider.value = Float(observer.wrappedValue[keyPath: property])
    }

    init(_ switch: UISwitch, observer: BindingObserver<Model>, property: WritableKeyPath<Model,Bool>) {
        self.syncAll = observer.snyAll
        self.property = property
        self.update = { [weak `switch`, weak observer, weak property] in
            guard let `switch` = `switch`,
                  let observer = observer,
                  let property = property
            else { return }
            observer.wrappedValue[keyPath: property] = `switch`.isOn
        }
        `switch`.addTarget(self, action: #selector(self.onChange), for: .valueChanged)
        `switch`.isOn = observer.wrappedValue[keyPath: property]
    }
    
    init<Value:LosslessStringConvertible>(_ segmentedControl: UISegmentedControl, observer: BindingObserver<Model>, property: WritableKeyPath<Model,[Value]>, onUpdate: @escaping((Value)->())) {
        self.syncAll = observer.snyAll
        self.property = property
        self.update = { [weak observer, weak property, weak segmentedControl] in
            guard let observer = observer,
                  let segmentedControl = segmentedControl,
                  let property = property
            else { return }
            onUpdate(observer.wrappedValue[keyPath: property][segmentedControl.selectedSegmentIndex])
        }
        segmentedControl.addTarget(self, action: #selector(self.onChange), for: .valueChanged)
        segmentedControl.removeAllSegments()
        for (index, value) in observer.wrappedValue[keyPath: property].enumerated() {
            segmentedControl.insertSegment(withTitle: String(value), at: index, animated: false)
        }
        defer {
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    
    @objc private func onChange() {
        guard let property = self.property else { return }
        self.syncAll(property)
    }
    
}
