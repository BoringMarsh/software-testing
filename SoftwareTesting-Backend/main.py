import ast
import decimal

import flask
import pandas as pd
import time
import datetime
from flask import Flask
from flask_cors import CORS
from hw_triangle import triangle
from hw_calendar import calendar
from hw_telephone import telephone
from hw_computer import computer
from http import HTTPStatus
# Flask应用创建
app = Flask(__name__)

# 配置跨域请求
cors_config = {
    r"/api/*": {"origins": "*"}  # 允许来自所有地址到/api/*的请求
}
CORS(app, resources=cors_config)


def make_response(read_time: float, test_time: float, total_count: int, pass_count: int, df: pd.DataFrame):
    return flask.jsonify({
        "readTime": read_time,
        "testTime": test_time,
        "total": total_count,
        "pass": pass_count,
        "passRate": f"{round(float(pass_count) / total_count * 100, 2)}%",
        "data": ast.literal_eval(df.to_json(orient='records'))
    })


def is_decimal_fraction_zero(decimal_number):
    # 使用 as_tuple 方法获取 Decimal 的元组表示
    decimal_tuple = decimal_number.as_tuple()

    # 小数部分为零当且仅当指数为零或正数
    if decimal_tuple.exponent >= 0:
        return True

    # 检查小数部分是否全为零
    fractional_part = decimal_tuple.digits[decimal_tuple.exponent:]
    return all(digit == 0 for digit in fractional_part)


@app.route("/api/hw/triangle", methods=['POST', 'GET'])
#@cross_origin
def hw_triangle():
    # ----------------------------------- 读取测试用例 ----------------------------------- #
    read_start_time = time.time_ns()  # 初始时间

    try:
        df = pd.read_csv("test case/triangle_boundary.csv")  # 读取测试用例
    except FileNotFoundError:
        response = {
            "message": "test case not found"
        }
        return flask.jsonify(response), HTTPStatus.NOT_FOUND  # 文件不存在，报404错误

    read_time = round(float(time.time_ns() - read_start_time) / 1000000000, 4)  # 计算读取时间
    # ------------------------------------------------------------------------------------ #

    total_count = df.shape[0]  # 获取测试用例个数
    pass_count = 0             # 通过测试个数，初始为0

    # ------------------------------------- 进行测试 ------------------------------------- #
    test_start_time = time.time_ns()  # 初始时间

    for i in range(total_count):
        # 进行测试，结果填入当前行的结果列
        df.iloc[i, 5] = triangle.triangle(df.iloc[i, 1], df.iloc[i, 2], df.iloc[i, 3])
        raw_result = triangle.triangle(df.iloc[i, 1], df.iloc[i, 2], df.iloc[i, 3])
        format_result = raw_result

        df.iloc[i, 5] = format_result
        df.iloc[i, 8] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        df.iloc[i, 9] = "2151294"
        df.iloc[i, 10] = ""

        # 与预期输出进行比对
        if str(df.iloc[i, 4]) != str(df.iloc[i, 5]):
            df.iloc[i, 6] = "未通过测试"
        else:
            df.iloc[i, 6] = "通过测试"
            pass_count += 1

    test_time = round(float(time.time_ns() - test_start_time) / 1000000000, 4)  # 计算测试时间
    # ------------------------------------------------------------------------------------ #

    df.to_csv("test result/triangle_result.csv")  # 将测试结果及比对结果写回表格
    return make_response(read_time, test_time, total_count, pass_count, df)  # 将表格信息返回给前端


@app.route("/api/hw/calendar")
def hw_calendar():
    # ----------------------------------- 读取测试用例 ----------------------------------- #
    read_start_time = time.time_ns()  # 初始时间

    try:
        df = pd.read_csv("test case/calendar_boundary.csv")  # 读取测试用例
    except FileNotFoundError:
        response = {
            "message": "test case not found"
        }
        return flask.jsonify(response), HTTPStatus.NOT_FOUND  # 文件不存在，报404错误

    read_time = round(float(time.time_ns() - read_start_time) / 1000000000, 4)  # 计算读取时间
    # ------------------------------------------------------------------------------------ #

    total_count = df.shape[0]  # 获取测试用例个数
    pass_count = 0  # 通过测试个数，初始为0

    # ------------------------------------- 进行测试 ------------------------------------- #
    test_start_time = time.time_ns()  # 初始时间

    for i in range(total_count):
        # 进行测试，结果填入当前行的结果列
        raw_result = calendar.calendar(df.iloc[i, 1], df.iloc[i, 2], df.iloc[i, 3])
        format_result = raw_result

        df.iloc[i, 5] = format_result
        df.iloc[i, 8] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        df.iloc[i, 9] = "2151294"
        df.iloc[i, 10] = ""

        # 与预期输出进行比对
        if str(df.iloc[i, 4]) != str(df.iloc[i, 5]):
            df.iloc[i, 6] = "未通过测试"
        else:
            df.iloc[i, 6] = "通过测试"
            pass_count += 1

    test_time = round(float(time.time_ns() - test_start_time) / 1000000000, 4)  # 计算测试时间
    # ------------------------------------------------------------------------------------ #

    df.to_csv("test result/calendar_result.csv")  # 将测试结果及比对结果写回表格
    return make_response(read_time, test_time, total_count, pass_count, df)  # 将表格信息返回给前端


@app.route("/api/hw/telephone")
def hw_telephone():
    # ----------------------------------- 读取测试用例 ----------------------------------- #
    read_start_time = time.time_ns()  # 初始时间

    try:
        df = pd.read_csv("test case/telephone_boundary.csv")  # 读取测试用例
    except FileNotFoundError:
        response = {
            "message": "test case not found"
        }
        return flask.jsonify(response), HTTPStatus.NOT_FOUND  # 文件不存在，报404错误

    read_time = round(float(time.time_ns() - read_start_time) / 1000000000, 4)  # 计算读取时间
    # ------------------------------------------------------------------------------------ #

    total_count = df.shape[0]  # 获取测试用例个数
    pass_count = 0  # 通过测试个数，初始为0

    # ------------------------------------- 进行测试 ------------------------------------- #
    test_start_time = time.time_ns()  # 初始时间

    for i in range(total_count):
        # 进行测试，结果填入当前行的结果列
        raw_result = telephone.telephone(df.iloc[i, 1], df.iloc[i, 2])

        if type(raw_result) == decimal.Decimal:
            format_result = str(int(raw_result)) if is_decimal_fraction_zero(raw_result) else str(
                raw_result.normalize())
        else:
            format_result = raw_result

        df.iloc[i, 4] = format_result
        df.iloc[i, 7] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        df.iloc[i, 8] = "2151294"
        df.iloc[i, 9] = ""

        # 与预期输出进行比对（pandas读取浮点数时会带多余的0，通过Decimal的normalize去掉）
        if df.iloc[i, 3] != df.iloc[i, 4]:
            df.iloc[i, 5] = "未通过测试"
        else:
            df.iloc[i, 5] = "通过测试"
            pass_count += 1

    test_time = round(float(time.time_ns() - test_start_time) / 1000000000, 4)  # 计算测试时间
    # ------------------------------------------------------------------------------------ #

    df.to_csv("test result/telephone_result.csv")  # 将测试结果及比对结果写回表格
    return make_response(read_time, test_time, total_count, pass_count, df)  # 将表格信息返回给前端


@app.route("/api/hw/computer")
def hw_computer():
    # ----------------------------------- 读取测试用例 ----------------------------------- #
    read_start_time = time.time_ns()  # 初始时间

    try:
        df = pd.read_csv("test case/computer_boundary.csv")  # 读取测试用例
    except FileNotFoundError:
        response = {
            "message": "test case not found"
        }
        return flask.jsonify(response), HTTPStatus.NOT_FOUND  # 文件不存在，报404错误

    read_time = round(float(time.time_ns() - read_start_time) / 1000000000, 4)  # 计算读取时间
    # ------------------------------------------------------------------------------------ #

    total_count = df.shape[0]  # 获取测试用例个数
    pass_count = 0  # 通过测试个数，初始为0

    test_start_time = time.time_ns()
    for i in range(total_count):
        # 进行测试，结果填入当前行的结果列
        raw_result = computer.computer(df.iloc[i, 1], df.iloc[i, 2], df.iloc[i, 3])
        format_result = str(raw_result)

        df.iloc[i, 5] = format_result
        df.iloc[i, 8] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        df.iloc[i, 9] = "2151294"
        df.iloc[i, 10] = ""

        # 与预期输出进行比对
        if str(df.iloc[i, 4]) != str(df.iloc[i, 5]):
            df.iloc[i, 6] = "未通过测试"
        else:
            df.iloc[i, 6] = "通过测试"
            pass_count += 1

    test_time = round(float(time.time_ns() - test_start_time) / 1000000000, 4)  # 计算测试时间
    # ------------------------------------------------------------------------------------ #

    df.to_csv("test result/computer_result.csv")  # 将测试结果及比对结果写回表格
    return make_response(read_time, test_time, total_count, pass_count, df)  # 将表格信息返回给前端


if __name__ == '__main__':
    app.run(debug=True, port=5001)