.PHONY: all clean

# create a minimal directory to be included in the fpga image
splash3 :
	mkdir -p                                       $@/codes/apps/barnes/inputs
	cp apps/barnes/BARNES                          $@/codes/apps/barnes/
	cp apps/barnes/inputs/n16384-p2                $@/codes/apps/barnes/inputs/

	mkdir -p                                       $@/codes/apps/fmm/inputs
	cp apps/fmm/FMM                                $@/codes/apps/fmm/
	cp apps/fmm/inputs/input.2.16384               $@/codes/apps/fmm/inputs/

	mkdir -p                                       $@/codes/apps/ocean/contiguous_partitions
	cp apps/ocean/contiguous_partitions/OCEAN      $@/codes/apps/ocean/contiguous_partitions/

	mkdir -p                                       $@/codes/apps/radiosity
	cp apps/radiosity/RADIOSITY                    $@/codes/apps/radiosity/

	mkdir -p                                       $@/codes/apps/raytrace/inputs
	cp apps/raytrace/RAYTRACE                      $@/codes/apps/raytrace/
	cp apps/raytrace/inputs/car.*                  $@/codes/apps/raytrace/inputs/

	mkdir -p                                       $@/codes/apps/water-nsquared/inputs
	cp apps/water-nsquared/WATER-NSQUARED          $@/codes/apps/water-nsquared/
	cp apps/water-nsquared/random.in               $@/codes/apps/water-nsquared/
	cp apps/water-nsquared/inputs/n512-p2          $@/codes/apps/water-nsquared/inputs/

	mkdir -p                                       $@/codes/apps/water-spatial/inputs
	cp apps/water-spatial/WATER-SPATIAL            $@/codes/apps/water-spatial/
	cp apps/water-spatial/random.in                $@/codes/apps/water-spatial/
	cp apps/water-spatial/inputs/n512-p2           $@/codes/apps/water-spatial/inputs/

	mkdir -p                                       $@/codes/kernels/cholesky/inputs
	cp kernels/cholesky/CHOLESKY                   $@/codes/kernels/cholesky/
	cp kernels/cholesky/inputs/tk15.O              $@/codes/kernels/cholesky/inputs/

	mkdir -p                                       $@/codes/kernels/fft
	cp kernels/fft/FFT                             $@/codes/kernels/fft/

	mkdir -p                                       $@/codes/kernels/lu/contiguous_blocks
	cp kernels/lu/contiguous_blocks/LU             $@/codes/kernels/lu/contiguous_blocks/

	mkdir -p                                       $@/codes/kernels/lu/non_contiguous_blocks
	cp kernels/lu/non_contiguous_blocks/LU         $@/codes/kernels/lu/non_contiguous_blocks/

	mkdir -p                                       $@/codes/kernels/radix
	cp kernels/radix/RADIX                         $@/codes/kernels/radix/


splash3/runtest : splash3
	echo "cd /perf/splash3/codes/apps/barnes" > $@
	echo "./BARNES < inputs/n16384-p2" >> $@
	echo "./BARNES < inputs/n16384-p2" >> $@

	echo "cd /perf/splash3/codes/apps/fmm" >> $@
	echo "./FMM < inputs/input.2.16384" >> $@
	echo "./FMM < inputs/input.2.16384" >> $@

	echo "cd /perf/splash3/codes/apps/ocean/contiguous_partitions" >> $@
	echo "./OCEAN -p2 -n258" >> $@
	echo "./OCEAN -p2 -n258" >> $@

	echo "cd /perf/splash3/codes/apps/radiosity" >> $@
	echo "./RADIOSITY -p 2 -ae 5000 -bf 0.1 -en 0.05 -room -batch" >> $@
	echo "./RADIOSITY -p 2 -ae 5000 -bf 0.1 -en 0.05 -room -batch" >> $@

	echo "cd /perf/splash3/codes/apps/raytrace" >> $@
	echo "./RAYTRACE -p2 -m64 inputs/car.env" >> $@
	echo "./RAYTRACE -p2 -m64 inputs/car.env" >> $@

	echo "cd /perf/splash3/codes/apps/water-nsquared" >> $@
	echo "./WATER-NSQUARED < inputs/n512-p2" >> $@
	echo "./WATER-NSQUARED < inputs/n512-p2" >> $@

	echo "cd /perf/splash3/codes/apps/water-spatial" >> $@
	echo "./WATER-SPATIAL < inputs/n512-p2" >> $@
	echo "./WATER-SPATIAL < inputs/n512-p2" >> $@

	echo "cd /perf/splash3/codes/kernels/cholesky" >> $@
	echo "./CHOLESKY -p2 < inputs/tk15.O" >> $@
	echo "./CHOLESKY -p2 < inputs/tk15.O" >> $@

	echo "cd /perf/splash3/codes/kernels/fft" >> $@
	echo "./FFT -p2 -m16" >> $@
	echo "./FFT -p2 -m16" >> $@

	echo "cd /perf/splash3/codes/kernels/lu/contiguous_blocks" >> $@
	echo "./LU -p2 -n512" >> $@
	echo "./LU -p2 -n512" >> $@

	echo "cd /perf/splash3/codes/kernels/lu/non_contiguous_blocks" >> $@
	echo "./LU -p2 -n512" >> $@
	echo "./LU -p2 -n512" >> $@

	echo "cd /perf/splash3/codes/kernels/radix" >> $@
	echo "./RADIX -p2 -n1048576" >> $@
	echo "./RADIX -p2 -n1048576" >> $@

	chmod +x $@

all:
	$(MAKE) -C apps/barnes
	$(MAKE) -C apps/fmm
	$(MAKE) -C apps/ocean/contiguous_partitions
	# $(MAKE) -C apps/ocean/non_contiguous_partitions
	$(MAKE) -C apps/radiosity
	$(MAKE) -C apps/raytrace
	# $(MAKE) -C apps/volrend
	$(MAKE) -C apps/water-nsquared
	$(MAKE) -C apps/water-spatial
	$(MAKE) -C kernels/cholesky
	$(MAKE) -C kernels/fft
	$(MAKE) -C kernels/lu/contiguous_blocks
	$(MAKE) -C kernels/lu/non_contiguous_blocks
	$(MAKE) -C kernels/radix
	$(MAKE)  splash3/runtest

clean:
	rm -rf splash3
	$(MAKE) -C apps/barnes clean
	$(MAKE) -C apps/fmm clean
	$(MAKE) -C apps/ocean/contiguous_partitions clean
	# $(MAKE) -C apps/ocean/non_contiguous_partitions clean
	$(MAKE) -C apps/radiosity clean
	$(MAKE) -C apps/raytrace clean
	# $(MAKE) -C apps/volrend clean
	$(MAKE) -C apps/water-nsquared clean
	$(MAKE) -C apps/water-spatial clean
	$(MAKE) -C kernels/cholesky clean
	$(MAKE) -C kernels/fft clean
	$(MAKE) -C kernels/lu/contiguous_blocks clean
	$(MAKE) -C kernels/lu/non_contiguous_blocks clean
	$(MAKE) -C kernels/radix clean
