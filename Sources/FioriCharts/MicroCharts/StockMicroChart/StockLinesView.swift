//
//  StockLinesView.swift
//  Micro Charts
//
//  Created by Xu, Sheng on 1/9/20.
//  Copyright © 2020 sstadelman. All rights reserved.
//

import SwiftUI

struct StockLinesView: View {
    @EnvironmentObject var model: ChartModel

    var rect: CGRect
    var startPos: Int = 0
    var scale: CGFloat = 1.0
    
    var body: some View {
        var noData = false
        var width = rect.size.width
        let height = rect.size.height
        let startPosInFloat = CGFloat(startPos)
        
        let unitWidth: CGFloat = width * scale / CGFloat(StockUtility.numOfDataItmes(model) - 1)
        let startIndex = Int(startPosInFloat / unitWidth)
        
        var endIndex = Int(((startPosInFloat + width) / unitWidth).rounded(.up))
        let startOffset: CGFloat = -startPosInFloat.truncatingRemainder(dividingBy: unitWidth)
        
        var endOffset: CGFloat = (CGFloat(endIndex) * unitWidth - startPosInFloat - width).truncatingRemainder(dividingBy: unitWidth)
    
        if endIndex > StockUtility.lastValidDimIndex(model) {
            endIndex = StockUtility.lastValidDimIndex(model)
        }

        if startIndex > endIndex {
            noData = true
        }
        if StockUtility.isIntraDay(model) {
            let count = StockUtility.lastValidDimIndex(model)
            
            width =  min(CGFloat(count) * unitWidth - startPosInFloat, rect.size.width)
            endOffset = (CGFloat(endIndex) * unitWidth - startPosInFloat - width).truncatingRemainder(dividingBy: unitWidth)
        }
        
        let range = model.ranges?[model.currentSeriesIndex] ?? 0...1
        var data: [Double] = []
        if !noData {
            let curDisplayData = model.data[model.currentSeriesIndex][startIndex...endIndex]
            data = curDisplayData.map { $0.first ?? 0 }
            
        }
        
        return ZStack {
            Color(#colorLiteral(red: 0.9999071956, green: 1, blue: 0.999881804, alpha: 1)).frame(width: rect.size.width, height: height)
            
            if !noData {
                ZStack {
                    HStack(spacing: 0) {
                        LinesShape(points: data, displayRange: range, fill: true, startOffset: startOffset, endOffset: endOffset)
                            .fill(LinearGradient(gradient:
                                Gradient(colors: [Color(#colorLiteral(red: 0.4957013249, green: 0.9818227649, blue: 0.6320676684, alpha: 1)), Color(#colorLiteral(red: 0.9872599244, green: 0.992430985, blue: 0.9878047109, alpha: 1))]),
                                                 startPoint: .top,
                                                 endPoint: .bottom))
                            .frame(width: width, height: height)
                            .clipped()
                        Spacer(minLength: 0)
                    }.frame(width: rect.size.width, height: height)
                    
                    HStack(spacing: 0) {
                        LinesShape(points: data, displayRange: range,startOffset: startOffset, endOffset: endOffset)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.green)
                            .frame(width: width, height: height)
                            .clipped()
                        Spacer(minLength: 0)
                    }.frame(width: rect.size.width, height: height)
                }
            }
        }
    }
}

struct StockLinesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        //ForEach(Tests.stockModels) {
            //StockLinesView(rect: CGRect(x: 0, y: 0, width: 300, height: 200), startOffset: -10, endOffset: 90).environmentObject(StockUtility.preprocessModel($0))
            StockLinesView(rect: CGRect(x: 0, y: 0, width: 358, height: 200), startPos: 168, scale: 1.89).environmentObject(StockUtility.preprocessModel(Tests.stockModels[1]))
            
            StockLinesView(rect: CGRect(x: 0, y: 0, width: 358, height: 200), startPos: 20, scale: 2.0).environmentObject(StockUtility.preprocessModel(Tests.stockModels[1]))
        }
        .frame(width:300, height: 200)
        .previewLayout(.sizeThatFits)
    }
}
