from pyats import aetest
from pyats.topology import loader
import socket
import time

class CommonSetup(aetest.CommonSetup):
    @aetest.subsection
    def load_testbed(self):
        testbed = loader.load('testbed.yaml')
        self.parent.parameters.update(testbed=testbed)

class TestSIPPortForwarding(aetest.Testcase):
    @aetest.setup
    def setup(self):
        # Define SIP ports to test
        self.sip_ports = [5060, 5061]  # Standard SIP ports - adjust as needed
        
        # Get WAN IP of pfSense router - you'll need to define how to obtain this
        # This is placeholder code:
        self.pfsense_wan_ip = "YOUR_WAN_IP"  # Replace with actual WAN IP or method to get it
        
        # Get the SOHO router IP where SIP should be forwarded
        self.soho_ip = self.parent.parameters['testbed'].devices['soho_router'].connections.cli.ip
        
    @aetest.test
    def test_sip_ports_open(self):
        # Test if SIP ports are accessible from WAN and forwarded correctly
        for port in self.sip_ports:
            # Test if port is open on pfSense WAN
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(2)
            try:
                s.connect((self.pfsense_wan_ip, port))
                s.close()
                self.passed(f"SIP port {port} is open on WAN IP {self.pfsense_wan_ip}")
            except socket.error:
                self.failed(f"SIP port {port} is NOT open on WAN IP {self.pfsense_wan_ip}")
                
            # You could add additional tests here to verify the traffic is properly forwarded
            # This would require more sophisticated testing tools or packet capture analysis

if __name__ == '__main__':
    from pyats.topology import loader
    from pyats import reporter
    
    reporter.configure(logdir='./logs')
    aetest.main()