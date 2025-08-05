//
//  Protocol.swift
//  WWEmojiTextField
//
//  Created by William.Weng on 2025/8/5.
//

import Foundation

// MARK: - WWEmojiTextField.Delegate
extension WWEmojiTextField {
    
    public protocol Delegate {
        
        /// 文字的轉換結果
        func convert(textField: WWEmojiTextField, result: Result<Bool, Error>)
        
        /// 高亮的轉換結果
        func highlight(textField: WWEmojiTextField, result: Result<Bool, Error>)
        
        /// 文字變換的提示
        func didChange(textField: WWEmojiTextField)
    }
}
