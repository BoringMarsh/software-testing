import ast
import decimal
import pandas as pd
import time
import datetime
from flask import *
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
    return jsonify({
        "readTime": read_time,
        "testTime": test_time,
        "total": total_count,
        "pass": pass_count,
        "passRate": float(pass_count) / total_count ,
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


def exec_test(hw_name, data, arg_count, row):
    if hw_name == 'triangle':
        return triangle.triangle(
            data.iloc[row, arg_count - 2],
            data.iloc[row, arg_count - 1],
            data.iloc[row, arg_count]
        )
    elif hw_name == 'computer':
        return computer.computer(
            data.iloc[row, arg_count - 2],
            data.iloc[row, arg_count - 1],
            data.iloc[row, arg_count]
        )
    elif hw_name == 'telephone':
        return telephone.telephone(
            data.iloc[row, arg_count - 1],
            data.iloc[row, arg_count]
        )
    elif hw_name == 'calendar':
        return calendar.calendar(
            data.iloc[row, arg_count - 2],
            data.iloc[row, arg_count - 1],
            data.iloc[row, arg_count]
        )
    else:
        return None


def format_result(hw_name, raw_result):
    if hw_name == 'computer':
        return str(raw_result)
    elif hw_name == 'telephone':
        if type(raw_result) == decimal.Decimal:
            return str(int(raw_result)) if is_decimal_fraction_zero(raw_result) else str(raw_result.normalize())
        else:
            return raw_result
    elif hw_name == 'calendar' or hw_name == 'triangle':
        return raw_result
    else:
        return None


def test_procedure(filename, hw_name, arg_count):
    # ----------------------------------- 读取测试用例 ----------------------------------- #
    read_start_time = time.time_ns()  # 初始时间
    src_path = "test case/" + filename

    try:
        df = pd.read_csv(src_path)  # 读取测试用例
    except FileNotFoundError:
        response = {
            "message": "test case not found"
        }
        return jsonify(response), HTTPStatus.NOT_FOUND  # 文件不存在，报404错误

    read_time = round(float(time.time_ns() - read_start_time) / 1000000000, 4)  # 计算读取时间
    # ------------------------------------------------------------------------------------ #

    total_count = df.shape[0]  # 获取测试用例个数
    pass_count = 0  # 通过测试个数，初始为0

    # ------------------------------------- 进行测试 ------------------------------------- #
    test_start_time = time.time_ns()  # 初始时间

    for i in range(total_count):
        # 进行测试，结果填入当前行的结果列
        raw_result = exec_test(hw_name, df, arg_count, i)
        formatted_result = format_result(hw_name, raw_result)

        df.iloc[i, arg_count + 2] = formatted_result
        df.iloc[i, arg_count + 5] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        df.iloc[i, arg_count + 6] = "2151294"
        df.iloc[i, arg_count + 7] = ""

        # 与预期输出进行比对
        if str(df.iloc[i, arg_count + 1]) != str(df.iloc[i, arg_count + 2]):
            df.iloc[i, arg_count + 3] = "未通过测试"
        else:
            df.iloc[i, arg_count + 3] = "通过测试"
            pass_count += 1

    test_time = round(float(time.time_ns() - test_start_time) / 1000000000, 4)  # 计算测试时间
    # ------------------------------------------------------------------------------------ #

    df.to_csv(f"test result/{hw_name}_result.csv")  # 将测试结果及比对结果写回表格
    return make_response(read_time, test_time, total_count, pass_count, df)  # 将表格信息返回给前端


@app.route("/api/hw/triangle", methods=['POST', 'GET'])
def hw_triangle():
    file = request.files['file']
    return test_procedure(file.filename, 'triangle', 3)


@app.route("/api/hw/calendar", methods=['POST', 'GET'])
def hw_calendar():
    file = request.files['file']
    return test_procedure(file.filename, 'calendar', 3)


@app.route("/api/hw/telephone", methods=['POST', 'GET'])
def hw_telephone():
    file = request.files['file']
    return test_procedure(file.filename, 'telephone', 2)


@app.route("/api/hw/computer", methods=['POST', 'GET'])
def hw_computer():
    file = request.files['file']
    return test_procedure(file.filename, 'computer', 3)


if __name__ == '__main__':
    app.run(debug=True, port=5001)