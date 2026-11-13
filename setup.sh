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
        minSdk = 26
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
        android:icon="@mipmap/ic_launcher"
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

mkdir -p app/src/main/res/drawable app/src/main/res/values app/src/main/res/mipmap-anydpi-v26

cat > app/src/main/res/values/ic_colors.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_bg">#0F766E</color>
</resources>
EOF

if [ -f icon.png ]; then
  cp icon.png app/src/main/res/drawable/ic_fg.png
else
cat > app/src/main/res/drawable/ic_fg.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp" android:height="108dp"
    android:viewportWidth="108" android:viewportHeight="108">
    <path android:fillColor="#99F6E4"
        android:pathData="M32,34 h36 a4,4 0 0 1 4,4 v4 h-44 v-4 a4,4 0 0 1 4,-4 z"/>
    <path android:fillColor="#FFFFFF"
        android:pathData="M32,40 h44 a4,4 0 0 1 4,4 v26 a4,4 0 0 1 -4,4 h-44 a4,4 0 0 1 -4,-4 v-26 a4,4 0 0 1 4,-4 z"/>
    <path android:fillColor="#0F766E"
        android:pathData="M66,57 a4,4 0 1 0 8,0 a4,4 0 1 0 -8,0 z"/>
</vector>
EOF
fi

cat > app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_bg"/>
    <foreground android:drawable="@drawable/ic_fg"/>
</adaptive-icon>
EOF
