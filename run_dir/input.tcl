assertion -summary -final
database -open waves.shm -shm
probe apb_top_testbench -all -depth all -shm -database waves.shm 

assertion -logging -state none -all
run
assertion -summary
