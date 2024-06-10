from allpairspy import AllPairs
import random
import string


def generate_upper_lower_digit(min_len, max_len):
    length = random.randint(max(min_len, 3), max_len)  # 生成随机长度在8到12之间的字符串
    all_chars = string.ascii_letters + string.digits  # 大写字母、小写字母和数字
    random_chars = random.choices(all_chars, k=length)

    # 确保生成的字符串中同时包含大写字母、小写字母和数字
    while not (any(c.isupper() for c in random_chars) and
               any(c.islower() for c in random_chars) and
               any(c.isdigit() for c in random_chars)):
        random_chars = random.choices(all_chars, k=length)

    return ''.join(random_chars)


def generate_letter_or_digit(min_len, max_len, if_letter):
    # 生成一个1到1024之间的随机长度
    length = random.randint(min_len, max_len)

    # 随机选择字符的范围
    characters = (string.ascii_letters if if_letter else "") + string.digits

    # 生成随机字符串
    random_string = ''.join(random.choice(characters) for _ in range(length))

    return random_string


parameters = [
    ["符合格式"],
    ["符合格式"],
    ["符合格式"],
    ["符合格式"],
    ["嘉定校区", "四平路校区", "沪西校区", "沪北校区", "其他校区"],
    ["符合格式"],
    ["不为空"],
    ["2023本", "2022本", "2021本", "2020本", "硕士研究生", "博士研究生"],
    ["新生院", "艺术与传媒学院", "外国语学院", "法学院", "政治与国际关系学院", "经济与管理学院", "建筑与城市规划学院", "设计创意学院",
        "土木工程学院", "环境科学与工程学院", "机械与能源工程学院", "交通运输工程学院", "汽车学院", "铁道与城市轨道交通研究院",
        "材料科学与工程学院", "航空航天与力学学院", "测绘与地理信息学院", "电子与信息工程学院", "软件学院", "物理科学与工程学院",
        "海洋与地球科学学院", "数学科学学院", "化学科学与工程学院", "生命科学与技术学院", "口腔医学院", "医学院", "中德工程学院",
        "马克思主义学院", "国际足球学院", "其它学院"],
    ["符合格式"]
]

majors = [
    ['人文科学试验班', '社会科学试验班', '经济管理试验班', '工科试验班（建筑城规景观与设计类）', '工科试验班（土木与环境类）',
        '工科试验班（智能交通与车辆类）', '工科试验班（智能化制造类）', '工科试验班（信息类）', '理科试验班', '医学试验班',
        '机械类（中外合作办学）', '设计学类', '其它'],
    ['表演', '动画', '广播电视编导', '音乐表演', '广播电视学', '广告学'],
    ['日语', '英语', '德语'],
    ['法学'],
    ['政治学与行政学', '社会学'],
    ['金融学', '国际经济与贸易', '会计学', '市场营销', '物流管理', '工程管理', '信息管理与信息系统'],
    ['风景园林', '城乡规划', '历史建筑保护工程', '建筑学', '城市设计'],
    ['工业设计', '产品设计', '环境设计', '视觉传达设计'],
    ['港口航道与海岸工程', '智能建造', '土木工程', '地质工程'],
    ['环境科学', '环境工程', '给排水科学与工程'],
    ['建筑环境与能源应用工程', '能源与动力工程', '工业工程', '机械设计制造及其自动化', '智能制造工程'],
    ['交通工程', '交通运输'],
    ['车辆工程（汽车）'],
    ['车辆工程'],
    ['新能源材料与器件', '材料科学与工程'],
    ['工程力学', '飞行器制造工程'],
    ['测绘工程'],
    ['电气工程及其自动化', '自动化', '通信工程', '微电子科学与工程', '数据科学与大数据技术', '电子信息工程', '计算机科学与技术',
        '信息安全', '人工智能'],
    ['软件工程'],
    ['光电信息科学与工程', '应用物理学'],
    ['海洋技术', '地球物理学', '海洋科学'],
    ['统计学', '数学与应用数学'],
    ['应用化学', '化学工程与工艺'],
    ['生物技术', '生物信息学'],
    ['口腔医学'],
    ['临床医学', '护理学', '康复物理治疗'],
    ['机械电子工程', '汽车服务工程', '建筑电气与智能化'],
    ['马克思主义理论'],
    ['运动训练'],
    ['其它专业']
]

p = len(parameters)
print("Id,Username,Password,Email,Phone,Campus,PayPassword,StuName,StuYear,StuSchool,StuMajor,StuNotes,Expect Output,"
      "Actual Output,Result,Analysis Strategy,Time,Person,Defect Description")

for i, pair in enumerate(AllPairs(parameters)):
    print(f"{i + 1},", end="")

    for j in range(p - 1):
        if j == 0:
            print(f"{generate_letter_or_digit(8, 16, True)},", end="")
        elif j == 1:
            print(f"{generate_upper_lower_digit(8, 24)},", end="")
        elif j == 2:
            print(f"{generate_letter_or_digit(1, 64, True)},", end="")
        elif j == 3:
            print(f"{generate_letter_or_digit(11, 11, False)},", end="")
        elif j == 5:
            print(f"{generate_letter_or_digit(6, 6, False)},", end="")
        elif j == 6:
            print(f"{generate_letter_or_digit(1, 64, True)},", end="")
        elif j in [4, 7, 8]:
            print(f"{pair[j]},", end="")

    school = parameters[8].index(pair[8])
    total = len(majors[school])
    index = random.randint(0, total - 1)
    print(f"{majors[school][index]},{generate_letter_or_digit(1, 128, True)},student register success,,,正交实验法,,,")