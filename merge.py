import argparse, os, re, subprocess, random, shutil
from subprocess import getoutput

def plan_exists(): # checks if instance contains plans
	present = True
	with open(args.instance,'r') as instance_file:
		if (re.search('move', instance_file.read())) is None: present = False
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
	output = getoutput('clingo temp.lp encoding/' + typ + '_fixed.lp -V0 --out-atomf=%s. -c fixed=' + str(robot_id) + ' | head -n -1')
	error_check(output)
	with open('temp.lp', "w") as temp:
		temp.write(output)

def conflict(typ, robot_id): # checks plan for vertex or edge conflicts
	return getoutput('clingo temp.lp encoding/test_' + typ + '_fixed.lp -V0 -c fixed=' + str(robot_id) + '| head -n -1')

def num_robots(): # counts number of robots in plans of instance
	num_robots = getoutput('clingo encoding/numR.lp ' + args.instance + ' -V0| head -n -1')
	return int((num_robots.split('('))[1].split(')')[0])

def append_robot_init(robot_id): # appends init and path of robot to the temporary solution
	init = getoutput('clingo encoding/get_robot_init.lp -c id=' + str(robot_id) + ' ' + args.instance + ' -V0 --out-atomf=%s. | head -n -1')
	with open('temp.lp', "a") as temp:
		temp.write(init)

def append_basic_init(): # appends init of shelves, products, nodes and orders to the temporary solution
	init = getoutput('clingo encoding/get_basic_init.lp ' + args.instance + ' -V0 --out-atomf=%s. | head -n -1')
	with open('temp.lp', "a") as temp:
		temp.write(init)

def prio(): # merges plans by using priorities
	num_rob = num_robots()
	order = list(range(1, num_rob+1)) # init priorities
	if args.retries: retries_robot = args.retries + 1 # set number of retries per robot
	else: retries_robot = num_rob + 1
	stop = False
	retry = True
	while retry:
		with open('temp.lp', "w") as temp:
			temp.write('')
		random.shuffle(order)
		append_basic_init()
		for robot_id in order:
			append_robot_init(robot_id)
			if robot_id != order[0]:
				count = 0
				count_rep = 0
				e_cs = conflict('ec', robot_id)
				v_cs = conflict('vc', robot_id)
				v_cs_before = ''
				v_cs_befbef = ''
				while v_cs != '' or e_cs != '':
					count = count + 1
					if v_cs != '': resolve('vertex', robot_id)
					e_cs = conflict('ec', robot_id)
					if e_cs != '': resolve('edge', robot_id)
					if count > 0: v_cs_befbef = v_cs_before
					v_cs_before = v_cs
					v_cs = conflict('vc', robot_id)
					e_cs = conflict('ec', robot_id)
					if (v_cs_before in v_cs and v_cs_before!='') or (v_cs_befbef in v_cs and v_cs_befbef!=''):
						count_rep = count_rep + 1
						if count_rep==2: break
					if count == retries_robot: break
				if count_rep==2: break
				if count == retries_robot:
					retry = True
					break
		if count != retries_robot and count_rep!=2:
			retry = False

def single():
	if plan_exists(): print("Instance already contains single agent plans!")
	horizon=0
	while not plan_exists():
		print('Try with horizon = ' + str(horizon))
		output = getoutput('clingo encoding/single_agent.lp -c horizon=' + str(horizon) + ' ' + args.instance + ' -V0 --out-atomf=%s. --out-ifs="\n" | head -n -1')
		if output != '':
			with open(args.instance, "a") as instance:
				instance.write("\n%plan\n" + output)
			print("Appended single agent plans to instance file!")
			print("Horizon=" + str(horizon))	
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
