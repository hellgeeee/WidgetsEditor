.import 'colours.js' as Pallete

var Application = {
    'background' : Pallete.blue['700'],
    'foreground' : Pallete.grey['50'],
    'borderColor' : Pallete.grey['500'],
    'shadow' : Pallete.grey['700'],
    'textColor' : Pallete.grey['100'],
    'highlitedTextColor' : Pallete.blue[600],
    'textSize' : 14,
    'radius': 5,
    'borderWidth':2,
    'font': 'Roboto-Regular.ttf'
}


var Button = {
    'textColor' : Pallete.grey['800'],
    'background' : Pallete.grey['300'],
    'foreground' : Pallete.blue['700'],
    'borderColor' : Pallete.grey['400'],
    'borderWidth' : 2,
    'radius' : 4,
    'textSize' : 14,
    'hover' : Pallete.blue['200']
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
    'height' : 120
}

var Bulges = {
    'deepIn' : 20,
    'slightIn' : 15,
    'almostSame' : 5,
    'slightOut' : -8,
    'lushOut' : -50,
    'deepInColor' : Pallete.grey['50'],// это неверно и вызывает в qml предупреждения, но я просто не знаю, как будет белый
    'slightOutColor' : Pallete.yellow['50'],
    'strongOutColor' : Pallete.yellow['100']
}

var Shadow = {
    "samples" : 20,
    "deepColor" : Pallete.grey["900"],
    "slightColor" : Pallete.grey['700'],
    "slightRadius" : "6",
    "smallRadius" : "8",
    "mediumRadius" : "10",
    "fluffyRadius" : "16"
}

var Animation = {
    "fading" : 1000,
    "slowDuration" : 400,
    "mediumDuration" : 300
}

var MainMenu = {
    "width" : 40,
    "widthUnfolded" : 500,
    "color" : Pallete.grey['700'],
    "negativeSpace" : 8
}
