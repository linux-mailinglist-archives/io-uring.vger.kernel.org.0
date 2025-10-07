Return-Path: <io-uring+bounces-9905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C27BABC030F
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 07:23:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B56F189D5A6
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 05:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D431E1DE7;
	Tue,  7 Oct 2025 05:23:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819C01DE3B7
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 05:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759814612; cv=none; b=tPGAD911jG0DAnIeoyGw3FxcuUQVt8TT6qOVflktgwr1Bu5Xs0oRrbaYF6mfm9uaHC49ZrH2wrtVW5/Fk/v/RZWYFHJjv2iNH54B2yMPwv7s+rGPgmP/qSIbY0DKtRDcsCQyDTWZlGkF1q4S9f5zEowzg7jgHmqtKlcHwcbHjI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759814612; c=relaxed/simple;
	bh=hF/RTtCsIXYJfva7IJoml8ntiMvzO1XyrjLgq49Rz+A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b0oatfaXM2KOGQ+/yaiTq6lSuotskKacoaFtzit4Fd69oS5MU50eb9//9nxbGD8fLJ/e648At+Kd3wvs8tmxi5MOtSyamwAsSOVV/i7jLN2UxQw17T0PD9ZQ9zEnb/GtFpMispYqCBMqWobZ6sd0ef0bW6mQkH+7WRl2AnOHrWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-42f64261ab8so90731295ab.0
        for <io-uring@vger.kernel.org>; Mon, 06 Oct 2025 22:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759814609; x=1760419409;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nVHfrhw8p9Pa8xYIGQ9EljBv3N3ecAdNVnBD/usVWZs=;
        b=nzKQGZ7OkRNRzBZg3Frl+fzXvVTC+DzPOeCztitbZSiqquTuXkd1dj38B2uZMukICq
         oPSKRmMupDAfPQ1/WbLXf0j7O50R3mXu3jWvhR+wPigezLAQ0MP9pLKo2VRT+o0MCkqY
         2wCyUCTtDHZRC1bu37gyNrPlSGFUtCe20xiffyS91l7wIF0g2S9Cc81K5FenfncVAFgf
         b8hz/96W/SS3cq3QUkv/zcVbPdMRw+1NzPQmpDOhkJ8kIa1IQ6MpdL6rKCDY5RGuUztP
         wbqL7dpQ4yjVhmMMcwwFD8+8GcMnjcFBcA0EoEoZAd9BP4WqOqDzOIUlmvYFnyl986KJ
         sDCw==
X-Forwarded-Encrypted: i=1; AJvYcCVLXi0Ez2iJmxAKDqDrXoJkgOPEkYbJc71pBm+6sKVRBsX8yZsryOkilnFefbU1QeUhSa6nFQ69wg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6psYUN0l39mZRIJ4fl6h60wXU8qPxUJV3QFz47RjztgazO9w9
	HCN0UmuYkX2zj66w6yneGITwC+oYsbDdjJQf2xhMU+qxT62xiQJllY/Ka7TWtj7bcK8Y6kXJxC7
	PoHOXPR7R15KSZq/fE3nlM+xbLIXvfKF7neVPmtcpVypCcAcyZwUwi5XqkSA=
X-Google-Smtp-Source: AGHT+IFQohCLUW9JVi6BCN8/njSlnTUl1RB9nqXey9XZZdZkOqOrsSglfemmEdZpzp1F1yCF8Ho8lPXmjcLO8SMiMpD1aLXZC5zs
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168e:b0:424:14a4:5064 with SMTP id
 e9e14a558f8ab-42e7ac437a1mr189297915ab.0.1759814609600; Mon, 06 Oct 2025
 22:23:29 -0700 (PDT)
Date: Mon, 06 Oct 2025 22:23:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e4a3d1.a00a0220.298cc0.0471.GAE@google.com>
Subject: [syzbot] [nfs?] [io-uring?] WARNING in nfsd_file_cache_init
From: syzbot <syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com>
To: Dai.Ngo@oracle.com, axboe@kernel.dk, chuck.lever@oracle.com, 
	io-uring@vger.kernel.org, jlayton@kernel.org, linux-kernel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, neil@brown.name, okorniev@redhat.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d104e3d17f7b Merge tag 'cxl-for-6.18' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=116bb942580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccc18dddafa95b97
dashboard link: https://syzkaller.appspot.com/bug?extid=a6f4d69b9b23404bbabf
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1573b214580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b515cd980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/335d7c35cbbe/disk-d104e3d1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/72dbd901415b/vmlinux-d104e3d1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3ff1353d0870/bzImage-d104e3d1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6128 at kernel/locking/lockdep.c:6606 lockdep_unregister_key+0x2ca/0x310 kernel/locking/lockdep.c:6606
Modules linked in:
CPU: 1 UID: 0 PID: 6128 Comm: syz.4.21 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:lockdep_unregister_key+0x2ca/0x310 kernel/locking/lockdep.c:6606
Code: 50 e4 0f 48 3b 44 24 10 0f 84 26 fe ff ff e8 bd cd 17 09 e8 e8 ce 17 09 41 f7 c7 00 02 00 00 74 bd fb 40 84 ed 75 bc eb cd 90 <0f> 0b 90 e9 19 ff ff ff 90 0f 0b 90 e9 2a ff ff ff 48 c7 c7 d0 ac
RSP: 0018:ffffc90003e870d0 EFLAGS: 00010002
RAX: eb1525397f5bdf00 RBX: ffff88803c121148 RCX: 1ffff920007d0dfc
RDX: 0000000000000000 RSI: ffffffff8acb1500 RDI: ffffffff8b1dd0e0
RBP: 00000000ffffffea R08: ffffffff8eb5aa37 R09: 1ffffffff1d6b546
R10: dffffc0000000000 R11: fffffbfff1d6b547 R12: 0000000000000000
R13: ffff88814d1b8900 R14: 0000000000000000 R15: 0000000000000203
FS:  00007f773f75e6c0(0000) GS:ffff88812712f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdaea3af52 CR3: 000000003a5ca000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __kmem_cache_release+0xe3/0x1e0 mm/slub.c:7696
 do_kmem_cache_create+0x74e/0x790 mm/slub.c:8575
 create_cache mm/slab_common.c:242 [inline]
 __kmem_cache_create_args+0x1ce/0x330 mm/slab_common.c:340
 nfsd_file_cache_init+0x1d6/0x530 fs/nfsd/filecache.c:816
 nfsd_startup_generic fs/nfsd/nfssvc.c:282 [inline]
 nfsd_startup_net fs/nfsd/nfssvc.c:377 [inline]
 nfsd_svc+0x393/0x900 fs/nfsd/nfssvc.c:786
 nfsd_nl_threads_set_doit+0x84a/0x960 fs/nfsd/nfsctl.c:1639
 genl_family_rcv_msg_doit+0x212/0x300 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x846/0xa10 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:742
 ____sys_sendmsg+0x508/0x820 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x1a1/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f77400eeec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f773f75e038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7740345fa0 RCX: 00007f77400eeec9
RDX: 0000000000008004 RSI: 0000200000000180 RDI: 0000000000000006
RBP: 00007f7740171f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7740346038 R14: 00007f7740345fa0 R15: 00007ffce616f8d8
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

