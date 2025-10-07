Return-Path: <io-uring+bounces-9920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B405BC19F6
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 16:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 256E03AC803
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 14:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F2A2DFA27;
	Tue,  7 Oct 2025 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gw+Jel9m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B5319DF66
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759845749; cv=none; b=mMKgxa63lr3M6hp5KGfK13FvyOTpHMbpDOZ1FSVMTavlDvJhDa8jFH9VUFwLN6FJ29jOPlJ4PlXH3hsRIfUyI8MydTbjyRkIA/M+vRk/npvBpbOHJe2Okrftqa5pESbal/WWbmVeVWeElqjGnRfw6Nq2i+qdy5ofUiSndURcTp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759845749; c=relaxed/simple;
	bh=YYM0DLTWLid+LxoSK+oRaIV4SXgjoLmmCX6dB5jdzSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nQCd5KEVsRh+XxgBMnguV3Sgn9D3NPV5uzeUvYyKFo59AvPPcP1BeaHruDZhmgNB9hiJj598V/dC5j749HJAR6BUVG2q54qvdre1vr35BxEGwKrKximhfHt3C/BwnY8Lyb9sSGn4RAWmTEW+9How60WzVp3VVhD05P1593a9e50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gw+Jel9m; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so3023442f8f.1
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 07:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759845745; x=1760450545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8X3644BJ08teap+WkoqaT6uPTiMPl6es12UalmJA20=;
        b=gw+Jel9mR8sM7nswjLcMuuIzqR3UE5rokImp2iUUXWe7NHrWVF3dzvqOoY5ImjE/bi
         YRn6YbXrkUuxF/ZaBQ6jl2PVlD40umbXzVWheAFxAs1edUpiHO2cNQ7EgKQp71MHRphZ
         pvCHIhywuwt8kMUWquZGe5ycjapDyBRcJpC+byYu4ykgiLfJQ/mkgRJ60lG7aNxgqHUK
         Lf215hICJaXpe8w/ISpqjptJmnB8x9TPWX/C+hhkZrMCFpFOjdxILdUqv5iLE8L7XLgr
         XRN2MOraUBj4v4ecZ/7BT8fPUZAAfc+pgnsE9Lo/cgefxMcHr8stil1bn8y9qvoGoDWZ
         1cjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759845745; x=1760450545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J8X3644BJ08teap+WkoqaT6uPTiMPl6es12UalmJA20=;
        b=Teou323ncmiWg0eiisTZTa3rfzISweIRx1l4sbFcf8xywtPcK4G+gO5fbN8RpjTn4X
         562bTuEXWMtHl21o4RPSt8T8hZMbhMuRT31+bo5PJP356A39awsN10ekp4FnDRDr5LUv
         GQMUprq3w43hveRBbcYJgpOqtPhNiicovS39fPMwsWrb5WlPbFTht65tZa4RzaKanqfF
         eeSjvFN8i88mKNoqgf5XXh5n/rF7jy+V6/EWHZFjPKY+8kcrRCR972j0tidO06dSyPfR
         7z8m9UZQo6jwum4Op/udHz2/lL8z6jbU6ajxP0gGw1+uVjL3lbOKzuz2jx68sVD6chbD
         iJbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWO0m47ndGvpTIzTZCQWtjOPQiWYb+2lYAWzRU7pkItCTkt9xmfr+3/g2yAHJdZnFyC8sqbJYypTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDFiQfoJSOKScFcg2WkU0uO7ldexJm5iSGlpS9G318N0PepxwT
	vWz/LtekHXLtTKHopEcPuJWiACT8AR/eAmY5r6WQH8r+XquicVS2SuFuTcrvnFfuwtbZxq3/8Yg
	V2z7tuFDS+PklLqnzU21h1LCsvf0FtxY=
X-Gm-Gg: ASbGncthkLg5PM6ypu7idi+ZsTL9H5/dCojLvB+iAQMdKsC3nbLFR+rq/tGhZUYMQ1Z
	7bPiqbnHcXOwRJ3OCvnWWWHTovL85sNfzhBN/1NlTx7tIwrPnajkfZyUbmE8oTWDQMXkkQg5K92
	s49L5+rCFGim5M7/B2VTVpLzD+OvxRseSW7nYy6Q9roLTn4QA1a8ktNMm49AqUi9oft0Vy1cm9d
	BGpbZmGXegv4zT/p8Ncghl2PwIgUOGxolqYgi9+gkx4sJkSGIfOQHPuXBGWuBA=
X-Google-Smtp-Source: AGHT+IHkq6zjvBo4oVmQTHFSNBkjkb0ric9D0Rn0cJMo0RUZrD31yaz5Tbc2F6bqQXoTIRnhIb3vZzhho68Fd2xwYeU=
X-Received: by 2002:a05:6000:2891:b0:3ee:15b4:8470 with SMTP id
 ffacd0b85a97d-425671b27e6mr11462577f8f.45.1759845744825; Tue, 07 Oct 2025
 07:02:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68e4a3d1.a00a0220.298cc0.0471.GAE@google.com> <c9c65caaf4d9503b28d4314c479ef75cefa58312.camel@kernel.org>
In-Reply-To: <c9c65caaf4d9503b28d4314c479ef75cefa58312.camel@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 7 Oct 2025 07:02:13 -0700
X-Gm-Features: AS18NWACV1ZSBecqbvLz-myA1t25n1s4SCYTm7AjbAyokPZIep1iWbE0rrpg49Q
Message-ID: <CAADnVQ+sdJ9__9PL=mMxKAqELhnXBX95gXUsgVfMg3ohBOsBDA@mail.gmail.com>
Subject: Re: [syzbot] [nfs?] [io-uring?] WARNING in nfsd_file_cache_init
To: Jeff Layton <jlayton@kernel.org>
Cc: syzbot <syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com>, 
	Dai.Ngo@oracle.com, Jens Axboe <axboe@kernel.dk>, chuck.lever@oracle.com, 
	io-uring <io-uring@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-nfs@vger.kernel.org, neil@brown.name, okorniev@redhat.com, 
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>, tom@talpey.com, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 7, 2025 at 7:00=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> On Mon, 2025-10-06 at 22:23 -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    d104e3d17f7b Merge tag 'cxl-for-6.18' of git://git.kern=
el...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D116bb942580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dccc18dddafa=
95b97
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Da6f4d69b9b234=
04bbabf
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1573b2145=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12b515cd980=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/335d7c35cbbe/d=
isk-d104e3d1.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/72dbd901415b/vmli=
nux-d104e3d1.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/3ff1353d0870=
/bzImage-d104e3d1.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 6128 at kernel/locking/lockdep.c:6606 lockdep_unre=
gister_key+0x2ca/0x310 kernel/locking/lockdep.c:6606
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 6128 Comm: syz.4.21 Not tainted syzkaller #0 PREEMPT=
_{RT,(full)}
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 08/18/2025
> > RIP: 0010:lockdep_unregister_key+0x2ca/0x310 kernel/locking/lockdep.c:6=
606
> > Code: 50 e4 0f 48 3b 44 24 10 0f 84 26 fe ff ff e8 bd cd 17 09 e8 e8 ce=
 17 09 41 f7 c7 00 02 00 00 74 bd fb 40 84 ed 75 bc eb cd 90 <0f> 0b 90 e9 =
19 ff ff ff 90 0f 0b 90 e9 2a ff ff ff 48 c7 c7 d0 ac
> > RSP: 0018:ffffc90003e870d0 EFLAGS: 00010002
> > RAX: eb1525397f5bdf00 RBX: ffff88803c121148 RCX: 1ffff920007d0dfc
> > RDX: 0000000000000000 RSI: ffffffff8acb1500 RDI: ffffffff8b1dd0e0
> > RBP: 00000000ffffffea R08: ffffffff8eb5aa37 R09: 1ffffffff1d6b546
> > R10: dffffc0000000000 R11: fffffbfff1d6b547 R12: 0000000000000000
> > R13: ffff88814d1b8900 R14: 0000000000000000 R15: 0000000000000203
> > FS:  00007f773f75e6c0(0000) GS:ffff88812712f000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007ffdaea3af52 CR3: 000000003a5ca000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  __kmem_cache_release+0xe3/0x1e0 mm/slub.c:7696
> >  do_kmem_cache_create+0x74e/0x790 mm/slub.c:8575
> >  create_cache mm/slab_common.c:242 [inline]
> >  __kmem_cache_create_args+0x1ce/0x330 mm/slab_common.c:340
> >  nfsd_file_cache_init+0x1d6/0x530 fs/nfsd/filecache.c:816
> >  nfsd_startup_generic fs/nfsd/nfssvc.c:282 [inline]
> >  nfsd_startup_net fs/nfsd/nfssvc.c:377 [inline]
> >  nfsd_svc+0x393/0x900 fs/nfsd/nfssvc.c:786
> >  nfsd_nl_threads_set_doit+0x84a/0x960 fs/nfsd/nfsctl.c:1639
> >  genl_family_rcv_msg_doit+0x212/0x300 net/netlink/genetlink.c:1115
> >  genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
> >  genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
> >  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2552
> >  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
> >  netlink_unicast+0x846/0xa10 net/netlink/af_netlink.c:1346
> >  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
> >  sock_sendmsg_nosec net/socket.c:727 [inline]
> >  __sock_sendmsg+0x219/0x270 net/socket.c:742
> >  ____sys_sendmsg+0x508/0x820 net/socket.c:2630
> >  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
> >  __sys_sendmsg net/socket.c:2716 [inline]
> >  __do_sys_sendmsg net/socket.c:2721 [inline]
> >  __se_sys_sendmsg net/socket.c:2719 [inline]
> >  __x64_sys_sendmsg+0x1a1/0x260 net/socket.c:2719
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f77400eeec9
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f773f75e038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 00007f7740345fa0 RCX: 00007f77400eeec9
> > RDX: 0000000000008004 RSI: 0000200000000180 RDI: 0000000000000006
> > RBP: 00007f7740171f91 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007f7740346038 R14: 00007f7740345fa0 R15: 00007ffce616f8d8
> >  </TASK>
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing=
.
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
>
> Pretty sure that this patch broke it:
>
> commit 83382af9ddc3cb0ef43f67d049b461720ad785e6
> Author: Alexei Starovoitov <ast@kernel.org>
> Date:   Mon Sep 8 18:00:05 2025 -0700
>
>     slab: Make slub local_(try)lock more precise for LOCKDEP
>
> The new lock_key is initialized late in do_kmem_cache_create(), and it
> can end up calling __kmem_cache_release() before the lock_key is ever
> registered.

No idea, but if so, the fix is in slab tree already.

