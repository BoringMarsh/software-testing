from decimal import Decimal, getcontext

# 设置精度
getcontext().prec = 10

base_charge = 25
charge_per_minute = Decimal("0.15")


def telephone(minute: int, fail_time: int):
    if minute < 0:
        return "minute can't be negative"
    elif minute > 31 * 24 * 60:
        return "minute exceeded"

    if fail_time < 0:
        return "fail time can't be negative"

    max_fail_time = 0
    discount = Decimal("0.0")

    if 0 < minute <= 60:
        max_fail_time = 1
        discount = Decimal("0.01")
    elif 60 < minute <= 120:
        max_fail_time = 2
        discount = Decimal("0.015")
    elif 120 < minute <= 180:
        max_fail_time = 3
        discount = Decimal("0.02")
    elif 180 < minute <= 300:
        max_fail_time = 3
        discount = Decimal("0.025")
    elif minute > 300:
        max_fail_time = 6
        discount = Decimal("0.03")

    total_charge = base_charge + minute * charge_per_minute * (1 - (0 if fail_time > max_fail_time else discount))
    return str(total_charge.normalize())


if __name__ == "__main__":
    print(telephone(3000, 1))