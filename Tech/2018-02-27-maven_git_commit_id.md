---
title: jar包名中自动添加git commit id
layout: post
author: WenfengShi
category: 技术
tags: [git,maven]
---
博客链接: [http://codeshold.me/2018/02/maven_git_commit_id.html](http://codeshold.me/2018/02/maven_git_commit_id.html)

- 插件名：[maven-git-commit-id-plugin](https://github.com/ktoso/maven-git-commit-id-plugin/)
- pom.xml plugin配置样例
    ```xml
    ......
      <plugin>
        <groupId>pl.project13.maven</groupId>
        <artifactId>git-commit-id-plugin</artifactId>
        <version>2.2.4</version>
        <executions>
          <execution>
            <id>get-the-git-infos</id>
            <goals>
              <goal>revision</goal>
            </goals>
          </execution>
        </executions>
        <configuration>
          <!-- 使properties扩展到整个maven bulid 周期
          Ref: https://github.com/ktoso/maven-git-commit-id-plugin/issues/280 -->
          <injectAllReactorProjects>true</injectAllReactorProjects>
          <dateFormat>yyyy.MM.dd HH:mm:ss</dateFormat>
          <verbose>true</verbose>
          <!-- 是否生 git.properties 属性文件 -->
          <generateGitPropertiesFile>true</generateGitPropertiesFile>
          <!--git描述配置,可选;由JGit提供实现;-->
          <gitDescribe>
            <!--是否生成描述属性-->
            <skip>false</skip>
            <!--提交操作未发现tag时,仅打印提交操作ID,-->
            <always>false</always>
            <!--提交操作ID显式字符长度,最大值为:40;默认值:7; 0代表特殊意义;后面有解释; -->
            <abbrev>7</abbrev>
            <!--构建触发时,代码有修改时(即"dirty state"),添加指定后缀;默认值:"";-->
            <dirty>-dirty</dirty>
            <!--always print using the "tag-commits_from_tag-g_commit_id-maybe_dirty" format, even if "on" a tag. The distance will always be 0 if you're "on" the tag. -->
            <forceLongFormat>false</forceLongFormat>
          </gitDescribe>
        </configuration>
    </plugin>
    ......
    ```
- pom.xml jar包名配置样例（结合maven-shade-plugin）
    - 同时会在`target/classes`下生成`git.properties`文件
```xml
......
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-shade-plugin</artifactId>
        <version>2.4.3</version>
        <executions>
          <execution>
            <phase>package</phase>
            <goals>
              <goal>shade</goal>
            </goals>
            <configuration>
              <artifactSet>
                <includes>
                  <include>*:*</include>
                </includes>
              </artifactSet>
              <!-- 生成的jar文件名 with git.commit.id.abbrev -->
              <outputFile>
                ${project.build.directory}/${project.artifactId}-${git.commit.id.abbrev}.jar
              </outputFile>
            </configuration>
          </execution>
        </executions>
      </plugin>
......
```
