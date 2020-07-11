#ifndef WIDGETSEDITOR_H
#define WIDGETSEDITOR_H

#include <QObject>
#include <QVariant>


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

class OutputAcceptor : public QObject{
    Q_OBJECT
public:
    struct FileForCategories{
        QString fileName;
        QList<QString> deviceCategories;
        QJsonObject* fileContent;
    };

    OutputAcceptor(QObject* parent = nullptr) : QObject(parent) {}
private:
    QList<FileForCategories> filesForCategories;
public slots:
    void onWidgetChanged(const QJsonObject&);
};
#endif // WIDGETSEDITOR_H
