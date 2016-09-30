//
//  AVAssetImageGeneratorTimePoints.swift
//  GifMaker_ObjC
//
//  Created by Hamid Belahrach on 3/1/16.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import AVFoundation

public extension AVAssetImageGenerator {
    public func generateCGImagesAsynchronouslyForTimePoints(timePoints: [TimePoint], completionHandler: AVAssetImageGeneratorCompletionHandler) {
        let times = timePoints.map {timePoint in
            return NSValue(CMTime: timePoint)
        }
        self.generateCGImagesAsynchronouslyForTimes(times, completionHandler: completionHandler)
    }
}
