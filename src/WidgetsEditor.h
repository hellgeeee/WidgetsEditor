#ifndef WIDGETSEDITOR_H
#define WIDGETSEDITOR_H

#include <QObject>
#include <QVariant>

#include<QDebug>

class CategoryParameter : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)

public:
    CategoryParameter( const QString& name = "", QObject* parent = nullptr) : QObject(parent) {
        _name = name;
    }
    QString name() { return _name; }
    QString image() { return _image; }
    void setName(const QString& name) { _name = name; }
    void setImage(const QString& image) { _image = image; }
private:
    QString _name{""};
    QString _image{""};
signals:
    void nameChanged();
    void imageChanged();
};

class DeviceCategory : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged )
    Q_PROPERTY(QVariant attributes READ attributes/* WRITE setAttributes */ NOTIFY attributesChanged)

public:
    DeviceCategory( const QString& name = "", QObject* parent = nullptr);
    QString name() { return _name; }
    void setName(const QString& name) { _name = name; }
    QVariant attributes() { return QVariant::fromValue(_parameters); }
    void addParameter(const QString& name) { _parameters.append(new CategoryParameter(name, this)); }
//    void setAttributes(const QVariant& attributes) { /*_attributes = attributes.toList();*/ }
private:
    QString _name;
    QList<QObject*> _parameters;
signals:
    void nameChanged();
    void attributesChanged();
};

class WidgetsEditorManager : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString inFileName READ inFileName WRITE setInFileName NOTIFY inFileChanged)
    Q_PROPERTY(QString outFileName READ outFileName WRITE setOutFileName NOTIFY outFileChanged)
    Q_PROPERTY(QString widgetsExistFileName READ widgetsExistFileName WRITE setWidgetsExistFileName NOTIFY widgetsExistFileNameChanged)
    Q_PROPERTY(QVariant categories READ categories NOTIFY categoriesChanged)
    Q_PROPERTY(QString outFileContent WRITE setOutFileContent NOTIFY outFileContentChanged)

public:
    WidgetsEditorManager(QObject* parent = nullptr) : QObject(parent) {}

    QString inFileName(){ return _inFileName; }

    void setInFileName(const QString& val){
        _inFileName = val;
        _categories = parse();
    }

    QString outFileName(){ return _outFileName; }

    void setOutFileName(const QString& val){
        _outFileName = val;
    }

    QString widgetsExistFileName(){ return _widgetsExistFileName; }

    void setWidgetsExistFileName(const QString& val){
        _widgetsExistFileName = val;
        qDebug() << "setter in cpp" + val + "___" + _widgetsExistFileName;
    }

    QVariant categories(){ return QVariant::fromValue(_categories); }
    void setCategories(QList<QObject*>);
    void setOutFileContent(const QString&);

private:
    QList<QObject*> parse();
    QString _inFileName{ "" };
    QString _outFileName{ "" };
    QString _widgetsExistFileName{ "" };
    QList<QObject*> _categories;
    QString _outFileContent{ "" };
signals:
    void inFileChanged();
    void outFileChanged();
    void outFileContentChanged();
    void widgetsExistFileNameChanged();
    void categoriesChanged();
};
#endif // WIDGETSEDITOR_H
