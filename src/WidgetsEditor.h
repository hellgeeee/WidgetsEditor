#pragma once

#include <QObject>
#include <QVariant>
#include <QDir>
#include <QJsonObject>

#include<QDebug>

class CategoryParameter : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int indexCur READ indexCur WRITE setIndexCur NOTIFY indexCurChanged)
    Q_PROPERTY(QString signatureCur READ signatureCur WRITE setSignatureCur NOTIFY signatureCurChanged)
    Q_PROPERTY(bool upperBoundCur READ upperBoundCur WRITE setUpperBoundCur NOTIFY upperBoundCurChanged)
    Q_PROPERTY(bool lowerBoundCur READ lowerBoundCur WRITE setLowerBoundCur NOTIFY lowerBoundCurChanged)
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

    bool upperBoundCur() { return _upperBoundCur; }
    void setUpperBoundCur(const bool& upperBoundCur) { _upperBoundCur = upperBoundCur; }

    bool lowerBoundCur() { return _lowerBoundCur; }
    void setLowerBoundCur(const bool& lowerBoundCur) { _lowerBoundCur = lowerBoundCur; }

    QString imageCur() { return _imageCur; }
    void setImageCur(const QString& image) { _imageCur = image; }

private:
    QString _name{""};
    int _indexCur{-1};
    QString _signatureCur{"undefined"};
    bool _upperBoundCur{false};
    bool _lowerBoundCur{false};
    QString _imageCur{""};

signals:
    void nameChanged();
    void indexCurChanged();
    void signatureCurChanged();
    void upperBoundCurChanged();
    void lowerBoundCurChanged();
    void imageCurChanged();
};

class DeviceCategory : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged )
    Q_PROPERTY(QString image READ image NOTIFY imageChanged )
    Q_PROPERTY(QVariant parameters READ parameters NOTIFY attributesChanged)

public:
    DeviceCategory( const QString& name = "", const QString& image = "", QObject* parent = nullptr);

    QString name() { return _name; }
    void setName(const QString& name) { _name = name; }

    QString image() { return _image; }
    void setImage(const QString& image) { _image = image; }

    QVariant parameters() { return QVariant::fromValue(_parameters); }
    void addParameter(const QString& name) { _parameters.append(new CategoryParameter(name, this)); }

private:
    QString _name;
    QString _image;
    QList<QObject*> _parameters;

signals:
    void nameChanged();
    void imageChanged();
    void attributesChanged();
};

class WidgetsEditorManager : public QObject{
    Q_OBJECT

    Q_PROPERTY(QVariant categories READ categories NOTIFY categoriesChanged)
    Q_PROPERTY(QString outFileContent READ outFileContent WRITE setOutFileContent NOTIFY outFileContentChanged)
    Q_PROPERTY(QString IPEFolder READ IPEFolder WRITE setIPEFolder NOTIFY IPEFolderChanged)
    Q_PROPERTY(QString inFileName READ inFileName WRITE setInFileName NOTIFY inFileChanged)
    Q_PROPERTY(QString outFileName READ outFileName WRITE setOutFileName NOTIFY outFileChanged)
    Q_PROPERTY(QString selectedCategories WRITE setSelectedCategories NOTIFY selectedCategoriesChanged)
    //Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)

public:
    WidgetsEditorManager(QObject* parent = nullptr) : QObject(parent) {}

    QString inFileName(){ return _inFileName; }
    void setInFileName(const QString& val);

    QString outFileName(){ return _outFileName; }
    void setOutFileName(const QString&);

    QString IPEFolder(){return _IPEFolder;}
    void setIPEFolder(const QString& val){
        QDir exeDir(val);
        exeDir.cd("../../");
        _IPEFolder = exeDir.path();
    }

    QVariant categories(){ return QVariant::fromValue(_categories); }
    void setCategories(QList<QObject*> val){ _categories = val; }

    QString outFileContent(){return _outFileContent;}
    void setOutFileContent(const QString&);
    void setSelectedCategories(const QString&);



private:
    QList<QObject*> parse();
    QString _inFileName{""};
    QString _outFileName{ "" };
    QList<QObject*> _categories;
    QString _outFileContent{ "" };
    QString _IPEFolder{ "" };
    QJsonObject _existingWidgetsJsn;
signals:
    void inFileChanged();
    void outFileChanged();
    void outFileContentChanged();
    void widgetsExistFileNameChanged();
    void categoriesChanged();
    void curDirChanged();
    void IPEFolderChanged();
    void selectedCategoriesChanged();
};
