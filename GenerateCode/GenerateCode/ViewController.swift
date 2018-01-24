//
//  ViewController.swift
//  GenerateCode
//
//  Created by zhengjiacheng on 2018/1/24.
//  Copyright © 2018年 zhengjiacheng. All rights reserved.
//

import Cocoa

class EditMode {
    var key: String = ""
    var value: String = ""
}

class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var editVCL: EditViewController!
    var dataItems: [EditMode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        editVCL = EditViewController(windowNibName: NSNib.Name.init("EditViewController"))
        editVCL.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func initData(){
        var arr: [EditMode] = []
        for (key, value) in SharedUserDefault.shared.mapping {
            let m = EditMode()
            m.key = key
            m.value = value
            arr.append(m)
        }
        self.dataItems = arr
    }
    
    func save(){
        var dic: [String: String] = [:]
        for model in self.dataItems {
            if !model.key.isEmpty,  !model.value.isEmpty{
                dic[model.key] = model.value
            }
        }
        SharedUserDefault.shared.saveMapping(dic: dic)
    }
    
    @objc func tableViewDoubleClick(_ sender:AnyObject) {
        let item = dataItems[tableView.selectedRow]
        self.editVCL.showWindow(self)
        self.editVCL.updateViewWith(model: item, isAdd: false)
    }

    @IBAction func clickAddButton(_ sender: Any) {
        self.editVCL.showWindow(self)
        self.editVCL.updateViewWith(model: EditMode(), isAdd: true)
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataItems.count
    }
}

extension ViewController: EditViewControllerProtocol{
    func modelUpdated(model: EditMode, isAdd: Bool){

        if isAdd {
            dataItems.append(model)
        }else{
            if tableView.selectedRow >= 0{
                dataItems[tableView.selectedRow] = model
            }
        }
        self.tableView.reloadData()
        save()
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let key = dataItems[row].key
        let value = dataItems[row].value
        
        let cellIdentifier = tableColumn == tableView.tableColumns[0] ? "Key" : "Value"
        let text = tableColumn == tableView.tableColumns[0] ? key : value

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(cellIdentifier), owner: self) as? NSTableCellView{
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}




