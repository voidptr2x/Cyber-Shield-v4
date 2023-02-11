<div align="center"<
<h1>Cyber Shield v4.0.0</h1>
<p>The Future Of Cyber Of Protection</p>
</div>
<div align="center">

[Official Website](https://cybershield.shop/) |
[Shield v4.0 Discord](https://discord.gg/Aj8CYnx79V) |
[Shield Community Discord](https://discord.gg/CyberShield) 


</div>

### Features Of Cyber Shield v4.0

- Optional TUI mode with ``-tui`` flag
- Reset IPTables After an attack has successfully finished with ``-reset`` flag
- Disable inbound connection and use whitlisting ``-ball`` flag
- Block IP Addresses With ``-bip`` flag
- Whitlist IP Addresses with ``-wip`` flag
- Default protection monitor with no TUI (no outputs)
- Terminal User Interface (Designs, Logos, ASCII, Layouts)
- Socket for public dstating visitors
- Branding Customization System. Create your own UI/Layout!
- Detect and analyze large connection request spams UDP/TCP for more information
- Dropping UDP/TCP Flood Techniques
- Dump files containing the following information. ``Connections``, ``Attacked Port``, ``Current PPS``, ``Current CPU Usage``, ``Current BPS``, ``Nload Statistics``, ``Packet Data in Hex Strings``, ``PPS Data Graph``
- Supported to work on all linux platforms

### How To Install
Ubuntu / Debian (Officially created on ubuntu 20.04 LTS)
```
sudo apt install git -y
git clone https://github.com/NefariousTheDev/Cyber-Shield-v4.git
cd Cyber-Shield-v4
./shield -h
```

### How To Customize the TUI
Choosing a desired layout. Create a layout with your logo or anything you want on it and put it in your UI file located in ``assets/themes/builtin/ui.txt`` file
Positiong terminal text. Change the value of row and column by modifiying the array values ``[0, 0]`` of every key in JSON file located in ``assets/config.json``
