/*
Copyright 2015 Esri.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#include <QDebug>
#include <QSettings>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QCommandLineParser>
#include <QDir>

#ifdef Q_OS_WIN
#include <Windows.h>
#endif

#include "AppInfo.h"

//------------------------------------------------------------------------------

#define kSettingsFormat                 QSettings::IniFormat

//------------------------------------------------------------------------------

#define kArgShowName                    "show"
#define kArgShowValueName               "showOption"
#define kArgShowDescription             "Show option maximized | minimized | fullscreen | normal | default"
#define kArgShowDefault                 "show"

#define kShowMaximized                  "maximized"
#define kShowMinimized                  "minimized"
#define kShowFullScreen                 "fullscreen"
#define kShowNormal                     "normal"

//------------------------------------------------------------------------------

int main(int argc, char *argv[])
{
    qDebug() << "Initializing application";

    QGuiApplication app(argc, argv);

    QCoreApplication::setApplicationName(kApplicationName);
    QCoreApplication::setApplicationVersion(kApplicationVersion);
    QCoreApplication::setOrganizationName(kOrganizationName);
#ifdef Q_OS_MAC
    QCoreApplication::setOrganizationDomain(kOrganizationName);
#else
    QCoreApplication::setOrganizationDomain(kOrganizationDomain);
#endif
    QSettings::setDefaultFormat(kSettingsFormat);

#ifdef Q_OS_WIN
    // Force usage of OpenGL ES through ANGLE on Windows
    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);
#endif

    // Initialize license

#ifdef kClientId
    QCoreApplication::instance()->setProperty("ArcGIS.Runtime.clientId", kClientId);
#ifdef kLicense
    QCoreApplication::instance()->setProperty("ArcGIS.Runtime.license", kLicense);
#endif
#endif

    // Intialize application window

    QQmlApplicationEngine appEngine;
    appEngine.addImportPath(QDir(QCoreApplication::applicationDirPath()).filePath("qml"));
    appEngine.load(QUrl(kApplicationSourceUrl));

    auto topLevelObject = appEngine.rootObjects().value(0);
    qDebug() << Q_FUNC_INFO << topLevelObject;

    auto window = qobject_cast<QQuickWindow *>(topLevelObject);
    if (!window)
    {
        qCritical("Error: Your root item has to be a Window.");

        return -1;
    }

#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    // Process command line

    QCommandLineOption showOption(kArgShowName, kArgShowDescription, kArgShowValueName, kArgShowDefault);

    QCommandLineParser commandLineParser;

    commandLineParser.setApplicationDescription(kApplicationDescription);
    commandLineParser.addOption(showOption);
    commandLineParser.addHelpOption();
    commandLineParser.addVersionOption();
    commandLineParser.process(app);

    // Show app window

    auto showValue = commandLineParser.value(kArgShowName).toLower();

    if (showValue.compare(kShowMaximized) == 0)
    {
        window->showMaximized();
    }
    else if (showValue.compare(kShowMinimized) == 0)
    {
        window->showMinimized();
    }
    else if (showValue.compare(kShowFullScreen) == 0)
    {
        window->showFullScreen();
    }
    else if (showValue.compare(kShowNormal) == 0)
    {
        window->showNormal();
    }
    else
    {
        window->show();
    }

#else
    window->show();
#endif

    return app.exec();
}

//------------------------------------------------------------------------------

