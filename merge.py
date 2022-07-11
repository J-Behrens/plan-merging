import argparse, os, re, subprocess, random, shutil
from subprocess import getoutput

def write_instance(dest):
	with open(args.instance, "r") as inst:
		with open(dest, "w") as fu:
			fu.write(inst.read())	

def plan_exists():
	present = True
	instance_file = open(args.instance,'r')
	if (re.search('%plan', instance_file.read())) is None:
		present = False
	instance_file.close()
	return(present)
			
def alt_fixed(robot_id):
	if v_conflict():
		output = getoutput('clingo temp.lp encoding/vertex_fixed.lp -V0 --out-atomf=%s. -c fixed=' + str(robot_id) + ' | head -n -1')
		if error(output):
			print(output)
			return(True)
		else:
			with open('temp.lp', "w") as temp:
				temp.write(output)
	if e_conflict():
		output = getoutput('clingo temp.lp encoding/edge_fixed.lp -V0 --out-atomf=%s. -c fixed=' + str(robot_id) + ' | head -n -1')
		if error(output):
			print(output)
			return(True)
		else:
			with open('temp.lp', "w") as temp:
				temp.write(output)

def error(output):
	if (re.search('ERROR', output)) is None and output != '': return(False)
	else: return(True)
		
def v_conflict():
	if (re.search('vc', getoutput('clingo temp.lp encoding/test_vc.lp -V0 | head -n -1'))) is None: return(False)
	else: return(True)	
		
def e_conflict():
	if (re.search('ec', getoutput('clingo temp.lp encoding/test_ec.lp -V0 | head -n -1'))) is None: return(False)
	else: return(True)	
		
def conflict():
	if v_conflict() or e_conflict(): return(True)
	else: return(False)
		
def prio():
	num_robots = getoutput('clingo encoding/numR.lp ' + args.instance + ' -V0| head -n -1')
	num_robots = int((num_robots.split('('))[1].split(')')[0])
	order = list(range(1, num_robots+1))
	stop = False
	retry = True
	while retry:
		with open('temp.lp', "w") as temp:
			temp.write('')
		random.shuffle(order)
		print(order)
		
		for robot_id in order:
			init = getoutput('clingo encoding/get_init.lp -c id=' + str(robot_id) + ' ' + args.instance + ' -V0 --out-atomf=%s. | head -n -1')
			with open('temp.lp', "a") as temp:
				temp.write(init)
			path = getoutput('clingo encoding/get_path.lp -c id=' + str(robot_id) + ' ' + args.instance + ' -V0 --out-atomf=%s. | head -n -1')
			with open('temp.lp', "a") as temp:
				temp.write(path)
			if robot_id != order[0]:
				count = 0
				count_rep = 0
				while conflict():
					count = count + 1
					shutil.copyfile('temp.lp', 'temp-1.lp')
					if alt_fixed(robot_id):
						stop = True
						break
					v_cs        = getoutput('clingo temp.lp   encoding/test_vc_fixed.lp -V0 -c fixed=' + str(robot_id) + '| head -n -1')
					v_cs_before = getoutput('clingo temp-1.lp encoding/test_vc_fixed.lp -V0 -c fixed=' + str(robot_id) + '| head -n -1')
					e_cs        = getoutput('clingo temp.lp   encoding/test_ec_fixed.lp -V0 -c fixed=' + str(robot_id) + '| head -n -1')
					e_cs_before = getoutput('clingo temp-1.lp encoding/test_ec_fixed.lp -V0 -c fixed=' + str(robot_id) + '| head -n -1')
					
					if v_cs_before in v_cs and e_cs==e_cs_before:
						count_rep = count_rep + 1
						if count_rep==2: break
					if count == 20: break
				if count_rep==2: break
				if count == 20:
					retry = True
					break
			if stop:
				retry = False
				break
		if count != 20 and count_rep!=2:
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
parser.add_argument("-s", "--single",		help="Get single agent plans and add to instance",  	action='store_true')
parser.add_argument("-v", "--visualize",	help="Visualize output with asprilo visualizer",    	action='store_true')
#parser.add_argument("-b", "--benchmark",	help="Analyze runtimes",       			action='store_true')

args = parser.parse_args()

if args.single: single()
else: prio()
if args.visualize: os.system('viz -p temp.lp')
