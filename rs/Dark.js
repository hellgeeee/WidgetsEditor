.import 'colours.js' as Pallete

var Application = {
    'background' : Pallete.blueGrey['500'],
    'foreground' : Pallete.grey['200'],
    'borderColor' : Pallete.blueGrey['800'],
    'shadow' : Pallete.grey['600'],
    'textColor' : Pallete.blue['100'],
    'highlitedTextColor' : Pallete.blue[600],
    'textSize' : 14,
    'radius': 5,
    'borderWidth':2,
    'font': 'Roboto-Regular.ttf'
}

var Button = {
    'textColor' : Pallete.grey['700'],
    'background' : Pallete.blue['900'],
    'foreground' : Pallete.blue['200'],
    'borderColor' : Pallete.blueGrey['400'],
    'borderWidth' : 2,
    'radius' : 4,
    'textSize' : 12,
    'hover' : Pallete.blue['700'],
}

var Input = {
    'height' : 35,
    'textMargin' : 6,
    'textSize' : 18,
    'tipColor' : Pallete.grey['500'],
    'textColor' : Pallete.grey['900']
}

var List = {
    'stringHeight' : 32,
    'stringColor' : Pallete.grey['50'], // это неверно и вызывает в qml предупреждения, но я просто не знаю, как будет белый
    'stringColorAlternative' : Pallete.grey['100'],
    'textSize' : 16
}

var HorizontalList = {
    'height' : 140
}

var Bulges = {
    'deepIn' : 20,
    'slightIn' : 15,
    'almostSame' : 5,
    'slightOut' : -8,
    'lushOut' : -50,
    'deepInColor' : Pallete.grey['50'],// это неверно и вызывает в qml предупреждения, но я просто не знаю, как будет белый
    'slightOutColor' : Pallete.yellow['50']
}

var Shadow = {
    "samples" : 30,
    "deepColor" : Pallete.grey["900"],
    "slightColor" : Pallete.grey['700'],
    "slightRadius" : "6",
    "smallRadius" : "8",
    "mediumRadius" : "10",
    "lushRadius" : "10"
}

var Animation = {
    "slowDuration" : 400,
    "mediumDuration" : 300
}

var MainMenu = {
    "width" : 50
}
