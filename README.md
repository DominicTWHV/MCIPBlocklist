# MCIPBlocklist
A list of IPs that my own system gathered running https://github.com/DominicTWHV/Anti_Server_Scanner

# To use:

Clone the repo at https://github.com/DominicTWHV/Anti_Server_Scanner

Make sure you have iptables and ipset installed on your system.

You do NOT need a proxy server to use the set, however, it is required if you wish to use the main script (https://github.com/DominicTWHV/Anti_Server_Scanner)

```bash
git clone https://github.com/DominicTWHV/Anti_Server_Scanner.git
cd Anti_Server_Scanner
git clone https://github.com/DominicTWHV/MCIPBlocklist.git
sudo chmod +x *.sh
```

**Running:**

```bash
./block.sh
```

Then enter 'set.txt` when prompted for file path.

---

# Disclaimer:

The set may contain false IPs flagged by the automated script, try disabling the set if you have issues with specific players.

Additionally, you may want to set up your own script, just clone the repository at `https://github.com/DominicTWHV/Anti_Server_Scanner` and read the instructions there for setting up.

**Pull requests welcome!**
