current_month=`date +%Y/%m`
cleaning=50
elec_prefix='elec'
water_prefix='water'
stair_elec_id=790
basement_elec_id=789
data_file=egar.csv

water_fee=`cat $water_prefix/$current_month|tr -d ' '`
stair_fee=`awk "/^$stair_elec_id/{print \\$2}" $elec_prefix/$current_month`
basement_fee=`awk "/^$basement_elec_id/{print \\$2}" $elec_prefix/$current_month`

echo b $basement_fee s $stair_fee w $water_fee

awk 	-v water_fee=$water_fee \
	-v stair_fee=$stair_fee \
	-v basement_fee=$basement_fee \
	-v cleaning=$cleaning \
	-v elec_file=$elec_prefix/$current_month \
	'{
	if(NR==1||$1==""){next};
	"awk   \"/^"$3"/{print \\$2}\"   "elec_file|getline elec; 
	#print $3,elec; 
	printf("=====\nNo:\t%8d\nName:\tMr. %s %3d\nEgar:\t%8.2f\nElec:\t%8.2f\nWater:\t%8.2f\nSellem:\t%8.2f\nBadrom:\t%8.2f\nNadafa:\t%8.2f\nTOTAL:\t%8.2f\n=====\n", 
	$1,
	$2,
	$3,
	$4,
	elec,
	water_fee/7.5,
	stair_fee/7,
	basement_fee/7,
	cleaning,$4+(stair_fee+basement_fee)/7+water_fee/7.5+cleaning+elec);
	elec=0;
	}' $data_file
