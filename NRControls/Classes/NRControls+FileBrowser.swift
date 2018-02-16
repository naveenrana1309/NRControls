//
//  NRControls+FileBrowser.swift
//  NRControls
//
//  Created by Naveen Rana on 16/02/18.
//

import Foundation
import FileProvider

extension NRControls: UIDocumentPickerDelegate {
    
    
    open func openDocumentPicker(_ viewController: UIViewController, completionHandler: @escaping DocumentPickerCompletionHandler) {
        self.documentPickerCompletionHandler = completionHandler

        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        viewController.present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        if let _ = self.documentPickerCompletionHandler {
            self.documentPickerCompletionHandler!(nil)
        }
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let _ = self.documentPickerCompletionHandler {
            self.documentPickerCompletionHandler!(urls)
        }

    }
    
}
