package apc.fgo.flutter_fgo_items

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import java.io.File

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        transparentToWhite()
    }

    private fun transparentToWhite() {
        val options = BitmapFactory.Options().apply { inMutable = true }
        var bitmap = BitmapFactory.decodeResource(resources, R.mipmap.ic_launcher, options)
        for (y in 0 until bitmap.height) {
            for (x in 0 until bitmap.width) {
                val pixel = bitmap.getPixel(x, y)
                if (pixel == 0) bitmap.setPixel(x, y, Color.WHITE)
            }
        }
        bitmap = Bitmap.createScaledBitmap(bitmap, 120, 120, true)
        File(cacheDir, "Icon-App-60x60@2x.png").outputStream().use { bitmap.compress(Bitmap.CompressFormat.PNG, 0, it) }
    }
}