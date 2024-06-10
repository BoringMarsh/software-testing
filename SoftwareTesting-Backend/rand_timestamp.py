import random
from datetime import datetime, timedelta


def random_datetime(start, end):
    """
    Generate a random datetime between `start` and `end`.

    :param start: The start datetime (inclusive).
    :param end: The end datetime (inclusive).
    :return: A random datetime between `start` and `end`.
    """
    delta = end - start
    int_delta = delta.total_seconds()
    random_second = random.randint(0, int_delta)
    return start + timedelta(seconds=random_second)


# Define the start and end datetime
start_date = datetime.strptime('2000-01-01 00:00:00', '%Y-%m-%d %H:%M:%S')
end_date = datetime.strptime('2024-06-05 10:23:34', '%Y-%m-%d %H:%M:%S')


for i in range(100):
    # Generate a random datetime
    random_date = random_datetime(start_date, end_date)

    # Format the datetime to the desired format
    formatted_random_date = random_date.strftime('%Y-%m-%d %H:%M:%S')

    print(formatted_random_date)
