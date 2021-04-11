Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898EE35B281
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 10:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhDKI6r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Apr 2021 04:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbhDKI6n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Apr 2021 04:58:43 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D634C061574;
        Sun, 11 Apr 2021 01:58:27 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h25so7066153pgm.3;
        Sun, 11 Apr 2021 01:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CQ9+qOPuenjNjl5RJxDwcyVzCVSJQFHAcJ0WWEjFnzg=;
        b=rFGzVZVixD1qZCgbcw2wlCHop0KwsxAUhm0buCT7BjFs9+EktstZTvIh6aWLHsMqW6
         vGSQdz60FzQIRH2P9et0196db51n8wohVrSywYK+gz1sCaaMEPhXxuXHCzZ5qQi1Ed/m
         TXg9ozpLlxIX+QWAPi0tLjfTTNNNO/QYXF1xnixRpY7HOGdUBTsYAsa7i66oUZ2KlZY2
         64A9ysxtgxIN6br+VVKGJp3Ul8nQ5BbUp3SlXa4tK7uSgtr+xP/rZVIXqvk/nbUTSU1q
         ryhdJYDnTT8BynKVQ9vML+v+wMn5ntbXCszz3qBARBsxQnKHkChD5sI9Nvz2QGTpwirJ
         ZDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CQ9+qOPuenjNjl5RJxDwcyVzCVSJQFHAcJ0WWEjFnzg=;
        b=tEkWplLzS63+YEo/PwxbzpqJjbzlfvJJBODFXLCfdBUH66ecZvB8fz5Y8Sz7co4HnC
         qMX7RDwsWjeTK+7AH3xBymhyKc8UgW8Vo4887eVHJklHhPiDtXP8ql71HvcDd8PywkBd
         pSd9iYwV5katES0GWKukI1h/QJH3N4zyNwe1Pdd/0Qb3v9BGwp2v4ZP7W88uqaat2h1s
         plEUESGaIn0lvdEggbxSjvstMx6pObefU+wwVS96viPtHV9XTb1Ty7PxtiehPVilXgzS
         NokmdA4lWxD8bCuxut1Ky6okepQ0/6VS0jtLOVE6mh5j7PUDObDxvqOt6LvAbzaPudtB
         f1xg==
X-Gm-Message-State: AOAM531Yc5KqwBojNOzyk9GsjKJM9RqJdkVTeifo8Q4xYQKI3YE9WAv2
        J0BswY5nKesPEVnDD+AO4nYy7yRQ3/gfHZ3llA==
X-Google-Smtp-Source: ABdhPJxRUSLO8kAQlx20I5w8MxWWIADofdXdgus+L3oUUNaX5ckdpXoix4OuPvmLuNiQvJawhzZwEfEMrrxAA3n/FFw=
X-Received: by 2002:a63:3606:: with SMTP id d6mr21731213pga.349.1618131506987;
 Sun, 11 Apr 2021 01:58:26 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsb4Ad60ZTyaaObBj2DKxSv1avmTSo3WUrnvH+amuDuhrA@mail.gmail.com>
 <461a8447-bc48-145f-c3dc-4b049621afcc@gmail.com>
In-Reply-To: <461a8447-bc48-145f-c3dc-4b049621afcc@gmail.com>
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Sun, 11 Apr 2021 16:58:23 +0800
Message-ID: <CACkBjsZLvtAVYO4MTtB8E+E3TzRDxCrBJ8Y6oeepRC0tRmmiAA@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in io_uring_cancel_task_requests
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2021=E5=B9=B44=E6=9C=8811=
=E6=97=A5=E5=91=A8=E6=97=A5 =E4=B8=8B=E5=8D=884:14=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On 11/04/2021 04:08, Hao Sun wrote:
> > Hi
> >
> > When using Healer(https://github.com/SunHao-0/healer/tree/dev) to fuzz
> > the Linux kernel, I found a null-ptr-deref bug in
> > io_uring_cancel_task_requests under fault injection condition, but I'm
> > not sure about this.
> > Sorry, I do not have a reproducing program for this bug.
> > I hope that the stack trace information in the crash log can help you
> > locate the problem.
>
> Thanks Hao. io_cqring_wait() fails should not anyhow affect
> cancellation, so the log doesn't make sense from first sight,
> something strange is going on.
>
Is it possible that the failure of io_cqring_wait affects other
operations with side effects between io_cqring_wait and cancellation,
which eventually leads to the cancellation bug?
I found the last call sequence (Syzlang format) executed by the fuzzer
before triggering the bug.
This may be helpful, but there is no guarantee that this is the direct
cause of the bug.

Possible guilty test case:
r19 =3D syz_io_uring_setup(0x7211,
&(0x7f0000000540)=3D{0x6e3620b713f86b87,0xf615,0x2,0x1000,0x1a6,0xa26bc79d6=
b5315eb,0x0,[0x0,0x0,0x0],[0x813a698e7df9790f,0x1,0xb43ab5cc286248ee,0xe543=
f3b8cf765dd5,0x8005afeb090b0e62,0x1a29b15882d5d0b7,0xd7dc82c17c7ba1a7,0xab9=
d3c813ad3ae79,0x0,0x0],[0x1,0xd3a439e17ea7133c,0x4b845483eeeab284,0xf6fdf7f=
35d59044,0xf,0x99a9733bb1278a03,0xf8a69ea77c12e2b2,0x1,0x1,0x176ecee6d3c048=
36]},
&(0x7f0000000000/0x5000)=3Dnil, &(0x7f0000000000/0x120000)=3Dnil,
&(0x7f00000005c0)=3D<r17=3D>0x0, &(0x7f0000000600)=3D<r18=3D>0x0)
io_uring_enter(r19, 0x1, 0x66ab, 0x3,
&(0x7f0000000040)=3D{[0xfffe8c2bdda0afdd]}, 0x8)
io_uring_register$IORING_UNREGISTER_EVENTFD(r19, 0x5, 0x0, 0x0)

> >
> > Here is the details:
> > commit:   3b9cdafb5358eb9f3790de2f728f765fef100731
> > version:   linux 5.11
> > git tree:    upstream
> > Full log can be found in the attachment.
> > cqwait()
> > Fault injection log:
> > FAULT_INJECTION: forcing a failure.
> > name fail_usercopy, interval 1, probability 0, space 0, times 0
> > CPU: 1 PID: 9161 Comm: executor Not tainted 5.11.0+ #5
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:79 [inline]
> >  dump_stack+0x137/0x194 lib/dump_stack.c:120
> >  fail_dump lib/fault-inject.c:52 [inline]
> >  should_fail+0x23e/0x250 lib/fault-inject.c:146
> >  should_fail_usercopy+0x16/0x20 lib/fault-inject-usercopy.c:37
> >  _copy_from_user+0x1c/0xd0 lib/usercopy.c:14
> >  copy_from_user include/linux/uaccess.h:192 [inline]
> >  set_user_sigmask+0x4b/0x110 kernel/signal.c:3015
> >  io_cqring_wait+0x2e3/0x8b0 fs/io_uring.c:7250
> >  __do_sys_io_uring_enter fs/io_uring.c:9480 [inline]
> >  __se_sys_io_uring_enter+0x8fc/0xb70 fs/io_uring.c:9397
> >  __x64_sys_io_uring_enter+0x74/0x80 fs/io_uring.c:9397
> >  do_syscall_64+0x39/0x80 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x46a379
> > Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f046fa19c58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> > RAX: ffffffffffffffda RBX: 000000000078c080 RCX: 000000000046a379
> > RDX: 00000000000066ab RSI: 0000000000000001 RDI: 0000000000000003
> > RBP: 00007f046fa19c90 R08: 0000000020000040 R09: 0000000000000008
> > R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
> > R13: 0000000000000000 R14: 000000000078c080 R15: 00007fff769deef0
> >
> > Crash log:
> > BUG: kernel NULL pointer dereference, address: 0000000000000040
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page
> > PGD 49954067 P4D 49954067 PUD 45f92067 PMD 0
> > Oops: 0000 [#1] PREEMPT SMP
> > CPU: 1 PID: 9161 Comm: executor Not tainted 5.11.0+ #5
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > RIP: 0010:io_uring_cancel_task_requests+0x3f/0x990 fs/io_uring.c:9045
> > Code: 48 8b 04 25 28 00 00 00 48 89 44 24 68 e8 89 e6 c5 ff 65 4c 8b
> > 34 25 00 6d 01 00 49 8d 7c 24 40 48 89 7c 24 30 e8 81 97 d6 ff <41> 8b
> > 5c 24 40 89 de 83 e6 02 31 ff e8 70 ea c5 ff 83 e3 02 48 89
> > RSP: 0018:ffffc90002a97b48 EFLAGS: 00010246
> > RAX: ffff88804b8e0d38 RBX: ffff88804b8ad700 RCX: 0000000000000764
> > RDX: 0000000000000040 RSI: ffff8880409d5140 RDI: 0000000000000040
> > RBP: ffff8880409d5140 R08: 0000000000000000 R09: 0000000000000043
> > R10: 0001ffffffffffff R11: ffff88804b8e0280 R12: 0000000000000000
> > R13: ffff8880409d5140 R14: ffff88804b8e0280 R15: ffff8880481c1800
> > FS:  00007f046fa1a700(0000) GS:ffff88807ec00000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000040 CR3: 00000000479a5000 CR4: 0000000000750ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > PKRU: 55555554
> > Call Trace:
> >  __io_uring_files_cancel+0x9b/0x200 fs/io_uring.c:9140
> >  io_uring_files_cancel include/linux/io_uring.h:65 [inline]
> >  do_exit+0x1a8/0x16d0 kernel/exit.c:780
> >  do_group_exit+0xc5/0x180 kernel/exit.c:922
> >  get_signal+0xd90/0x1470 kernel/signal.c:2773
> >  arch_do_signal_or_restart+0x2a/0x260 arch/x86/kernel/signal.c:811
> >  handle_signal_work kernel/entry/common.c:147 [inline]
> >  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
> >  exit_to_user_mode_prepare+0x109/0x1a0 kernel/entry/common.c:208
> >  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
> >  syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:301
> >  do_syscall_64+0x45/0x80 arch/x86/entry/common.c:56
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x46a379
> > Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f046fa19cd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> > RAX: fffffffffffffe00 RBX: 000000000078c080 RCX: 000000000046a379
> > RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000078c088
> > RBP: 000000000078c088 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c08c
> > R13: 0000000000000000 R14: 000000000078c080 R15: 00007fff769deef0
> > Modules linked in:
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > CR2: 0000000000000040
> > ---[ end trace 613db1a25ecf6443 ]---
> > RIP: 0010:io_uring_cancel_task_requests+0x3f/0x990 fs/io_uring.c:9045
> > Code: 48 8b 04 25 28 00 00 00 48 89 44 24 68 e8 89 e6 c5 ff 65 4c 8b
> > 34 25 00 6d 01 00 49 8d 7c 24 40 48 89 7c 24 30 e8 81 97 d6 ff <41> 8b
> > 5c 24 40 89 de 83 e6 02 31 ff e8 70 ea c5 ff 83 e3 02 48 89
> > RSP: 0018:ffffc90002a97b48 EFLAGS: 00010246
> > RAX: ffff88804b8e0d38 RBX: ffff88804b8ad700 RCX: 0000000000000764
> > RDX: 0000000000000040 RSI: ffff8880409d5140 RDI: 0000000000000040
> > RBP: ffff8880409d5140 R08: 0000000000000000 R09: 0000000000000043
> > R10: 0001ffffffffffff R11: ffff88804b8e0280 R12: 0000000000000000
> > R13: ffff8880409d5140 R14: ffff88804b8e0280 R15: ffff8880481c1800
> > FS:  00007f046fa1a700(0000) GS:ffff88807ec00000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000040 CR3: 00000000479a5000 CR4: 0000000000750ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > PKRU: 55555554
> >
>
> --
> Pavel Begunkov
