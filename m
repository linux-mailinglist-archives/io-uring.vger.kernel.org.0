Return-Path: <io-uring+bounces-10170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4F3C038E4
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 23:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8A5C3A382F
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 21:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C521E5B95;
	Thu, 23 Oct 2025 21:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="K4/iINgZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C33296BD0
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 21:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761255254; cv=none; b=Ag/XdK5BkwuYTLZfDIO5QPAX/5ShwIPt6l533BhyJQqV5jLclq8EJvsv+7f3X8oTFL+xNfnZ3eOYtP9xXJ8ZQCp3bZeyrS4RnanQRvL1SMPkIl19eT1fupUZYV14P8PZ93iZv2o59G/4gqYdTdvkjeubtUNjLCFusLDCJj3sA9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761255254; c=relaxed/simple;
	bh=zKsP8dHKf8yQOzK9i+S0TaAtt4DnK1GHWRxhsZoCz+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EBLkyDXQngdGRXM6uFC3Rc0Sn30fy8Stif/PL/0pvoIJM15asgsTSD+9r6Y8oQcnmTJsLlNx1oLP1i3q4JTzBl4oTKtSZ08Ziy76qL9HM0IdsIEUPhxnhoX0ePKffvDP7afOCNhCR1lelmaKcKgg3UiBEwjU5YFpb/eauKznAbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=K4/iINgZ; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2699ef1b4e3so2208705ad.0
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 14:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761255252; x=1761860052; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmXne/HpAUaogOSdpIX9KC9MtAaj0qp7mmdNBZpis4w=;
        b=K4/iINgZIueOF6YGIxvLWj1/IKbCntDJgXb3Mzlco641wiBApQa+Xdh+ZvSqTPFAPk
         0nk2+fy8u8/aNgq6Qw+KJ4Xyjc2CDjaq2VR2Sf74Gocu46M7P1o2FseiV4YJYJSs1JPs
         TJWZMEdkD+Q+81kRE4bxIhIiLu/v/7sjKa9+A45ZUbwQTVgV4TaYEExAfuo2R/iljBOE
         oESPddiKFYK34zB0rlppFMYy7MeqP81j9CV4NMvqMXAdEvmXhFeTXYG3Ov7V2izXR0Oh
         /upOZ835Xfs7/SdwnkfvQrrjrqtkG4oCXhpzCEMwxXGysV3W/zKR+QwBW5r0ay/vLYq6
         1tTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761255252; x=1761860052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qmXne/HpAUaogOSdpIX9KC9MtAaj0qp7mmdNBZpis4w=;
        b=Z2X6zhO4uOjLzy/DFSPoYDzUCBpkSp3xV7bHI21Tsd0N6fG6dlk7XtCNiIkfwSffmy
         i3D/LicbpWBr7K2ZgfFr0cb2qyQqUDx9T0S07pg7nHQnNGfabqUG7nncDL8ySFeHN38s
         9lkWr8OvXIB9Kb1nagWMQ5U7vLxvKARPI5So2faYf64z1V3Zzjh9XQP5J3VW1MVpLLrN
         M9c8h/o/BegREq5DGUHkm/EEH0r8T21NxKOO1c0G7TMikkSpsHN/e5Zl41y3nmKXsXWN
         yFYm8hkOvuD1gvPnSiZcpeu9mNOnVdd466QeTm/jwVtv2uq2cVFZY/sdDJq63HZNLmk9
         eJFA==
X-Forwarded-Encrypted: i=1; AJvYcCVsPpnv+1uPw1bs0tqZl07No9AC76khQEs7uYYyZblayk2GjqW5rlsMpax1NtlPHKaqfp7qDPKvpA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWw4WVCOo9O9oSZlagO8eE83zDRo+HeAqElyHnrY7cqOQh50EQ
	WiT6GGSbAT09WAVuirCFvZFTMd3xPKzbinsuoKguLLcJ4BirT/GTaRGz9m4qQCX1C+Jd8wZGbDn
	F0agaOTFw/YIsShuP4L6avpNt7+F24ZiuUDzvJcBZpQ==
X-Gm-Gg: ASbGncsc1MRnfUXgeDugUhTYiNwESBl1aeuwR1GpH/bAxLJ3mbb77brdtmDgzi1KToc
	dm2hFa5O3t3WvtvoAoMap8YG3hU8zbO0v88OWKgU+czqo3E+4wxBtSc8wIBsFEsWlYNYAP/FDsz
	s/tUyi1a7Y/RuINu2M9WUGbeaBXyn083xrqXuaijG0xes1a3aE6aUyV5RQR7D++OJymXegwN9VI
	qwQpw2GELJl0OVQU9PNUodBDoiMJg4W/uu0daVUOn329SVVaO5ZjvjP87YZHbK2IzjGWP+DAgB3
	verwk5yLgLw1DT+HuMg=
X-Google-Smtp-Source: AGHT+IGd78+JiwzikwJEVd6ymCJ10GLaYCB9X40ihyUXvS0aK/SLH09nV/urBH/Co1SII1Kpt/ZYuqjUuAMpfiSpEyM=
X-Received: by 2002:a17:903:3d0f:b0:274:944f:9d84 with SMTP id
 d9443c01a7336-290ccaccc47mr164262585ad.11.1761255251764; Thu, 23 Oct 2025
 14:34:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68fa9c5e.a70a0220.3bf6c6.00c9.GAE@google.com>
In-Reply-To: <68fa9c5e.a70a0220.3bf6c6.00c9.GAE@google.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 23 Oct 2025 14:34:00 -0700
X-Gm-Features: AS18NWBkKZEOPS_2aeIAJ2AnO0KE3pGJ8tRaenjQsYbg5sXp_knzSkrSbu0JtG8
Message-ID: <CADUfDZqUS_gk=u+fx5QVp7+gNGTSt438YG+Z-FBZP8kougK3Fw@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_uring_show_fdinfo (4)
To: syzbot <syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, kbusch@kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 2:21=E2=80=AFPM syzbot
<syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    aaa9c3550b60 Add linux-next specific files for 20251022
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11880c9258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc8b911aebadf6=
410
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Da77f64386b3e1b2=
ebb51
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12e73734580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D102f43e258000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/44f7af9b7ca1/dis=
k-aaa9c355.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9d09b0a9994d/vmlinu=
x-aaa9c355.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ae729ccb2c5c/b=
zImage-aaa9c355.xz
>
> The issue was bisected to:
>
> commit 31dc41afdef21f264364288a30013b538c46152e
> Author: Keith Busch <kbusch@kernel.org>
> Date:   Thu Oct 16 18:09:38 2025 +0000
>
>     io_uring: add support for IORING_SETUP_SQE_MIXED
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D12eac61458=
0000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D11eac61458=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16eac61458000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com
> Fixes: 31dc41afdef2 ("io_uring: add support for IORING_SETUP_SQE_MIXED")
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 6032 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/02/2025
> RIP: 0010:__io_uring_show_fdinfo io_uring/fdinfo.c:103 [inline]
> RIP: 0010:io_uring_show_fdinfo+0x371/0x1840 io_uring/fdinfo.c:255
> Code: 0f 85 29 04 00 00 45 8b 36 44 89 f7 44 89 ee e8 a5 ec 94 00 45 39 e=
e 76 11 e8 db ea 94 00 45 89 fd 4c 8b 3c 24 e9 c9 03 00 00 <80> 3b 00 45 89=
 fd 0f 85 17 04 00 00 0f b6 2c 25 00 00 00 00 48 8b
> RSP: 0018:ffffc9000392f928 EFLAGS: 00010293
> RAX: ffffffff812b42ab RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: ffff888026c65ac0 RSI: 00000000000001ff RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff888069c000aa R09: 1ffff1100d380015
> R10: dffffc0000000000 R11: ffffed100d380016 R12: 0000000000000008
> R13: 00000000000001ff R14: 0000000000000000 R15: 0000000000000000
> FS:  000055556a027500(0000) GS:ffff888125f29000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30363fff CR3: 0000000076c50000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  seq_show+0x5bc/0x730 fs/proc/fd.c:68
>  seq_read_iter+0x4ef/0xe20 fs/seq_file.c:230
>  seq_read+0x369/0x480 fs/seq_file.c:162
>  vfs_read+0x200/0xa30 fs/read_write.c:570
>  ksys_read+0x145/0x250 fs/read_write.c:715
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f198c78efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffae1a3128 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 00007f198c9e5fa0 RCX: 00007f198c78efc9
> RDX: 0000000000002020 RSI: 00002000000040c0 RDI: 0000000000000004
> RBP: 00007f198c811f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f198c9e5fa0 R14: 00007f198c9e5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__io_uring_show_fdinfo io_uring/fdinfo.c:103 [inline]
> RIP: 0010:io_uring_show_fdinfo+0x371/0x1840 io_uring/fdinfo.c:255
> Code: 0f 85 29 04 00 00 45 8b 36 44 89 f7 44 89 ee e8 a5 ec 94 00 45 39 e=
e 76 11 e8 db ea 94 00 45 89 fd 4c 8b 3c 24 e9 c9 03 00 00 <80> 3b 00 45 89=
 fd 0f 85 17 04 00 00 0f b6 2c 25 00 00 00 00 48 8b
> RSP: 0018:ffffc9000392f928 EFLAGS: 00010293
> RAX: ffffffff812b42ab RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: ffff888026c65ac0 RSI: 00000000000001ff RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff888069c000aa R09: 1ffff1100d380015
> R10: dffffc0000000000 R11: ffffed100d380016 R12: 0000000000000008
> R13: 00000000000001ff R14: 0000000000000000 R15: 0000000000000000
> FS:  000055556a027500(0000) GS:ffff888125f29000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30363fff CR3: 0000000076c50000 CR4: 00000000003526f0
> ----------------
> Code disassembly (best guess):
>    0:   0f 85 29 04 00 00       jne    0x42f
>    6:   45 8b 36                mov    (%r14),%r14d
>    9:   44 89 f7                mov    %r14d,%edi
>    c:   44 89 ee                mov    %r13d,%esi
>    f:   e8 a5 ec 94 00          call   0x94ecb9
>   14:   45 39 ee                cmp    %r13d,%r14d
>   17:   76 11                   jbe    0x2a
>   19:   e8 db ea 94 00          call   0x94eaf9
>   1e:   45 89 fd                mov    %r15d,%r13d
>   21:   4c 8b 3c 24             mov    (%rsp),%r15
>   25:   e9 c9 03 00 00          jmp    0x3f3
> * 2a:   80 3b 00                cmpb   $0x0,(%rbx) <-- trapping instructi=
on
>   2d:   45 89 fd                mov    %r15d,%r13d
>   30:   0f 85 17 04 00 00       jne    0x44d
>   36:   0f b6 2c 25 00 00 00    movzbl 0x0,%ebp
>   3d:   00
>   3e:   48                      rex.W
>   3f:   8b                      .byte 0x8b
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

#syz dup: [syzbot] [io-uring?] general protection fault in
io_uring_show_fdinfo (3)

