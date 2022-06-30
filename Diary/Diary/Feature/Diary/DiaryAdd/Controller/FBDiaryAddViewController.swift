//
//  FBDiaryAddViewController.swift
//  Diary
//
//  Created by Simon Miao on 2022/6/27.
//

import UIKit
import Photos

typealias FBDiarAddCallback = (_ item: FBHomeItem) -> Void
class FBDiaryAddViewController: FBBaseViewController {

    private var callback: FBDiarAddCallback?
    
    private var isShowKeyboard: Bool = false
    private var keyboardHeight: CGFloat = 0.0
    private var sureItem: UIBarButtonItem?
    private var imageEncodedStr: String = ""
    lazy var addView: FBDiaryAddView = {
        var addView = FBDiaryAddView(frame: .zero)
        
        return addView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavItem()
        initSubView()
        addNoticeObserver()
    }
     
    private func initSubView() {
        addView.delegate = self
        view.addSubview(addView)
        
        addView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}


// MARK: public methods
extension FBDiaryAddViewController {
    func addItemCallback(complete: @escaping FBDiarAddCallback) {
        callback = complete
    }
}
// MARK: private methods
extension FBDiaryAddViewController {
    private func createNavItem() {
        sureItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(sureItemClicked(_:)))
        navigationItem.rightBarButtonItem = sureItem
    }
    
    @objc private func sureItemClicked(_ sender: UIBarButtonItem) {
        guard let callback = callback else {
            return
        }
        
        navigationController?.popViewController(animated: true)
        
        let timestamp = Date().timeIntervalSince1970
        let item = FBHomeItem(title: addView.titleTextView.text,
                              detail: addView.detailTextView.text,
                              timestamp: timestamp,
                              imageEncodedStr: imageEncodedStr)
        
        callback(item)
    }
    
    private func addNoticeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        if (isShowKeyboard) {
            return;
        }
        
        guard let userInfo = sender.userInfo else { return }
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        keyboardHeight = keyboardRect.height
//        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        
        self.addView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-self.keyboardHeight)
        }
        
        isShowKeyboard = true
//        UIView.animate(withDuration: duration, delay: 0, options: .allowAnimatedContent, animations: { [self] in
//            self.addView.frame.origin.y = self.view.frame.origin.y - self.keyboardHeight
//        }, completion: nil)
    }
    @objc private func keyboardWillHide(_ sender: Notification) {
        self.addView.snp.updateConstraints { make in
            make.bottom.equalToSuperview();
        }
        
        isShowKeyboard = false
        
//        UIView.animate(withDuration: 0.25, delay: 0, options: .allowAnimatedContent, animations: {
//            self.addView.frame.origin.y += self.keyboardHeight
//        }, completion: nil)
    }
    
    private func openPhoto() {
        if #available(iOS 14, *) {
            let authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            if authStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .limited:
                        print("相册部分")
                        self.goPhoto()
                    case .authorized:
                        print("相册允许")
                        self.goPhoto()
                    case .restricted:
                        print("相册限制")
                    case .denied:
                        print("用户拒绝访问相册")
                    default:
                        print("未授权")
                    }
                    
                }
            } else if authStatus == .authorized {
                self.goPhoto()
            }
                
        } else {
            let authStatus = PHPhotoLibrary.authorizationStatus()
            if authStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .limited:
                        print("相册部分")
                        self.goPhoto()
                    case .authorized:
                        print("相册允许")
                        self.goPhoto()
                    case .restricted:
                        print("相册限制")
                    case .denied:
                        print("用户拒绝访问相册")
                    default:
                        print("未授权")
                    }
                }
            }
            
        }
        
    }
    
    private func goPhoto() {
        DispatchQueue.main.async {
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
//            photoPicker.allowsEditing = true
            photoPicker.sourceType = .photoLibrary
            self.present(photoPicker, animated: true, completion: nil)
        }
    }
    
    // 拍照
    private func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("不支持拍照")
        }
    }
}

extension FBDiaryAddViewController: FBDiaryAddViewDelegate {
    func diaryAddViewDidChange(_ titleTextView: UITextView) {
        if (titleTextView.text.count > 0) {
            sureItem?.isEnabled = true
        } else {
            sureItem?.isEnabled = false
        }
    }
}

extension FBDiaryAddViewController: FBDiaryAddToolBarProtocol {
    func diaryAddToolBarBtnItemClicked(_ diaryAddToolBar: FBDiaryAddToolBar, systemItem: UIBarButtonItem.SystemItem) {
        switch systemItem {
        case .camera:
            let alertCtr = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let photo = UIAlertAction(title: "相册", style: .default) { action in
                self.openPhoto()
            }
            let camera = UIAlertAction(title: "拍照", style: .default) { action in
                self.openCamera()
            }
            alertCtr.addAction(cancel)
            alertCtr.addAction(camera)
            alertCtr.addAction(photo)
            self.present(alertCtr, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension FBDiaryAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("获得照片============= \(info)")
        let image : UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        //        let rootPath:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        //        //图片文件路径
        //        let filePath = rootPath.strings(byAppendingPaths: ["selectedImage.jpg"]).first
        let pickedImage = image //.normalizedImage()
        let originData = pickedImage.jpegData(compressionQuality: 1.0)
        
        addView.photoImageView.image = image
        
        let imageData: Data?
        
        if ((originData?.count ?? 0) / 1024) > 5000 {
            imageData = pickedImage.jpegData(compressionQuality: 0.1)
        } else {
            imageData = pickedImage.jpegData(compressionQuality: 0.3)
        }
        
        imageEncodedStr = imageData?.base64EncodedString() ?? ""
        
        self.dismiss(animated: true, completion: nil)
    }
}
