//
//  MSFormCell.swift
//  MSFormCell
//
//  Created by 須藤 将史 on 2017/02/19.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

private extension String {
    
    func pregMatche(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
        return matches.count > 0
    }
}

private extension Selector {
    static let textFieldChanged = #selector(MSFormCell.textFieldChanged(_:))
}

final public class MSFormCell: UITableViewCell, UITextFieldDelegate {

    public var textField: UITextField!
 
    private var beginEditing: (() -> Void)?
    private var textChanged: ((String) -> Void)!
    private var didReturn: (() -> Void)!
    
    private var maxTextCount: Int = 0
    private var isMust: Bool = true
    private var currentLengthLabel: UILabel!
    private var errorMessageLabel: UILabel!
    private var pregError: (message: String, pattern: String)?

    public init(maxTextCount: Int = 0, isMust: Bool = true, pregError:(message: String, pattern: String)? = nil, textChanged: @escaping (String) -> Void, didReturn: @escaping () -> Void) {
        
        super.init(style: .default, reuseIdentifier: "MSFormCell")
        self.beginEditing = nil
        self.textChanged = textChanged
        self.didReturn = didReturn
        
        self.setup(maxTextCount: maxTextCount, isMust: isMust, pregError: pregError)
    }
    
    public init(maxTextCount: Int = 0, isMust: Bool = true, pregError:(message: String, pattern: String)? = nil, beginEditing: @escaping () -> Void, textChanged: @escaping (String) -> Void, didReturn: @escaping () -> Void) {

        super.init(style: .default, reuseIdentifier: "MSFormCell")
        self.beginEditing = beginEditing
        self.textChanged = textChanged
        self.didReturn = didReturn
        
        self.setup(maxTextCount: maxTextCount, isMust: isMust, pregError: pregError)
    }
    
    private func setup(maxTextCount: Int, isMust: Bool, pregError:(message: String, pattern: String)?) {
        
        self.selectionStyle = .none
        self.accessoryType = .none
        
        self.maxTextCount = maxTextCount
        self.pregError = pregError
        self.isMust = isMust
        
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
        self.fix(currentTextLength: 0)
        self.contentView.addSubview(self.currentLengthLabel)
        
        self.errorMessageLabel = UILabel(frame: .zero)
        if let pregError = pregError {
            self.errorMessageLabel.text = "・" + pregError.message
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
        self.currentLengthLabel.frame = CGRect(x: self.textField.frame.width - self.layoutMargins.left - self.layoutMargins.right, y: 2, width: 40, height: 12)
        self.errorMessageLabel.frame = CGRect(x: self.layoutMargins.left, y: self.contentView.frame.height - self.layoutMargins.bottom - 2, width: self.contentView.frame.width - self.layoutMargins.left - self.layoutMargins.right - 5, height: 12)
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard let beginEditing = self.beginEditing else { return true }
        beginEditing()
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if self.maxTextCount > 0 {
            self.currentLengthLabel.isHidden = false
        } else {
            self.currentLengthLabel.isHidden = true
        }
        
        if let count = textField.text?.characters.count {
            self.fix(currentTextLength: count)
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text: String = textField.text else { return }
        self.showLabel(text: text)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {

        self.fix(currentTextLength: 0)
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let text: String = textField.text else {
            self.didReturn()
            return true
        }

        self.showLabel(text: text)
        self.didReturn()
        return true
    }
    
    // MARK: - change text
    
    func textFieldChanged(_ textField: UITextField) {
        
        if let count = textField.text?.characters.count {
            self.fix(currentTextLength: count)
            
            if let text = textField.text {
                self.textChanged(text)
            }
        }
    }
    
    // MARK: - text count
    
    private func fix(currentTextLength: Int) {
        
        if self.maxTextCount > 0 {
            self.currentLengthLabel.text = String(format: "%d/%d", currentTextLength, self.maxTextCount)
            
            if currentTextLength > self.maxTextCount {
                self.currentLengthLabel.textColor = .red
            } else {
                self.currentLengthLabel.textColor = .lightGray
            }
        } else {
            self.currentLengthLabel.isHidden = true
        }
    }
    
    // MARK: - show UILabel
    
    private func showLabel(text:String) {
        
        var showCurrentLength: Bool = false
        var showErrorMessage: Bool = false
        
        if text.characters.count > self.maxTextCount {
            showCurrentLength = true
        } else if self.isMust && text.characters.count == 0 {
            self.currentLengthLabel.textColor = .red
            showCurrentLength = true
        }
        
        if let pregError = self.pregError {
            if !text.pregMatche(pattern: pregError.pattern) {
                showErrorMessage = true
            }
        }
        
        self.currentLengthLabel.isHidden = !showCurrentLength
        self.errorMessageLabel.isHidden = !showErrorMessage
    }
}