## Network Testing using pyATS

### Getting Started

1. Setting up your environment

```
# Create and activate virtual environment
python -m venv pyats_env
source pyats_env/bin/activate  # On Windows: pyats_env\Scripts\activate

# Install pyATS and its components
pip install pyats
pip install pyats.contrib
pip install genie
```

2. Create a YAML file that defines your network
3. Run tests:

```
python test_connectivity.py
python test_sip_forwarding.py
```
