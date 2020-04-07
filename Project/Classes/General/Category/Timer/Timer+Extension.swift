//
//  Timer+Extension.swift
//  LawChatForLawyer
//
//  Created by Juice on 2017/12/15.
//  Copyright © 2017年 就问律师. All rights reserved.
//

import Foundation

extension Timer {
    
    /// 在extension中创建timer
    /// 注意没有传target，而是直接写成self，self是当前extension
    class func lv_scheduledTimer (timeInterval: TimeInterval, repeats: Bool, completion:((_ timer:Timer)->())?) -> Timer {
        let timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(lv_completionLoop(timer:)),
                                         userInfo: completion, repeats: repeats);
        // scheduledTimer方法默认会以defaultRunLoopMode模式运行，这会导致scrollView滑动timer停止计时，所以在当前runloop中以commonModes重新加一次
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        return timer
    }
    
    @objc class func lv_completionLoop(timer:Timer) {
        guard let completion = timer.userInfo as? ((Timer) -> ()) else {
            return;
        }
        completion(timer);
    }
}
