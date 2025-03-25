Return-Path: <io-uring+bounces-7243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BAFA709DD
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 20:03:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4352817E8FA
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 18:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB761E1DE2;
	Tue, 25 Mar 2025 18:53:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f80.google.com (mail-ua1-f80.google.com [209.85.222.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948781DDA14
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928827; cv=none; b=MxtmNTlGNWMeZteOPrWpP8y9vDHTNzZL3RwccQJt3+uBVEstz1DhMWtBh+EDA8FlSOpjMmXqLNySw1m6VAMVQxDiE03pHLlEFJhmOuwTvEJq2OvfTzd3D7m+Xb9+MEBnNMsBW+9Ca0YKFv/W6M4rPryxlBjp4433X+JKOVsSGSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928827; c=relaxed/simple;
	bh=zGupvF8yrRozOv6tT9j+/eKRp+/zVe79XmqL3dHGU8o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BLntboIBOFF03dWh3nwpu6xU3dYGGJSXZ0zT1xhAdduyNDZLU3UIAp/J8JcEkgeZ19bt97GpN3X3dtM20I0dZ3oo6YhPq550llYpGfjwXJjGR7JSp2R5dq0sEj4pCE/9gHDWCaOvqFv7F0mp3LLY3Cvz3FVvBz5EQ2aPJLAGFog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.222.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ua1-f80.google.com with SMTP id a1e0cc1a2514c-86d376bc992so7851800241.3
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 11:53:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742928824; x=1743533624;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GG0iCKwDH9KZTZsDp4Avb3wqwoFz6sePEbX2q3Ppj48=;
        b=SDMbKmWowMsT7A2BvoidkdhWgVaQB7kl2DAPq0NtZKyOZlVR9n2DGCuLVKyLcTA++4
         2wr2hJQoRJkF1Rdkh6QxriSGp/FGet0xbNkJCdSfZp4FimotJs3SRTv9Qg9J3C9EHvdF
         0xPx39lnLoFHrZ3yzR18f2fMAx2HlkQUxsqG3kj7vFXZdI+RrwDDgfoLRln75quMiRfq
         p69Tt67VSH6pLGHF/AJ4L5aavmUCPrgIiQpqD+TNrYagiu7rriwrdrFd6mGjiLCjI4CK
         u0rCJ/HOsc8/vGd84vQP8OSpkxYnEZtxy+vpnN9+/ThGuiUhakbqk/dIg1CKNcS9pL3I
         ja4g==
X-Forwarded-Encrypted: i=1; AJvYcCV9i8dpkhjxnDFE2dA+rEw3xDRQKWVc2z8QwtSpzaEDGIB+NBRYxCrmi7W1mv1thwJpyQ5TG9FdpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1mvc36tj6aaG7lN3iSyGa6MdDwk/zd4UAmeYgcQz1OgsBpA4x
	XEMnVi6zWyHH1KFJeFX/w59DK+NaDF/OzIWou/zlGKMhG/o1nfBU1GfSfD3BWqNA4ieD3Wf/hrU
	GaBeQx9sYfIbZXr41f9TBDpNOhoJUa9BjlYRHDkL9iG6vJfMZB/QIN8Q=
X-Google-Smtp-Source: AGHT+IH9aZIr86YFiB/nZHoAPIpiFpPmKisM4Mc/3V3NF81TDmbJHgoghCJ/dvYt9MZpKzy+bEC3111aWBBUM1mj0KhgoMl73MoN
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca46:0:b0:3d3:d823:5402 with SMTP id
 e9e14a558f8ab-3d59613ea0bmr199543535ab.7.1742928813390; Tue, 25 Mar 2025
 11:53:33 -0700 (PDT)
Date: Tue, 25 Mar 2025 11:53:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e2fbad.050a0220.a7ebc.0052.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING: refcount bug in io_tx_ubuf_complete
From: syzbot <syzbot+640cb22897e59078196e@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d07de43e3f05 Merge tag 'io_uring-6.14-20250321' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e4de98580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2e330e9768b5b8ff
dashboard link: https://syzkaller.appspot.com/bug?extid=640cb22897e59078196e
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89a42818241f/disk-d07de43e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/379e7ddd9b3b/vmlinux-d07de43e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1ad55828885f/bzImage-d07de43e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+640cb22897e59078196e@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 11036 at lib/refcount.c:28 refcount_warn_saturate+0x14a/0x210 lib/refcount.c:28
Modules linked in:
CPU: 1 UID: 0 PID: 11036 Comm: syz.5.1209 Not tainted 6.14.0-rc7-syzkaller-00186-gd07de43e3f05 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:refcount_warn_saturate+0x14a/0x210 lib/refcount.c:28
Code: ff 89 de e8 e8 1b f5 fc 84 db 0f 85 66 ff ff ff e8 3b 21 f5 fc c6 05 77 2b 86 0b 01 90 48 c7 c7 20 17 d3 8b e8 87 51 b5 fc 90 <0f> 0b 90 90 e9 43 ff ff ff e8 18 21 f5 fc 0f b6 1d 52 2b 86 0b 31
RSP: 0018:ffffc9000bd979c8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9001d01c000
RDX: 0000000000080000 RSI: ffffffff817a2276 RDI: 0000000000000001
RBP: ffff888049207010 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: ffff888049207010 R15: ffff88802a564000
FS:  00007fa9b395d6c0(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f53a8057d58 CR3: 000000002b110000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000097 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_sub_and_test include/linux/refcount.h:275 [inline]
 __refcount_dec_and_test include/linux/refcount.h:307 [inline]
 refcount_dec_and_test include/linux/refcount.h:325 [inline]
 io_tx_ubuf_complete+0x236/0x280 io_uring/notif.c:50
 io_notif_flush io_uring/notif.h:40 [inline]
 io_send_zc_cleanup+0x8a/0x1c0 io_uring/net.c:1222
 io_clean_op io_uring/io_uring.c:406 [inline]
 io_free_batch_list io_uring/io_uring.c:1429 [inline]
 __io_submit_flush_completions+0xcb3/0x1df0 io_uring/io_uring.c:1470
 io_submit_flush_completions io_uring/io_uring.h:159 [inline]
 ctx_flush_and_put.constprop.0+0x9a/0x410 io_uring/io_uring.c:1031
 io_handle_tw_list+0x3df/0x540 io_uring/io_uring.c:1071
 tctx_task_work_run+0xac/0x390 io_uring/io_uring.c:1123
 tctx_task_work+0x7b/0xd0 io_uring/io_uring.c:1141
 task_work_run+0x14e/0x250 kernel/task_work.c:227
 get_signal+0x1d3/0x26c0 kernel/signal.c:2809
 arch_do_signal_or_restart+0x90/0x7e0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x150/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa9b2b8d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa9b395d038 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000800 RBX: 00007fa9b2da5fa0 RCX: 00007fa9b2b8d169
RDX: 0000000000000000 RSI: 00000000000047bc RDI: 0000000000000005
RBP: 00007fa9b2c0e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fa9b2da5fa0 R15: 00007ffee776f038
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

