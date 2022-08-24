Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA495A003F
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 19:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbiHXRUQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 24 Aug 2022 13:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238271AbiHXRUQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 13:20:16 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30F17269A
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 10:20:14 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id v14-20020a6b5b0e000000b0067bc967a6c0so9597386ioh.5
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 10:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc;
        bh=8/N8d+mwyBo4wqGAZcushzQXBzpMvy11Je374A1h+1w=;
        b=jYAeftKBBL1S2QdD0uB1Kwmf3k7G1d4bSyFHDPtNLGY0g4/7bkjffX9XhHRkls4b8t
         dsja88SILkKtBR8RwX0kFQOdvbzuNfRbvKtoNPDHdjbUlia95bybE7CDklppgfjSHL0t
         fsy8RkYlYadIelrquQsWAsQa0D96uEes6Sg9RcrJoWT+9GOWGlsWW1XxZtxUYtQdfGTk
         iOXuvPQGLoqhKYu4MZlcTIuMlW04kQ2EdwC3r2j1I3cPOnTga0MfEDSCwhBLzkGhY9av
         G+Z2rSyX26BQ0WRMz9a5lXIMa+B+1pql4q1c67mlEPQ8GwOQGMVxyAtwbQtraE9Oxgr2
         KFaw==
X-Gm-Message-State: ACgBeo0UGZgAXEMEinOJSreTBW3SgTcLeseXkfyM+zhRsnl6ScPLCjfE
        aV8DVxzLPmSWo8ZBG8oddp/rNRE3skEcpiNaGkLwH/J/6GKv
X-Google-Smtp-Source: AA6agR4hnbLGtQgptn8zwG8iHL3j0MNJJFRAvl3d2ykuZXMR31ieQP3nckWZbNmjFCD4Qqa5xXN6rkd1+TMtJtL2GoWnSSZy6kie
MIME-Version: 1.0
X-Received: by 2002:a6b:105:0:b0:688:2b66:1ed6 with SMTP id
 5-20020a6b0105000000b006882b661ed6mr15401iob.165.1661361613845; Wed, 24 Aug
 2022 10:20:13 -0700 (PDT)
Date:   Wed, 24 Aug 2022 10:20:13 -0700
In-Reply-To: <fa23ffc2-755e-7e04-362d-68fad7d69c85@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d63d1505e6ffe433@google.com>
Subject: Re: [syzbot] general protection fault in __io_sync_cancel
From:   syzbot <syzbot+bf76847df5f7359c9e09@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

    T1] Segment Routing with IPv6
[   11.778749][    T1] RPL Segment Routing with IPv6
[   11.780518][    T1] In-situ OAM (IOAM) with IPv6
[   11.782042][    T1] mip6: Mobile IPv6
[   11.786486][    T1] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[   11.793665][    T1] ip6_gre: GRE over IPv6 tunneling driver
[   11.798208][    T1] NET: Registered PF_PACKET protocol family
[   11.799896][    T1] NET: Registered PF_KEY protocol family
[   11.802055][    T1] Bridge firewalling registered
[   11.803589][    T1] NET: Registered PF_X25 protocol family
[   11.804806][    T1] X25: Linux Version 0.2
[   11.847206][    T1] NET: Registered PF_NETROM protocol family
[   11.888898][    T1] NET: Registered PF_ROSE protocol family
[   11.892054][    T1] NET: Registered PF_AX25 protocol family
[   11.893357][    T1] can: controller area network core
[   11.894670][    T1] NET: Registered PF_CAN protocol family
[   11.895475][    T1] can: raw protocol
[   11.896141][    T1] can: broadcast manager protocol
[   11.897027][    T1] can: netlink gateway - max_hops=1
[   11.898177][    T1] can: SAE J1939
[   11.898810][    T1] can: isotp protocol
[   11.901860][    T1] Bluetooth: RFCOMM TTY layer initialized
[   11.902785][    T1] Bluetooth: RFCOMM socket layer initialized
[   11.904012][    T1] Bluetooth: RFCOMM ver 1.11
[   11.904822][    T1] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   11.905764][    T1] Bluetooth: BNEP filters: protocol multicast
[   11.907262][    T1] Bluetooth: BNEP socket layer initialized
[   11.908295][    T1] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[   11.909403][    T1] Bluetooth: CMTP socket layer initialized
[   11.911056][    T1] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   11.912703][    T1] Bluetooth: HIDP socket layer initialized
[   11.917719][    T1] NET: Registered PF_RXRPC protocol family
[   11.919950][    T1] Key type rxrpc registered
[   11.920646][    T1] Key type rxrpc_s registered
[   11.922687][    T1] NET: Registered PF_KCM protocol family
[   11.924005][    T1] lec:lane_module_init: lec.c: initialized
[   11.925480][    T1] mpoa:atm_mpoa_init: mpc.c: initialized
[   11.926437][    T1] l2tp_core: L2TP core driver, V2.0
[   11.927682][    T1] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[   11.928781][    T1] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   11.935470][    T1] l2tp_netlink: L2TP netlink interface
[   11.941080][    T1] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[   11.947835][    T1] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[   11.955837][    T1] NET: Registered PF_PHONET protocol family
[   11.962541][    T1] 8021q: 802.1Q VLAN Support v1.8
[   11.981227][    T1] DCCP: Activated CCID 2 (TCP-like)
[   11.987131][    T1] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   11.996367][    T1] sctp: Hash tables configured (bind 32/56)
[   12.004581][    T1] NET: Registered PF_RDS protocol family
[   12.011589][    T1] Registered RDS/infiniband transport
[   12.018376][    T1] Registered RDS/tcp transport
[   12.023397][    T1] tipc: Activated (version 2.0.0)
[   12.029562][    T1] NET: Registered PF_TIPC protocol family
[   12.035917][    T1] tipc: Started in single node mode
[   12.042799][    T1] NET: Registered PF_SMC protocol family
[   12.048895][    T1] 9pnet: Installing 9P2000 support
[   12.055031][    T1] NET: Registered PF_CAIF protocol family
[   12.066266][    T1] NET: Registered PF_IEEE802154 protocol family
[   12.073314][    T1] Key type dns_resolver registered
[   12.078510][    T1] Key type ceph registered
[   12.084022][    T1] libceph: loaded (mon/osd proto 15/24)
[   12.091969][    T1] batman_adv: B.A.T.M.A.N. advanced 2022.2 (compatibility version 15) loaded
[   12.100976][    T1] openvswitch: Open vSwitch switching datapath
[   12.110679][    T1] NET: Registered PF_VSOCK protocol family
[   12.116771][    T1] mpls_gso: MPLS GSO support
[   12.132488][    T1] IPI shorthand broadcast: enabled
[   12.137708][    T1] AVX2 version of gcm_enc/dec engaged.
[   12.143629][    T1] AES CTR mode by8 optimization enabled
[   12.153389][    T1] sched_clock: Marking stable (12128368826, 24694216)->(12161609834, -8546792)
[   12.164371][    T1] registered taskstats version 1
[   12.176236][    T1] Loading compiled-in X.509 certificates
[   12.187851][    T1] Loaded X.509 cert 'Build time autogenerated kernel key: 56474817b0befbc4db6691a48efa9e68df22c0e8'
[   12.201889][    T1] zswap: loaded using pool lzo/zbud
[   12.209454][    T1] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
[   14.002305][    T1] Key type ._fscrypt registered
[   14.007306][    T1] Key type .fscrypt registered
[   14.012126][    T1] Key type fscrypt-provisioning registered
[   14.024575][    T1] kAFS: Red Hat AFS client v0.1 registering.
[   14.041755][    T1] Btrfs loaded, crc32c=crc32c-intel, assert=on, zoned=yes, fsverity=yes
[   14.050906][    T1] Key type big_key registered
[   14.058508][    T1] Key type encrypted registered
[   14.063568][    T1] AppArmor: AppArmor sha1 policy hashing enabled
[   14.070180][    T1] ima: No TPM chip found, activating TPM-bypass!
[   14.076527][    T1] Loading compiled-in module X.509 certificates
[   14.086703][    T1] Loaded X.509 cert 'Build time autogenerated kernel key: 56474817b0befbc4db6691a48efa9e68df22c0e8'
[   14.097558][    T1] ima: Allocated hash algorithm: sha256
[   14.103429][    T1] ima: No architecture policies found
[   14.109151][    T1] evm: Initialising EVM extended attributes:
[   14.115568][    T1] evm: security.selinux (disabled)
[   14.120773][    T1] evm: security.SMACK64 (disabled)
[   14.126049][    T1] evm: security.SMACK64EXEC (disabled)
[   14.131557][    T1] evm: security.SMACK64TRANSMUTE (disabled)
[   14.137432][    T1] evm: security.SMACK64MMAP (disabled)
[   14.142977][    T1] evm: security.apparmor
[   14.147215][    T1] evm: security.ima
[   14.151081][    T1] evm: security.capability
[   14.155477][    T1] evm: HMAC attrs: 0x1
[   14.243494][    T1] PM:   Magic number: 2:237:189
[   14.249013][    T1] tty ttys1: hash matches
[   14.253781][    T1] acpi device:1b: hash matches
[   14.261317][    T1] printk: console [netcon0] enabled
[   14.266586][    T1] netconsole: network logging started
[   14.273514][    T1] gtp: GTP module loaded (pdp ctx size 104 bytes)
[   14.282346][    T1] rdma_rxe: loaded
[   14.286627][    T1] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   14.297869][    T1] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   14.306790][   T14] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   14.313129][    T1] ALSA device list:
[   14.316846][   T14] platform regulatory.0: Falling back to sysfs fallback for: regulatory.db
[   14.320575][    T1]   #0: Dummy 1
[   14.332576][    T1]   #1: Loopback 1
[   14.336298][    T1]   #2: Virtual MIDI Card 1
[   14.343790][    T1] md: Waiting for all devices to be available before autodetect
[   14.351699][    T1] md: If you don't use raid, use raid=noautodetect
[   14.358204][    T1] md: Autodetecting RAID arrays.
[   14.363414][    T1] md: autorun ...
[   14.367120][    T1] md: ... autorun DONE.
[   14.478701][    T1] EXT4-fs (sda1): mounted filesystem with ordered data mode. Quota mode: none.
[   14.488011][    T1] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[   14.503979][    T1] devtmpfs: mounted
[   14.580996][    T1] Freeing unused kernel image (initmem) memory: 2724K
[   14.587928][    T1] Write protecting the kernel read-only data: 176128k
[   14.599937][    T1] Freeing unused kernel image (text/rodata gap) memory: 2016K
[   14.608369][    T1] Freeing unused kernel image (rodata/data gap) memory: 376K
[   14.623046][    T1] Failed to set sysctl parameter 'max_rcu_stall_to_panic=1': parameter not found
[   14.632909][    T1] Run /sbin/init as init process
[   15.125500][ T2940] EXT4-fs (sda1): re-mounted. Quota mode: none.
mount: mounting smackfs on /sys/fs/smackfs failed: No such file or directory
mount: mounting selinuxfs on /sys/fs/selinux failed: No such file or directory
mount: mounting mqueue on /dev/mqueue failed: No such file or directory
mount: mounting hugetlbfs on /dev/hugepages failed: No such file or directory
mount: mounting fuse.lxcfs on /v[   15.247660][ T2942] mount (2942) used greatest stack depth: 23392 bytes left
ar/lib/lxcfs failed: No such file or directory
Starting syslogd: OK
Starting acpid: OK
Starting klogd: OK
Running sysctl: [   15.777837][ T2969] logger (2969) used greatest stack depth: 23000 bytes left
OK
Populating /dev using udev: [   16.034860][ T2971] udevd[2971]: starting version 3.2.10
[   16.293122][ T2972] udevd[2972]: starting eudev-3.2.10
[   16.297135][ T2971] udevd (2971) used greatest stack depth: 22776 bytes left
[   17.605358][ T2986] ------------[ cut here ]------------
[   17.613372][ T2986] kernel BUG at arch/x86/mm/physaddr.c:28!
[   17.621301][ T2986] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[   17.627417][ T2986] CPU: 1 PID: 2986 Comm: udevadm Not tainted 6.0.0-rc1-syzkaller-00014-g0596fa5ef9af #0
[   17.637288][ T2986] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
[   17.647372][ T2986] RIP: 0010:__phys_addr+0xd3/0x140
[   17.652560][ T2986] Code: e3 44 89 e9 31 ff 48 d3 eb 48 89 de e8 26 22 45 00 48 85 db 75 0f e8 3c 25 45 00 4c 89 e0 5b 5d 41 5c 41 5d c3 e8 2d 25 45 00 <0f> 0b e8 26 25 45 00 48 c7 c0 10 50 cb 8b 48 ba 00 00 00 00 00 fc
[   17.672198][ T2986] RSP: 0018:ffffc90002d8fc90 EFLAGS: 00010293
[   17.678322][ T2986] RAX: 0000000000000000 RBX: ffff000000000000 RCX: 0000000000000000
[   17.686329][ T2986] RDX: ffff888021510000 RSI: ffffffff8136e1c3 RDI: 0000000000000006
[   17.694351][ T2986] RBP: ffff000080000000 R08: 0000000000000006 R09: ffff000080000000
[   17.702441][ T2986] R10: ffff778000000000 R11: 0000000000000000 R12: ffff778000000000
[   17.710451][ T2986] R13: ffffc90002d8fcf8 R14: ffff000000000000 R15: 0000000000000000
[   17.718890][ T2986] FS:  00007f452d713840(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
[   17.728368][ T2986] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.735074][ T2986] CR2: 0000558861bac008 CR3: 000000001e706000 CR4: 00000000003506e0
[   17.743071][ T2986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   17.751043][ T2986] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   17.759039][ T2986] Call Trace:
[   17.762331][ T2986]  <TASK>
[   17.765282][ T2986]  qlist_free_all+0x86/0x170
[   17.769889][ T2986]  kasan_quarantine_reduce+0x180/0x200
[   17.775358][ T2986]  __kasan_slab_alloc+0xa2/0xc0
[   17.780217][ T2986]  kmem_cache_alloc+0x267/0x3b0
[   17.785076][ T2986]  getname_flags.part.0+0x50/0x4f0
[   17.790221][ T2986]  getname_flags+0x9a/0xe0
[   17.794694][ T2986]  user_path_at_empty+0x2b/0x60
[   17.799556][ T2986]  do_readlinkat+0xcd/0x2f0
[   17.804066][ T2986]  ? cp_compat_stat+0x830/0x830
[   17.808925][ T2986]  ? syscall_enter_from_user_mode+0x22/0xb0
[   17.814848][ T2986]  __x64_sys_readlink+0x74/0xb0
[   17.819708][ T2986]  do_syscall_64+0x35/0xb0
[   17.824135][ T2986]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   17.830033][ T2986] RIP: 0033:0x7f452d327277
[   17.834538][ T2986] Code: 73 01 c3 48 8b 0d 01 dc 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 59 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d1 db 0c 00 f7 d8 64 89 01 48
[   17.854257][ T2986] RSP: 002b:00007ffedcc439a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000059
[   17.862678][ T2986] RAX: ffffffffffffffda RBX: 00007ffedcc439b8 RCX: 00007f452d327277
[   17.870653][ T2986] RDX: 0000000000000400 RSI: 00007ffedcc439b8 RDI: 00007ffedcc43e98
[   17.878628][ T2986] RBP: 0000000000000400 R08: 0000000000003fff R09: 0000000000000000
[   17.886603][ T2986] R10: 0000000000000012 R11: 0000000000000246 R12: 00007ffedcc43e98
[   17.895108][ T2986] R13: 00007ffedcc43e08 R14: 0000558861ba3910 R15: 0000558861ba3a60
[   17.903094][ T2986]  </TASK>
[   17.906110][ T2986] Modules linked in:
[   17.915398][ T2986] ---[ end trace 0000000000000000 ]---
[   17.922149][ T2986] RIP: 0010:__phys_addr+0xd3/0x140
[   17.928659][ T2986] Code: e3 44 89 e9 31 ff 48 d3 eb 48 89 de e8 26 22 45 00 48 85 db 75 0f e8 3c 25 45 00 4c 89 e0 5b 5d 41 5c 41 5d c3 e8 2d 25 45 00 <0f> 0b e8 26 25 45 00 48 c7 c0 10 50 cb 8b 48 ba 00 00 00 00 00 fc
[   17.959306][ T2986] RSP: 0018:ffffc90002d8fc90 EFLAGS: 00010293
[   17.965635][ T2986] RAX: 0000000000000000 RBX: ffff000000000000 RCX: 0000000000000000
[   17.973707][ T2986] RDX: ffff888021510000 RSI: ffffffff8136e1c3 RDI: 0000000000000006
[   17.982205][ T2986] RBP: ffff000080000000 R08: 0000000000000006 R09: ffff000080000000
[   17.990257][ T2986] R10: ffff778000000000 R11: 0000000000000000 R12: ffff778000000000
[   17.999595][ T2986] R13: ffffc90002d8fcf8 R14: ffff000000000000 R15: 0000000000000000
[   18.009718][ T2986] FS:  00007f452d713840(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
[   18.018693][ T2986] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.026893][ T2986] CR2: 0000558861bac008 CR3: 000000001e706000 CR4: 00000000003506e0
[   18.036928][ T2986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   18.047510][ T2986] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   18.055838][ T2986] Kernel panic - not syncing: Fatal exception
[   18.062093][ T2986] Kernel Offset: disabled
[   18.066545][ T2986] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=<nil>)
GO111MODULE="auto"
GOARCH="amd64"
GOBIN=""
GOCACHE="/syzkaller/.cache/go-build"
GOENV="/syzkaller/.config/go/env"
GOEXE=""
GOEXPERIMENT=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOINSECURE=""
GOMODCACHE="/syzkaller/jobs/linux/gopath/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="linux"
GOPATH="/syzkaller/jobs/linux/gopath"
GOPRIVATE=""
GOPROXY="https://proxy.golang.org,direct"
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GOVCS=""
GOVERSION="go1.17"
GCCGO="gccgo"
AR="ar"
CC="gcc"
CXX="g++"
CGO_ENABLED="1"
GOMOD="/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mod"
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build2121451332=/tmp/go-build -gno-record-gcc-switches"

git status (err=<nil>)
HEAD detached at cea8b0f72
nothing to commit, working tree clean


go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sys/syz-sysgen
make .descriptions
bin/syz-sysgen
touch .descriptions
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=cea8b0f72c56f0c82a465154bb7412407e78dcd8 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220823-115137'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer github.com/google/syzkaller/syz-fuzzer
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=cea8b0f72c56f0c82a465154bb7412407e78dcd8 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220823-115137'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=cea8b0f72c56f0c82a465154bb7412407e78dcd8 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20220823-115137'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-stress github.com/google/syzkaller/tools/syz-stress
mkdir -p ./bin/linux_amd64
gcc -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wframe-larger-than=16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-format-overflow -static-pie -fpermissive -w -DGOOS_linux=1 -DGOARCH_amd64=1 \
	-DHOSTGOOS_linux=1 -DGIT_REVISION=\"cea8b0f72c56f0c82a465154bb7412407e78dcd8\"


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=1597dfd3080000


Tested on:

commit:         0596fa5e io_uring/net: save address for sendzc async e..
git tree:       git://git.kernel.dk/linux-block io_uring-6.0
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b9175e0879a7749
dashboard link: https://syzkaller.appspot.com/bug?extid=bf76847df5f7359c9e09
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
