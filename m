Return-Path: <io-uring+bounces-11325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AAC86CE8DE0
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 08:15:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4E10C3008888
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 07:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7229B39FD9;
	Tue, 30 Dec 2025 07:15:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C270021CC79
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 07:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767078927; cv=none; b=DoHZWctbMjySKaefel22IFNXDT8+nutdYCSVqymKnCMVCfEa5hk2eDcEA5fluafP6xpqW117JFX4L+jSfM5JfoYs95lp9vop3NsFd9ukcYVN6w8KTJpw7r0nrPpDcUoqSZzqH5fonddKwFb1Rl3QgPYWK2y4ulzLyuMwzYkmqhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767078927; c=relaxed/simple;
	bh=DBXp4VT3186GU8/Wx0M5N0H7sbJdtIXGgSPmJnL0s0I=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=BposhV9AMRxRfSPY1gdD6V/Wjs+rD053HAIrIsIhjnTcWp3leFR01ei2URek3m5hBXXXpl2yr2shzEUdqRs41g08mex/RPMiMJi3QjN9vFQzcpGunIxl5YdrVH8sDvtJzoOi1sn6zq3k9HIbHBUsXEit1Ohnn0tEyHvmC8QsRvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c702d1a4f7so21901812a34.3
        for <io-uring@vger.kernel.org>; Mon, 29 Dec 2025 23:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767078925; x=1767683725;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgGJwD7qdIdKEkDnJjehUEAeSDmCHmFoHq1pnxZA+X4=;
        b=lejCd35nN8zbBkvXWHeW4har9vb7L3p1TqpGOwpQaS+8ncEbm2RRYgRfklnKXxpwVN
         utixOsSnRL6NDO3iuMzvzIwNJ7qthVm4Tg+1oHKHksh6kDKmEMYuJNGsMa/88/FlQx5Y
         3ptPek/ORms0Ab2riLxDbJrbRFzEMmjT/XiEyjnPiLfi6xY4gngNi2qydVGmLcAsTbP7
         jcAGnCkWDrsVa7V+/g8cuP4irokhFd6mNyAV2k27cg+MgRXuv6DAtljqeJq5uS4xqI1+
         wh9YxMutexU9qGjvTO1Gh8IEzThaImSCT3y9/8iAjLbwWrPUvN0a3DSq8KNkajjQcOG/
         qRaA==
X-Forwarded-Encrypted: i=1; AJvYcCXdw3/XD4F3lwUXBIIKFlMh79Ao5jf6yPu3Blz2MTjUOS1cOrF2jaCZcjBUYnX8P2M0Szq33yJb1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKRTsejC2Xdcd4aXW+mGKgwNOZfJ9G1sAI8woGTrCSpctNoYoY
	emt/kCbB7BaaSpqoDYe6ILxe0zr6bs8udA6BonfRpWMJNTSVK+yA4dusYw2xVdKKC+bSr7YQuP2
	adL358CHtt8rI5UY46Nr3NJt2ME2BTuzOVxN7mCuZaAwpRf471meuKD2UAe0=
X-Google-Smtp-Source: AGHT+IFJhWEJ1/oaFGClk2GgR+etAe+nQroVNojAIznuwC57O4eAWg7uAX4V8RvYQSht2iYlBujBz85W4cL2tj9nhybPYYeNHctb
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:178:b0:659:9a49:8fe8 with SMTP id
 006d021491bc7-65d0e9620c8mr12157870eaf.21.1767078924733; Mon, 29 Dec 2025
 23:15:24 -0800 (PST)
Date: Mon, 29 Dec 2025 23:15:24 -0800
In-Reply-To: <20251229201933.515797-1-alexandre@negrel.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69537c0c.050a0220.329c0f.04b2.GAE@google.com>
Subject: [syzbot ci] Re: io_uring: make overflowing cqe subject to OOM
From: syzbot ci <syzbot+ci34ed6dfe453ba6f8@syzkaller.appspotmail.com>
To: alexandre@negrel.dev, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] io_uring: make overflowing cqe subject to OOM
https://lore.kernel.org/all/20251229201933.515797-1-alexandre@negrel.dev
* [PATCH] io_uring: make overflowing cqe subject to OOM

and found the following issue:
WARNING in io_get_cqe_overflow

Full report is available here:
https://ci.syzbot.org/series/d71ff874-04e1-4cc7-b7c0-e48eb77bc984

***

WARNING in io_get_cqe_overflow

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c13ff885-4e87-4df2-9d49-a52f3d040dd6/config
C repro:   https://ci.syzbot.org/findings/e3c6e33b-4e4e-45de-b5b7-4ff5fc363989/c_repro
syz repro: https://ci.syzbot.org/findings/e3c6e33b-4e4e-45de-b5b7-4ff5fc363989/syz_repro

------------[ cut here ]------------
WARNING: io_uring/io_uring.h:211 at io_lockdep_assert_cq_locked io_uring/io_uring.h:211 [inline], CPU#0: syz.0.17/5984
WARNING: io_uring/io_uring.h:211 at io_get_cqe_overflow+0x599/0x730 io_uring/io_uring.h:249, CPU#0: syz.0.17/5984
Modules linked in:
CPU: 0 UID: 0 PID: 5984 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:io_lockdep_assert_cq_locked io_uring/io_uring.h:211 [inline]
RIP: 0010:io_get_cqe_overflow+0x599/0x730 io_uring/io_uring.h:249
Code: 0f 0b 90 e9 0e fb ff ff e8 c4 29 35 fd 90 0f 0b 90 e9 91 fb ff ff e8 b6 29 35 fd 90 0f 0b 90 e9 6a fd ff ff e8 a8 29 35 fd 90 <0f> 0b 90 e9 5c fd ff ff e8 9a 29 35 fd 90 0f 0b 90 e9 4a fd ff ff
RSP: 0018:ffffc90003cf7958 EFLAGS: 00010293
RAX: ffffffff848d4748 RBX: 0000000000000000 RCX: ffff888110c8ba80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff888110c8ba80 R09: 0000000000000002
R10: 00000000fffffdef R11: 0000000000000000 R12: 0000000000000000
R13: 1ffff11022544c00 R14: ffff888112a26000 R15: dffffc0000000000
FS:  00005555940b9500(0000) GS:ffff88818e40f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30563fff CR3: 00000001731de000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 io_get_cqe io_uring/io_uring.h:271 [inline]
 io_fill_cqe_req io_uring/io_uring.h:293 [inline]
 __io_submit_flush_completions+0x11c/0xe50 io_uring/io_uring.c:1507
 io_submit_flush_completions io_uring/io_uring.h:239 [inline]
 io_submit_state_end io_uring/io_uring.c:2318 [inline]
 io_submit_sqes+0x1c26/0x2130 io_uring/io_uring.c:2433
 __do_sys_io_uring_enter io_uring/io_uring.c:3264 [inline]
 __se_sys_io_uring_enter+0x2f7/0x2c30 io_uring/io_uring.c:3203
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f00d579acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc380f6178 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f00d5a05fa0 RCX: 00007f00d579acb9
RDX: 0000000000000002 RSI: 0000000000004d10 RDI: 0000000000000003
RBP: 00007f00d5808bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f00d5a05fac R14: 00007f00d5a05fa0 R15: 00007f00d5a05fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

