MSFormCell
====

## Overview

Demo |
--- |
<img src="https://raw.githubusercontent.com/masashi-sutou/MSFormCell/master/demo_images/demo.jpg" width="320"/> |

## Requirement
- Xcode 8
- Swift 3
- iOS 8.0 or later

## Usage
```Swift

// Example phone number in Japan

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = MSFormCell(maxTextCount: 11, pregError: ("Invalid format phone number in Japan", "^[0-9]{10,11}$"), textChanged: { (text) in
        self.user.tel = text
    }, didReturn: {
        if let cell = tableView.cellForRow(at: indexPath) as? MSFormCell {
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
  pod "MSFormCell"
end
```

#### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your Cartfile:
```ruby
github "masashi-sutou/MSFormCell"
```

## Licence
MSFormCell is available under the MIT license. See the LICENSE file for more info.
