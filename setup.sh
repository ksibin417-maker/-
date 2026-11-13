#!/bin/bash
set -e
mkdir -p app/src/main/assets app/src/main/java/com/example/expensetracker
cp index.html app/src/main/assets/index.html

cat > settings.gradle.kts <<'EOF'
pluginManagement { repositories { google(); mavenCentral(); gradlePluginPortal() } }
dependencyResolutionManagement { repositories { google(); mavenCentral() } }
rootProject.name = "ExpenseTracker"
include(":app")
EOF

cat > build.gradle.kts <<'EOF'
plugins { id("com.android.application") version "8.5.2" apply false }
EOF

cat > gradle.properties <<'EOF'
org.gradle.jvmargs=-Xmx2g
android.useAndroidX=true
EOF

cat > app/build.gradle.kts <<'EOF'
plugins { id("com.android.application") }
android {
    namespace = "com.example.expensetracker"
    compileSdk = 34
    defaultConfig {
        applicationId = "com.example.expensetracker"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}
EOF

cat > app/src/main/AndroidManifest.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="ചെലവ് ട്രാക്കർ"
        android:theme="@android:style/Theme.DeviceDefault.NoActionBar">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

cat > app/src/main/java/com/example/expensetracker/MainActivity.java <<'EOF'
package com.example.expensetracker;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
    private WebView web;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        web = new WebView(this);
        WebSettings s = web.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        web.setWebViewClient(new WebViewClient());
        setContentView(web);
        web.loadUrl("file:///android_asset/index.html");
    }

    @Override
    public void onBackPressed() {
        if (web.canGoBack()) web.goBack(); else super.onBackPressed();
    }
}
EOF
