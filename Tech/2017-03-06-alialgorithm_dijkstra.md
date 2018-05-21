---
title: 2017阿里在线编程题--单源最短路径问题
layout: post
author: WenfengShi
category: 技术
tags: [算法]
---

> 原文链接: [http://codeshold.me/2017/03/alialgorithm_dijkstra.html](http://codeshold.me/2017/03/alialgorithm_dijkstra.html)  

## 题目
西湖是杭州最有名的风景区，每年到西湖旅游的客户非常多，大家各自从不同的地方出发到西湖，交通问题非常令人头疼。阿里小二J准备通过高德地图实时数据和只能推荐帮助大家解决这个问题。
现在有一组地理坐标，地理位置用5位以内的大写字母表示。高德地图会根据实时的车流情况预估实时路况：从地理位置1到地理位置2之间的用时，单位为分钟。地理位置之间和用时之间都用英文逗号分隔。比如：WSX,BQB,20，表示从WSX位置到BQB位置，需要20分钟。注意，仅凭这一条信息不能代表BQB到WSX也为20分钟。西湖的地理位置用XH表示
系统保障：
地理位置不重名
至少存在一条从目的地到西湖的路径
实时路况数量不超过10000
地理位置数不超过100
实时路况的分钟数为1到21亿之间的正整数
请计算从给出目的地理位置（非XH的任意地理位置）到西湖的最少用时路径


## 解答

> 一个典型的Dijkstra算法， 但自己算法确实生疏了（要抓紧时间开始刷题了），秉承着诚信的原则，半小时内确实没有实现！

> 有时间了提供一个基于优先队列的实现！

> python实现

```
# -*- encoding:utf-8 -*-


class BuildGraph(object):
    def __init__(self, filename):
        self.file = filename
        self.matrix = [[float('inf') for _ in range(100)] for _ in range(100)]
        self.v2idict = {}
        self.i2vdict = {}
        self.start = 0
        self.end = 0
        self.__parse_file()

    def vcount(self):
        return len(self.v2idict)

    def __parse_file(self):
        with open(self.file, 'r') as f:
            count = int(f.readline().strip('\n\r '))
            for i in range(1, count+1):
                data = f.readline().strip('\n\r ').split(',')
                if data[0] not in self.v2idict:
                    index = len(self.v2idict)
                    self.v2idict[data[0]] = index
                    self.i2vdict[index] = data[0]
                if data[1] not in self.v2idict:
                    index = len(self.v2idict)
                    self.v2idict[data[1]] = index
                    self.i2vdict[index] = data[1]
                line = self.v2idict[data[0]]
                col = self.v2idict[data[1]]
                self.matrix[line][col] = int(data[2])
            self.start = self.v2idict[(f.readline().strip('\n\r '))]
            self.end = self.v2idict['XH']


class DijkstraAlgorithm(object):
    def __init__(self, graph):
        self.matrix = graph.matrix
        self.start = graph.start
        self.end = graph.end
        self.i2vdict = graph.i2vdict
        self.vcount = graph.vcount()
        self.path = []
        self.dist = [float('inf')] * self.vcount
        self.__remain_set = set()
        self.i2vdict = graph.i2vdict
        for i in range(0, self.vcount):
            self.dist[i] = self.matrix[self.start][i]
            self.__remain_set.add(i)
        self.__deal()

    def __get_min(self):
        min_vertex = -1
        min_index = -1
        for i in self.__remain_set:
            if min_vertex == -1:
                min_vertex = i
                min_index = i
            if self.dist[i] < min_vertex:
                min_vertex = self.dist[i]
                min_index = i
        return min_index

    def __deal(self):
        self.path.append(self.start)
        self.__remain_set.remove(self.start)
        for n in range(0, self.vcount-2):
            min = self.__get_min()
            self.__remain_set.remove(min)
            if min == self.end:
                break
            for i in self.__remain_set:
                if self.dist[i] > self.dist[min] + self.matrix[min][i]:
                    self.dist[i] = self.dist[min] + self.matrix[min][i]
                    if i == self.end:
                        self.path.append(min)

    def print_result(self):
        print "Path: ",
        for i in range(0, len(self.path)):
            print self.i2vdict[self.path[i]], "-->",
        print self.i2vdict[self.end]
        print "Cost: ", self.dist[self.end]


if __name__ == "__main__":
    test = BuildGraph("test.txt")
    deal = DijkstraAlgorithm(test)
    deal.print_result()
```
