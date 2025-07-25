//
//  NvUserAction.swift
//  NetVision
//
//  Created by compass-362 on 22/06/16.
//  Copyright © 2016 compass-362. All rights reserved.
//

import UIKit




public class NvUserAction: NSObject {
    private static let TAG = "NvUserAction";
    
    func traverseViewHierarchy( act : UIViewController , uet: UAEVENTTYPE.UAEVENTTYPE, ev: CGPoint, autoTxn: NvAutoTransaction? ){
        var view = act.view ;
        
        while view?.superview != nil {
            view = view?.superview;
        }
        
        let vg = view?.subviews ;
        if(vg?.count == 0){
        }
        let touchonview : UIView? = view?.hitTest(ev, with: nil);
        
        if(touchonview != nil){
//            print("at.. if(touchonview != nil){")
            var a,b : String
            (a,b) = getElemInfo(v: touchonview!);
            if(autoTxn != nil){
                autoTxn!.checkSetAutoTxn(a:a, b:b, v:touchonview!);
            }
            let topleft = CGPoint.init(x: (touchonview?.center.x)!, y: (touchonview?.center.y)!);
            logTouchEvent(act: act, uet: uet, ev: topleft, v: touchonview!);
        }
        else {
        }
        
    }
    func logOnChangeEvent(act : UIViewController , v : UIView ){
        if (!NvCapConfigManager.getInstance().getNvControl().isRumEnabled()) {return;}
        let nvr = NvRequest() ;
        nvr._setReqCode( reqCode: NvRequest.REQCODE.USERACTION );
        let uad = UserActionData() ;
        
        // now fill up uad for the touchevent
        uad._setSessionId(sessionId: NvApplication.getSessId());
        uad._setPageId(pageId: NvApplication.getPageId());
        let pInst = NvApplication.getpageInstance();
        uad._setPageInstance(pageInstance: pInst);
        uad._settimestamp( timestamp: NvTimer.current_timestamp() ); // nne dto declare timestamp  [phase 2]
        uad._setDuration(duration: 0);     // not relevant in case of touchevent
        uad._setEvType(evType: UAEVENTTYPE.UAEVENTTYPE.CHANGE);
        uad._setId(id: v.tag); //send string id and not int id generated by android
        var elemName : String;
        var elemType : String;
        (elemName, elemType) = getElemInfo(v: v);
        uad._setElemName(elemName: elemName);
        uad._setElemType(elemType: elemType);
        uad._setElemSubType(elemSubType: "");
        
        uad._setPreValue( preValue: String (NvApplication.getSnapShotInstance()) );
        uad._setValue(value: elemName);
        //Put View position.
        
        uad._setXpos( xpos: Int (v.center.x - (v.bounds.size.width/2))) ;
        
        uad._setYpos(ypos: Int( v.center.y - (v.bounds.size.height/2)));
        
        uad._setWidth(width: Int(v.bounds.size.width));
        
        uad._setHeight(height: Int(v.bounds.size.height));
        
        let top = Int(v.bounds.origin.y);
        let left = Int(v.bounds.origin.x);
        uad._setTop(top: top);
        uad._setLeft(left: left);
        
        //_set the value.
        if let txtv = v as? UITextView {       //instance of problem
            uad._setValue(value: txtv.text)
        }
        else if let txtv = v as? UITextField {
            uad._setValue(value: txtv.text!)
        }
        else {
        }
        nvr._setReqData(reqData: uad);
    }
    
    func logUserAction(act : UIViewController , v : UIView, actionName : String ,actionData : String ){
        if (!NvCapConfigManager.getInstance().getNvControl().isRumEnabled()) {return;}
        let nvr = NvRequest()
        nvr._setReqCode(reqCode: NvRequest.REQCODE.USERACTION);
        let uad = UserActionData()
        
        uad._setSessionId(sessionId: NvApplication.getSessId());
        uad._setPageId(pageId: NvApplication.getPageId());
        let pInst = NvApplication.getpageInstance();
        uad._setPageInstance(pageInstance: pInst);
        uad._settimestamp(timestamp: NvTimer.current_timestamp());
        uad._setDuration(duration: 0);     // not relevant in case of api triggered user action loggin
        uad._setEvType(evType: UAEVENTTYPE.UAEVENTTYPE.APIUA);
        uad._setId(id: v.tag);  // send the string id and not the int id generated by android
        var elemName : String;
        var elemType : String;
        (elemName, elemType) = getElemInfo(v: v);
        uad._setElemName(elemName: elemName);
        uad._setElemType(elemType: elemType);
        uad._setPreValue( preValue: String (NvApplication.getSnapShotInstance()) );
        uad._setElemSubType(elemSubType: "");
        uad._setValue(value: elemName);
        //Put View position.
        uad._setXpos(xpos: Int( v.bounds.origin.x));  // Do we need to normalize the coordinate to certain x axis value
        uad._setYpos(ypos: Int(v.bounds.origin.y));
        uad._setWidth(width: Int(v.bounds.size.width));
        uad._setHeight(height: Int(v.bounds.size.height));
        let top = Int(v.bounds.origin.y);
        let left = Int(v.bounds.origin.x);
        uad._setTop(top: top);
        uad._setLeft(left: left);
        
        //_set the value.
        uad._setValue( value: actionName + ":" + actionData);
        nvr._setReqData(reqData: uad);
        NvCapture.getActivityMonitor().addRequest(nvr: nvr);  // send the request to background service thru server api
    }
    
    private func logTouchEvent(act: UIViewController , uet :UAEVENTTYPE.UAEVENTTYPE, ev: CGPoint , v: UIView ){
//        print("at.. logTouchEvent")
        let nvr = NvRequest();
        nvr._setReqCode(reqCode: NvRequest.REQCODE.USERACTION);
        let uad = UserActionData();
        // now fill up uad for the touchevent
        uad._setSessionId(sessionId: NvApplication.getSessId());
        uad._setPageId(pageId: NvApplication.getPageId());
        let pInst = NvApplication.getpageInstance();
        uad._setPageInstance(pageInstance: pInst);
        if( uet == UAEVENTTYPE.UAEVENTTYPE.LONGPRESS || uet == UAEVENTTYPE.UAEVENTTYPE.CLICK || uet == .TOUCHEND){
            let root = NvUtils.getRootView(view: act.view);
            NvPageDump.savePageDump(view: root, Name: "useraction", force: true);
            NSLog("[NetVision][NvUserAction] capturing page dump because of click");
            uad._setPreValue( preValue: String (NvApplication.getSnapShotInstance()) );
        }
        
        uad._settimestamp(timestamp: NvTimer.current_timestamp()); //timestamp declaration
        uad._setDuration(duration: 0);     // not relevant in case of touchevent
        uad._setEvType(evType: uet);
        uad._setId(id: v.tag);  // send the string id and not the int id generated by android
        var elemName : String;
        var elemType : String;
        (elemName, elemType) = getElemInfo(v: v);
        uad._setElemName(elemName: elemName);
        uad._setElemType(elemType: elemType);
        uad._setValue(value: elemName);
        uad._setElemSubType(elemSubType: "NA");
        let cgpnt = ev;
        let X = Int(cgpnt.x)
        let Y = Int(cgpnt.y)
        
        let position = v.convert(v.bounds.origin, to: nil)
        uad._setWidth(width: Int(v.bounds.size.width));
        uad._setHeight(height: Int(v.bounds.size.height));
        let offsetx = (uad.getWidth()/2)
        let offsety = (uad.getHeight()/2)
        let top = Int(position.y)
        let left = Int(position.x)
        
        uad._setTop(top: top);
        uad._setLeft(left: left);
        uad._setXpos(xpos: left);  // Do we need to normalize the coordinate to certain x axis value
        uad._setYpos(ypos: top);
        print("Debug data : ")
        print(uad.toJSON())
        nvr._setReqData(reqData: uad);
        NvCapture.getActivityMonitor().addRequest(nvr: nvr);  // send the request to background service thru server api
    }
    
    public static func logCustomMetric( cm :CustomMetric, value :String)
    {
        let nvr = NvRequest();
        nvr._setReqCode(reqCode: NvRequest.REQCODE.APIEVENT);
        let ereq = EventRequest() ;
        
        Crash()
        
        //#NOTE : CRASHDONE
        var a : Int? = nil;
        var b = a!
        
        ereq._setSessionId(sessionId: NvApplication.getSessId());
        
        ereq._setPageId(pageId: NvApplication.getPageId());
        let pInst = NvApplication.getpageInstance();
        ereq._setPageInstance(pageInstance: pInst);
        ereq._settimestamp(timestamp: NvTimer.current_timestamp());
        ereq._setEvName(String: "customMetrics");
       
        var modValue : String = String(cm.getViewId());
        //value will be decided on basis of it's type.
        if cm.getType() == "number" {
            modValue += value + "|0.0||";            // cmID
        }
            
        else if(cm.getType() == "double")
        {
            modValue += "|0|" + String(value) + "||";            // cmID
        }
            
        else if(cm.getType() == "text" || cm.getType() == "string")
        {
            modValue += "|0|0.0|" + String (value) + "|";                       // cmID
        }
        else {
            modValue += "|0|0.0||" + String(value) ;           // cmID
        }
        
        var valueMap = [String : String]();
        valueMap["customMetrics"] =  modValue;
        ereq._setProp(prop: valueMap);
        nvr._setReqData(reqData: ereq);
        NvCapture.getActivityMonitor().addRequest(nvr: nvr);
    }
    
    /**
     *
     * @param v: View object for which information is to be returned
     * @return: view info as String array index 0:view name which vary according to view for ex: button text, index 1; element type
     */

    private func getElemInfo(v: UIView) -> (String,String) {
        var ret : String? = "";
        var ret2 : String = "";
        ////NSLog("[NetVision] finding info");
        if (v is UIButton){
            
            ret = (v as! UIButton).title(for: []);
            var get = (v as! UIButton).titleLabel;
            var ge = (v as! UIButton).tag;
            var g = (v as! UIButton).titleColor(for: []);
            ret2 = "Button";
        }
        else if (v is UIImageView ){
            ret = "";
            ret2 = "Image";
        }
        else if (v is UISwitch){
            ret = (v as! UISwitch).description;
            ret2 = "ToggleButton";
        }
        else if (v is UITextField){
            ret = (v as! UITextField).description
            ret2 = "Text";
        }
        else if (v is UITextView){
            ret = (v as! UITextView).description
            ret2 = "Text";
        }
        else if (v is UISegmentedControl ){
            ret = (v as! UISegmentedControl).description;
            ret2 = "RadioButton";
        }
        else if (v is UILabel){
            ret = (v as! UILabel).text
            ret2 = "Label";
        }
            
        else {
            ret2 = "--"
            ret = "-"
            
        }
        if(ret == nil){
            ret = " ";
        }
        return (ret!,ret2);
    }
}
