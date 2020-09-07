//
//  ZGDataStructureViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/6/22.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class ZGDataStructureViewController: XHBaseViewController {
    
    
    @IBOutlet weak var showBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func showBtnAction(_ sender: Any) {
        bubbleSort()
    }
    
}

// MARK: - 数据结构
extension ZGDataStructureViewController {
    
    // swift版本
    private func bubbleSort() {
        var array = [24, 17, 85, 13, 9, 54, 76, 45, 5, 63]
        
        for i in 0..<(array.count-1) {
            for j in 0..<(array.count - 1 - i) {
                if array[j] < array[j+1] {
                    let temp = array[j]
                    array[j] = array[j+1]
                    array[j+1] = temp
                }
            }
        }
        
        print(array)
    }
    
    
}



/*
 //
 //  ZGClassicAlgorithmsViewController.m
 //  SummaryDemo
 //
 //  Created by zhaogang on 2018/8/21.
 //  Copyright © 2018年 audiocn. All rights reserved.
 //
 #import "ZGClassicAlgorithmsViewController.h"
 @interface ZGClassicAlgorithmsViewController ()
 @end
 @implementation ZGClassicAlgorithmsViewController
 - (void)viewDidLoad {
     [super viewDidLoad];
     // Do any additional setup after loading the view.
     
     //    [self bubbleSort]; // 冒泡算法
     //    [self quickSort]; // 快速排序算法
     //    [self selectionSort]; // 选择排序
     [self mergeSort]; // 归并排序
 }
 #pragma mark - 1、冒泡算法
 - (void)bubbleSort
 {
     /*
      冒泡排序算法的运作如下：（从后往前）
      1、比较相邻的元素。如果第一个比第二个大，就交换他们两个。
      2、对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。在这一点，最后的元素应该会是最大的数。
      3、针对所有的元素重复以上的步骤，除了最后一个。
      4、持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。
      
      冒泡排序的最坏时间复杂度为 n^2
      综上，因此冒泡排序总的平均时间复杂度为:n^2
      
      算法稳定性:
      冒泡排序就是把小的元素往前调或者把大的元素往后调。比较是相邻的两个元素比较，交换也发生在这两个元素之间。所以，如果两个元素相等，我想你是不会再无聊地把他们俩交换一下的；如果两个相等的元素没有相邻，那么即使通过前面的两两交换把两个相邻起来，这时候也不会交换，所以相同元素的前后顺序并没有改变，所以冒泡排序是一种稳定排序算法。
      */
     
     /*
     NSMutableArray *listArray = @[@(25), @(1), @(89), @(76), @(45), @(19),@(5), @(97), @(36), @(58)].mutableCopy;
     
     NSInteger count = listArray.count;
     for (NSInteger i = 0; i < count -1; i ++) {
         
         for (NSInteger j = 0; j < count - 1 - i; j++) {
             // <降序排列 >升序排列
             if ([listArray[j] integerValue] > [listArray[j+1] integerValue]) {
                 NSInteger temp = [listArray[j] integerValue];
                 [listArray replaceObjectAtIndex:j withObject:listArray[j+1]];
                 [listArray replaceObjectAtIndex:j+1 withObject:@(temp)];
                 
                 NSLog(@"----------------%@", listArray);
             }
         }
     }
     
     NSLog(@"最终结果---------------%@", listArray);
      
      打印结果：
      2018-08-21 10:15:24.422211+0800 SummaryDemo[3797:328910] 最终结果---------------(
      1,
      5,
      19,
      25,
      36,
      45,
      58,
      76,
      89,
      97
      )
      */
     
     
     int array[10] = {24, 17, 85, 13, 9, 54, 76, 45, 5, 63};
     int num = sizeof(array)/sizeof(int);
     for(int i = 0; i < num-1; i++) {
         for(int j = 0; j < num - 1 - i; j++) {
             if(array[j] < array[j+1]) {
                 // <降序排列 >升序排列
                 int tmp = array[j];
                 array[j] = array[j+1];
                 array[j+1] = tmp;
             }
         }
     }
     
     for(int i = 0; i < num; i++) {
         printf("%d", array[i]);
         if(i == num-1) {
             printf("\n");
         }
         else {
             printf(" ");
         }
     }
     
     // 打印结果 85 76 63 54 45 24 17 13 9 5
 }
 #pragma mark - 2、快速排序算法
 - (void)quickSort
 {
     /*
      快速排序（Quicksort）是对冒泡排序的一种改进。
      快速排序由C. A. R. Hoare在1962年提出。它的基本思想是：通过一趟排序将要排序的数据分割成独立的两部分，其中一部分的所有数据都比另外一部分的所有数据都要小，然后再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。
      
      设要排序的数组是A[0]……A[N-1]，首先任意选取一个数据（通常选用数组的第一个数）作为关键数据，然后将所有比它小的数都放到它前面，所有比它大的数都放到它后面，这个过程称为一趟快速排序。值得注意的是，快速排序不是一种稳定的排序算法，也就是说，多个相同的值的相对位置也许会在算法结束时产生变动。
      一趟快速排序的算法是：
      1）设置两个变量i、j，排序开始的时候：i=0，j=N-1；
      2）以第一个数组元素作为关键数据，赋值给key，即key=A[0]；
      3）从j开始向前搜索，即由后开始向前搜索(j--)，找到第一个小于key的值A[j]，将A[j]和A[i]互换；
      4）从i开始向后搜索，即由前开始向后搜索(i++)，找到第一个大于key的A[i]，将A[i]和A[j]互换；
      5）重复第3、4步，直到i=j； (3,4步中，没找到符合条件的值，即3中A[j]不小于key,4中A[i]不大于key的时候改变j、i的值，使得j=j-1，i=i+1，直至找到为止。找到符合条件的值，进行交换的时候i， j指针位置不变。另外，i==j这一过程一定正好是i+或j-完成的时候，此时令循环结束）。
      */
     
     int array[10] = {24, 17, 85, 13, 9, 54, 76, 45, 5, 63};
     int num = sizeof(array)/sizeof(int);
     sort(array, 0, num-1);
     
     for(int i = 0; i < num; i++) {
         printf("%d", array[i]);
         if(i == num-1) {
             printf("\n");
         }
         else {
             printf(" ");
         }
     }
     
     // 打印结果：85 76 63 54 45 24 17 13 9 5
 }
 void sort(int *a, int left, int right) {
     if(left >= right) {
         return ;
     }
     int i = left;
     int j = right;
     int key = a[left];
     while (i < j) {
         while (i < j && key >= a[j]) {
             j--;
         }
         a[i] = a[j];
         while (i < j && key <= a[i]) {
             i++;
         }
         a[j] = a[i];
     }
     
     a[i] = key;
     sort(a, left, i-1);
     sort(a, i+1, right);
 }
 #pragma mark - 3、选择排序
 - (void)selectionSort
 {
     /*
      选择排序（Selection sort）是一种简单直观的排序算法。它的工作原理是每一次从待排序的数据元素中选出最小（或最大）的一个元素，存放在序列的起始位置，直到全部待排序的数据元素排完。 选择排序是不稳定的排序方法（比如序列[5， 5， 3]第一次就将第一个[5]与[3]交换，导致第一个5挪动到第二个5后面）。
      
      n个记录的文件的直接选择排序可经过n-1趟直接选择排序得到有序结果：
      ①初始状态：无序区为R[1..n]，有序区为空。
      ②第1趟排序
      在无序区R[1..n]中选出关键字最小的记录R[k]，将它与无序区的第1个记录R[1]交换，使R[1..1]和R[2..n]分别变为记录个数增加1个的新有序区和记录个数减少1个的新无序区。
      ……
      ③第i趟排序
      第i趟排序开始时，当前有序区和无序区分别为R[1..i-1]和R(i..n）。该趟排序从当前无序区中选出关键字最小的记录 R[k]，将它与无序区的第1个记录R交换，使R[1..i]和R分别变为记录个数增加1个的新有序区和记录个数减少1个的新无序区。
      */
     
     int numArr[10] = {86, 37, 56, 29, 92, 73, 15, 63, 30, 8};
     sort1(numArr, 10);
     for (int i = 0; i < 10; i++) {
         printf("%d, ", numArr[i]);
     }
     printf("\n");
     // 打印结果：8, 15, 29, 30, 37, 56, 63, 73, 86, 92,
 }
 void sort1(int a[],int n)
 {
     int i, j, index;
     for(i = 0; i < n - 1; i++) {
         index = i;
         for(j = i + 1; j < n; j++) {
             if(a[index] > a[j]) {
                 index = j;
             }
         }
         if(index != i) {
             int temp = a[i];
             a[i] = a[index];
             a[index] = temp;
         }
     }
 }
 #pragma mark - 4、归并排序（MERGE-SORT）
 - (void)mergeSort
 {
     /*
      归并排序（MERGE-SORT）是建立在归并操作上的一种有效的排序算法,该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。将已有序的子序列合并，得到完全有序的序列；即先使每个子序列有序，再使子序列段间有序。若将两个有序表合并成一个有序表，称为二路归并。
      归并过程为：比较a[i]和b[j]的大小，若a[i]≤b[j]，则将第一个有序表中的元素a[i]复制到r[k]中，并令i和k分别加上1；否则将第二个有序表中的元素b[j]复制到r[k]中，并令j和k分别加上1，如此循环下去，直到其中一个有序表取完，然后再将另一个有序表中剩余的元素复制到r中从下标k到下标t的单元。归并排序的算法我们通常用递归实现，先把待排序区间[s,t]以中点二分，接着把左边子区间排序，再把右边子区间排序，最后把左区间和右区间用一次归并操作合并成有序的区间[s,t]。
      
      
      归并操作(merge)，也叫归并算法，指的是将两个顺序序列合并成一个顺序序列的方法。
      如　设有数列{6，202，100，301，38，8，1}
      初始状态：6,202,100,301,38,8,1
      第一次归并后：{6,202},{100,301},{8,38},{1}，比较次数：3；
      第二次归并后：{6,100,202,301}，{1,8,38}，比较次数：4；
      第三次归并后：{1,6,8,38,100,202,301},比较次数：4；
      总的比较次数为：3+4+4=11,
      逆序数为14；
      
      */
     
     int numArr[10] = {86, 37, 56, 29, 92, 73, 15, 63, 30, 8};
     int tempArr[10];
     sort2(numArr, tempArr, 0, 9);
     for (int i = 0; i < 10; i++) {
         printf("%d, ", numArr[i]);
     }
     printf("\n");
     
     // 打印结果：8, 15, 29, 30, 37, 56, 63, 73, 86, 92,
 }
 void sort2(int souceArr[], int tempArr[], int startIndex, int endIndex) {
     int midIndex;
     if (startIndex < endIndex) {
         midIndex = (startIndex + endIndex) / 2;
         sort2(souceArr, tempArr, startIndex, midIndex);
         sort2(souceArr, tempArr, midIndex + 1, endIndex);
         merge1(souceArr, tempArr, startIndex, midIndex, endIndex);
     }
 }
 // 千万不要把函数命名成“merge”，会导致报错：linker command failed with exit code 1 (use -v to see invocation)
 void merge1(int sourceArr[], int tempArr[], int startIndex, int midIndex, int endIndex) {
     
     int i = startIndex;
     int j = midIndex + 1;
     int k = startIndex;
     
     while (i != midIndex + 1 && j != endIndex + 1) {
         if (sourceArr[i] >= sourceArr[j]) {
             tempArr[k++] = sourceArr[j++];
         }
         else {
             tempArr[k++] = sourceArr[i++];
         }
     }
     
     while (i != midIndex + 1) {
         tempArr[k++] = sourceArr[i++];
     }
     
     while (j != endIndex + 1) {
         tempArr[k++] = sourceArr[j++];
     }
     
     for (i = startIndex; i <= endIndex; i++) {
         sourceArr[i] = tempArr[i];
     }
 }
 @end
 */
