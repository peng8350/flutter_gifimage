# flutter_gifimage

We can use gifs in Flutter but there is no way to manipulate them. If you are planning to:

* change its speed
* set the current frame of the gif
* animate to and from specific frames
* loop the gif frames in a specific range

This package solves these problems, it also helps you to contain gif cache, to avoid that the frame is loaded over and over again.

# Screenshots

![](arts/gif.gif)

# Usage(Simple)
To install the package add this to your `pubspec.yaml`:

   ```dart

        flutter_gifimage: ^1.0.0

   ```

 Simple example usage:

 ```dart
     GifController controller = GifController(vsync: this);


     GifImage(
          controller: controller,
          image: AssetImage("images/animate.gif"),
     )

 ```

 list the most common operate in GifController:


 ```dart
 // loop from 0 frame to 29 frame
 controller.repeat(min: 0, max: 29, period: Duration(milliseconds: 300));

 // jumpTo thrid frame(index from 0)
 controller.value = 0;

 // from current frame to 26 frame
 controller.animateTo(26);

 ```

 If you need to preCache gif, try this

 ```dart
 // put imageProvider
 fetchGif(AssetImage("images/animate.gif"));

 ```




# Thanks
* [gif_ani](https://github.com/hyz1992/gif_ani)  (thanks for giving me the idea)

# License

```
MIT License

Copyright (c) 2019 Jpeng

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```