import argparse, os, re, subprocess, random, clingo
from subprocess import getoutput

def get_model(m):
        global model
        model = str(m)

def plan_exists(robot_id): # checks if instance contains plans
	present = True
	with open(args.instance,'r') as instance_file:
		if (re.search(robot_id + '\),action\(move', instance_file.read())) is None: present = False
	return(present)

def error_check(output): # checks output for errors and unsatisfiability
	if (re.search('ERROR', output)):
		print(output)
		exit()
	elif output == '':
		print('UNSAT (faulty encoding)')
		exit()
	else: return(False)

def resolve(typ, robot_id):
        ctl = clingo.Control(['-c fixed=' + str(robot_id)])
        ctl.load('encoding/' + typ + '_fixed.lp')
        ctl.load('temp.lp')
        ctl.ground([("base", [])])
        ctl.solve(on_model=get_model)
        model_with_space = model + ' '
        model_with_dots = model_with_space.replace(" ", ". ")
        error_check(model_with_dots)
        with open('temp.lp', "w") as temp:
                temp.write(model_with_dots)

def conflict(typ, robot_id): # checks plan for vertex or edge conflicts
        ctl = clingo.Control(['-c fixed=' + str(robot_id)])
        ctl.load('encoding/test_' + typ + '_fixed.lp')
        ctl.load('temp.lp')
        ctl.ground([("base", [])])
        ctl.solve(on_model=get_model)
        return(model)

def num_robots(instance): # gets highest number of robot ID from instance
        num=0
        tmp=instance.split('init(object(robot,')
        for par in tmp:
                if '),' in par:
                        new_str = par.split('),')[0]
                        if new_str.isdigit():
                                new = int(new_str)
                                if new > num:
                                        num = new
        return(num)

def append_robot_init(instance, robot_id): # appends init and path of robot to the temporary solution
        instance_splitted = instance.split('\n')
        init = ''
        for line in instance_splitted:
                if 'robot,' + str(robot_id) + ')' in line:
                	if 'value(at' in line or 'action(move' in line: init = init + line + '\n'
        with open('temp.lp', "a") as temp:
                temp.write(init)

def write_basic_init(instance): # appends init nodes and shelves to the temporary solution
        init = ''
        instance_splitted = instance.split('\n')
        for line in instance_splitted:
                if 'node' in line or 'shelf' in line : init = init + line + '\n'
        with open('temp.lp', "w") as temp:
                temp.write(init)

def prio(): # merges plans by using priorities
	with open(args.instance, "r") as inst:
		instance = inst.read()
	num_rob = num_robots(instance)
	order = list(range(1, num_rob+1)) # init priorities
	if args.retries: retries_robot = args.retries + 1 # set number of retries per robot
	else: retries_robot = num_rob
	retry = True
	while retry:
		retry = False
		random.shuffle(order)
		write_basic_init(instance)
		for robot_id in order:
			append_robot_init(instance, robot_id)
			if robot_id != order[0]:
				count = 0
				count_rep = 0
				v_cs = conflict('vc', robot_id)
				if v_cs == '': e_cs = conflict('ec', robot_id)
				v_cs_before = ''
				v_cs_befbef = ''
				while v_cs != '' or e_cs != '':
					count = count + 1
					if robot_id==1: retry=True
					if robot_id==1: break
					if v_cs != '':
						resolve('vertex', robot_id)
						e_cs = conflict('ec', robot_id)
					if e_cs != '':
						resolve('edge', robot_id)
						e_cs = conflict('ec', robot_id)
					v_cs_befbef = v_cs_before
					v_cs_before = v_cs
					v_cs = conflict('vc', robot_id)
					if (v_cs_before in v_cs and v_cs_before!='') or (v_cs_befbef in v_cs and v_cs_befbef!=''): count_rep = count_rep + 1
					if count == retries_robot or count_rep == 2: retry = True
					if retry: break
				if retry: break

def single():
	with open(args.instance, "r") as inst:
		instance = inst.read()
	with open(args.instance, "a") as instance_file:
		instance_file.write("\n%plan")
	for robot_id in (range(1, num_robots(instance)+1)):
		horizon=0
		while not plan_exists(str(robot_id)):
			print('Try with horizon = ' + str(horizon))
			output = getoutput('clingo encoding/single_agent.lp -c robot_id=' + str(robot_id) + ' -c horizon=' + str(horizon) + ' ' + args.instance + ' -V0 --out-atomf=%s. --out-ifs="\n" | head -n -1')
			if output != '':
				with open(args.instance, "a") as instance:
					instance.write("\n" + output)
				print('Appended shortest path of robot ' + str(robot_id) + ' to instance file!')	
			else: horizon = horizon+1

parser = argparse.ArgumentParser()

parser.add_argument("-i", "--instance",	help="Instance file",					required=True)
parser.add_argument("-r", "--retries",	help="Number of retries per robot",		  	type=int)
parser.add_argument("-s", "--single",		help="Get single agent plans and add to instance",  	action='store_true')
parser.add_argument("-v", "--visualize",	help="Visualize output with asprilo visualizer",    	action='store_true')
#parser.add_argument("-b", "--benchmark",	help="Analyze runtimes",       			action='store_true')

args = parser.parse_args()

if args.single: single()
else: prio()
if args.visualize: os.system('viz -p temp.lp')
