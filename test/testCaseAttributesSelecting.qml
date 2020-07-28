import QtQuick 2.0
import QtTest 1.2

TestCase {
    name: "DataTests"

    function init_data() {
      return [
           {tag:"init_data_1", a:1, b:2, answer: 3},
           {tag:"init_data_2", a:2, b:4, answer: 6}
      ];
    }

    function test_table_data() {
        return [
            {tag: "2 + 2 = 4", a: 2, b: 2, answer: 4 },
            {tag: "2 + 6 = 8", a: 2, b: 6, answer: 8 },
        ]
    }

    function test_table(data) {
        //data comes from test_table_data
        compare(data.a + data.b, data.answer)
    }

    function test__default_table(data) {
        //data comes from init_data
        compare(data.a + data.b, data.answer)
    }
}
