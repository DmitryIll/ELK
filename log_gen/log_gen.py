import argparse
import datetime
import json
import os

def  get_params():

    parser = argparse.ArgumentParser()
    parser.add_argument('level', choices=['info', 'error', 'warning', 'debug',])
    parser.add_argument('-m', '--msg')
    params = parser.parse_args()

    return params.level, params.msg

BASE_DIR = os.path.dirname(os.path.abspath(__file__))


if __name__ == '__main__':

    level, msg = get_params()

    log = {
        'level': level, 
        'msg': msg,
        'asctime': datetime.datetime.utcnow().isoformat(timespec='milliseconds', sep=' ')
    }

    with open(os.path.join(BASE_DIR, 'log_gen.log'), 'a') as f:
        f.write(json.dumps(log) + '\n')