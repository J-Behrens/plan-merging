import argparse, os, re, subprocess
from subprocess import getoutput

def plan_exists():
	present = True
	instance_file = open(INSTANCE,'r')
	if (re.search('%plan', instance_file.read())) is None:
		present = False
	instance_file.close()
	return(present)

def wait():
	output = getoutput('clingo ' + INSTANCE + ' ' + args.encoding + ' -V0 --out-atomf=%s. | head -n -1')
	with open('temp.lp', "w") as temp:
		temp.write(output)
	print('Vertex conflict resolved!')
	while (re.search('vc', getoutput('clingo temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		output = getoutput('clingo temp.lp ' + args.encoding + ' -V0 --out-atomf=%s. | head -n -1')
		with open('temp.lp', "w") as temp:
			temp.write(output)
		print('Vertex conflict resolved!')
	
def edge():
	output = getoutput('clingo ' + INSTANCE + ' encoding/edge.lp -V0 --out-atomf=%s. | head -n -1')
	with open('temp.lp', "w") as temp:
		temp.write(output)
	print('Edge conflict resolved!')
	while (re.search('ec', getoutput('clingo temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		output = getoutput('clingo temp.lp encoding/edge.lp -V0 --out-atomf=%s. | head -n -1')
		with open('temp.lp', "w") as temp:
			temp.write(output)
		print('Edge conflict resolved!')

def merge_alternating():
	with open('temp.lp', "w") as temp:
		temp.write('')
	if (re.search('vc', getoutput('clingo ' + INSTANCE + ' temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		output = getoutput('clingo ' + INSTANCE + ' ' + args.encoding + ' -V0 --out-atomf=%s. | head -n -1')
		with open('temp.lp', "w") as temp:
			temp.write(output)
	elif (re.search('ec', getoutput('clingo ' + INSTANCE + ' temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		print('Edge conflict(s) found!')
		output = getoutput('clingo ' + INSTANCE + ' encoding/edge.lp -V0 --out-atomf=%s. | head -n -1')
		with open('temp.lp', "w") as temp:
			temp.write(output)
	while (re.search('vc', getoutput('clingo temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None or (re.search('ec', getoutput('clingo temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		if (re.search('vc', getoutput('clingo temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
			output = getoutput('clingo temp.lp ' + args.encoding + ' -V0 --out-atomf=%s. | head -n -1')
			with open('temp.lp', "w") as temp:
				temp.write(output)
			print('Vertex conflict resolved!')
		if (re.search('ec', getoutput('clingo temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
			output = getoutput('clingo temp.lp encoding/edge.lp -V0 --out-atomf=%s. | head -n -1')
			with open('temp.lp', "w") as temp:
				temp.write(output)
			print('Edge conflict resolved!')

def merge_vc_first():
	with open('temp.lp', "w") as temp:
		temp.write('')
	if (re.search('vc', getoutput('clingo ' + INSTANCE + ' temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		print('Vertex conflict(s) found!')
		wait()
	elif (re.search('ec', getoutput('clingo ' + INSTANCE + ' temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		print('Edge conflict(s) found!')
		edge()	
	while (re.search('vc', getoutput('clingo temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None or (re.search('ec', getoutput('clingo temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		if (re.search('vc', getoutput('clingo temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
			print('Vertex conflict(s) found!')
			wait()
		if (re.search('ec', getoutput('clingo temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
			print('Edge conflict(s) found!')
			edge()
	print('All conflicts resolved!')

def merge_ec_first():
	with open('temp.lp', "w") as temp:
		temp.write('')
	if (re.search('ec', getoutput('clingo ' + INSTANCE + ' encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		print('Edge conflict(s) found!')
		edge()
	elif (re.search('vc', getoutput('clingo ' + INSTANCE + ' encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		print('Vertex conflict(s) found!')
		wait()	
	while (re.search('ec', getoutput('clingo temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None or (re.search('vc', getoutput('clingo temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		if (re.search('ec', getoutput('clingo temp.lp encoding/test_ec.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
			print('Edge conflict(s) found!')
			edge()
		if (re.search('vc', getoutput('clingo temp.lp encoding/test_vc.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
			print('Vertex conflict(s) found!')
			wait()
	print('All conflicts resolved!')


def single():
	if plan_exists(): print("Instance already contains single agent plans!")
	horizon=0
	while not plan_exists():
		print('Try with horizon = ' + str(horizon))
		output = getoutput('clingo encoding/single_agent.lp -c horizon=' + str(horizon) + ' ' + INSTANCE + ' -V0 --out-atomf=%s. --out-ifs="\n" | head -n -1')
		if output != '':
			with open(args.instance, "a") as instance:
				instance.write("\n%plan\n" + output)
			print("Appended single agent plans to instance file!")
			print("Horizon=" + str(horizon))	
		else: horizon = horizon+1
		
parser = argparse.ArgumentParser()

parser.add_argument("-i", "--instance",	help="Instance file",					required=True)
parser.add_argument("-e", "--encoding",	help="Merging encoding",				type=str)
parser.add_argument("-s", "--single",		help="Get single agent plans",  		  	action='store_true')
parser.add_argument("-v", "--visualize",	help="Visualize output with asprilo visualizer",    	action='store_true')
#parser.add_argument("-b", "--benchmark",	help="Analyze runtimes",       			action='store_true')

args = parser.parse_args()

INSTANCE = args.instance

if args.single: single()
if args.encoding is not None:
	merge_alternating() # or
	#merge_ec_first()   # or
	#merge_vc_first()
if args.visualize: os.system('viz -p temp.lp')
