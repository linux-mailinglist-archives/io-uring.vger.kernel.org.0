Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312F83D4871
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 17:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhGXPKr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Jul 2021 11:10:47 -0400
Received: from pio-pvt-msa1.bahnhof.se ([79.136.2.40]:41008 "EHLO
        pio-pvt-msa1.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGXPKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Jul 2021 11:10:46 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jul 2021 11:10:46 EDT
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa1.bahnhof.se (Postfix) with ESMTP id 4E6253F46C
        for <io-uring@vger.kernel.org>; Sat, 24 Jul 2021 17:46:11 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -1.899
X-Spam-Level: 
X-Spam-Status: No, score=-1.899 tagged_above=-999 required=6.31
        tests=[BAYES_00=-1.9, URIBL_BLOCKED=0.001]
        autolearn=ham autolearn_force=no
Received: from pio-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9OQo7Srww2tV for <io-uring@vger.kernel.org>;
        Sat, 24 Jul 2021 17:46:10 +0200 (CEST)
Received: by pio-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id 581073F42E
        for <io-uring@vger.kernel.org>; Sat, 24 Jul 2021 17:46:10 +0200 (CEST)
Received: from [192.168.0.10] (port=59788)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1m7Jqr-0005JB-P2
        for io-uring@vger.kernel.org; Sat, 24 Jul 2021 17:46:09 +0200
To:     io-uring@vger.kernel.org
From:   Forza <forza@tnonline.net>
Subject: Stack trace with Samba VFS io_uring and large transfers
Message-ID: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
Date:   Sat, 24 Jul 2021 17:46:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!

I am getting a stack trace and broken/stalled transfers with Samba I 
have "vfs objects = io_uring" in smb.conf.

Using Samba-4.13.9, the problem occurs in at least kernel-5.12.17-19 and 
5.13.4. I haven't tried earlier kernels.


[52928.008736] ------------[ cut here ]------------
[52928.008740] WARNING: CPU: 3 PID: 2173 at fs/io_uring.c:8749 
io_ring_exit_work+0xbd/0x5f0
[52928.008753] Modules linked in: nf_conntrack_netlink vhost_net vhost 
vhost_iotlb tap tun xt_CHECKSUM xt_MASQUERADE xt_state ip6t_REJECT 
nf_reject_ipv6 ip6table_filter ip6table_raw ip6table_mangle ip6table_nat 
xt_multiport xt_limit ipt_REJECT nf_reject_ipv4 xt_NFLOG nfnetlink_log 
xt_conntrack xt_physdev iptable_filter iptable_mangle xt_nat iptable_nat 
xt_CT iptable_raw ip_set_bitmap_port ip_set_hash_ip ip_set_hash_net 
xt_esp ipt_ah nft_xfrm nf_tables nf_nat_pptp nf_conntrack_pptp nf_nat 
nf_conntrack_sip nf_conntrack_irc nf_conntrack_ftp nf_conntrack_h323 
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_bridge 
nf_conntrack nf_defrag_ipv6 ip6_tables ip_tables xt_recent xt_set ip_set 
nfnetlink nf_defrag_ipv4 nf_socket_ipv4 binfmt_misc amdgpu kvm_amd 
drm_ttm_helper kvm ttm gpu_sched k10temp uas irqbypass 8250 8250_base 
serial_mctrl_gpio video serial_core backlight pinctrl_amd
[52928.008821] CPU: 3 PID: 2173 Comm: kworker/u32:4 Not tainted 
5.13.4-gentoo-e350 #1
[52928.008826] Hardware name: Gigabyte Technology Co., Ltd. B450M 
DS3H/B450M DS3H-CF, BIOS F61c 05/10/2021
[52928.008829] Workqueue: events_unbound io_ring_exit_work
[52928.008835] RIP: 0010:io_ring_exit_work+0xbd/0x5f0
[52928.008841] Code: 00 00 00 4c 89 fa 48 c7 c6 b0 7e 30 83 e8 5b 7f 00 
00 4c 89 f7 e8 43 95 ff ff 48 8b 05 9c 75 0f 01 49 39 c5 0f 89 7b ff ff 
ff <0f> 0b e9 74 ff ff ff 48 c7 c2 c8 b0 af 84 48 c7 c6 be 99 1c 84 48
[52928.008845] RSP: 0018:ffffa52294007df0 EFLAGS: 00010293
[52928.008849] RAX: 0000000103237dd4 RBX: ffff89359ef92600 RCX: 
0000000000000008
[52928.008852] RDX: ffff89359ef92080 RSI: 0000000000000000 RDI: 
ffff89359ef924c0
[52928.008855] RBP: ffffa52294007e90 R08: 0000000000000001 R09: 
0000000000000000
[52928.008857] R10: 0000000000000000 R11: 0000000000000003 R12: 
ffff89359ef925d0
[52928.008858] R13: 0000000103237dc0 R14: 0000000000000000 R15: 
ffff89359ef92000
[52928.008861] FS:  0000000000000000(0000) GS:ffff8937a6ec0000(0000) 
knlGS:0000000000000000
[52928.008864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[52928.008867] CR2: 00007f13f7904001 CR3: 00000001b62be000 CR4: 
00000000003506e0
[52928.008871] Call Trace:
[52928.008876]  ? __switch_to+0x23b/0x420
[52928.008882]  process_one_work+0x1af/0x300
[52928.008889]  worker_thread+0x48/0x3c0
[52928.008894]  ? process_one_work+0x300/0x300
[52928.008899]  kthread+0x122/0x140
[52928.008903]  ? set_kthread_struct+0x30/0x30
[52928.008908]  ret_from_fork+0x22/0x30
[52928.008914] ---[ end trace 6a275af934ed94fd ]---


I set "log level = 3" in smb.conf and captured the results:
Windows client: https://paste.tnonline.net/files/1U7Do7BKokPa_smbd-log.txt
Linux client: https://paste.tnonline.net/files/r4yebSzlGEVD_linux-client.txt


[2021/07/24 16:46:49.793735,  3] 
../../source3/smbd/smb2_read.c:415(smb2_read_complete)
   smbd_smb2_read: fnum 4007995332, file 
media/vm/libvirt/images/NomadBSD.img, length=1048576 offset=1282408448 
read=1048576
[2021/07/24 16:46:49.803693,  3] 
../../source3/smbd/smb2_read.c:415(smb2_read_complete)
   smbd_smb2_read: fnum 4007995332, file 
media/vm/libvirt/images/NomadBSD.img, length=1048576 offset=1283457024 
read=1048576
[2021/07/24 16:46:49.811478,  3] 
../../source3/smbd/smb2_read.c:415(smb2_read_complete)
   smbd_smb2_read: fnum 4007995332, file 
media/vm/libvirt/images/NomadBSD.img, length=1048576 offset=1284505600 
read=1048576

... here it just stops adding to the log file and the client eventually 
times out waiting for more data. No apparent error message in any of the 
samba log files.

The stack trace "events_unbound io_ring_exit_work" only seems to occur 
once and then doesn't come back in subsequent testing, even if I restart 
Samba itself. It comes back after a reboot.

This happens every time I have the io_uring vfs module enabled and never 
otherwise. It seems to be only large (several GB) file transfers that 
are affected.



