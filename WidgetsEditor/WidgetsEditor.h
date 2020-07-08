#ifndef WIDGETSEDITOR_H
#define WIDGETSEDITOR_H

#include <QObject>
#include <QVariant>


class CategoryParameter : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged )

public:
    CategoryParameter( const QString& name = "", QObject* parent = nullptr) : QObject(parent) {
        _name = name;
    }
    QString name() { return _name; }
    void setName(const QString& name) { _name = name; }
private:
    QString _name;
signals:
    void nameChanged();
};


class FacilityCategory : public QObject{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged )
    Q_PROPERTY(QVariant attributes READ attributes/* WRITE setAttributes */ NOTIFY attributesChanged)

public:
    FacilityCategory( const QString& name = "", QObject* parent = nullptr);
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
#endif // WIDGETSEDITOR_H
