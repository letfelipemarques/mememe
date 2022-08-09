//
//  MemeEditorViewController.swift
//  memeMe
//
//  Created by Felipe Marques on 23/03/22.
//

import UIKit

struct Meme {
    var memetopText: String = ""
    var memebottomText: String = ""
    var theMeme:UIImage = UIImage()
}

final class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topToolbar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveMeme: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setMemeAttributes()
        navigationController?.isToolbarHidden = false
        navigationController?.navigationBar.tintColor = UIColor.white
        self.topText.delegate = self
        self.bottomText.delegate = self
        cameraButton.isEnabled = UIImagePickerController
            .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setkeyboardNotifications()
    }

    func setkeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unsubscribeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    func setMemeAttributes() {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -5
        ]
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
    }

    @IBAction func addImageFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func addImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareMeme(_ sender: Any) {
        let finalMeme: UIImage = generateFinalMeme()
        let controller = UIActivityViewController(activityItems: [finalMeme], applicationActivities: nil)
        controller.popoverPresentationController?.barButtonItem = shareButton
        controller.completionWithItemsHandler = {( _, ok, _, _ ) in
            if ok {
                self.memeInit()
            }
        }
        self.present(controller, animated: true, completion: nil)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func saveMeme(_ sender: Any) {
        let meme = Meme(memetopText: topText.text!, memebottomText: bottomText.text!, theMeme: generateFinalMeme())
        UIImageWriteToSavedPhotosAlbum(meme.theMeme, nil, nil, nil)
        let dialogMessage = UIAlertController(title: "Meme Saved!", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        incrementArray(meme: meme)
    }

    func incrementArray(meme: Meme) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memesRepo.append(meme)
    }

    func memeInit() {
        _ = Meme(memetopText: topText.text!, memebottomText: bottomText.text!, theMeme: UIImage())
    }

    func generateFinalMeme() -> UIImage {
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        UIGraphicsBeginImageContextWithOptions(imageContainer.bounds.size, true, 0)
        imageContainer.drawHierarchy(in: imageContainer.bounds, afterScreenUpdates: true)
        let generatedMeme = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        topToolbar.isHidden =  false
        bottomToolbar.isHidden = false
        return generatedMeme
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
