from pyats import aetest
from pyats.topology import loader
import subprocess
import time

class CommonSetup(aetest.CommonSetup):
    @aetest.subsection
    def load_testbed(self):
        # Load testbed file
        testbed = loader.load('testbed.yaml')
        self.parent.parameters.update(testbed=testbed)

class TestBasicConnectivity(aetest.Testcase):
    @aetest.test
    def test_pfsense_reachable(self):
        # Test pfSense router reachability
        pfsense_ip = self.parent.parameters['testbed'].devices['pfsense_router'].connections.cli.ip
        result = subprocess.run(['ping', '-c', '4', pfsense_ip], 
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        assert result.returncode == 0, f"pfSense router at {pfsense_ip} is not reachable"
        
    @aetest.test
    def test_soho_reachable(self):
        # Test SOHO router reachability
        soho_ip = self.parent.parameters['testbed'].devices['soho_router'].connections.cli.ip
        result = subprocess.run(['ping', '-c', '4', soho_ip], 
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        assert result.returncode == 0, f"SOHO router at {soho_ip} is not reachable"

class CommonCleanup(aetest.CommonCleanup):
    @aetest.subsection
    def clean_everything(self):
        # Any cleanup code needed
        pass

if __name__ == '__main__':
    from pyats.topology import loader
    from pyats import reporter
    
    # Define a reporter for better result visualization
    reporter.configure(logdir='./logs')
    
    # Run the tests
    aetest.main()