#include <stdio.h>

int reuse = 0;
int notReuse = 0;

//------------------------------
// 再利用可能な関数(良い例)
//------------------------------
int reuseable(int input)
{
    int output = 0;

    // 演算
    reuse = reuse + input;
    output = reuse;

    // 再使用可能なようにリセットする
    reuse = 0;

    return output;
}

//------------------------------
// 再利用不可能な関数(悪い例)
//------------------------------
int notReuseable(int input)
{
    int output = 0;

    // 演算
    notReuse = notReuse + input;
    output = notReuse;

    // リセットを行わず保持してしまう

    return output;
}

//------------------------------
// それぞれの関数を使ってみる
//------------------------------
int main(void)
{
    int input = 10;

    printf("再利用可能プログラム実験\n");
    printf("    1回目：%d", reuseable(input));
    printf("    2回目：%d", reuseable(input));
    printf("    3回目：%d\n", reuseable(input));

    printf("非再利用可能プログラム実験\n");
    printf("    1回目：%d", notReuseable(input));
    printf("    2回目：%d", notReuseable(input));
    printf("    3回目：%d\n", notReuseable(input));
    return 0;
}
/*
-------------------------------------------------------
再利用可能プログラムは、演算の終わりにリセットをかけることによって
何度呼び出しても同じ入力であれば同じ出力を返す
前回の実行結果に依存しないプログラムのこと
-------------------------------------------------------
*/
// 　　\n