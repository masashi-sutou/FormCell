//
//  MSFormCell.swift
//  MSFormCell
//
//  Created by 須藤 将史 on 2017/02/19.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

private enum LengthPattern: Int {
    case none = 0
    case min
    case max
    case range
    
    init(_ lengthError: (min: Int, max: Int)?) {
        
        guard let lengthError = lengthError else { self = .none; return }
        
        if lengthError.min > 0 && lengthError.max == 0 {
            self = .min
            return
        }
        
        if lengthError.min == 0 && lengthError.max > 0 {
            self = .max
            return
        }
        
        if lengthError.min < lengthError.max {
            self = .range
            return
        }
        
        self = .none
    }
}

private extension Selector {
    static let textFieldChanged = #selector(MSFormCell.textFieldChanged(_:))
}

final public class MSFormCell: UITableViewCell, UITextFieldDelegate {

    public var textField: UITextField!

    private var lengthPattern: LengthPattern = .none
    private var lengthError: (min: Int, max: Int)?
    private var pregError: (pattern: PregMatchePattern, message: String?)?
    private var isOptional: Bool = false
    
    private var beginEditing: (() -> Void)?
    private var textChanged: ((String) -> Void)?
    private var didReturn: (() -> Void)?
    
    private var currentLengthLabel: UILabel!
    private var errorMessageLabel: UILabel!
    
    public init(lengthError: (Int, Int)? = nil, pregError:(PregMatchePattern, String?)? = nil, isOptional: Bool = false) {
        
        super.init(style: .default, reuseIdentifier: "MSFormCell")

        self.selectionStyle = .none
        self.accessoryType = .none
        self.accessoryView = nil

        self.setup(lengthError: lengthError, pregError: pregError, isOptional: isOptional)
    }
    
    public func editField(beginEditing: (() -> Void)?, textChanged: ((String) -> Void)?, didReturn: (() -> Void)?) {

        self.beginEditing = beginEditing
        self.textChanged = textChanged
        self.didReturn = didReturn
    }
    
    private func setup(lengthError:(min: Int, max: Int)?, pregError:(pattern: PregMatchePattern, message: String?)?, isOptional: Bool) {
        
        self.lengthPattern = LengthPattern(lengthError)
        self.lengthError = lengthError
        self.pregError = pregError
        self.isOptional = isOptional
        
        self.textField = UITextField(frame: .zero)
        self.textField.clearButtonMode = .whileEditing
        self.textField.text = nil
        self.textField.addTarget(self, action: .textFieldChanged, for: .editingChanged)
        self.textField.delegate = self
        self.contentView.addSubview(self.textField)
        
        self.currentLengthLabel = UILabel(frame: .zero)
        self.currentLengthLabel.font = UIFont.systemFont(ofSize: 10)
        self.currentLengthLabel.numberOfLines = 1
        self.currentLengthLabel.isHidden = true
        self.currentLengthLabel.textAlignment = .right
        self.textField.addSubview(self.currentLengthLabel)
        
        self.errorMessageLabel = UILabel(frame: .zero)
        if let pregError = pregError {
            if let message = pregError.message {
                self.errorMessageLabel.text = "・" + message
            } else {
                self.errorMessageLabel.text = "・" + pregError.pattern.errorMessage()
            }
        }
        
        self.errorMessageLabel.numberOfLines = 1
        self.errorMessageLabel.lineBreakMode = .byTruncatingMiddle
        self.errorMessageLabel.textColor = .red
        self.errorMessageLabel.font = UIFont.systemFont(ofSize: 10)
        self.errorMessageLabel.isHidden = true
        self.errorMessageLabel.textAlignment = .left
        self.contentView.addSubview(self.errorMessageLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.textField.frame = CGRect(x: self.layoutMargins.left, y: 0, width: self.contentView.frame.width - self.layoutMargins.left - self.layoutMargins.right - 5, height: self.contentView.frame.height)
        self.currentLengthLabel.frame = CGRect(x: self.textField.frame.width - 60, y: 2, width: 60, height: 12)
        self.errorMessageLabel.frame = CGRect(x: self.layoutMargins.left, y: self.contentView.frame.height - self.layoutMargins.bottom - 2, width: self.contentView.frame.width - self.layoutMargins.left - self.layoutMargins.right - 5, height: 12)
        self.showLabels()
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let beginEditing = self.beginEditing {
            beginEditing()
        }
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        defer {
            if let count = textField.text?.characters.count {
                self.fix(currentTextLength: count)
            }
        }
        
        guard let lengthError = self.lengthError else { return }
        
        if lengthError.min > 0 || lengthError.max > 0 {
            self.currentLengthLabel.isHidden = false
        } else {
            self.currentLengthLabel.isHidden = true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text: String = textField.text else { return }
        self.showLabels(text: text)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {

        self.fix(currentTextLength: 0)
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let text: String = textField.text else {
            
            if let didReturn = self.didReturn {
                didReturn()
            }
            
            return true
        }

        self.showLabels(text: text)
        if let didReturn = self.didReturn {
            didReturn()
        }
        
        return true
    }
    
    // MARK: - change text
    
    func textFieldChanged(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        self.fix(currentTextLength: text.characters.count )
        
        if let textChanged = self.textChanged {
            textChanged(text)
        }
    }
    
    // MARK: - text count
    
    private func fix(currentTextLength: Int) {
        
        guard let lengthError = self.lengthError else {
            self.currentLengthLabel.isHidden = true
            return
        }
        
        switch self.lengthPattern {
        case .none:
            self.currentLengthLabel.isHidden = true

        case .min:
            self.currentLengthLabel.text = String(format: "%d/%d ~ ∞", currentTextLength, lengthError.max)
            
            if currentTextLength < lengthError.min {
                self.currentLengthLabel.textColor = .red
            } else {
                self.currentLengthLabel.textColor = .lightGray
            }
            self.currentLengthLabel.isHidden = false
        
        case .max:
            self.currentLengthLabel.text = String(format: "%d/∞ ~ %d", currentTextLength, lengthError.max)
            
            if currentTextLength > lengthError.max {
                self.currentLengthLabel.textColor = .red
            } else {
                self.currentLengthLabel.textColor = .lightGray
            }
            self.currentLengthLabel.isHidden = false
        
        case .range:
            self.currentLengthLabel.text = String(format: "%d/%d ~ %d", currentTextLength, lengthError.min, lengthError.max)
            
            if lengthError.min...lengthError.max ~= currentTextLength {
                self.currentLengthLabel.textColor = .red
            } else {
                self.currentLengthLabel.textColor = .lightGray
            }
            self.currentLengthLabel.isHidden = false
        }
    }
    
    // MARK: - show UILabels

    public func showLabels() {
        
        guard let text: String = textField.text else { return }
        self.fix(currentTextLength: text.characters.count)
        self.showLabels(text: text)
    }
    
    private func showLabels(text:String) {
        
        self.currentLengthLabel.isHidden = !self.showCurrentLengthLabel(text: text)
        self.errorMessageLabel.isHidden = !self.showErrorMessageLabel(text: text)
    }
    
    private func showCurrentLengthLabel(text: String) -> Bool {
        
        guard let lengthError = self.lengthError else { return false }
        
        let length: Int = text.characters.count
        
        switch self.lengthPattern {
        case .none:
            return false
        case .min:
            
            if length == 0 && self.isOptional {
                return false
            } else {
                return length < lengthError.min
            }
            
        case .max:
            
            if length == 0 && self.isOptional {
                return false
            } else {
                return length > lengthError.max
            }
            
        case .range:
            
            if length == 0 && self.isOptional {
                return false
            } else {
                return lengthError.min...lengthError.max ~= length
            }
        }
    }
    
    private func showErrorMessageLabel(text: String) -> Bool {
        
        guard let pregError = self.pregError  else { return false }
        
        if text.characters.count == 0 && self.isOptional {
            return false
        } else {
            return !text.pregMatche(pattern: pregError.pattern)
        }
    }
}
