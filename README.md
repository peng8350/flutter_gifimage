# flutter_gifimage

We should know that in order to achieve Gif in flutter, we can use Image, but we have no way to manipulate Gif, for example: change its speed, control it has been playing in a frame,
 in which frame range loop. These problems can be solved by this widget,it also help you contain gif cache,avoid load frame every time.

# Usage(Simple)

 ```dart
     controller4= GifController(vsync: this);


     GifImage(
          controller: controller,
          image: MemoryImage(base64Decode(base64_url)),
     )

 ```
 GifController is just a AnimationController, usage is the same with AnimationController,If you want to play animate Between two frames ,you just called 'repeat(min: max:)','period' can change the repeat speed
 ,If you want to stop in one frame ,  call 'controller.value = .. '

# Thanks
* [gif_ani](https://github.com/hyz1992/gif_ani)  (thanks for giving me idea)

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