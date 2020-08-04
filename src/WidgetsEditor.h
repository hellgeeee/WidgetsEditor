#ifndef WIDGETSEDITOR_H
#define WIDGETSEDITOR_H

#include <QObject>
#include <QVariant>
#include <QDir>

#include<QDebug>

class CategoryParameter : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int indexCur READ indexCur WRITE setIndexCur NOTIFY indexCurChanged)
    Q_PROPERTY(QString signatureCur READ signatureCur WRITE setSignatureCur NOTIFY signatureCurChanged)
    Q_PROPERTY(bool upperBoundaryCur READ upperBoundaryCur WRITE setUpperBoundaryCur NOTIFY upperBoundaryCurChanged)
    Q_PROPERTY(bool lowerBoundaryCur READ lowerBoundaryCur WRITE setLowerBoundaryCur NOTIFY lowerBoundaryCurChanged)
    Q_PROPERTY(QString imageCur READ imageCur WRITE setImageCur NOTIFY imageCurChanged)

public:
    CategoryParameter( const QString& name = "", QObject* parent = nullptr) : QObject(parent) {
        _name = name;
    }
    QString name() { return _name; }
    void setName(const QString& name) { _name = name; }
    int indexCur() { return _indexCur; }
    void setIndexCur(const int& indexCur) { _indexCur = indexCur; }
    QString signatureCur() { return _signatureCur; }
    void setSignatureCur(const QString& signatureCur) { _signatureCur = signatureCur; }
    bool upperBoundaryCur() { return _upperBoundaryCur; }
    void setUpperBoundaryCur(const bool& upperBoundaryCur) { _upperBoundaryCur = upperBoundaryCur; }
    bool lowerBoundaryCur() { return _upperBoundaryCur; }
    void setLowerBoundaryCur(const bool& lowerBoundaryCur) { _lowerBoundaryCur = lowerBoundaryCur; }
    QString imageCur() { return _imageCur; }
    void setImageCur(const QString& image) { _imageCur = image; }
private:
    QString _name{""};
    int _indexCur{-1};
    QString _signatureCur{"undefined"};
    bool _upperBoundaryCur{false};
    bool _lowerBoundaryCur{false};
    QString _imageCur{""};
signals:
    void nameChanged();
    void indexCurChanged();
    void signatureCurChanged();
    void upperBoundaryCurChanged();
    void lowerBoundaryCurChanged();
    void imageCurChanged();
};

class DeviceCategory : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged )
    Q_PROPERTY(QVariant parameters READ parameters/* WRITE setAttributes */ NOTIFY attributesChanged)

public:
    DeviceCategory( const QString& name = "", QObject* parent = nullptr);
    QString name() { return _name; }
    void setName(const QString& name) { _name = name; }
    QVariant parameters() { return QVariant::fromValue(_parameters); }
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
    Q_PROPERTY(QString curDir READ curDir NOTIFY curDirChanged)

public:
    WidgetsEditorManager(QObject* parent = nullptr) : QObject(parent) {
        QDir curDir = QDir::current();
        curDir.cd("../doc/InOutFilesExample");
        _curDir = curDir.path();
    }

    QString inFileName(){ return _inFileName; }

    void setInFileName(const QString& val){
        _inFileName = val;
        _categories = parse();

        QDir curDir = QDir(_inFileName);
        curDir.cdUp();
        _curDir = curDir.path();
    }

    QString outFileName(){ return _outFileName; }

    void setOutFileName(const QString& val){
        _outFileName = val;
    }

    QString widgetsExistFileName(){ return _widgetsExistFileName; }

    void setWidgetsExistFileName(const QString& val){
        _widgetsExistFileName = val;
    }

    QString curDir(){return _curDir;}

    QVariant categories(){ return QVariant::fromValue(_categories); }
    void setCategories(QList<QObject*>);
    void setOutFileContent(const QString&);

private:
    QList<QObject*> parse();
    QString _inFileName{""};
    QString _outFileName{ "" };
    QString _widgetsExistFileName{ "" };
    QList<QObject*> _categories;
    QString _outFileContent{ "" };
    QString _curDir{ "" };
signals:
    void inFileChanged();
    void outFileChanged();
    void outFileContentChanged();
    void widgetsExistFileNameChanged();
    void categoriesChanged();
    void curDirChanged();
};
#endif // WIDGETSEDITOR_H
