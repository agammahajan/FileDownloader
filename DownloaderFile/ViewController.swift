//
//  ViewController.swift
//  DownloaderFile
//
//  Created by Agam Mahajan on 11/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import UIKit

var destinationUrl : NSURL?

class ViewController: UIViewController , NSURLSessionDataDelegate ,  UITextFieldDelegate{
    
    @IBOutlet var TextField: UITextField!
    @IBOutlet var Download: UIButton!
    @IBOutlet var ProgressBar: UIProgressView!
    
    @IBOutlet var ImageFound: UIButton!
    @IBOutlet var Complete: UILabel!
    
    var url : NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressBar.hidden = true
        TextField.delegate = self
        ProgressBar.setProgress(0.0, animated: true)
        Complete.hidden = true
        ImageFound.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    //is called once the download is complete
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
    {
        
        let ext = (self.url! as NSURL).pathExtension
        
        //copy downloaded data to your documents directory with same names as source file
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
         destinationUrl = documentsUrl!.URLByAppendingPathComponent(url!.lastPathComponent!)
        let dataFromURL = NSData(contentsOfURL: location)
        dataFromURL?.writeToURL(destinationUrl!, atomically: true)
        
        print(destinationUrl)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        print("Dowloaded")
        
        
        let imageExtensions:[String] = ["jpg","jpeg","png","gif","xmf"]
        if imageExtensions.indexOf(ext!) != nil{
            dispatch_async(dispatch_get_main_queue(),{
                self.ImageFound.hidden = false
            })
            
        }
        

    }
    
    //this is to track progress
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten t1: Int64, totalBytesExpectedToWrite t2: Int64)
    {
        let taskTotalBytesWritten = Int(t1)
        let taskTotalBytesExpectedToWrite = Int(t2)
        let percentageWritten = Float(taskTotalBytesWritten) / Float(taskTotalBytesExpectedToWrite)
        dispatch_async(dispatch_get_main_queue(),{
            self.ProgressBar.setProgress(percentageWritten, animated:true)
            print(percentageWritten)
            
            if percentageWritten == 1.0
            {
                self.Complete.hidden = false
            }
           }
        )
    }
    
    // if there is an error during download this will be called
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        if(error != nil)
        {
            //handle the error
            print("Download completed with error: \(error!.localizedDescription)");
        }
    }
    
    func download(url: NSURL)
    {
        self.url = url
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(url.absoluteString)
        let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithURL(url)
        task.resume()
    }

    @IBAction func onClick(sender: AnyObject) {
        ProgressBar.hidden = false
        TextField.delegate = self
         Complete.hidden = true
        ImageFound.hidden = true
        ProgressBar.setProgress(0.0, animated: true)
        if(TextField.text == ""){
            print("Enter url")
        }
        else{
            url = NSURL(string: TextField.text!)
            download(url!)
        }
    }

}

