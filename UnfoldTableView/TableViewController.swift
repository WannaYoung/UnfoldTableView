//
//  TableViewController.swift
//  UnfoldTableView
//
//  Created by yang on 2016/12/27.
//  Copyright © 2016年 yang. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let unfoldDefault:Int = 2
    let tableSource:NSArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "source", ofType: "plist")!)!
    let flagArray : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func makeData(){
        for _ : NSInteger in 0...tableSource.count - 1 {
            flagArray.add(false)
        }
        flagArray[unfoldDefault] = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number:Int = 0
        if flagArray[section] as! Bool{
            if (tableSource[section] as! NSDictionary)["type"] as? String == "1" {
                number = (((tableSource[section] as! NSDictionary)["list"] as? NSArray)?.count)!
            }
            else {
                number = 1
            }
        }else{
            number = 0
        }
        return number
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0.0
        switch Int(((tableSource[indexPath.section] as! NSDictionary)["type"] as? String)!)! {
        case 1:
            height = 50.0
            break
        case 2:
            let content:String = (tableSource[indexPath.section] as! NSDictionary)["content"] as! String
            height = getCellHeightWithText(content: content)
            break
        case 3:
            height = 120.0
            break
        default:
            break
        }
        return height
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView : HeaderView = HeaderView.instantiateFromNib()
        headerView.tag = section + 2000
        headerView.spreadBtn.isSelected = flagArray[section] as! Bool
        headerView.spreadBlock = {(index : NSInteger,isSelected : Bool) in
            let ratio : NSInteger = index - 2000
            if self.flagArray[ratio] as! Bool{
                self.flagArray[ratio] = false
            }else{
                self.flagArray[ratio] = true
            }
            tableView.reloadSections(IndexSet.init(integer: index - 2000), with: UITableViewRowAnimation.automatic)
        }
        headerView.titleLabel.text = (tableSource[section] as! NSDictionary)["title"] as? String
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let sourceDict:NSDictionary = tableSource[indexPath.section] as! NSDictionary
        switch Int((sourceDict["type"] as? String)!)! {
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath)
            let nameLabel:UILabel = cell.viewWithTag(1) as! UILabel
            nameLabel.text = ((sourceDict["list"] as? NSArray)?[indexPath.row] as! String)
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath)
            let contentLabel:UILabel = cell.viewWithTag(11) as! UILabel
            contentLabel.text = sourceDict["content"] as? String
            setContentLabel(contentLabel: contentLabel, lineSpacing: 5.0, textAlignment: .left)
            break
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath)
            let nameLabel:UILabel = cell.viewWithTag(21) as! UILabel
            let contentLabel:UILabel = cell.viewWithTag(22) as! UILabel
            let contentImage:UIImageView = cell.viewWithTag(23) as! UIImageView
            nameLabel.text = sourceDict["name"] as? String
            contentLabel.text = sourceDict["content"] as? String
            contentImage.image = UIImage(named: sourceDict["image"] as! String)
            break
        default:
            break
            
        }
        return cell
    }

    
    func getCellHeightWithText(content:String) -> CGFloat
    {
        let paragraphStyle:NSMutableParagraphStyle  = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        let options = unsafeBitCast(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue |
            NSStringDrawingOptions.usesFontLeading.rawValue,
                                    to: NSStringDrawingOptions.self)
        let boundingRect = content.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width-50, height: 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15),NSParagraphStyleAttributeName:paragraphStyle], context: nil)
        return boundingRect.size.height
        
    }
    
    func setContentLabel(contentLabel:UILabel,lineSpacing:CGFloat,textAlignment:NSTextAlignment) {
        let attributedString:NSMutableAttributedString  = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle:NSMutableParagraphStyle  = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, (contentLabel.text?.characters.count)!))
        contentLabel.attributedText = attributedString
    }

}
