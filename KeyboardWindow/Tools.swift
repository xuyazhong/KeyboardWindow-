//
//  Tools.swift
//  KeyboardWindow
//
//  Created by xuyazhong on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

let Notification_POST = "Notification_POST"
let NOTI_POST_LEVEL = "NOTI_POST_LEVEL"


enum LevelType: String {
    case PUBLIC_LEVEL = "public_level"
    case PRIVATE_LEVEL = "private_level"
}

class Services: NSObject {
    
    static let sharedInstance = Services()

    var currentType: LevelType = .PUBLIC_LEVEL
    
}

extension UIColor {
    @objc static func colorFromHex(_ hexValue: UInt, alpha:Float = 1) -> UIColor {
        return UIColor(
            red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    open class func mainColor() -> UIColor {
        return UIColor.colorFromHex(0x0843d5)
    }
    
    open class func textColor(_ alpha: Float = 0.8) -> UIColor {
        return UIColor.colorFromHex(0x000E33, alpha: alpha)
    }
    
}

extension UIView {
    func round (radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}

class LevelAlertView: UIView {

    lazy var publicV: LevelIconItemView = {
        var publicV: LevelIconItemView = LevelIconItemView(frame: CGRect(x: 0, y: 0, width: 188, height: 68))
        publicV.refresh(.PUBLIC_LEVEL)
        return publicV
    }()
    lazy var privateV: LevelIconItemView = {
        var privateV: LevelIconItemView = LevelIconItemView(frame: CGRect(x: 0, y: 68.5, width: 188, height: 68))
        privateV.refresh(.PRIVATE_LEVEL)
        return privateV
    }()
    lazy var lineV: UIView = {
        var lineV: UIView = UIView(frame: CGRect(x: 0, y: 68, width: 188, height: 0.5))
        lineV.backgroundColor = .gray
        return lineV
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(publicV)
        addSubview(lineV)
        addSubview(privateV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class InputIdeaView: UIView {

    var inputText: UITextView = {
        var inputText: UITextView = UITextView(frame: CGRect(x: 20, y: 15, width: ScreenWidth-40, height: 85))
        inputText.backgroundColor = .white
        inputText.font = .systemFont(ofSize: 14)
        inputText.textColor = .black
        return inputText
    }()
    lazy var postBtn: UIButton = {
        var postBtn: UIButton = UIButton(frame: CGRect(x: frame.width-20-80, y: frame.height-50, width: 80, height: 50))
        postBtn.setTitle("发布", for: .normal)
        postBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        postBtn.setTitleColor(.mainColor(), for: .normal)
        return postBtn
    }()
    lazy var levelBtn: LevelBtn = {
        var levelBtn: LevelBtn = LevelBtn(frame: CGRect(x: 20, y: frame.height-50, width: 80, height: 50))
        levelBtn.addTarget(self, action: #selector(actionShow), for: .touchUpInside)
        return levelBtn
    }()
    var placeholderLbl: UILabel = {
        var placeholderLbl: UILabel = UILabel(frame: CGRect(x: 20, y: 15, width: ScreenWidth-40, height: 85))
        placeholderLbl.text = "写点什么呢？你说..."
        placeholderLbl.numberOfLines = 0
        placeholderLbl.font = .systemFont(ofSize: 14)
        placeholderLbl.textColor = .gray
        placeholderLbl.sizeToFit()
        return placeholderLbl
    }()
    
    var inputValue: String {
        set {
            inputText.text = newValue
        }
        get {
            return inputText.text!
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(inputText)
        addSubview(levelBtn)
        addSubview(postBtn)
        inputText.addSubview(placeholderLbl)
        inputText.setValue(placeholderLbl, forKey: "_placeholderLabel")
    }
    
    @objc func actionShow() {
        let level = LevelWindow(frame: UIScreen.main.bounds)
        level.show()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class LevelIconItemView: UIControl {

    lazy var iconV: UIImageView = {
        var iconV: UIImageView = UIImageView(frame: CGRect(x: 15, y: 15, width: 22, height: 22))
        return iconV
    }()
    lazy var titleLbl: UILabel = {
        var titleLbl: UILabel = UILabel(frame: CGRect(x: 37+5, y: 15, width: frame.width-30-27, height: 22))
        titleLbl.font = .boldSystemFont(ofSize: 16)
        return titleLbl
    }()
    lazy var detailLbl: UILabel = {
        var detailLbl: UILabel = UILabel(frame: CGRect(x: 37+5, y: 15+22, width: frame.width-30-27, height: 22))
        detailLbl.font = .systemFont(ofSize: 14)
        return detailLbl
    }()
    lazy var rightV: UIImageView = {
        var rightV: UIImageView = UIImageView(frame: CGRect(x: frame.width-15-22, y: frame.height/2-11, width: 22, height: 22))
        rightV.image = UIImage(named: "right")
        return rightV
    }()
    
    var __type: LevelType = .PUBLIC_LEVEL
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconV)
        addSubview(titleLbl)
        addSubview(detailLbl)
        addSubview(rightV)
    }
    
    func refresh(_ type: LevelType) {
        __type = type
        if (type == .PUBLIC_LEVEL) {
            iconV.image = UIImage(named: "public")
            titleLbl.text = "公开"
            detailLbl.text = "所有人可见"
        } else {
            iconV.image = UIImage(named: "private")
            titleLbl.text = "私密"
            detailLbl.text = "仅自己可见"
        }
        
        if (Services.sharedInstance.currentType == type) {
            iconV.image = type == .PUBLIC_LEVEL ? UIImage(named: "public_active") : UIImage(named: "private_active")
            titleLbl.textColor = .mainColor()
            detailLbl.textColor = .mainColor()
            rightV.isHidden = false
        } else {
            rightV.isHidden = true
            titleLbl.textColor = .textColor(0.9)
            detailLbl.textColor = .textColor(0.6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LevelBtn: UIControl {

    lazy var leftIcon: UIImageView = {
        var leftIcon: UIImageView = UIImageView()
        return leftIcon
    }()
    lazy var titleLbl: UILabel = {
        var titleLbl: UILabel = UILabel()
        titleLbl.font = .systemFont(ofSize: 14)
        return titleLbl
    }()
    lazy var rightIcon: UIImageView = {
        var rightIcon: UIImageView = UIImageView()
        rightIcon.image = UIImage(named: "down")
        return rightIcon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftIcon)
        addSubview(rightIcon)
        addSubview(titleLbl)
        leftIcon.frame = CGRect(x: 0, y: frame.height/2-11, width: 22, height: 22)
        titleLbl.frame = CGRect(x: 27, y: frame.height/2-10, width: 40, height: 20)
        rightIcon.frame = CGRect(x: 67, y: frame.height/2-11, width: 22, height: 22)
        refresh(Services.sharedInstance.currentType)
        NotificationCenter.default.addObserver(self, selector: #selector(actionRefresh), name: NSNotification.Name(rawValue: NOTI_POST_LEVEL), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func actionRefresh() {
        refresh(Services.sharedInstance.currentType)
    }
    
    func refresh(_ type: LevelType) {
        if (type == .PUBLIC_LEVEL) {
            leftIcon.image = UIImage(named: "public")
            titleLbl.text = "公开"
        } else {
            leftIcon.image = UIImage(named: "private")
            titleLbl.text = "私密"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
