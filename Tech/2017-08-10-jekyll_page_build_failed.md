---
title: ［solved］Page build failed(Jekyll)
layout: post
author: WenfengShi
category: 技术
tags: []
---
博客链接: [http://codeshold.me/2017/08/jekyll_page_build_failed.html](http://codeshold.me/2017/08/jekyll_page_build_failed.html)

> The page build failed for the `master` branch with the following error:
Page build failed. For more information, see https://help.github.com/articles/troubleshooting-github-pages-builds/.
For information on troubleshooting Jekyll see:
  https://help.github.com/articles/troubleshooting-jekyll-builds

## 问题
以上是自己向 GitHubPage push 代码之后收到的 build failed 信息（邮件全部内容）！  
自己很诧异，因为距离上次成功push && build后，我从未做过任何配置文件的修改（中间仅隔了几天），而且自己本地测试跑Jekyll, build也是成功的（`bundle exec jekyll serve`）并没有出现任何的报警和 failed 信息（本地重现不了）！
根据Github邮件中的链接，自己一个个都仔细看了，然并没有任何的帮助。于是自己给Github Staff发邮件希望能获取到更详细的错误信息，之后收到的回复如下：

> 
Here's the full error we're seeing:
[31m  Liquid Exception: 1 is not a symbol nor a string in sitemap.xml[0m
[31m             Fatal: TypeError[0m
[31m                    1 is not a symbol nor a string[0m
You can also find this by building your site locally with Jekyll:
https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/
Hope this helps!

上述信息当时也并没有给我什么具体的帮助，只是提到了自己的 sitemap.xml 文件中有语法类的错误，但是 `近一年我从未修改过 sitemap.xml 文件啊`! 尝试google，但也没有帮助。

好吧，反正第一步应该是在本地复现该错误，之后找到解决方法也方便！

## 解决

1. 本地不能重现GitHubPage上的错误，第一反应是 **Jekyll 版本可能和GitHubPage 服务器上的不一致**
    - 核实后发现本地的Jekyll的版本号是 3.4.3， 而[官方][1]的版本是 3.5.1，既然这样那就升级呗！
    - 但这里又有一个坑，升级之前最好先删除本地的`Gemfile.lock`文件，如果不删除的话`bundle update jekyll`不会升级到最新的3.5.1版本，其默认只升级到的Gemfile.lock文件中指定的最新版本，除非你在`Gemfile`强制写入了github-pages的版本信息，如`gem 'github-pages', '~> 148'`([参考链接][2]）再update! 当然，直接删除lock文件比较方便，此时Gemfile中只需要有`gem 'github-pages'`信息就行！具体原因如下
    > 第一次    运行 bundle install 时会自动生成 Gemfile.lock 。
    以后每次运行 bundle install 时,如果 Gemfile 中的条目不变 bundle 就不会再次计算 gem 依赖版本号，其会直接根据 Gemfile.lock 检查和安装 gem。若出现依赖冲突时可以通过 bundle update 更新 Gemfile.lock。所以如果想全部更新，直接删除lock文件再update就行，参考[stackoverflow][3]
    - 简单说，升级Jekyll的方式有两种：一种是删除Gemfile.lock文件后update；第二种是修改Genfile文件后update
    - 如下，Jekyll升级成功（顺带着自己也把bundle升级了）：
        ```bash
        RICHIEWFSHI-MB0:wenfengshi.github.io wenfeng$ bundle exec jekyll --version
        jekyll 3.4.3
        
        RICHIEWFSHI-MB0:wenfengshi.github.io wenfeng$ bundle update jekyll
        ......
        Using github-pages 148
        Bundle updated!
        
        RICHIEWFSHI-MB0:wenfengshi.github.io wenfeng$ bundle exec jekyll -v
        jekyll 3.5.1
        ```
2. 本地开始重现问题后，`bundle jekyll serve -V -t`启动Jekyll
    - 执行的打印信息如下，显示是和sitemap.xml有关！
    ![image_1bn3u1uc81qv4c0ghu522d1cmkp.png-100.3kB][4]
    - 额，好吧，自己尝试先把sitemap.xml文件删掉, 于是乎，build 成功了! -- **找到了一个暂时解决问题的方法**!!!
    -  另外最好修改 `_config.yml`中gems配置信息，如果不修改运行jekyll时也会报警告, 如下（最开时google相关的错误时也发现了这些 [链接一][5] , [链接二][6]）！
    ![image_1bnbe3t4dr763sgbemehsuj39.png-85.6kB][7]
    - `_config.yml` git log 修改记录如下
        ```
        diff --git a/_config.yml b/_config.yml
        index 6455447..6a95083 100644
        --- a/_config.yml
        +++ b/_config.yml
        @@ -129,4 +129,4 @@ exclude: ["README.md"]
         
        -gems: [jekyll-paginate]
        +plugins:
        +    - jekyll-paginate
        ```
    - 至此，自己的Jekyll是能正常跑起来了的，GitHubPage上也可以，解决方式就是 **删除Gemfile.lock文件，更新jekyll，删除sitmap.xml文件，修改_config.yml配置文件**
3. 但是我需要sitemap.xml文件啊， 额， 这个有一种更方便的方法
    - 在`_config.yml`文件中添加插件`jekyll-sitemap`,然后`bundle exec`即可, 参考[Sitemaps for GitHub Pages][8]
    - 自己的`_config.yml`插件配置如下

        ```
        plugins:
            - jekyll-paginate
            - jekyll-sitemap
        ```   
4. 至此困扰了自己一段时间的问题圆满解决了
    - 删除Gemfile.lock 文件，更新jekyll
    - 修改`_config.yml` 中插件的配置， 删除自己编写的 sitemap.xml
    - 在`_config.yml`中使用 jekyll-sitemap 插件

## 参考

1. https://pages.github.com/versions/
2. https://rubygems.org/gems/jekyll
3. https://stackoverflow.com/questions/6927442/what-is-the-difference-between-gemfile-and-gemfile-lock-in-ruby-on-rails
5. http://talk.jekyllrb.com/t/liquid-exception-1-is-not-a-symbol-nor-a-string-in-sitemap-xml/724
6. https://talk.jekyllrb.com/t/what-is-this-error-that-i-am-receiving/722
8. https://help.github.com/articles/sitemaps-for-github-pages/


  [1]: https://pages.github.com/versions/
  [2]: https://rubygems.org/gems/jekyll
  [3]: https://stackoverflow.com/questions/6927442/what-is-the-difference-between-gemfile-and-gemfile-lock-in-ruby-on-rails
  [4]: http://static.zybuluo.com/wuzhimang/jwvqzgyiankv17un48pfd4ux/image_1bn3u1uc81qv4c0ghu522d1cmkp.png
  [5]: http://talk.jekyllrb.com/t/liquid-exception-1-is-not-a-symbol-nor-a-string-in-sitemap-xml/724
  [6]: https://talk.jekyllrb.com/t/what-is-this-error-that-i-am-receiving/722
  [7]: http://static.zybuluo.com/wuzhimang/tkk8jck0l0osi086qtlkl8xg/image_1bnbe3t4dr763sgbemehsuj39.png
  [8]: https://help.github.com/articles/sitemaps-for-github-pages/
