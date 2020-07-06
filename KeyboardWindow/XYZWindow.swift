//
//  XYZWindow.swift
//  KeyboardWindow
//
//  Created by xuyazhong on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class XYZWindow: UIView {

    lazy var inputV: InputIdeaView = {
        let inputV = InputIdeaView(frame: CGRect(x: 0, y: ScreenHeight-150, width: ScreenWidth, height: 150))
        inputV.postBtn.addTarget(self, action: #selector(actionPost), for: .touchUpInside)
        return inputV
    }()
    lazy var bgView: UIView = {
        let bgV = UIView(frame: UIScreen.main.bounds)
        bgV.backgroundColor = .colorFromHex(0x000000, alpha: 0.3)
        bgV.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionTouchOther))
        bgV.addGestureRecognizer(tap)
        return bgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .colorFromHex(0x000000, alpha: 0.3)
        addSubview(bgView)
        addSubview(inputV)
        /// 键盘弹出监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: NSNotification.Name(rawValue: UIResponder.keyboardWillShowNotification.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name(rawValue: UIResponder.keyboardWillHideNotification.rawValue), object: nil)
    }
    
    func show() {
        let keyWindow = UIApplication.shared.keyWindow!
        keyWindow.addSubview(self)
        showKeyboard()
    }
    
    deinit {
        print("deinit=> \(self)")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func actionPost() {
        if (inputV.inputValue == "" ) {
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification_POST), object: inputV.inputValue)
        
        hideKeyboard()
    }
    
    @objc func actionTouchOther() {
        hideKeyboard()
    }
    
    func showKeyboard() {
        inputV.inputText.becomeFirstResponder()
    }
    
    func hideKeyboard() {
        inputV.inputText.resignFirstResponder()
        removeFromSuperview()
    }
    
    /// 键盘弹起
    @objc func keyboardWillAppear(_ noti: NSNotification) {
        /// 获得软键盘的高
        guard let userInfo = noti.userInfo, let keyboardInfo: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            print("keyboardInfo error")
            return
        }
        let kbRect = keyboardInfo.cgRectValue
        
        var inputRect = inputV.frame
        inputRect.origin.y = kbRect.minY - inputRect.size.height
        
        UIView.animate(withDuration: 0.3) {
            self.bgView.isHidden = false
            self.bgView.alpha = 0.2
        }
        
        self.inputV.frame = inputRect
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        var inputRect = inputV.frame
        inputRect.origin.y = ScreenHeight
        
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0
            self.bgView.isHidden = true
        }
        
        self.inputV.frame = inputRect
        self.inputV.inputValue = ""
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
