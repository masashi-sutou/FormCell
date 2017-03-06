FormCell
====

## Overview

Demo |
--- |
<img src="https://raw.githubusercontent.com/masashi-sutou/FormCell/master/demo_images/demo.jpg" width="320"/> |

## Requirement
- Xcode 8
- Swift 3
- iOS 9.0 or later

## Usage
```Swift

// Example: phone number in Japan

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = FormFieldCell(lengthError: (0, 11), pregError: (.phone, nil))
    cell.editField(textChanged: { (text) in
        self.user.tel = text
    }, didReturn: {
        if let cell = tableView.cellForRow(at: indexPath) as? FormFieldCell {
            cell.textField.resignFirstResponder()
        }
    })

    cell.textField.keyboardType = .numberPad
    cell.textField.placeholder = "enter your phone number"
    cell.textField.text = self.user.tel
    return cell
}
```

## Installation
#### [CocoaPods](https://cocoapods.org/)
Add the following line to your Podfile:
```ruby
use_frameworks!

target 'YOUR_TARGET_NAME' do
  pod "FormCell"
end
```

#### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your Cartfile:
```ruby
github "masashi-sutou/FormCell"
```

## Licence
FormCell is available under the MIT license. See the LICENSE file for more info.
