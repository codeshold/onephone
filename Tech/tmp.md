> 通过Maven打包时，希望生成的jar包名能自动带上git commit id等信息，google搜了下，找到了 maven-git-commit-id-plugin 这个插件，在配置和使用的过程中踩了几个小坑，下面直接贴出自己的成果！
P.S. 我的jar包是长这个样子的`XXXXXX-RELEASE-T_2018_03_18_20-eda0493-jar-with-dependencies.jar`


## 基本配置
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

## 开发网下的额外配置
公司开发网下，在进行如上配置后，打包时可能会出现失败的情况

- 报错信息
    - Failed to execute goal pl.project13.maven:git-commit-id-plugin:2.2.4:
```
......
[ERROR] Failed to execute goal pl.project13.maven:git-commit-id-plugin:2.2.4:revision (get-the-git-infos) on project spark-data-driver-2.11: Execution get-the-git-infos of goal pl.project13.maven:git-commit-id-plugin:2.2.4:revision failed: Plugin pl.project13.maven:git-commit-id-plugin:2.2.4 or one of its dependencies could not be resolved: Failed to collect dependencies at pl.project13.maven:git-commit-id-plugin:jar:2.2.4 -> com.fasterxml.jackson.core:jackson-databind:jar:2.6.4: Failed to read artifact descriptor for com.fasterxml.jackson.core:jackson-databind:jar:2.6.4: Could not transfer artifact com.fasterxml.jackson.core:jackson-databind:pom:2.6.4 from/to central (http://maven.oa.com/nexus/content/groups/public): Failed to transfer file: http://maven.oa.com/nexus/content/groups/public/com/fasterxml/jackson/core/jackson-databind/2.6.4/jackson-databind-2.6.4.pom. Return code is: 418 , ReasonPhrase:Unknown. -> [Help 1]
......
```


- **报错原因**
git-commit-id-plugin 当前最新版本2.2.4依赖于 *com.fasterxml.jackson.core:jackson-databind:jar:2.6.4*， 但是该2.6.4版本 **存在严重安全漏洞，根据公司安全管理要求，已禁止使用该版本**,所以从 http://maven.oa.com 中下载不了2.6.4版本的依赖包，进而 Failed to execute goal！
- **解决方法**
手动修改git-commit-id-plugin 的POM文件，更改jackson-databind的版本号
    - 公司建议将`com.fasterxml.jackson.core:jackson-databind:jar:2.6.4`升级到版本2.7.9.2 , 2.8.11 或 2.9.4 以上版本
    - 即修改`.m2\repository\pl\project13\maven\git-commit-id-plugin\2.2.4\git-commit-id-plugin-2.2.4.pom`，更改版本号，如下
```
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.9.4</version>
    </dependency>
```
    - 重新编译打包即可

## 参考
1. [maven-git-commit-id-plugin](https://github.com/ktoso/maven-git-commit-id-plugin/)
2. [github issues](https://github.com/ktoso/maven-git-commit-id-plugin/issues/280)
