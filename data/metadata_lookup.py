import glob
import csv
import os

g = glob.iglob('./*/**')
d = {}


for f in g:
	f_name = os.path.basename(f)
	age, gender = 0, 0

	age = f_name.split('_age_')[1].split('_')[0]
	gender = f_name.split('_gender_')[1][0]

	d[f_name] = (age, gender)

# print(d)


with open('metadata_lookup.csv', 'w', encoding='utf8', newline='') as f:
	writer = csv.writer(f)
	writer.writerows([[k, v[0], v[1]]for k, v in d.items()])