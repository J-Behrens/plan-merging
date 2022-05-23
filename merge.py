#TODO: github upload and readme, replace open read in plan_exists() with with open as ... , cleanup temp.lp in merge() afterwards, write test() ?

import argparse, os, re
from subprocess import getoutput
import subprocess

def plan_exists():
	present = True
	instance_file = open(INSTANCE,'r')
	if (re.search('%plan', instance_file.read())) is None:
		present = False
	instance_file.close()
	return(present)

def merge():
	output = getoutput('clingo ' + INSTANCE + ' ' + args.encoding + ' -V0 --out-atomf=%s. | head -n -1')
	with open('temp.lp', "w") as temp:
		temp.write(output)
	while (re.search('vc', getoutput('clingo temp.lp encoding/test.lp -V0 --out-atomf=%s. | head -n -1'))) is not None:
		output = getoutput('clingo temp.lp ' + args.encoding + ' -V0 --out-atomf=%s. | head -n -1')
		with open('temp.lp', "w") as temp:
			temp.write(output)
	return(output)	#saveToFile(args.instance + '_merged', output, 1)
	
def single():
	if not plan_exists():
		output = getoutput('clingo encoding/single_agent.lp -c horizon=' + str(args.single) + ' ' + INSTANCE + ' -V0 --out-atomf=%s. --out-ifs="\n" | head -n -1')
		with open(args.instance, "a") as instance:
			instance.write("\n%plan\n" + output)
		print("Appended single agent plans to instance file!")
	else:	print("Instance already contains single agent plans!")
	
#TODO def visualize():

parser = argparse.ArgumentParser()

parser.add_argument("-i", "--instance",	help="Instance file",					required=True)
parser.add_argument("-e", "--encoding",	help="Merging encoding",	     			type=str)
parser.add_argument("-s", "--single",		help="Get single agent plans",     			type=int)
parser.add_argument("-t", "--test",		help="Test merging encoding",	      			action='store_true')
parser.add_argument("-v", "--visualize",	help="Visualize output with asprilo visualizer",    	action='store_true')
#parser.add_argument("-b", "--benchmark",	help="Analyze runtimes",       			action='store_true')

args = parser.parse_args()

INSTANCE = args.instance

if args.encoding and args.single:			print("INFO: --single does not require encoding, ignoring --encoding " + args.encoding)
if args.encoding and args.single and args.test:	print("INFO: --single and --test incompatible; --single ignored, testing encoding!")
if not args.encoding and args.test:		 parser.error("Please specify encoding to be tested by using --encoding ENCODING.")

if args.single: single()
if args.encoding is not None: print(merge())
#TODO: if args.visualize: visualize()
