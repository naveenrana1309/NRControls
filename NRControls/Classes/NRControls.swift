//
//  NRControls.swift
//  
//
//  Created by Naveen Rana on 21/08/16.
//  Developed by Naveen Rana. All rights reserved.
//

import Foundation
import MessageUI


/// This completionhandler use for call back image picker controller delegates.
public typealias ImagePickerControllerCompletionHandler = (controller: UIImagePickerController, info: Dictionary<String,AnyObject>) -> Void

/// This completionhandler use for call back mail controller delegates.
public typealias MailComposerCompletionHandler = (result:MFMailComposeResult ,error: NSError?) -> Void

/// This completionhandler use for call back alert(Alert) controller delegates.
public typealias AlertControllerCompletionHandler = (alertController: UIAlertController, index: Int) -> Void

/// This completionhandler use for call back alert(ActionSheet) controller delegates.
public typealias AlertTextFieldControllerCompletionHandler = (alertController: UIAlertController, index: Int, text: String) -> Void

/// This completionhandler use for call back of selected image using image picker controller delegates.
public typealias CompletionImagePickerController = (selectedImage: UIImage?) -> Void


/// This class is used for using a common controls like alert, action sheet and imagepicker controller with proper completion Handlers.

public class NRControls: NSObject,UIImagePickerControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate{
    
    /// This completionhandler use for call back image picker controller delegates.
    var imagePickerControllerHandler: ImagePickerControllerCompletionHandler?
    
    /// This completionhandler use for call back mail controller delegates.
    var mailComposerCompletionHandler: MailComposerCompletionHandler?

    ///Shared instance
    public static let sharedInstance = NRControls()

    /**
     This function is used for taking a picture from iphone camera or camera roll.
     - Parameters:
        - viewController: Source viewcontroller from which you want to present this popup.
        - completionHandler: This completion handler will give you image or nil.
     
 */
    //MARK: UIImagePickerController

    public func takeOrChoosePhoto(viewController: UIViewController, completionHandler: CompletionImagePickerController) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Choose photo", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
            completionHandler(selectedImage: nil)
            
        }
        actionSheetController.addAction(cancelAction)
        
        
        //Create and add first option action
        
        //Create and add a second option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            
            self.openImagePickerController(.Camera, isVideo: false, inViewController: viewController) { (controller, info) -> Void in
                let image = info[UIImagePickerControllerOriginalImage] as? UIImage
                completionHandler(selectedImage: image)
            }
        }
        
        actionSheetController.addAction(takePictureAction)
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose from library", style: .Default) { action -> Void in
            
            self.openImagePickerController(.PhotoLibrary, isVideo: false, inViewController: viewController) { (controller, info) -> Void in
                let image = info[UIImagePickerControllerOriginalImage] as? UIImage
                completionHandler(selectedImage: image)
            }
        }
        actionSheetController.addAction(choosePictureAction)
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
            // In this case the device is an iPad.
            
           
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceView = viewController.view
                popoverController.sourceRect = viewController.view.bounds
            }
            
        }
        viewController.presentViewController(actionSheetController, animated: true, completion: nil)
    }

    /**
     This function is used open image picker controller.
     - Parameters:
        - sourceType:  PhotoLibrary, Camera, SavedPhotosAlbum
        - inViewController: Source viewcontroller from which you want to present this imagecontroller.
        - isVideo: if you want to capture video then set it to yes, by default value is false.
        - completionHandler: Gives you the call back with Imagepickercontroller and information about image.

     */

    public func openImagePickerController(sourceType: UIImagePickerControllerSourceType, isVideo: Bool = false, inViewController:UIViewController, completionHandler: ImagePickerControllerCompletionHandler)-> Void {

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
        
        if (UI_USER_INTERFACE_IDIOM() == .Pad) { //iPad support
            // In this case the device is an iPad.
            
            if let popoverController = controller.popoverPresentationController {
                popoverController.sourceView = inViewController.view
                popoverController.sourceRect = inViewController.view.bounds
            }
            
        }
        inViewController.presentViewController(controller, animated: true, completion: nil)

    }
    
    //MARK: UIImagePickerController Delegates
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("didFinishPickingMediaWithInfo")
        
        self.imagePickerControllerHandler!(controller: picker, info: info)
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
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
    public func openMailComposerInViewController(recipientsEmailIds:[String], viewcontroller: UIViewController, subject: String = "", message: String = "" ,attachment: NSData? = nil,completionHandler: MailComposerCompletionHandler){
        self.mailComposerCompletionHandler = completionHandler
        let mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController.mailComposeDelegate = self
        mailComposerViewController.setSubject(subject)
        mailComposerViewController.setMessageBody(message, isHTML: true)
        mailComposerViewController.setToRecipients(recipientsEmailIds)
        if let _ = attachment {
            if (attachment!.length>0) 
            {
                mailComposerViewController.addAttachmentData(attachment!, mimeType: "image/jpeg", fileName: "attachment.jpeg")
            }

        }
        viewcontroller.presentViewController(mailComposerViewController, animated: true, completion:nil)
    }
    
    //MARK: MFMailComposeViewController Delegates

    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion:nil)
        if self.mailComposerCompletionHandler != nil {
            self.mailComposerCompletionHandler!(result: result, error: error)

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

    
    public func openAlertViewFromViewController(viewController: UIViewController, title: String = "", message: String = "", buttonsTitlesArray: [String], completionHandler: AlertControllerCompletionHandler?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        for element in buttonsTitlesArray {
            let action:UIAlertAction = UIAlertAction(title: element, style: .Default, handler: { (action) -> Void in
                if let _ = completionHandler {
                    completionHandler!(alertController: alertController, index: buttonsTitlesArray.indexOf(element)!)
                }
                
            })
            alertController.addAction(action)
        }
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
      
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

   public func openActionSheetFromViewController(viewController: UIViewController, title: String, message: String, buttonsTitlesArray: [String], completionHandler: AlertControllerCompletionHandler?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        for element in buttonsTitlesArray {
            let action:UIAlertAction = UIAlertAction(title: element, style: .Default, handler: { (action) -> Void in
                if let _ = completionHandler {
                    completionHandler!(alertController: alertController, index: buttonsTitlesArray.indexOf(element)!)
                }
                
            })
            alertController.addAction(action)
        }
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
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

    public func openAlertViewWithTextFieldFromViewController(viewController: UIViewController, title: String = "", message: String = "", placeHolder: String = "", isSecure: Bool = false, buttonsTitlesArray: [String], isNumberKeyboard: Bool = false, completionHandler: AlertTextFieldControllerCompletionHandler?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        for element in buttonsTitlesArray {
            let action: UIAlertAction = UIAlertAction(title: element, style: .Default, handler: { (action) -> Void in
                if let _ = completionHandler {
                    if let _ = alertController.textFields where alertController.textFields?.count > 0 , let text = alertController.textFields?.first?.text {
                        completionHandler!(alertController: alertController, index: buttonsTitlesArray.indexOf(element)!, text: text)

                    }
                }
                
            })
            alertController.addAction(action)
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
          
            textField.secureTextEntry = isSecure
            textField.placeholder =  placeHolder
            if isNumberKeyboard {
                textField.keyboardType = .NumberPad
            }
            else {
                textField.keyboardType = .EmailAddress

            }
        }
        viewController.presentViewController(alertController, animated: false, completion: nil)
    }
    
    
}