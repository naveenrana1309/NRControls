//
//  NRControls.swift
//  
//
//  Created by Naveen Rana on 21/08/16.
//  Developed by Naveen Rana. All rights reserved.
//

import Foundation
import MessageUI
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



/// This completionhandler use for call back image picker controller delegates.
public typealias ImagePickerControllerCompletionHandler = (_ controller: UIImagePickerController, _ info: Dictionary<String,AnyObject>) -> Void

/// This completionhandler use for call back mail controller delegates.
public typealias MailComposerCompletionHandler = (_ result:MFMailComposeResult ,_ error: NSError?) -> Void

/// This completionhandler use for call back alert(Alert) controller delegates.
public typealias AlertControllerCompletionHandler = (_ alertController: UIAlertController, _ index: Int) -> Void

/// This completionhandler use for call back alert(ActionSheet) controller delegates.
public typealias AlertTextFieldControllerCompletionHandler = (_ alertController: UIAlertController, _ index: Int, _ text: String) -> Void

/// This completionhandler use for call back of selected image using image picker controller delegates.
public typealias CompletionImagePickerController = (_ selectedImage: UIImage?) -> Void


/// This class is used for using a common controls like alert, action sheet and imagepicker controller with proper completion Handlers.

open class NRControls: NSObject,UIImagePickerControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate{
    
    /// This completionhandler use for call back image picker controller delegates.
    var imagePickerControllerHandler: ImagePickerControllerCompletionHandler?
    
    /// This completionhandler use for call back mail controller delegates.
    var mailComposerCompletionHandler: MailComposerCompletionHandler?

    ///Shared instance
    open static let sharedInstance = NRControls()

    /**
     This function is used for taking a picture from iphone camera or camera roll.
     - Parameters:
        - viewController: Source viewcontroller from which you want to present this popup.
        - completionHandler: This completion handler will give you image or nil.
     
 */
    //MARK: UIImagePickerController

    open func takeOrChoosePhoto(_ viewController: UIViewController, completionHandler: @escaping CompletionImagePickerController) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Choose photo", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            completionHandler(nil)
            
        }
        actionSheetController.addAction(cancelAction)
        
        
        //Create and add first option action
        
        //Create and add a second option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
            
            self.openImagePickerController(.camera, isVideo: false, inViewController: viewController) { (controller, info) -> Void in
                let image = info[UIImagePickerControllerOriginalImage] as? UIImage
                completionHandler(image)
            }
        }
        
        actionSheetController.addAction(takePictureAction)
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose from library", style: .default) { action -> Void in
            
            self.openImagePickerController(.photoLibrary, isVideo: false, inViewController: viewController) { (controller, info) -> Void in
                let image = info[UIImagePickerControllerOriginalImage] as? UIImage
                completionHandler(image)
            }
        }
        actionSheetController.addAction(choosePictureAction)
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            // In this case the device is an iPad.
            
           
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceView = viewController.view
                popoverController.sourceRect = viewController.view.bounds
            }
            
        }
        viewController.present(actionSheetController, animated: true, completion: nil)
    }

    /**
     This function is used open image picker controller.
     - Parameters:
        - sourceType:  PhotoLibrary, Camera, SavedPhotosAlbum
        - inViewController: Source viewcontroller from which you want to present this imagecontroller.
        - isVideo: if you want to capture video then set it to yes, by default value is false.
        - completionHandler: Gives you the call back with Imagepickercontroller and information about image.

     */

    open func openImagePickerController(_ sourceType: UIImagePickerControllerSourceType, isVideo: Bool = false, inViewController:UIViewController, completionHandler: @escaping ImagePickerControllerCompletionHandler)-> Void {

        self.imagePickerControllerHandler = completionHandler
    
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.delegate = self;
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            
            controller.sourceType = sourceType
            
        }
        else
        {
            print("this source type not supported in this device")
        }
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) { //iPad support
            // In this case the device is an iPad.
            
            if let popoverController = controller.popoverPresentationController {
                popoverController.sourceView = inViewController.view
                popoverController.sourceRect = inViewController.view.bounds
            }
            
        }
        inViewController.present(controller, animated: true, completion: nil)

    }
    
    //MARK: UIImagePickerController Delegates
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("didFinishPickingMediaWithInfo")
        
        self.imagePickerControllerHandler!(picker, info as Dictionary<String, AnyObject>)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /**
     This function is used for open Mail Composer.
     - Parameters:
        - recipientsEmailIds:  email ids of recipents for you want to send emails.
        - viewcontroller: Source viewcontroller from which you want to present this mail composer.
        - subject: Subject of mail.
        - message: body of mail.
        - attachment: optional this is nsdata of video/photo or any other document.
        - completionHandler: Gives you the call back with result and error if any.
     
     */

    //MARK: MFMailComposeViewController
    open func openMailComposerInViewController(_ recipientsEmailIds:[String], viewcontroller: UIViewController, subject: String = "", message: String = "" ,attachment: Data? = nil,completionHandler: @escaping MailComposerCompletionHandler){
        if !MFMailComposeViewController.canSendMail() {
           print("No mail configured. please configure your mail first")
            return()
        }
        self.mailComposerCompletionHandler = completionHandler
        let mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController.mailComposeDelegate = self
        mailComposerViewController.setSubject(subject)
        mailComposerViewController.setMessageBody(message, isHTML: true)
        mailComposerViewController.setToRecipients(recipientsEmailIds)
        if let _ = attachment {
            if (attachment!.count>0) 
            {
                mailComposerViewController.addAttachmentData(attachment!, mimeType: "image/jpeg", fileName: "attachment.jpeg")
            }

        }
        viewcontroller.present(mailComposerViewController, animated: true, completion:nil)
    }
    
    //MARK: MFMailComposeViewController Delegates

    open func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion:nil)
        if self.mailComposerCompletionHandler != nil {
            self.mailComposerCompletionHandler!(result, error as NSError?)

        }
    }
    
    //MARK: AlertController

    /**
     This function is used for open Alert View.
     - Parameters:
     - viewcontroller: Source viewcontroller from which you want to present this mail composer.
     - title: title of the alert.
     - message: message of the alert .
     - buttonsTitlesArray: array of button titles eg: ["Cancel","Ok"].
     - completionHandler: Gives you the call back with alertController and index of selected button .
     
     */

    
    open func openAlertViewFromViewController(_ viewController: UIViewController, title: String = "", message: String = "", buttonsTitlesArray: [String], completionHandler: AlertControllerCompletionHandler?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for element in buttonsTitlesArray {
            let action:UIAlertAction = UIAlertAction(title: element, style: .default, handler: { (action) -> Void in
                if let _ = completionHandler {
                    completionHandler!(alertController, buttonsTitlesArray.index(of: element)!)
                }
                
            })
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
      
    }
    
    /**
     This function is used for open Action Sheet.
     - Parameters:
     - viewcontroller: Source viewcontroller from which you want to present this mail composer.
     - title: title of the alert.
     - message: message of the alert .
     - buttonsTitlesArray: array of button titles eg: ["Cancel","Ok"].
     - completionHandler: Gives you the call back with alertController and index of selected button .
     
     */

   open func openActionSheetFromViewController(_ viewController: UIViewController, title: String, message: String, buttonsTitlesArray: [String], completionHandler: AlertControllerCompletionHandler?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for element in buttonsTitlesArray {
            let action:UIAlertAction = UIAlertAction(title: element, style: .default, handler: { (action) -> Void in
                if let _ = completionHandler {
                    completionHandler!(alertController, buttonsTitlesArray.index(of: element)!)
                }
                
            })
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }

    /**
     This function is used for openAlertView with textfield.
     - Parameters:
        - viewcontroller: source viewcontroller from which you want to present this mail composer.
        - title: title of the alert.
        - message: message of the alert.
        - placeHolder: placeholder of the textfield.
        - isSecure: true if you want texfield secure, by default is false.
        - isNumberKeyboard: true if keyboard is of type numberpad, .
        - buttonsTitlesArray: array of button titles eg: ["Cancel","Ok"].
        - completionHandler: Gives you the call back with alertController,index and text of textfield.
     
     */

    open func openAlertViewWithTextFieldFromViewController(_ viewController: UIViewController, title: String = "", message: String = "", placeHolder: String = "", isSecure: Bool = false, buttonsTitlesArray: [String], isNumberKeyboard: Bool = false, completionHandler: AlertTextFieldControllerCompletionHandler?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for element in buttonsTitlesArray {
            let action: UIAlertAction = UIAlertAction(title: element, style: .default, handler: { (action) -> Void in
                if let _ = completionHandler {
                    if let _ = alertController.textFields , alertController.textFields?.count > 0 , let text = alertController.textFields?.first?.text {
                        completionHandler!(alertController, buttonsTitlesArray.index(of: element)!, text)

                    }
                }
                
            })
            alertController.addAction(action)
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
          
            textField.isSecureTextEntry = isSecure
            textField.placeholder =  placeHolder
            if isNumberKeyboard {
                textField.keyboardType = .numberPad
            }
            else {
                textField.keyboardType = .emailAddress

            }
        }
        viewController.present(alertController, animated: false, completion: nil)
    }
    
    
}
