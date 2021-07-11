Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1C3C3D5D
	for <lists+io-uring@lfdr.de>; Sun, 11 Jul 2021 16:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhGKOl4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jul 2021 10:41:56 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55232 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhGKOl4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jul 2021 10:41:56 -0400
Received: by mail-il1-f199.google.com with SMTP id r19-20020a92c5b30000b02901f175acc987so10058613ilt.21
        for <io-uring@vger.kernel.org>; Sun, 11 Jul 2021 07:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Cg+euSBsJkC16H8LHYIY+z2hry6pCPL+kVcPt36wfsA=;
        b=nGCL+CcMNfou3YiPG373wd284Atz4m7SYLQ8oODPq5pjM7UDhaqj951clbJD58L+pk
         Us9BibY/o7+SW93y8L8dgCY2PISlY3CTR2zSEXE7k4YihJ+/vRnz7U2l83pq4CTDX7r0
         TJ0iRk87SeOIxbbczZ6vQKoJnaaBBmfvvwzIaUW3ZwCl964+r0/+b4ZyUVtlHoTlz3wG
         U5EpkPbMkL7koKyJMhbs67DFNSedR3mbTD6Lx0TryARVdOAFQiZVfKvf1RyjwybKE4p/
         soIOjQc/gQA+KyQX8Th+q4nC4hRYG+9D1k5fGkX1HitzH7cAfkVcdQ3HrLVZjrY7LLTM
         NsBQ==
X-Gm-Message-State: AOAM5322B7bMo0OTK3j3wn2wXcpp86MRgprTJbZhI/y1MsbzUoinZoAS
        drm9CsBrIHlGVxEnib/r77M6xeR42rPk+5tbnvJWNNG3ho1i
X-Google-Smtp-Source: ABdhPJzlMZWMkNq6+XPjPsidM2nH7RZEmD3z9+Jn65PEeVZIHpU32cp0oq/f5UkskSEfI+4LDtOfih6aWiooTxXwppbg9UX8J4sp
MIME-Version: 1.0
X-Received: by 2002:a92:3009:: with SMTP id x9mr33480086ile.49.1626014349059;
 Sun, 11 Jul 2021 07:39:09 -0700 (PDT)
Date:   Sun, 11 Jul 2021 07:39:09 -0700
In-Reply-To: <f48e63f0-f193-586a-a98d-640359631ee4@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aceafa05c6d9f795@google.com>
Subject: Re: [syzbot] INFO: task hung in io_uring_cancel_generic
From:   syzbot <syzbot+ba6fcd859210f4e9e109@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

ace driver bcm203x
[    9.302351][    T1] usbcore: registered new interface driver bpa10x
[    9.303473][    T1] usbcore: registered new interface driver bfusb
[    9.305628][    T1] usbcore: registered new interface driver btusb
[    9.306881][    T1] usbcore: registered new interface driver ath3k
[    9.308526][    T1] CAPI 2.0 started up with major 68 (middleware)
[    9.309416][    T1] Modular ISDN core version 1.1.29
[    9.310922][    T1] NET: Registered PF_ISDN protocol family
[    9.312213][    T1] DSP module 2.0
[    9.312966][    T1] mISDN_dsp: DSP clocks every 80 samples. This equals 1 jiffies.
[    9.327662][    T1] mISDN: Layer-1-over-IP driver Rev. 2.00
[    9.329185][    T1] 0 virtual devices registered
[    9.330263][    T1] usbcore: registered new interface driver HFC-S_USB
[    9.331803][    T1] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    9.332793][    T1] usbcore: registered new interface driver vub300
[    9.335457][    T1] usbcore: registered new interface driver ushc
[    9.342005][    T1] iscsi: registered transport (iser)
[    9.343604][    T1] SoftiWARP attached
[    9.344289][    T1] Driver 'framebuffer' was unable to register with bus_type 'coreboot' because the bus was not initialized.
[    9.346043][    T1] Driver 'memconsole' was unable to register with bus_type 'coreboot' because the bus was not initialized.
[    9.347617][    T1] Driver 'vpd' was unable to register with bus_type 'coreboot' because the bus was not initialized.
[    9.357668][    T1] hid: raw HID events driver (C) Jiri Kosina
[    9.385985][    T1] usbcore: registered new interface driver usbhid
[    9.387037][    T1] usbhid: USB HID core driver
[    9.390066][    T1] usbcore: registered new interface driver es2_ap_driver
[    9.393006][    T1] comedi: version 0.7.76 - http://www.comedi.org
[    9.394302][    T1] usbcore: registered new interface driver dt9812
[    9.395545][    T1] usbcore: registered new interface driver ni6501
[    9.396763][    T1] usbcore: registered new interface driver usbdux
[    9.397991][    T1] usbcore: registered new interface driver usbduxfast
[    9.399198][    T1] usbcore: registered new interface driver usbduxsigma
[    9.402039][    T1] usbcore: registered new interface driver vmk80xx
[    9.403629][    T1] usbcore: registered new interface driver prism2_usb
[    9.405013][    T1] usbcore: registered new interface driver r8712u
[    9.407131][    T1] ashmem: initialized
[    9.408362][    T1] greybus: registered new driver hid
[    9.409362][    T1] greybus: registered new driver gbphy
[    9.410305][    T1] gb_gbphy: registered new driver usb
[    9.411889][    T1] asus_wmi: ASUS WMI generic driver loaded
[    9.486305][    T1] usbcore: registered new interface driver snd-usb-audio
[    9.487650][    T1] usbcore: registered new interface driver snd-ua101
[    9.488918][    T1] usbcore: registered new interface driver snd-usb-usx2y
[    9.492672][    T1] usbcore: registered new interface driver snd-usb-us122l
[    9.494778][    T1] usbcore: registered new interface driver snd-usb-caiaq
[    9.496007][    T1] usbcore: registered new interface driver snd-usb-6fire
[    9.497262][    T1] usbcore: registered new interface driver snd-usb-hiface
[    9.498782][    T1] usbcore: registered new interface driver snd-bcd2000
[    9.499887][    T1] usbcore: registered new interface driver snd_usb_pod
[    9.501897][    T1] usbcore: registered new interface driver snd_usb_podhd
[    9.503388][    T1] usbcore: registered new interface driver snd_usb_toneport
[    9.505421][    T1] usbcore: registered new interface driver snd_usb_variax
[    9.506582][    T1] drop_monitor: Initializing network drop monitor service
[    9.508642][    T1] NET: Registered PF_LLC protocol family
[    9.509528][    T1] GACT probability on
[    9.510771][    T1] Mirror/redirect action on
[    9.511554][    T1] Simple TC action Loaded
[    9.514496][    T1] netem: version 1.3
[    9.515461][    T1] u32 classifier
[    9.515990][    T1]     Performance counters on
[    9.516615][    T1]     input device check on
[    9.517586][    T1]     Actions configured
[    9.519992][    T1] nf_conntrack_irc: failed to register helpers
[    9.521431][    T1] nf_conntrack_sane: failed to register helpers
[    9.558483][    T1] nf_conntrack_sip: failed to register helpers
[    9.563419][    T1] xt_time: kernel timezone is -0000
[    9.564476][    T1] IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
[    9.565840][    T1] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
[    9.567503][    T1] IPVS: ipvs loaded.
[    9.568192][    T1] IPVS: [rr] scheduler registered.
[    9.568956][    T1] IPVS: [wrr] scheduler registered.
[    9.569738][    T1] IPVS: [lc] scheduler registered.
[    9.570511][    T1] IPVS: [wlc] scheduler registered.
[    9.571373][    T1] IPVS: [fo] scheduler registered.
[    9.572445][    T1] IPVS: [ovf] scheduler registered.
[    9.573312][    T1] IPVS: [lblc] scheduler registered.
[    9.574091][    T1] IPVS: [lblcr] scheduler registered.
[    9.575006][    T1] IPVS: [dh] scheduler registered.
[    9.575796][    T1] IPVS: [sh] scheduler registered.
[    9.576720][    T1] IPVS: [mh] scheduler registered.
[    9.577462][    T1] IPVS: [sed] scheduler registered.
[    9.578179][    T1] IPVS: [nq] scheduler registered.
[    9.578924][    T1] IPVS: [twos] scheduler registered.
[    9.580010][    T1] IPVS: [sip] pe registered.
[    9.580916][    T1] ipip: IPv4 and MPLS over IPv4 tunneling driver
[    9.583382][    T1] gre: GRE over IPv4 demultiplexor driver
[    9.584183][    T1] ip_gre: GRE over IPv4 tunneling driver
[    9.589932][    T1] IPv4 over IPsec tunneling driver
[    9.593837][    T1] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    9.594983][    T1] Initializing XFRM netlink socket
[    9.596079][    T1] IPsec XFRM device driver
[    9.598464][    T1] NET: Registered PF_INET6 protocol family
[    9.608978][    T1] Segment Routing with IPv6
[    9.609706][    T1] RPL Segment Routing with IPv6
[    9.610809][    T1] mip6: Mobile IPv6
[    9.615121][    T1] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    9.619694][    T1] ip6_gre: GRE over IPv6 tunneling driver
[    9.622557][    T1] NET: Registered PF_PACKET protocol family
[    9.623545][    T1] NET: Registered PF_KEY protocol family
[    9.624882][    T1] Bridge firewalling registered
[    9.626399][    T1] NET: Registered PF_X25 protocol family
[    9.627654][    T1] X25: Linux Version 0.2
[    9.658018][    T1] NET: Registered PF_NETROM protocol family
[    9.690465][    T1] NET: Registered PF_ROSE protocol family
[    9.691536][    T1] NET: Registered PF_AX25 protocol family
[    9.692549][    T1] can: controller area network core
[    9.693668][    T1] NET: Registered PF_CAN protocol family
[    9.694924][    T1] can: raw protocol
[    9.695672][    T1] can: broadcast manager protocol
[    9.696412][    T1] can: netlink gateway - max_hops=1
[    9.698003][    T1] can: SAE J1939
[    9.698531][    T1] can: isotp protocol
[    9.699817][    T1] Bluetooth: RFCOMM TTY layer initialized
[    9.702356][    T1] Bluetooth: RFCOMM socket layer initialized
[    9.703679][    T1] Bluetooth: RFCOMM ver 1.11
[    9.704852][    T1] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    9.705927][    T1] Bluetooth: BNEP filters: protocol multicast
[    9.706958][    T1] Bluetooth: BNEP socket layer initialized
[    9.707792][    T1] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[    9.708751][    T1] Bluetooth: CMTP socket layer initialized
[    9.709753][    T1] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    9.710823][    T1] Bluetooth: HIDP socket layer initialized
[    9.714808][    T1] NET: Registered PF_RXRPC protocol family
[    9.715884][    T1] Key type rxrpc registered
[    9.716522][    T1] Key type rxrpc_s registered
[    9.718643][    T1] NET: Registered PF_KCM protocol family
[    9.720344][    T1] lec:lane_module_init: lec.c: initialized
[    9.721491][    T1] mpoa:atm_mpoa_init: mpc.c: initialized
[    9.722893][    T1] l2tp_core: L2TP core driver, V2.0
[    9.723943][    T1] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[    9.724919][    T1] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[    9.726037][    T1] l2tp_netlink: L2TP netlink interface
[    9.726945][    T1] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[    9.728211][    T1] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[    9.729626][    T1] NET: Registered PF_PHONET protocol family
[    9.731015][    T1] 8021q: 802.1Q VLAN Support v1.8
[    9.740161][    T1] DCCP: Activated CCID 2 (TCP-like)
[    9.741707][    T1] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    9.744573][    T1] sctp: Hash tables configured (bind 32/56)
[    9.747220][    T1] NET: Registered PF_RDS protocol family
[    9.749148][    T1] Registered RDS/infiniband transport
[    9.750956][    T1] Registered RDS/tcp transport
[    9.751705][    T1] tipc: Activated (version 2.0.0)
[    9.752972][    T1] NET: Registered PF_TIPC protocol family
[    9.754278][    T1] tipc: Started in single node mode
[    9.755659][    T1] NET: Registered PF_SMC protocol family
[    9.756824][    T1] 9pnet: Installing 9P2000 support
[    9.757958][    T1] NET: Registered PF_CAIF protocol family
[    9.763274][    T1] NET: Registered PF_IEEE802154 protocol family
[    9.764544][    T1] Key type dns_resolver registered
[    9.765265][    T1] Key type ceph registered
[    9.766634][    T1] libceph: loaded (mon/osd proto 15/24)
[    9.769906][    T1] batman_adv: B.A.T.M.A.N. advanced 2021.2 (compatibility version 15) loaded
[    9.771371][    T1] openvswitch: Open vSwitch switching datapath
[    9.774437][    T1] NET: Registered PF_VSOCK protocol family
[    9.775493][    T1] mpls_gso: MPLS GSO support
[    9.785657][    T1] IPI shorthand broadcast: enabled
[    9.786804][    T1] AVX2 version of gcm_enc/dec engaged.
[    9.787910][    T1] AES CTR mode by8 optimization enabled
[    9.794810][    T1] sched_clock: Marking stable (9773193399, 21522192)->(9795960439, -1244848)
[    9.797259][    T1] registered taskstats version 1
[    9.805286][    T1] Loading compiled-in X.509 certificates
[    9.807833][    T1] Loaded X.509 cert 'Build time autogenerated kernel key: f850c787ad998c396ae089c083b940ff0a9abb77'
[    9.810756][    T1] zswap: loaded using pool lzo/zbud
[    9.812477][    T1] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
[    9.814730][    T1] Key type ._fscrypt registered
[    9.815701][    T1] Key type .fscrypt registered
[    9.816492][    T1] Key type fscrypt-provisioning registered
[    9.819908][    T1] kAFS: Red Hat AFS client v0.1 registering.
[    9.821630][    T1] FS-Cache: Netfs 'afs' registered for caching
[    9.829938][    T1] Btrfs loaded, crc32c=crc32c-intel, assert=on, zoned=yes
[    9.832751][    T1] Key type big_key registered
[    9.836164][    T1] Key type encrypted registered
[    9.836954][    T1] AppArmor: AppArmor sha1 policy hashing enabled
[    9.837875][    T1] ima: No TPM chip found, activating TPM-bypass!
[    9.838746][    T1] Loading compiled-in module X.509 certificates
[    9.840036][    T1] Loaded X.509 cert 'Build time autogenerated kernel key: f850c787ad998c396ae089c083b940ff0a9abb77'
[    9.841866][    T1] ima: Allocated hash algorithm: sha256
[    9.842970][    T1] ima: No architecture policies found
[    9.844189][    T1] evm: Initialising EVM extended attributes:
[    9.845100][    T1] evm: security.selinux (disabled)
[    9.845782][    T1] evm: security.SMACK64 (disabled)
[    9.846463][    T1] evm: security.SMACK64EXEC (disabled)
[    9.847188][    T1] evm: security.SMACK64TRANSMUTE (disabled)
[    9.848128][    T1] evm: security.SMACK64MMAP (disabled)
[    9.848898][    T1] evm: security.apparmor
[    9.849482][    T1] evm: security.ima
[    9.850284][    T1] evm: security.capability
[    9.851141][    T1] evm: HMAC attrs: 0x1
[    9.851611][  T855] floppy0: no floppy controllers found
[    9.853250][  T855] work still pending
[    9.854504][    T1] PM:   Magic number: 13:793:535
[    9.855444][    T1] usb usb35-port4: hash matches
[    9.857025][    T1] bdi 1:13: hash matches
[    9.859054][    T1] printk: console [netcon0] enabled
[    9.859823][    T1] netconsole: network logging started
[    9.860932][    T1] gtp: GTP module loaded (pdp ctx size 104 bytes)
[    9.863283][    T1] rdma_rxe: loaded
[    9.865260][    T1] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    9.868221][    T1] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    9.870545][    T7] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    9.871871][    T1] ALSA device list:
[    9.872225][    T7] platform regulatory.0: Falling back to sysfs fallback for: regulatory.db
[    9.872637][    T1]   #0: Dummy 1
[    9.874348][    T1]   #1: Loopback 1
[    9.874960][    T1]   #2: Virtual MIDI Card 1
[    9.877845][    T1] md: Waiting for all devices to be available before autodetect
[    9.879094][    T1] md: If you don't use raid, use raid=noautodetect
[    9.880372][    T1] md: Autodetecting RAID arrays.
[    9.881327][    T1] md: autorun ...
[    9.881824][    T1] md: ... autorun DONE.
[    9.885213][    T1] VFS: Cannot open root device "sda1" or unknown-block(0,0): error -6
[    9.886783][    T1] Please append a correct "root=" boot option; here are the available partitions:
[    9.888572][    T1] 0100            4096 ram0 
[    9.888583][    T1]  (driver?)
[    9.889669][    T1] 0101            4096 ram1 
[    9.889677][    T1]  (driver?)
[    9.890870][    T1] 0102            4096 ram2 
[    9.890884][    T1]  (driver?)
[    9.892018][    T1] 0103            4096 ram3 
[    9.892027][    T1]  (driver?)
[    9.893121][    T1] 0104            4096 ram4 
[    9.893129][    T1]  (driver?)
[    9.894283][    T1] 0105            4096 ram5 
[    9.894291][    T1]  (driver?)
[    9.895698][    T1] 0106            4096 ram6 
[    9.895706][    T1]  (driver?)
[    9.896758][    T1] 0107            4096 ram7 
[    9.896766][    T1]  (driver?)
[    9.898038][    T1] 0108            4096 ram8 
[    9.898046][    T1]  (driver?)
[    9.899196][    T1] 0109            4096 ram9 
[    9.899204][    T1]  (driver?)
[    9.901225][    T1] 010a            4096 ram10 
[    9.901235][    T1]  (driver?)
[    9.902295][    T1] 010b            4096 ram11 
[    9.902303][    T1]  (driver?)
[    9.903361][    T1] 010c            4096 ram12 
[    9.903369][    T1]  (driver?)
[    9.904433][    T1] 010d            4096 ram13 
[    9.904441][    T1]  (driver?)
[    9.905537][    T1] 010e            4096 ram14 
[    9.905545][    T1]  (driver?)
[    9.906605][    T1] 010f            4096 ram15 
[    9.906613][    T1]  (driver?)
[    9.907702][    T1] 1f00             128 mtdblock0 
[    9.907710][    T1]  (driver?)
[    9.909222][    T1] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    9.910524][    T1] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.13.0-syzkaller #0
[    9.911577][    T1] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[    9.913030][    T1] Call Trace:
[    9.913582][    T1]  dump_stack_lvl+0xcd/0x134
[    9.914352][    T1]  panic+0x306/0x73d
[    9.914959][    T1]  ? __warn_printk+0xf3/0xf3
[    9.916524][    T1]  mount_block_root+0x3f8/0x4dd
[    9.917211][    T1]  ? init_rootfs+0x59/0x59
[    9.918287][    T1]  ? memcpy+0x39/0x60
[    9.919164][    T1]  mount_root+0x1af/0x1f5
[    9.919838][    T1]  ? mount_block_root+0x4dd/0x4dd
[    9.920611][    T1]  ? memcpy+0x39/0x60
[    9.921332][    T1]  prepare_namespace+0x1ff/0x234
[    9.922015][    T1]  kernel_init_freeable+0x729/0x741
[    9.922766][    T1]  ? rest_init+0x3e0/0x3e0
[    9.923398][    T1]  kernel_init+0x1a/0x1d0
[    9.924014][    T1]  ? rest_init+0x3e0/0x3e0
[    9.924684][    T1]  ret_from_fork+0x1f/0x30
[    9.931512][    T1] Kernel Offset: disabled
[    9.932134][    T1] Rebooting in 86400 seconds..


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=115cd5e4300000


Tested on:

commit:         1b2d5f60 io_uring: use right task for exiting checks
git tree:       git://git.kernel.dk/linux-block io_uring-5.14
kernel config:  https://syzkaller.appspot.com/x/.config?x=c4b9715112a24a2b
dashboard link: https://syzkaller.appspot.com/bug?extid=ba6fcd859210f4e9e109
compiler:       

