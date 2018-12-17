//
//  ChartViewController.swift
//  fridge-qr
//
//  Created by Vicente Cantu Garcia on 12/15/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import Foundation
import Charts

class ChartViewController: UIViewController {
    
    var barChartView: BarChartView?
    
    struct Grafica {
        var x: Double
        var y: Double
        var label: String
        var color: UIColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        barChartView?.clear()
    }
    
    
    func getData() {
        var datas: [Grafica]? = []
        var maxValue = 0
        ProductJSON.getProducts(onResponse: { (response) in
            for index in 0 ..< response.count {
                response[index].quantity > maxValue ? maxValue = response[index].quantity : nil
                datas?.append(Grafica(x: Double(index + 1), y: Double(response[index].quantity), label: response[index].name, color: UIColor.random()))
            }
            self.createBarChart(datas: datas, maxValue: maxValue)
            
        }, onError: { (error) in
            print(Utils.dataToString(error!))
        }, notConnection: { (_) in
            print("ERROR")
        })
    }
    
    // MARK: - BarChartConfiguration
    private func createBarChart(datas: [Grafica]?, maxValue: Int) {
        guard let charts = datas, charts.count > 0 else {
            return
        }
        var dataEntries: [BarChartDataEntry] = []
        var data: BarChartData!
        var dataSetArray: [BarChartDataSet] = []
        
        barChartView = BarChartView()
        barChartView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barChartView!)
        NSLayoutConstraint.activate([(barChartView?.widthAnchor.constraint(equalToConstant: view.frame.width))!,
                                     (barChartView?.heightAnchor.constraint(equalToConstant: view.frame.height))!,
                                     (barChartView?.topAnchor.constraint(equalTo: view.topAnchor))!,
                                     (barChartView?.trailingAnchor.constraint(equalTo: view.trailingAnchor))!,
                                     (barChartView?.bottomAnchor.constraint(equalTo: view.bottomAnchor))!,
                                     (barChartView?.leadingAnchor.constraint(equalTo: view.leadingAnchor))!])
        
        for data in charts {
            let grafica = BarChartDataEntry(x: data.x, y: data.y)
            dataEntries.append(grafica)
        }
        
        for i in 0 ..< charts.count {
            let dataSet = BarChartDataSet(values: [dataEntries[i]], label: charts[i].label)
            dataSet.setColor(charts[i].color)
            dataSetArray.append(dataSet)
            data = BarChartData(dataSets: dataSetArray)
        }
        
        barChartView?.data = data
        
        // Descripcion de la grafica
        barChartView?.chartDescription = nil
        // Si la grafica no tiene datos que presentar aparece el siguiente string
        barChartView?.noDataText = ""
        // Aparece el color de fondo de la vista
        barChartView?.drawGridBackgroundEnabled = false
        
        // NO FUNCIONAN
        // Color de la cuadricula
        barChartView?.gridBackgroundColor = UIColor.clear
        barChartView?.borderColor = #colorLiteral(red: 0.9060000181, green: 0.2980000079, blue: 0.2349999994, alpha: 1)
        barChartView?.borderLineWidth = 5
        
        // Desactiva/activa el zoom en 'x' y 'y'
        barChartView?.pinchZoomEnabled = true
        // Desactiva/activa el scroll
        barChartView?.dragEnabled = true
        // Desactiva/activa el zoom
        barChartView?.setScaleEnabled(false)
        //        barChartView.isUserInteractionEnabled = false
        
        // Inserta el valor adentro/arriba de la grafica
        barChartView?.drawValueAboveBarEnabled = true
        // Esconde el valor de la grafica si es mayor a n
        barChartView?.maxVisibleCount = 3
        
        barChartView?.xAxis.drawGridLinesEnabled = false
        barChartView?.leftAxis.drawGridLinesEnabled = false
        
        // CONFIG: Labels en 'x'
        barChartView?.xAxis.labelPosition = .bottom
        barChartView?.xAxis.labelFont = .systemFont(ofSize: 11, weight: .medium)
        // Valor minimo entre las graficas
        barChartView?.xAxis.granularity = 1
        // Numero de labels que puede tener en 'x'
        barChartView?.xAxis.labelCount = 5
        
        // CONFIG: Labels en 'y' izquierda
        barChartView?.leftAxis.labelFont = .systemFont(ofSize: 11, weight: .medium)
        barChartView?.leftAxis.labelCount = 4
        barChartView?.leftAxis.labelPosition = .outsideChart
        //        barChartView.leftAxis.spaceTop = 3
        //        barChartView.leftAxis.spaceBottom = 1
        // Valor maximo de la tabla en 'y'
        barChartView?.leftAxis.axisMaximum = Double(maxValue)
        // Valor minimo de la tabla en 'y'
        barChartView?.leftAxis.axisMinimum = 0
        
        // CONFIG: Labels en 'y' derecha
        barChartView?.rightAxis.enabled = false
        
        // CONFIG: Leyenda Grafica
        barChartView?.legend.horizontalAlignment = .center
        barChartView?.legend.verticalAlignment = .bottom
        barChartView?.legend.orientation = .horizontal
        barChartView?.legend.drawInside = false
        barChartView?.legend.form = .circle
        barChartView?.legend.formSize = 10
        //        barChartView.legend.font = .systemFont(ofSize: 13, weight: .medium)
        //        barChartView.legend.xEntrySpace = 20
        
        barChartView?.animate(yAxisDuration: 1, easingOption: ChartEasingOption.easeInBack)
    }
    
}
