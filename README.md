# DatePickerView

## Example 

https://user-images.githubusercontent.com/82878923/169653992-f5d138ce-36db-4f82-9853-c00eb242337b.MP4

## Additional dependencies
  - you need to import Combine Cocoa framework to use DatePickerView inside youre project via SPM or CocoaPods
  ```ruby
  https://github.com/CombineCommunity/CombineCocoa
  ```
  
## How to use

  1. Copy and paste whole DatePicker floder to youre project, that will include all neded classes and extensions 

  2. Inherit youre textfiled form Birthday text field 

  <img width="258" alt="Screenshot 2022-05-21 at 16 43 34" src="https://user-images.githubusercontent.com/82878923/169654448-b5a1003b-4fd5-4adc-9da1-52ebc72e8a42.png">
  
<img width="641" alt="Screenshot 2022-05-21 at 16 43 10" src="https://user-images.githubusercontent.com/82878923/169654475-a494276f-132c-488b-868d-b8549fee2f5b.png">

  3. Visit DialogDatePickerView and choose one of the following method to configure presentation window
  ```ruby
  For Sceene Delagate use 
  guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("Could not get scene delegate ")
        }
        
        sceneDelegate.window?.addSubview(self)
        sceneDelegate.window?.bringSubviewToFront(self)
        sceneDelegate.window?.endEditing(true)
  ```
  ```ruby
  For App Delegate use 
  guard let appDelegate = UIApplication.shared.delegate,
              let window = appDelegate.window else {
            return
        }

        window?.addSubview(self)
        window?.bringSubviewToFront(self)
        window?.endEditing(true)
  ```

  Thats it, no more actions needed!
  
  4. To get a result, use this binding
  ```ruby
  func bind() {
        dobTextField.dateOutput
            .compactMap { $0 }
            .sink { value in
                print(value)
            }.store(in: &cancellables)
    }
 ```
    
