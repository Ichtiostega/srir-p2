GXX=UPCXX_GASNET_CONDUIT=udp upcxx -O2
EXEC=mc_temp_propagation_upc

$(EXEC): $(EXEC).cpp
	$(GXX) -o $@ $<

run: nodes $(EXEC)
	upcxx-run -shared-heap 256M -n $(n) $$(upcxx-nodes nodes) $(EXEC) $(args)

test: nodes $(EXEC)
	upcxx-run -shared-heap 256M -n $(n) $$(upcxx-nodes nodes) $(EXEC) 0.01 10 10
	@echo "Expected value: ~25"i
	@echo  
	upcxx-run -shared-heap 256M -n $(n) $$(upcxx-nodes nodes) $(EXEC) 0.01 10 1
	@echo "Expected value: ~90"
	@echo 
	upcxx-run -shared-heap 256M -n $(n) $$(upcxx-nodes nodes) $(EXEC) 0.01 10 19
	@echo "Expected value: ~1.73"
	@echo  
	upcxx-run -shared-heap 256M -n $(n) $$(upcxx-nodes nodes) $(EXEC) 0.01 19 19
	@echo "Expected value: ~0.27"
	@echo  
	upcxx-run -shared-heap 256M -n $(n) $$(upcxx-nodes nodes) $(EXEC) 0.01 1 1
	@echo "Expected value: ~50"
nodes:
	- /opt/nfs/config/station_name_list.sh 101 116 > nodes

clean:
	- rm $(EXEC) nodes

