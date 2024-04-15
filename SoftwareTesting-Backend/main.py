import pandas as pd
from hw_triangle import triangle
from hw_calendar import calendar
from hw_telephone import telephone
from hw_computer import computer


if __name__ == '__main__':
    # df = pd.read_csv("triangle.csv")
    # print(df)
    #
    # for i in range(df.shape[0]):
    #     print(i)
    #
    #     df.iloc[i, 5] = triangle.triangle(df.iloc[i, 1], df.iloc[i, 2], df.iloc[i, 3])
    #     if str(df.iloc[i, 4]) != str(df.iloc[i, 5]):
    #         df.iloc[i, 6] = "未通过测试"
    #     else:
    #         df.iloc[i, 6] = "通过测试"
    #
    # df.to_csv("triangle_result.csv")

    # df = pd.read_csv("calendar.csv")
    # print(df)
    #
    # for i in range(df.shape[0]):
    #     print(i)
    #
    #     df.iloc[i, 5] = calendar.calendar(df.iloc[i, 1], df.iloc[i, 2], df.iloc[i, 3])
    #     if str(df.iloc[i, 4]) != str(df.iloc[i, 5]):
    #         df.iloc[i, 6] = "未通过测试"
    #     else:
    #         df.iloc[i, 6] = "通过测试"
    #
    # df.to_csv("calendar_result.csv")

    # df = pd.read_csv("telephone.csv")
    # print(df)
    #
    # for i in range(df.shape[0]):
    #     print(i)
    #
    #     df.iloc[i, 4] = telephone.telephone(df.iloc[i, 1], df.iloc[i, 2])
    #     if str(df.iloc[i, 3]) != str(df.iloc[i, 4]):
    #         df.iloc[i, 5] = "未通过测试"
    #     else:
    #         df.iloc[i, 5] = "通过测试"
    #
    # df.to_csv("telephone_result.csv")

    df = pd.read_csv("computer.csv")
    print(df)

    for i in range(df.shape[0]):
        print(i)

        df.iloc[i, 5] = computer.computer(df.iloc[i, 1], df.iloc[i, 2], df.iloc[i, 3])
        if str(df.iloc[i, 4]) != str(df.iloc[i, 5]):
            df.iloc[i, 6] = "未通过测试"
        else:
            df.iloc[i, 6] = "通过测试"

    df.to_csv("computer_result.csv")