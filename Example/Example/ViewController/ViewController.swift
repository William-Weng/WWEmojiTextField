//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/8/5.
//

import UIKit
import WWEmojiTextField

// MARK: - ViewController
final class ViewController: UIViewController {

    @IBOutlet weak var textField: WWEmojiTextField!

    private var emojiMapping: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmojiMapping()
        textField.configure(mapping: emojiMapping)
        // textField.configure(mapping: emojiMapping, convertRegex: /\((\w+)\s$/, highlightRegex: /\((\w+)$/)
    }
}

private extension ViewController {
    
    func loadEmojiMapping() {

        guard let url = Bundle.main.url(forResource: "emojiMapping", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decodedMap = try? JSONDecoder().decode([String: String].self, from: data)
        else {
            return
        }
        
        emojiMapping = Dictionary(uniqueKeysWithValues: decodedMap.map { ($0.lowercased(), $1) })
    }
}
