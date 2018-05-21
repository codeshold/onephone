---
title: 高品位代码集
layout: post
author: WenfengShi
category: 私库
tags: [c/c++]
---
博客链接: [http://codeshold.me/2017/02/c_code_sinped.html](http://codeshold.me/2017/02/c_code_sinped.html)

> 编程的品味也有高低之分

## 1. 单链表元素删除操作

[参考](http://www.changhai.org/articles/miscellaneous/blog/201609.php)

- 低品位

        remove_list_entry(entry)
        {
            prev = NULL;
            walk = entry;

            // Walk the list
            while(walk != entry) {
                prev = walk;
                walk = walk->next;
            }

            // Removing the entry by updating the previous or the head entry
            if(prev) {
                prev->next = entry->next;
            } else {
                head = entry->next;
            }
        }

- 高品位

        remove_list_entry(entry)
        {
            // The "indirect" pointer points to the ADDRESS of the thing we'll update
            indirect = &head;

            // Walk the list, looking for the thing points to the entry we want to remove
            while(*indirect != entry) {
                indirect = &(*indirect)->next;
            }

            // Remove the entry...
            *indirect = entry->next;
        }


## 2. 类型选择对程序执行时间的影响

[参考](http://www.ituring.com.cn/article/274244)

- `g++ test_int.cpp -O3 ` 编译运行

        #include <cstdio>
        #include <math.h>
        #include <ctime>

        #define NN 1000000

        int main()
        {
            int t=clock();
            long long sum=0;

            // 低品位, 运行时间明显长
            for(long long a=1;a<=NN;a++)
                for(long long b=1;b<=sqrt(NN);b++)
                    sum+=(a/b)*(a/b);

            printf("%lld,%d\n",sum,clock()-t);

            t=clock();
            sum=0;

            // 高品位, 运行时间明显短
            for(int a=1;a<=NN;a++)
                for(int b=1;b<=sqrt(NN);b++)
                    sum+=(long long)(a/b)*(a/b);

            printf("%lld,%d\n",sum,clock()-t);
        }
