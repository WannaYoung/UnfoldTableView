//
//  HeaderView.swift
//  UnfoldTableView
//
//  Created by yang on 2016/12/27.
//  Copyright © 2016年 yang. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var spreadBtn: UIButton!
    
    typealias callBackBlock = (_ index : NSInteger,_ isSelected : Bool)->()
    
    var spreadBlock : callBackBlock!
    
    class func instantiateFromNib() -> HeaderView {
        return Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)!.first as! HeaderView
    }
    
    @IBAction func spreadBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let _ = spreadBlock{
            spreadBlock(self.tag,sender.isSelected)
        }
    }

}
