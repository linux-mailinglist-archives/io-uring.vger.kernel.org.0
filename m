Return-Path: <io-uring+bounces-2206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4816D908125
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 03:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB381283B25
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 01:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910FF1822F3;
	Fri, 14 Jun 2024 01:53:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D0C26AEC
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 01:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329985; cv=none; b=F9WZz5T5w3h9i1WCo/r2G7woMsJ5b8Wg+rJyUNLpqpS+ifp35VPcWWJVNFQHPniBG49QLNhj/Y8hP5kCJoIkhB5yFVcXOk4KSZCbJEuXj5AJ50o2F0wDlLlRiu0kY0q7u6HZRYtvKWkf1i+Z5sd2fIfQfxGENxh3UlQ9DuddZZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329985; c=relaxed/simple;
	bh=ZXLS7Meuj9b7gWiDEZtsoDJJdpAcvkCEEXSA5XocxaE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=VSoUT5zC2Cda4ePNkUQeV7dp2XR/yUzUhn5fkfQo2bQmu5jIoAUPi26x93L39P+4Ctg5flbGkYuXOpANv+x+BFfWfwZQFocDLvmPo0Unjm4XX+Nr/Dd/PbsEu9MzIkrIbNdgAu6BnUvGalWUjLm62Yj1oUSFhp6i6XK61faZvNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-36db3bbf931so17106305ab.0
        for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 18:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718329982; x=1718934782;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGFZODxFU68El3Ust4/5uSYb8B9OfgBf0JcJEBsD44Q=;
        b=FKWTek02mvJnHTJBB6kzBhw1Lqd/gZCcIwzo9Uh47EyZxTlWbDAClGQP4CdxDf30nt
         qY8GQ4Kifi8hNnus+Ifg7XFekTgCRG1R4DGoIUvoD0RucDQON/XGC8AeP7hygSVXuiZd
         UGLY38U1XhT9+Z/ElKn41Lh4wi35P5SXiO6lI0SuVZTd4bs/LVvFsGNs44BIHq3QFZP/
         707sONv4jOzhm9SFW0w9g3iW9UQP2fjafqY/HdtS+DY7gyAKgWvGysYWQKd9gEyQVcf4
         uWzqqfdHFJDcKISTJBNpMBWenJc4hBjmili3jsKdoQVCaDvW74OjZcmYuUAzWnjRzwSA
         X7tQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2McQ0L4/rc/nuQWSNYPTSwlUe9Wfg+/U95BSc7ukHwPF++0KbMGP8Sdat+fZu7ym/9TW2tgpQoy6u4Yq0BKLeArI4oLvGlBs=
X-Gm-Message-State: AOJu0YwP28HhWfUgYbD1D4RkuXxMPsXwI6zJkF01V8LjJtt7CmajVGlk
	4EEXSqBhaWkBcTFm2oiDJgVi7O5gYP4xgeVedzFveuLid86U6aSLN6jvzbhsxYEw+Mg/yQ2BD4G
	FJ5ubFlzMqsXC0DgoFk6v1tTqWp6AQ2/PE9v64i9tYGw21b7GuMXVa7A=
X-Google-Smtp-Source: AGHT+IHBSV9rkjUe75sCk5g6MKuFsJesK6eMgDlpSth+4UbGGaI7nYEd96/egQGEWRTzvcyjDtzizuHKCnd3j+Yjttg7jFZ+X7cB
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20ec:b0:36c:5c1b:2051 with SMTP id
 e9e14a558f8ab-375e10b24a8mr793335ab.6.1718329982589; Thu, 13 Jun 2024
 18:53:02 -0700 (PDT)
Date: Thu, 13 Jun 2024 18:53:02 -0700
In-Reply-To: <6d0ab5f4-45d5-4e16-bd4d-ae14e29d5f32@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003835b9061acfe0c4@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_cqe_overflow (3)
From: syzbot <syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

: Dummy 1
[   50.085324][    T1]   #1: Loopback 1
[   50.089179][    T1]   #2: Virtual MIDI Card 1
[   50.099411][   T10] platform regulatory.0: Direct firmware load for regu=
latory.db failed with error -2
[   50.110715][    T1] md: Waiting for all devices to be available before a=
utodetect
[   50.110769][    T1] md: If you don't use raid, use raid=3Dnoautodetect
[   50.110836][    T1] md: Autodetecting RAID arrays.
[   50.110883][    T1] md: autorun ...
[   50.119809][   T10] platform regulatory.0: Falling back to sysfs fallbac=
k for: regulatory.db
[   50.125316][    T1] md: ... autorun DONE.
[   50.234241][    T1] EXT4-fs (sda1): mounted filesystem 5941fea2-f5fa-4b4=
e-b5ef-9af118b27b95 ro with ordered data mode. Quota mode: none.
[   50.247976][    T1] VFS: Mounted root (ext4 filesystem) readonly on devi=
ce 8:1.
[   50.325610][    T1] devtmpfs: mounted
[   50.579226][    T1] Freeing unused kernel image (initmem) memory: 37032K
[   50.590992][    T1] Write protecting the kernel read-only data: 262144k
[   50.636998][    T1] Freeing unused kernel image (rodata/data gap) memory=
: 1808K
[   52.297749][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages f=
ound.
[   52.307966][    T1] x86/mm: Checking user space page tables
[   53.810797][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages f=
ound.
[   53.819734][    T1] Failed to set sysctl parameter 'kernel.hung_task_all=
_cpu_backtrace=3D1': parameter not found
[   53.841397][    T1] Failed to set sysctl parameter 'max_rcu_stall_to_pan=
ic=3D1': parameter not found
[   53.853295][    T1] Run /sbin/init as init process
[   55.624426][ T4453] mount (4453) used greatest stack depth: 8144 bytes l=
eft
[   55.700932][ T4454] EXT4-fs (sda1): re-mounted 5941fea2-f5fa-4b4e-b5ef-9=
af118b27b95 r/w. Quota mode: none.
mount: mounting smackfs on /sys/fs/smackfs failed: No such file or director=
y
mount: mounting selinuxfs on /sys/fs/selinux failed: No such file or direct=
ory
[   56.048626][ T4457] mount (4457) used greatest stack depth: 5568 bytes l=
eft
Starting syslogd: OK
Starting acpid: OK
Starting klogd: OK
Running sysctl: OK
Populating /dev using udev: [   59.882175][ T4487] udevd[4487]: starting ve=
rsion 3.2.11
[   63.461760][ T4488] udevd[4488]: starting eudev-3.2.11
[   63.474018][ T4487] udevd (4487) used greatest stack depth: 5288 bytes l=
eft
[   96.328335][ T1216] net_ratelimit: 2 callbacks suppressed
[   96.328413][ T1216] aoe: packet could not be sent on lo.  consider incre=
asing tx_queue_len
[   96.343724][ T1216] aoe: packet could not be sent on bond0.  consider in=
creasing tx_queue_len
[   96.352822][ T1216] aoe: packet could not be sent on dummy0.  consider i=
ncreasing tx_queue_len
[   96.362365][ T1216] aoe: packet could not be sent on eql.  consider incr=
easing tx_queue_len
[   96.371420][ T1216] aoe: packet could not be sent on ifb0.  consider inc=
reasing tx_queue_len
[   96.380617][ T1216] aoe: packet could not be sent on ifb1.  consider inc=
reasing tx_queue_len
[   96.390232][ T1216] aoe: packet could not be sent on eth0.  consider inc=
reasing tx_queue_len
[   96.399307][ T1216] aoe: packet could not be sent on wlan0.  consider in=
creasing tx_queue_len
[   96.408742][ T1216] aoe: packet could not be sent on wlan1.  consider in=
creasing tx_queue_len
[   96.417980][ T1216] aoe: packet could not be sent on hwsim0.  consider i=
ncreasing tx_queue_len
done
Starting system message bus: done
Starting iptables: OK
Starting network: OK
Starting dhcpcd...
dhcpcd-9.4.1 starting
dev: loaded udev
DUID 00:04:98:24:4c:28:99:7c:d9:70:fe:51:ca:fe:56:33:2c:7d
forked to background, child pid 4700
[  111.646112][ T4701] 8021q: adding VLAN 0 to HW filter on device bond0
[  111.665731][ T4701] eql: remember to turn off Van-Jacobson compression o=
n your slave devices
[  111.739327][   T10] cfg80211: failed to load regulatory.db
Starting sshd: [  114.013627][    C0] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  114.021043][    C0] BUG: KMSAN: uninit-value in receive_buf+0x25e3/0x5fd=
0
[  114.028525][    C0]  receive_buf+0x25e3/0x5fd0
[  114.033381][    C0]  virtnet_poll+0xd1c/0x23c0
[  114.038271][    C0]  __napi_poll+0xe7/0x980
[  114.042818][    C0]  net_rx_action+0x82a/0x1850
[  114.047892][    C0]  handle_softirqs+0x1ce/0x800
[  114.052877][    C0]  __irq_exit_rcu+0x68/0x120
[  114.057788][    C0]  irq_exit_rcu+0x12/0x20
[  114.062305][    C0]  common_interrupt+0x94/0xa0
[  114.067214][    C0]  asm_common_interrupt+0x2b/0x40
[  114.072524][    C0]  unmap_page_range+0x437/0x8670
[  114.077770][    C0]  unmap_single_vma+0x380/0x490
[  114.082992][    C0]  unmap_vmas+0x34a/0x610
[  114.087600][    C0]  exit_mmap+0x236/0xe60
[  114.091998][    C0]  __mmput+0x147/0x5d0
[  114.096258][    C0]  mmput+0x8a/0xa0
[  114.100278][    C0]  exec_mmap+0x80a/0x9b0
[  114.104689][    C0]  begin_new_exec+0x1ac4/0x2bd0
[  114.109838][    C0]  load_elf_binary+0x1412/0x4e10
[  114.114974][    C0]  bprm_execve+0xc57/0x21c0
[  114.119763][    C0]  do_execveat_common+0xceb/0xd70
[  114.124999][    C0]  __x64_sys_execve+0xf4/0x130
[  114.130048][    C0]  x64_sys_call+0x164f/0x3b90
[  114.135028][    C0]  do_syscall_64+0xcd/0x1e0
[  114.139822][    C0]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  114.145930][    C0]=20
[  114.148491][    C0] Uninit was created at:
[  114.152960][    C0]  __alloc_pages_noprof+0x9d6/0xe70
[  114.158456][    C0]  alloc_pages_mpol_noprof+0x299/0x990
[  114.164147][    C0]  alloc_pages_noprof+0x1bf/0x1e0
[  114.169493][    C0]  skb_page_frag_refill+0x2bf/0x7c0
[  114.175099][    C0]  virtnet_rq_alloc+0x43/0xbb0
[  114.180136][    C0]  try_fill_recv+0x3f0/0x2f50
[  114.184984][    C0]  virtnet_open+0x1cc/0xb00
[  114.189780][    C0]  __dev_open+0x546/0x6f0
[  114.194331][    C0]  __dev_change_flags+0x309/0x9a0
[  114.199804][    C0]  dev_change_flags+0x8e/0x1d0
[  114.204763][    C0]  devinet_ioctl+0x13ec/0x22c0
[  114.209866][    C0]  inet_ioctl+0x4bd/0x6d0
[  114.214386][    C0]  sock_do_ioctl+0xb7/0x540
[  114.219190][    C0]  sock_ioctl+0x727/0xd70
[  114.223697][    C0]  __se_sys_ioctl+0x261/0x450
[  114.228714][    C0]  __x64_sys_ioctl+0x96/0xe0
[  114.233472][    C0]  x64_sys_call+0x18c0/0x3b90
[  114.238517][    C0]  do_syscall_64+0xcd/0x1e0
[  114.243222][    C0]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  114.249490][    C0]=20
[  114.251937][    C0] CPU: 0 PID: 4799 Comm: S50sshd Not tainted 6.10.0-rc=
1-syzkaller-00009-gf4a1254f2a07 #0
[  114.262178][    C0] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 06/07/2024
[  114.272668][    C0] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  114.279876][    C0] Disabling lock debugging due to kernel taint
[  114.286162][    C0] Kernel panic - not syncing: kmsan.panic set ...
[  114.292711][    C0] CPU: 0 PID: 4799 Comm: S50sshd Tainted: G    B      =
        6.10.0-rc1-syzkaller-00009-gf4a1254f2a07 #0
[  114.304458][    C0] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 06/07/2024
[  114.314789][    C0] Call Trace:
[  114.318203][    C0]  <IRQ>
[  114.321156][    C0]  dump_stack_lvl+0x216/0x2d0
[  114.326043][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.332094][    C0]  dump_stack+0x1e/0x30
[  114.336442][    C0]  panic+0x4e2/0xcd0
[  114.340533][    C0]  ? kmsan_get_metadata+0x111/0x1d0
[  114.345974][    C0]  kmsan_report+0x2d5/0x2e0
[  114.350698][    C0]  ? kmsan_alloc_page+0x182/0x220
[  114.355934][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.361337][    C0]  ? __msan_warning+0x95/0x120
[  114.366312][    C0]  ? receive_buf+0x25e3/0x5fd0
[  114.371293][    C0]  ? virtnet_poll+0xd1c/0x23c0
[  114.376247][    C0]  ? __napi_poll+0xe7/0x980
[  114.380957][    C0]  ? net_rx_action+0x82a/0x1850
[  114.386121][    C0]  ? handle_softirqs+0x1ce/0x800
[  114.391359][    C0]  ? __irq_exit_rcu+0x68/0x120
[  114.396339][    C0]  ? irq_exit_rcu+0x12/0x20
[  114.401043][    C0]  ? common_interrupt+0x94/0xa0
[  114.406205][    C0]  ? asm_common_interrupt+0x2b/0x40
[  114.411631][    C0]  ? unmap_page_range+0x437/0x8670
[  114.417009][    C0]  ? unmap_single_vma+0x380/0x490
[  114.422335][    C0]  ? unmap_vmas+0x34a/0x610
[  114.427043][    C0]  ? exit_mmap+0x236/0xe60
[  114.431644][    C0]  ? __mmput+0x147/0x5d0
[  114.436101][    C0]  ? mmput+0x8a/0xa0
[  114.440190][    C0]  ? exec_mmap+0x80a/0x9b0
[  114.444795][    C0]  ? begin_new_exec+0x1ac4/0x2bd0
[  114.450011][    C0]  ? load_elf_binary+0x1412/0x4e10
[  114.455320][    C0]  ? bprm_execve+0xc57/0x21c0
[  114.460196][    C0]  ? do_execveat_common+0xceb/0xd70
[  114.465599][    C0]  ? __x64_sys_execve+0xf4/0x130
[  114.470719][    C0]  ? x64_sys_call+0x164f/0x3b90
[  114.475779][    C0]  ? do_syscall_64+0xcd/0x1e0
[  114.480647][    C0]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  114.486933][    C0]  ? kmsan_internal_memmove_metadata+0x17b/0x230
[  114.493494][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.498917][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.504332][    C0]  ? page_to_skb+0xdae/0x1620
[  114.509232][    C0]  __msan_warning+0x95/0x120
[  114.514026][    C0]  receive_buf+0x25e3/0x5fd0
[  114.518819][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.524319][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.530382][    C0]  virtnet_poll+0xd1c/0x23c0
[  114.535205][    C0]  ? __pfx_virtnet_poll+0x10/0x10
[  114.540952][    C0]  __napi_poll+0xe7/0x980
[  114.545495][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.550961][    C0]  net_rx_action+0x82a/0x1850
[  114.555904][    C0]  ? sched_clock_cpu+0x55/0x870
[  114.560969][    C0]  ? __pfx_net_rx_action+0x10/0x10
[  114.566314][    C0]  handle_softirqs+0x1ce/0x800
[  114.571324][    C0]  __irq_exit_rcu+0x68/0x120
[  114.576116][    C0]  irq_exit_rcu+0x12/0x20
[  114.580642][    C0]  common_interrupt+0x94/0xa0
[  114.585603][    C0]  </IRQ>
[  114.588665][    C0]  <TASK>
[  114.591713][    C0]  asm_common_interrupt+0x2b/0x40
[  114.596959][    C0] RIP: 0010:unmap_page_range+0x437/0x8670
[  114.602895][    C0] Code: 01 00 00 48 83 bc 24 38 02 00 00 00 0f 85 a2 7=
9 00 00 48 8b bc 24 f8 01 00 00 48 8b 1f 48 89 5c 24 20 e8 4c 22 26 00 4c 8=
b 30 <44> 8b 22 48 83 e3 9f 49 c7 45 00 00 00 00 00 4c 89 f0 48 83 e0 9f
[  114.622720][    C0] RSP: 0018:ffff8881178032f0 EFLAGS: 00000286
[  114.628967][    C0] RAX: ffff88811a3767f8 RBX: 800000011786d067 RCX: 000=
000011a7767f8
[  114.637129][    C0] RDX: ffff88811a7767f8 RSI: ffff88813fff9230 RDI: fff=
f88811ab767f8
[  114.645292][    C0] RBP: ffff888117803578 R08: ffffea000000000f R09: 000=
0000000000000
[  114.653453][    C0] R10: ffff888117003698 R11: 0000000000000004 R12: 000=
0000000000000
[  114.661696][    C0] R13: ffff888117a1ac00 R14: 0000000000000000 R15: 000=
07fef966eafff
[  114.669872][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.675323][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.680765][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.686196][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.692245][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.697670][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.703716][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.709137][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.715203][    C0]  unmap_single_vma+0x380/0x490
[  114.720293][    C0]  unmap_vmas+0x34a/0x610
[  114.724956][    C0]  exit_mmap+0x236/0xe60
[  114.729417][    C0]  ? kmsan_get_shadow_origin_ptr+0x4d/0xb0
[  114.735450][    C0]  __mmput+0x147/0x5d0
[  114.739725][    C0]  ? kmsan_internal_unpoison_memory+0x14/0x20
[  114.746005][    C0]  mmput+0x8a/0xa0
[  114.749934][    C0]  exec_mmap+0x80a/0x9b0
[  114.754382][    C0]  begin_new_exec+0x1ac4/0x2bd0
[  114.759451][    C0]  load_elf_binary+0x1412/0x4e10
[  114.764594][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.770014][    C0]  ? kmsan_internal_set_shadow_origin+0x66/0xe0
[  114.776491][    C0]  ? kmsan_internal_unpoison_memory+0x14/0x20
[  114.782774][    C0]  ? load_elf_binary+0x1341/0x4e10
[  114.788101][    C0]  ? kmsan_get_metadata+0x146/0x1d0
[  114.793557][    C0]  ? __pfx_load_elf_binary+0x10/0x10
[  114.799058][    C0]  bprm_execve+0xc57/0x21c0
[  114.803804][    C0]  do_execveat_common+0xceb/0xd70
[  114.809069][    C0]  __x64_sys_execve+0xf4/0x130
[  114.814046][    C0]  x64_sys_call+0x164f/0x3b90
[  114.818961][    C0]  do_syscall_64+0xcd/0x1e0
[  114.823690][    C0]  ? clear_bhb_loop+0x25/0x80
[  114.828613][    C0]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  114.834753][    C0] RIP: 0033:0x7fef96824ef7
[  114.839364][    C0] Code: Unable to access opcode bytes at 0x7fef96824ec=
d.
[  114.846558][    C0] RSP: 002b:00007ffee5058098 EFLAGS: 00000246 ORIG_RAX=
: 000000000000003b
[  114.855184][    C0] RAX: ffffffffffffffda RBX: 0000556bd3625190 RCX: 000=
07fef96824ef7
[  114.863430][    C0] RDX: 0000556bd36251a8 RSI: 0000556bd3625190 RDI: 000=
0556bd3625210
[  114.871579][    C0] RBP: 0000556bd3625210 R08: 0000556bd3625215 R09: 000=
07ffee5059fa2
[  114.879814][    C0] R10: 0000000000000008 R11: 0000000000000246 R12: 000=
0556bd36251a8
[  114.887957][    C0] R13: 00007fef969d2904 R14: 0000556bd36251a8 R15: 000=
0000000000000
[  114.896125][    C0]  </TASK>
[  114.899544][    C0] Kernel Offset: disabled
[  114.903930][    C0] Rebooting in 86400 seconds..


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
 -ffile-prefix-map=3D/tmp/go-build827277809=3D/tmp/go-build -gno-record-gcc=
-switches'

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
https://syzkaller.appspot.com/x/error.txt?x=3D12f14736980000


Tested on:

commit:         f4a1254f io_uring: fix cancellation overwriting req->f..
git tree:       git://git.kernel.dk/linux.git io_uring-6.10
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D54d66e52f38a45d=
8
dashboard link: https://syzkaller.appspot.com/bug?extid=3De6616d0dc8ded5dc5=
6d6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Note: no patches were applied.

