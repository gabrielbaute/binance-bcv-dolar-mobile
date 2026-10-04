# Reglas básicas para Flutter y R8

# Evita errores de R8 por clases faltantes de Play Store Deferred Components en Flutter
-dontwarn com.google.android.play.core.**

# Reglas básicas de preservación de Flutter Engine
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Mantener atributos de depuración y anotaciones esenciales
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
