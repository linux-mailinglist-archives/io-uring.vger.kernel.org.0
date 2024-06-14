Return-Path: <io-uring+bounces-2209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB84A908185
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 04:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 765F21F23AAB
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 02:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D9A127E0F;
	Fri, 14 Jun 2024 02:20:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0A12836A
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 02:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718331607; cv=none; b=stJxJOptn/yXRspoP1qQh8/pfxLKGixv6ZaLt54F5wNNp1j2X0TW/IF4aOtSu+hmp+Fw1jog6TbwFn0gV1JtaJb9vqlxuTDnHxaN0w4MfzlK2eCfzh/mM70TIF80tMpOI+xcqULFGv0n9FpLXn0iNYo3/vRuD42aFn+3bCWM3PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718331607; c=relaxed/simple;
	bh=0yQO3z7AspDA5dME1f1nhOFNx4jznOY2EPZq+x8/wXU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Bdbh5s3LxNX9ZPqh1anAxDDWLcTUg6dZPEASMlBbWtvf5D/1/i7+NWVI4xyzAjx4CwyRhXlsRIWlI3pvWZvfctT06pySe6etngoE/vYudmSfRnioJMDni4EmB05lhrCBsqjmCuH9RpqRBhL7zx5HXjHxXRm7RCRMwGGXSVlF244=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3759b8709afso18401695ab.3
        for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 19:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718331605; x=1718936405;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4I2iW2xM5ikGUI8oH0BrHAjdk2gzPwqkNhhENZ3+f8E=;
        b=e1ezs5QcpoeKNcN/aikIobqQqB4HHFq0DWuY00/TZ+TJaaDLJ+wV3qfmq0oIQIYIVI
         L/9A/h1IPLnvKfTseWAmefpD8PgiBvsf2ZrzzvfffisxzoTeFOtB2SSmE7ywkxTBDuQg
         96YH/OsQPet1TCENBlwr/D0a2mb0gG+4vbqtJ/1203B9ZOXIn+VXqhj042nVTUvze1Pj
         DlJ7WkFwKAl6ShogswsUdijYJ67qpaP5XBp9mNV5KR2SUhCOaqwbQt7JcK0jERUKeTyP
         v+uBRYcjSzr3Ir9AX4DtcvmvLSfuGSHJNmXF4uXQwacDuASnDWwIiM8F3MICkH2TJRrW
         5+zQ==
X-Forwarded-Encrypted: i=1; AJvYcCX97WVjVUOKDFuKyqGpMAzWrCZ8c9VbznQLi/p0Bt0AXnpjTkmpnm3VOldhCpfMRZDM6nEe1mghr9x+Aiju9hNXjhB1d1mHSII=
X-Gm-Message-State: AOJu0YzvKlM/oapaFnvMcztrpJMyPw9/kx+32qDzD7Q+FmMehiCvgugc
	6qVPiRcqJqcF/QKMHM0QSjybK/qxuS33YEtTqps7f/22OXO+B9nskRZvCTGMhQ74LtZyXP0cURu
	VbHcy3QQmpH6dgJld6+UlqBuaue732wlkS54DXr4xnYHLkibyZh6SZ6w=
X-Google-Smtp-Source: AGHT+IF5AplGeYh2oJDqrlztft+uc8bXDYqrd140hdTloUW+5DDGPSe0zWJ7Nn1t8ZIyXzTEcsvOnSR4ZVw4iGmJn15UWbA/6FwN
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c29:b0:375:a03d:773a with SMTP id
 e9e14a558f8ab-375e0e27c0fmr778825ab.1.1718331605091; Thu, 13 Jun 2024
 19:20:05 -0700 (PDT)
Date: Thu, 13 Jun 2024 19:20:05 -0700
In-Reply-To: <fc8f4adb-feef-421b-995d-ae9ae059f4c5@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed98d9061ad0404e@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_cqe_overflow (3)
From: syzbot <syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

6.343044][    T1] openvswitch: Open vSwitch switching datapath
[   46.363888][    T1] NET: Registered PF_VSOCK protocol family
[   46.372367][    T1] mpls_gso: MPLS GSO support
[   46.524387][    T1] IPI shorthand broadcast: enabled
[   48.017346][    T1] sched_clock: Marking stable (47990050167, 17795964)-=
>(48016243838, -8397707)
[   49.133874][    T1] Timer migration: 1 hierarchy levels; 8 children per =
group; 0 crossnode level
[   49.302883][    T1] registered taskstats version 1
[   49.367583][    T1] Loading compiled-in X.509 certificates
[   49.405812][    T1] Loaded X.509 cert 'Build time autogenerated kernel k=
ey: ef5392d16e2343e2e997a1a8439f31430dca794f'
[   49.643401][    T1] zswap: loaded using pool lzo/zsmalloc
[   49.652895][    T1] Demotion targets for Node 0: null
[   49.658483][    T1] Demotion targets for Node 1: null
[   49.665807][    T1] Key type .fscrypt registered
[   49.672365][    T1] Key type fscrypt-provisioning registered
[   49.679915][    T1] kAFS: Red Hat AFS client v0.1 registering.
[   49.713149][    T1] Btrfs loaded, assert=3Don, ref-verify=3Don, zoned=3D=
yes, fsverity=3Dyes
[   49.740050][    T1] Key type encrypted registered
[   49.745095][    T1] AppArmor: AppArmor sha256 policy hashing enabled
[   49.753397][    T1] ima: No TPM chip found, activating TPM-bypass!
[   49.759983][    T1] Loading compiled-in module X.509 certificates
[   49.802303][    T1] Loaded X.509 cert 'Build time autogenerated kernel k=
ey: ef5392d16e2343e2e997a1a8439f31430dca794f'
[   49.813515][    T1] ima: Allocated hash algorithm: sha256
[   49.819655][    T1] ima: No architecture policies found
[   49.826134][    T1] evm: Initialising EVM extended attributes:
[   49.832247][    T1] evm: security.selinux (disabled)
[   49.837410][    T1] evm: security.SMACK64 (disabled)
[   49.842758][    T1] evm: security.SMACK64EXEC (disabled)
[   49.848460][    T1] evm: security.SMACK64TRANSMUTE (disabled)
[   49.854407][    T1] evm: security.SMACK64MMAP (disabled)
[   49.860131][    T1] evm: security.apparmor
[   49.864545][    T1] evm: security.ima
[   49.868491][    T1] evm: security.capability
[   49.872958][    T1] evm: HMAC attrs: 0x1
[   49.882187][    T1] PM:   Magic number: 12:875:156
[   49.888285][    T1] usb usb36-port7: hash matches
[   49.894166][    T1] bdi 1:8: hash matches
[   49.900642][    T1] printk: legacy console [netcon0] enabled
[   49.906787][    T1] netconsole: network logging started
[   49.913765][    T1] gtp: GTP module loaded (pdp ctx size 128 bytes)
[   49.922755][    T1] rdma_rxe: loaded
[   49.928813][    T1] cfg80211: Loading compiled-in X.509 certificates for=
 regulatory database
[   49.950799][    T1] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   49.969818][    T1] Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06=
c7248db18c600'
[   49.978593][    T1] clk: Disabling unused clocks
[   49.983531][    T1] ALSA device list:
[   49.987431][    T1]   #0: Dummy 1
[   49.991050][    T1]   #1: Loopback 1
[   49.994878][    T1]   #2: Virtual MIDI Card 1
[   50.005050][   T10] platform regulatory.0: Direct firmware load for regu=
latory.db failed with error -2
[   50.014970][   T10] platform regulatory.0: Falling back to sysfs fallbac=
k for: regulatory.db
[   50.024723][    T1] md: Waiting for all devices to be available before a=
utodetect
[   50.032705][    T1] md: If you don't use raid, use raid=3Dnoautodetect
[   50.039465][    T1] md: Autodetecting RAID arrays.
[   50.044595][    T1] md: autorun ...
[   50.048512][    T1] md: ... autorun DONE.
[   50.117733][    T1] EXT4-fs (sda1): mounted filesystem 5941fea2-f5fa-4b4=
e-b5ef-9af118b27b95 ro with ordered data mode. Quota mode: none.
[   50.131603][    T1] VFS: Mounted root (ext4 filesystem) readonly on devi=
ce 8:1.
[   50.144403][    T1] devtmpfs: mounted
[   50.408360][    T1] Freeing unused kernel image (initmem) memory: 37036K
[   50.420188][    T1] Write protecting the kernel read-only data: 262144k
[   50.467096][    T1] Freeing unused kernel image (rodata/data gap) memory=
: 1804K
[   52.119267][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages f=
ound.
[   52.129621][    T1] x86/mm: Checking user space page tables
[   53.636226][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages f=
ound.
[   53.645529][    T1] Failed to set sysctl parameter 'kernel.hung_task_all=
_cpu_backtrace=3D1': parameter not found
[   53.666750][    T1] Failed to set sysctl parameter 'max_rcu_stall_to_pan=
ic=3D1': parameter not found
[   53.678915][    T1] Run /sbin/init as init process
[   55.261831][ T4447] mount (4447) used greatest stack depth: 7808 bytes l=
eft
[   55.340544][ T4448] EXT4-fs (sda1): re-mounted 5941fea2-f5fa-4b4e-b5ef-9=
af118b27b95 r/w. Quota mode: none.
mount: mounting smackfs on /sys/fs/smackfs failed: No such file or director=
y
mount: mounting selinuxfs on /sys/fs/selinux failed: No such file or direct=
ory
[   55.675477][ T4451] mount (4451) used greatest stack depth: 5568 bytes l=
eft
Starting syslogd: OK
Starting acpid: OK
Starting klogd: OK
Running sysctl: OK
Populating /dev using udev: [   59.510303][ T4481] udevd[4481]: starting ve=
rsion 3.2.11
[   63.097528][ T4482] udevd[4482]: starting eudev-3.2.11
[   63.110491][ T4481] udevd (4481) used greatest stack depth: 5232 bytes l=
eft
done
Starting system message bus: done
Starting iptables: OK
Starting network: OK
Starting dhcpcd...
dhcpcd-9.4.1 starting
dev: loaded udev
DUID 00:04:c7:fd:4a:df:9d:a6:e9:60:55:7b:b4:5b:1f:77:00:5c
forked to background, child pid 4695
[  110.977706][ T4696] 8021q: adding VLAN 0 to HW filter on device bond0
[  111.031404][ T4696] eql: remember to turn off Van-Jacobson compression o=
n your slave devices
[  111.650739][   T10] cfg80211: failed to load regulatory.db
Starting sshd: OK


syzkaller

syzkaller login: [  114.063784][    C0] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  114.071021][    C0] BUG: KMSAN: uninit-value in receive_buf+0x25e3/0x5fd=
0
[  114.078922][    C0]  receive_buf+0x25e3/0x5fd0
[  114.083796][    C0]  virtnet_poll+0xd1c/0x23c0
[  114.088752][    C0]  __napi_poll+0xe7/0x980
[  114.093517][    C0]  net_rx_action+0x82a/0x1850
[  114.098512][    C0]  handle_softirqs+0x1ce/0x800
[  114.103581][    C0]  __irq_exit_rcu+0x68/0x120
[  114.108412][    C0]  irq_exit_rcu+0x12/0x20
[  114.112996][    C0]  common_interrupt+0x94/0xa0
[  114.118086][    C0]  asm_common_interrupt+0x2b/0x40
[  114.123480][    C0]  __msan_metadata_ptr_for_load_8+0x18/0x40
[  114.129797][    C0]  filemap_map_pages+0xe81/0x2e30
[  114.135034][    C0]  handle_mm_fault+0x6f36/0xe610
[  114.140206][    C0]  exc_page_fault+0x41b/0x700
[  114.145072][    C0]  asm_exc_page_fault+0x2b/0x30
[  114.150167][    C0]=20
[  114.152572][    C0] Uninit was created at:
[  114.156953][    C0]  __alloc_pages_noprof+0x9d6/0xe70
[  114.162368][    C0]  alloc_pages_mpol_noprof+0x299/0x990
[  114.168132][    C0]  alloc_pages_noprof+0x1bf/0x1e0
[  114.173274][    C0]  skb_page_frag_refill+0x2bf/0x7c0
[  114.178692][    C0]  virtnet_rq_alloc+0x43/0xbb0
[  114.183610][    C0]  try_fill_recv+0x3f0/0x2f50
[  114.188492][    C0]  virtnet_open+0x1cc/0xb00
[  114.193392][    C0]  __dev_open+0x546/0x6f0
[  114.197955][    C0]  __dev_change_flags+0x309/0x9a0
[  114.203263][    C0]  dev_change_flags+0x8e/0x1d0
[  114.208266][    C0]  devinet_ioctl+0x13ec/0x22c0
[  114.213265][    C0]  inet_ioctl+0x4bd/0x6d0
[  114.217709][    C0]  sock_do_ioctl+0xb7/0x540
[  114.222474][    C0]  sock_ioctl+0x727/0xd70
[  114.226915][    C0]  __se_sys_ioctl+0x261/0x450
[  114.231888][    C0]  __x64_sys_ioctl+0x96/0xe0
[  114.236624][    C0]  x64_sys_call+0x18c0/0x3b90
[  114.241782][    C0]  do_syscall_64+0xcd/0x1e0
[  114.246586][    C0]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  114.252971][    C0]=20
[  114.255409][    C0] CPU: 0 PID: 4803 Comm: rm Not tainted 6.10.0-rc3-syz=
kaller-00102-ga3027fbd92ad #0
[  114.265197][    C0] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 06/07/2024
[  114.275517][    C0] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  114.282666][    C0] Disabling lock debugging due to kernel taint
[  114.289094][    C0] Kernel panic - not syncing: kmsan.panic set ...
[  114.295774][    C0] CPU: 0 PID: 4803 Comm: rm Tainted: G    B           =
   6.10.0-rc3-syzkaller-00102-ga3027fbd92ad #0
[  114.307012][    C0] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 06/07/2024
[  114.317158][    C0] Call Trace:
[  114.320500][    C0]  <IRQ>
[  114.323392][    C0]  dump_stack_lvl+0x216/0x2d0
[  114.328201][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.334149][    C0]  dump_stack+0x1e/0x30
[  114.338426][    C0]  panic+0x4e2/0xcd0
[  114.342445][    C0]  ? kmsan_get_metadata+0xb1/0x1d0
[  114.348148][    C0]  kmsan_report+0x2d5/0x2e0
[  114.352948][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.358285][    C0]  ? __msan_warning+0x95/0x120
[  114.363159][    C0]  ? receive_buf+0x25e3/0x5fd0
[  114.368024][    C0]  ? virtnet_poll+0xd1c/0x23c0
[  114.372882][    C0]  ? __napi_poll+0xe7/0x980
[  114.377788][    C0]  ? net_rx_action+0x82a/0x1850
[  114.382798][    C0]  ? handle_softirqs+0x1ce/0x800
[  114.387868][    C0]  ? __irq_exit_rcu+0x68/0x120
[  114.392766][    C0]  ? irq_exit_rcu+0x12/0x20
[  114.397357][    C0]  ? common_interrupt+0x94/0xa0
[  114.402324][    C0]  ? asm_common_interrupt+0x2b/0x40
[  114.407634][    C0]  ? __msan_metadata_ptr_for_load_8+0x18/0x40
[  114.413807][    C0]  ? filemap_map_pages+0xe81/0x2e30
[  114.419117][    C0]  ? handle_mm_fault+0x6f36/0xe610
[  114.424461][    C0]  ? exc_page_fault+0x41b/0x700
[  114.429619][    C0]  ? asm_exc_page_fault+0x2b/0x30
[  114.434797][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.440132][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.445631][    C0]  ? kmsan_internal_memmove_metadata+0x17b/0x230
[  114.452123][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.457453][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.462794][    C0]  ? page_to_skb+0xdae/0x1620
[  114.467694][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.473057][    C0]  __msan_warning+0x95/0x120
[  114.477746][    C0]  receive_buf+0x25e3/0x5fd0
[  114.482558][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.488004][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.493964][    C0]  virtnet_poll+0xd1c/0x23c0
[  114.498684][    C0]  ? __pfx_virtnet_poll+0x10/0x10
[  114.503816][    C0]  __napi_poll+0xe7/0x980
[  114.508269][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.513605][    C0]  net_rx_action+0x82a/0x1850
[  114.518407][    C0]  ? sched_clock_cpu+0x55/0x870
[  114.523437][    C0]  ? __pfx_net_rx_action+0x10/0x10
[  114.528662][    C0]  handle_softirqs+0x1ce/0x800
[  114.533665][    C0]  __irq_exit_rcu+0x68/0x120
[  114.538379][    C0]  irq_exit_rcu+0x12/0x20
[  114.542838][    C0]  common_interrupt+0x94/0xa0
[  114.547656][    C0]  </IRQ>
[  114.550894][    C0]  <TASK>
[  114.553890][    C0]  asm_common_interrupt+0x2b/0x40
[  114.559040][    C0] RIP: 0010:__msan_metadata_ptr_for_load_8+0x18/0x40
[  114.565833][    C0] Code: 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 9=
0 90 90 f3 0f 1e fa 55 48 89 e5 53 48 83 ec 10 9c 8f 45 e8 0f 01 ca 48 8b 5=
d e8 <be> 08 00 00 00 31 d2 e8 9c 25 00 00 48 89 5d f0 ff 75 f0 9d 48 83
[  114.585747][    C0] RSP: 0000:ffff88811852fa60 EFLAGS: 00000286
[  114.591926][    C0] RAX: 0000000000000000 RBX: 0000000000000286 RCX: fff=
f888116094180
[  114.600091][    C0] RDX: 0000000000000000 RSI: 0000000000000036 RDI: fff=
f88811852fa90
[  114.608158][    C0] RBP: ffff88811852fa78 R08: ffffffff8203f34a R09: fff=
fffff8203e5a8
[  114.616220][    C0] R10: 0000000000000002 R11: ffff888116094180 R12: 000=
0000002b000d1
[  114.624272][    C0] R13: 000000000000000c R14: 000000000000000b R15: 000=
0000000000000
[  114.632317][    C0]  ? next_uptodate_folio+0x4c8/0x1730
[  114.637792][    C0]  ? next_uptodate_folio+0x126a/0x1730
[  114.643393][    C0]  filemap_map_pages+0xe81/0x2e30
[  114.648516][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.653822][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.659840][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.665189][    C0]  handle_mm_fault+0x6f36/0xe610
[  114.670266][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.675574][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.681161][    C0]  ? __pfx_filemap_map_pages+0x10/0x10
[  114.686733][    C0]  exc_page_fault+0x41b/0x700
[  114.691535][    C0]  asm_exc_page_fault+0x2b/0x30
[  114.696492][    C0] RIP: 0033:0x7fc22a8cdd20
[  114.701001][    C0] Code: Unable to access opcode bytes at 0x7fc22a8cdcf=
6.
[  114.708193][    C0] RSP: 002b:00007ffd152fccc0 EFLAGS: 00010202
[  114.714661][    C0] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000000
[  114.722723][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000000
[  114.730785][    C0] RBP: 0000000000000000 R08: 0000000000000000 R09: 000=
0000000000000
[  114.738829][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: 000=
0000000000000
[  114.747002][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 000=
0000000000000
[  114.755163][    C0]  </TASK>
[  114.758494][    C0] Kernel Offset: disabled
[  114.762888][    C0] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
GO111MODULE=3D'auto'
GOARCH=3D'amd64'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFLAGS=3D''
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.21.4'
GCCGO=3D'gccgo'
GOAMD64=3D'v1'
AR=3D'ar'
CC=3D'gcc'
CXX=3D'g++'
CGO_ENABLED=3D'1'
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOWORK=3D''
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
PKG_CONFIG=3D'pkg-config'
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build2855798142=3D/tmp/go-build -gno-record-gc=
c-switches'

git status (err=3D<nil>)
HEAD detached at 2aa5052fed
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sy=
s/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
go fmt ./sys/... >/dev/null
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D2aa5052fed5f8993afacfce02174322df0f03ec4 -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20240612-135002'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer=
 github.com/google/syzkaller/syz-fuzzer
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D2aa5052fed5f8993afacfce02174322df0f03ec4 -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20240612-135002'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execpr=
og github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include -fpermissive -w -DGOOS_linu=
x=3D1 -DGOARCH_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"2aa5052fed5f8993afacfce02174322df0=
f03ec4\"


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D12e30256980000


Tested on:

commit:         a3027fbd Merge branch 'master' into syz-test
git tree:       git://git.kernel.dk/linux.git syz-test
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D3486f1660f47f85=
5
dashboard link: https://syzkaller.appspot.com/bug?extid=3De6616d0dc8ded5dc5=
6d6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Note: no patches were applied.

