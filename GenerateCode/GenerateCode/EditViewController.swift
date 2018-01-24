//
//  EditViewController.swift
//  GenerateCode
//
//  Created by zhengjiacheng on 2018/1/24.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

import Cocoa

protocol EditViewControllerProtocol: NSObjectProtocol {
    func modelUpdated(model: EditMode, isAdd: Bool)
}

class EditViewController: NSWindowController {
    
    var model: EditMode!
    weak var delegate: EditViewControllerProtocol?
    var isAdd: Bool = false
    
    @IBOutlet weak var keyText: NSTextField!
    @IBOutlet weak var valueText: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.delegate = self;
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func updateViewWith(model: EditMode, isAdd: Bool){
        self.isAdd = isAdd
        self.model = model
        self.keyText.stringValue = ""
        if !model.key.isEmpty {
            self.keyText.stringValue = model.key
        }
        self.valueText.stringValue = ""
        if !model.value.isEmpty {
            self.valueText.stringValue = model.value
        }

        self.keyText.delegate = self
        self.valueText.delegate = self
            
        self.valueText.becomeFirstResponder()
    }
}

extension EditViewController: NSWindowDelegate{
    func windowWillClose(_ notification: Notification) {
        delegate?.modelUpdated(model: self.model, isAdd: self.isAdd)
    }
}

extension EditViewController: NSTextFieldDelegate, NSControlTextEditingDelegate{
    override func controlTextDidChange(_ obj: Notification){
        guard let textField = obj.object as? NSTextField else{
            return
        }
        if textField == self.keyText {
            model.key = textField.stringValue
        } else if textField == self.valueText {
            model.value = textField.stringValue
        }
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        var result = false
        if control == self.valueText {
            if commandSelector == #selector(insertNewline(_:)) {
                textView.insertNewlineIgnoringFieldEditor(self)
                result = true
            }else if commandSelector == #selector(insertTab(_:)){
                textView.insertTabIgnoringFieldEditor(self)
            }
        }
        return result
    }
}
