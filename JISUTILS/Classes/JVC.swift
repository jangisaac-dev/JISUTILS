//
//  JVC.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation
import UIKit

class JVC: UIViewController {
    
    var screenWidth : CGFloat = UIScreen.main.bounds.size.width
    var screenHeight : CGFloat = UIScreen.main.bounds.size.height
    
    let picker = UIImagePickerController()
    
    var lastTitle = ""
    var vSpinner : UIView?
    
    private var lastNaviBackImage : UIImage?
    private var lastNaviShdImage : UIImage?
    
    private var imagePickerComplete : ((UIImage)->Void)?
    private var imagePickerFailed : (()->Void)?
    
    var screenNotMoveByKeyboard = true
    private var screenMovedAlready = false
    var lastOrigin : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        addKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        // needed to clear the text in the back navigation:
        self.navigationItem.title = " "
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = lastTitle
    }
    
   public func setTitle(title: String) {
        lastTitle = title
        self.title = title
    }
    
    public func addKeyboardNotification() {
        lastOrigin = self.view.frame.origin.y
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
            )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
            )
    }
    
   public func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
   public func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    public func getBottomSafeArea() -> CGFloat {
        guard let window = UIApplication.shared.keyWindow else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
    
    @objc public func keyboardWillShow(_ notification: Notification) {
        if screenNotMoveByKeyboard {
            return
        }
        if screenMovedAlready {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= (keyboardSize.height - 40 - getBottomSafeArea())
            screenMovedAlready = true
        }

    }
      
    @objc public func keyboardWillHide(_ notification: Notification) {
        if screenNotMoveByKeyboard {
            return
        }
        self.view.frame.origin.y = lastOrigin
        screenMovedAlready = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
   public func removeNavigationBorder() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
   public func showNavigationBorder() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
   public func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func openLibrary() {
        picker.sourceType = .photoLibrary
        
        present(picker, animated: false, completion: nil)
    }
    
    public func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
    }
    
   public func openSelectImageFrom(_ complete : @escaping ((UIImage?)->Void), _ failed : @escaping (()->Void)) {
        imagePickerComplete = complete
        imagePickerFailed = failed
        picker.delegate = self
        let alert =  UIAlertController(title: "사진 선택", message: "사진을 가져올 방법을 선택해주세요.", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    let loadingVC = JLoadingVC()
    
   public func showLoadingAlert() {
        loadingVC.modalTransitionStyle = .crossDissolve
        loadingVC.modalPresentationStyle = .overCurrentContext
        
        present(loadingVC, animated: true, completion: nil)
//        if let tabBar = self.tabBarController as? TRMTabBarController {
//            if let mainTop = tabBar.getMainNaviTopController() {
//                mainTop.showLoadingAnimationView()
//            }
//        }
    }
    
   public func hideLoadingAlert() {
        loadingVC.dismiss(animated: true, completion: nil)
//        if let tabBar = self.tabBarController as? TRMTabBarController {
//            if let mainTop = tabBar.getMainNaviTopController() {
//                mainTop.hideLoadingAnimationView()
//            }
//        }
    }
        
   public func showDatePicker(done: @escaping ((Date)->Void), defDate: Date?) {
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.locale = Locale.current
        myDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            myDatePicker.preferredDatePickerStyle = .wheels
        }
        if let defDate = defDate {
            myDatePicker.date = defDate
        }
        myDatePicker.frame = CGRect(x: 0, y: 5, width: view.bounds.width - 20, height: 180)
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        alertController.view.addSubview(myDatePicker)
        let selectAction = UIAlertAction(title: "완료", style: .default, handler: { _ in
            done(myDatePicker.date)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
   public func showTimePicker(done: @escaping ((Date)->Void), defDate: Date?, minuteInterval: Int? = 10) {
        let myDatePicker: UIDatePicker = UIDatePicker()
        
        myDatePicker.locale = Locale.current
        myDatePicker.datePickerMode = .time
        myDatePicker.minuteInterval = minuteInterval ?? 10
        if #available(iOS 13.4, *) {
            myDatePicker.preferredDatePickerStyle = .wheels
        }
        if let defDate = defDate {
            myDatePicker.date = defDate
        }
        myDatePicker.frame = CGRect(x: 0, y: 5, width: view.bounds.width - 20, height: 180)
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        alertController.view.addSubview(myDatePicker)
        let selectAction = UIAlertAction(title: "완료", style: .default, handler: { _ in
            done(myDatePicker.date)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    var selectPickerStringArray : [[String]] = []
    var lastSelectRow : [Int] = []
    var compNumber = 1
   public func showStringPicker(done: @escaping (([String], [Int])->Void),
                          list: [[String]],
                          initalSelection: [Int]?,
                          count : Int = 1) {
        
        if list.count != count { return }
        if initalSelection != nil && initalSelection!.count != count { return }
        
        compNumber = count
        selectPickerStringArray = list
        for _ in 0 ..< count {
            lastSelectRow.append(0)
        }
        
        
        let myPicker : UIPickerView = UIPickerView()
        myPicker.dataSource = self
        myPicker.delegate = self
        myPicker.reloadAllComponents()
        myPicker.frame = CGRect(x: 0, y: 5, width: view.bounds.width - 20, height: 180)
        if initalSelection != nil {
            for i in 0 ..< count {
                myPicker.selectRow(initalSelection![i], inComponent: i, animated: false)
                lastSelectRow[i] = initalSelection![i]
            }
        }
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(myPicker)
        alertController.isSpringLoaded = true
        
        let selectAction = UIAlertAction(title: "완료", style: .default, handler: { _ in
            var resultStrs = [String]()
            
            for cnt in 0 ..< count {
                let value = self.selectPickerStringArray[cnt][self.lastSelectRow[cnt]]
                resultStrs.append(value)
            }
            if self.lastSelectRow.count > 0 {
                done(resultStrs, self.lastSelectRow)
            }
            self.compNumber = 1
            self.selectPickerStringArray = []
            self.lastSelectRow = []
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: { action in
            self.compNumber = 1
            self.selectPickerStringArray = []
            self.lastSelectRow = []
        })
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    var viewLoading = UIView()
    var lbLoading = UILabel()
    
    public func initLoadingView() {
        viewLoading.translatesAutoresizingMaskIntoConstraints = false
        lbLoading.translatesAutoresizingMaskIntoConstraints = false
        
        let viewBack = UIView()
        viewBack.translatesAutoresizingMaskIntoConstraints = false
        viewBack.backgroundColor = .black
        viewBack.alpha = 0.5
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        lbLoading.text = ""
        lbLoading.textColor = .white
        lbLoading.font = UIFont.systemFont(ofSize: 18)
        
        
        viewLoading.addSubview(viewBack)
        viewLoading.addSubview(activityView)
        viewLoading.addSubview(lbLoading)
        
        self.view.addSubview(viewLoading)
        
        NSLayoutConstraint.activate([
            viewBack.topAnchor.constraint(equalTo: viewLoading.topAnchor),
            viewBack.rightAnchor.constraint(equalTo: viewLoading.rightAnchor),
            viewBack.leftAnchor.constraint(equalTo: viewLoading.leftAnchor),
            viewBack.bottomAnchor.constraint(equalTo: viewLoading.bottomAnchor),
            
            activityView.centerXAnchor.constraint(equalTo: viewLoading.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: viewLoading.centerYAnchor),
            
            lbLoading.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: 20),
            lbLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            viewLoading.topAnchor.constraint(equalTo: view.topAnchor),
            viewLoading.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewLoading.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewLoading.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
//        activityView.center = self.view.center
        
        activityView.center = view.center
        activityView.startAnimating()
        
        
        viewLoading.isHidden = true
        viewLoading.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onIgnoredClick)))
    }
    
   public func getLoadingView() -> UIView {
        let newView = UIView()
        let viewBack = UIView()
        viewBack.translatesAutoresizingMaskIntoConstraints = false
        viewBack.backgroundColor = .black
        viewBack.alpha = 0.5
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        
        newView.addSubview(viewBack)
        newView.addSubview(activityView)
        
        self.view.addSubview(newView)
        
        NSLayoutConstraint.activate([
            viewBack.topAnchor.constraint(equalTo: newView.topAnchor),
            viewBack.rightAnchor.constraint(equalTo: newView.rightAnchor),
            viewBack.leftAnchor.constraint(equalTo: newView.leftAnchor),
            viewBack.bottomAnchor.constraint(equalTo: newView.bottomAnchor),
            
            activityView.centerXAnchor.constraint(equalTo: newView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: newView.centerYAnchor),
        ])
        
        activityView.center = view.center
        activityView.startAnimating()
        
        
        newView.isHidden = true
        newView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onIgnoredClick)))
        return newView
    }
    
   public func updateLoadingView(str: String) {
        lbLoading.text = str
    }
    
   public func showLoadingView(str: String) {
        if viewLoading.superview == nil {
            initLoadingView()
        }
        
        lbLoading.text = str
        
        viewLoading.alpha = 0
        viewLoading.isHidden = false
        
        UIView.animate(withDuration: 1) {
            self.viewLoading.alpha = 0.5
        }
    }
    
   public func showLoadingView() {
        if viewLoading.superview == nil {
            initLoadingView()
        }
        lbLoading.text = ""
        
        viewLoading.alpha = 0
        viewLoading.isHidden = false
        
        UIView.animate(withDuration: 1) {
            self.viewLoading.alpha = 0.5
        }
    }
    
   public func hideLoadingView() {
        UIView.animate(withDuration: 1) {
            self.viewLoading.alpha = 0
        } completion: { (result) in
            self.viewLoading.isHidden = true
        }
    }
    
   public func getFrontLoadingView() {
        self.viewLoading.bringSubview(toFront: view)
    }
    
    @objc
   public func onIgnoredClick() {
        
    }
    
}
extension JVC : UIPickerViewDelegate, UIPickerViewDataSource {
   public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return compNumber
    }
    
   public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectPickerStringArray[component].count
    }
    
   public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectPickerStringArray[component][row]
    }
   public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lastSelectRow[component] = row
    }
    
    
}


extension JVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            self.imagePickerFailed?()
            return
        }
        self.imagePickerComplete?(image)
    }
    
}
