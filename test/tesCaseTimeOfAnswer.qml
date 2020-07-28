/// сюда просьба не смотреть пока, это в зачаточном состоянии

import QtQuick 2.0
import QtTest 1.12
TestCase {
    id: top
    name: "CreateBenchmark"

    function benchmark_create_component() {
        var component = Qt.createComponent("item.qml")
        var obj = component.createObject(top)
        obj.destroy()
        component.destroy()
    }
}

//RESULT : CreateBenchmark::benchmark_create_component:
//     0.23 msecs per iteration (total: 60, iterations: 256)
//PASS   : CreateBenchmark::benchmark_create_component()
