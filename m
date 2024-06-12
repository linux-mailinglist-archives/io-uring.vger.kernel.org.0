Return-Path: <io-uring+bounces-2173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B36904C6C
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 09:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 935FA283DED
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 07:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8B913CA9C;
	Wed, 12 Jun 2024 07:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YM0uwE6c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA2A13A275;
	Wed, 12 Jun 2024 07:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718176240; cv=none; b=GJLbkZ1pOPMkC+X0Y50KWjIp1jXQzSrdqzGD4bauGTlSxE+OEhFOk7H4QROVbW8aGbrpxBfEkrQSVxK+7XyL/ObBvfnwv+e/u4RqCm7GQzYE656dC+BGUfoLKWBv8ToY1CtSTf0a/9Crzs9Ztn1+yxnGhla/lczCO8dq1cuKdoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718176240; c=relaxed/simple;
	bh=0E/dP+JgY1h8LvmPra3kSmJVjKSVbX0+z+gI7jyAqMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=bBkp1H5W5BZLqXtaRFhk+nM01pSkMMedRjpYNpP9t6J6bgyI+7vkAzZvzaemM732UYkaLdMpcugQ6AO7yUUGpTWe2zOTc16CiDOpvE9/1PYnN0xGpSuA9/mMUY6hzqPFsSqnjxEh8wYPH4MuBS91xMrML7uYe/VR8OCYh9f/hew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YM0uwE6c; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-62f518bbab1so9828797b3.2;
        Wed, 12 Jun 2024 00:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718176238; x=1718781038; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ntuiepcls6DPTsVsPIFqvHYiiDifFrTTY9IXohUJcws=;
        b=YM0uwE6cliZZsETd8IFRtsZNiku3kc2gp35sdIo4BREQpDMaDggeWKMSCdpc1N8mlT
         P1Nbg8tRGoZTW4d11dCtU5WaK9KBurAv6T12aYFG3IOiEN7SsvmbaEvcknVQZzddWndX
         +2JYU0kD+8MvQRP8LzpiR4YB276oGxUa3UbqkRZprdtWwIBCf/WGXQHJ+aDthkxdOGwZ
         I/jR5g1e5uBAhQRa2eU5XJLtpsUBLPUxHMkb1YJUFRPI8qerYNRHCVibfoytmp3t5M1L
         i6hQ55AtjwkX5vrhV9WJZvus1rj5/nD2Kg6p0Gx6aH6CYvNL/1wiqizf3Atb5IJaLXw8
         /qXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718176238; x=1718781038;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ntuiepcls6DPTsVsPIFqvHYiiDifFrTTY9IXohUJcws=;
        b=flwSIg79e2/fjbRSich/EFzOqrsblBbzLH7kWA+h7kU8c+KROBiwgHq3QWULiNas6l
         HtT3pd1Hz9PBzwpuXShueEHrWgo6uiJON2wb0kcCpyYr7n6MG7PsmUjcrz2Px5p4WTh5
         tRHfOAvAZp23BVL+BtgTXfcMtZAhgdRG/wEcNNrU96HLo0L33r98p3J/lAB7TqiUqVDV
         hFkwz2dEYnsmerT6VFiPxEte6yA2eywMGOFR6vbtOTDnSHUpVd+RSH4sp/IVKdVoxH6F
         eKfKvP2bq498eteQT3VsBAyFa+HDxyu15ScWVj7ljH8yWAof88KnbV1Zi3Rs9HARfSGi
         gImg==
X-Forwarded-Encrypted: i=1; AJvYcCW6kY3IuDB3WaRSWcz46cpeA4aL6D3dMXH8ycv3ZKBjKbYPAt1DK3gIS656QmUjSAExW9fmmdSEV00XIDDrpDpw+2QbW8ahPv017iInjCAt/hmLRz6vaGZuZrUrrmS2KTFgKlVa7Eo=
X-Gm-Message-State: AOJu0YzEJlrxUq32iVjxr2HGmrLEQ9qKrcNet/g1vIMe/6nj6EdAMAh4
	KF7z4rejDPBfhIKmZWfWkMvD6/GWmi6iYf9GEQWZxc4FQedOB/snvxhs7DEQ1Q5ny61UC3pRl0/
	A7s0ty1MP6LcquLHhhH4aKWQb1NhHcDYC
X-Google-Smtp-Source: AGHT+IE46xb7WGHKuxjm/SNiaKTQHcPBCIOCPd9x6kc6K50arCbz40Pdwbf8UMPcovzeQ3p46N6KdJgMO2TP22vgTJM=
X-Received: by 2002:a81:7283:0:b0:62f:518b:ba53 with SMTP id
 00721157ae682-62fba943427mr8931797b3.49.1718176238038; Wed, 12 Jun 2024
 00:10:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDQx4tqCfCfmCHjUp9nhAJ8_qTX=cCYOFzMYiQQwtsNuag@mail.gmail.com>
 <4fd9cd27-487d-4a23-b17a-aa9dcb09075f@gmail.com>
In-Reply-To: <4fd9cd27-487d-4a23-b17a-aa9dcb09075f@gmail.com>
From: chase xd <sl1589472800@gmail.com>
Date: Wed, 12 Jun 2024 09:10:28 +0200
Message-ID: <CADZouDSyJVR=WX-X46QCUZeUz=7DHg_9=e5y=N7Wb+zMQ_dGtQ@mail.gmail.com>
Subject: Re: [io-uring] WARNING in io_fill_cqe_req_aux
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry now I'm also a bit confused by the branch choosing. I checked
out branch "for-6.9/io_uring" and started testing on that branch. I
assume that was the latest version of io_uring at that time, even now
I check out that branch and the bug still exists. How should I know
whether the branch will be merged, and which branch do you think I
should test on? Thanks.

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2024=E5=B9=B46=E6=9C=8812=
=E6=97=A5=E5=91=A8=E4=B8=89 03:11=E5=86=99=E9=81=93=EF=BC=9A
>
> On 6/7/24 18:07, chase xd wrote:
> > Dear Linux kernel maintainers,
> >
> > Syzkaller reports this previously unknown bug on Linux
> > 6.8.0-rc3-00043-ga69d20885494-dirty #4. Seems like the bug was
> > silently or unintendedly fixed in the latest version.
>
> That branch you're using is confusing, apart from being
> dirty and rc3, apparently it has never been merged. The
> patch the test fails on looks different upstream:
>
>
> commit 902ce82c2aa130bea5e3feca2d4ae62781865da7
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Mon Mar 18 22:00:32 2024 +0000
>
>      io_uring: get rid of intermediate aux cqe caches
>
>
> It reproduces with your version but not with anything
> upstream
>
>
> > ```
> > Syzkaller hit 'WARNING in io_fill_cqe_req_aux' bug.
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 7 PID: 8369 at io_uring/io_uring.h:132
> > io_lockdep_assert_cq_locked+0x2c7/0x340 io_uring/io_uring.h:132
> > Modules linked in:
> > CPU: 7 PID: 8369 Comm: syz-executor263 Not tainted
> > 6.8.0-rc3-00043-ga69d20885494-dirty #4
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04=
/01/2014
> > RIP: 0010:io_lockdep_assert_cq_locked+0x2c7/0x340 io_uring/io_uring.h:1=
32
> > Code: 48 8d bb 98 03 00 00 be ff ff ff ff e8 52 45 4b 06 31 ff 89 c3
> > 89 c6 e8 b7 e2 2d fd 85 db 0f 85 d5 fe ff ff e8 0a e7 2d fd 90 <0f> 0b
> > 90 e9 c7 fe ff ff e8 fc e6 2d fd e8 c7 38 fa fc 48 85 c0 0f
> > RSP: 0018:ffffc90012af79a8 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff845cf059
> > RDX: ffff8880252ea440 RSI: ffffffff845cf066 RDI: 0000000000000005
> > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
> > FS:  00005555570e13c0(0000) GS:ffff88823bd80000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f1bdbcae020 CR3: 0000000022624000 CR4: 0000000000750ef0
> > PKRU: 55555554
> > Call Trace:
> >   <TASK>
> >   io_fill_cqe_req_aux+0xd6/0x1f0 io_uring/io_uring.c:925
> >   io_poll_check_events io_uring/poll.c:325 [inline]
> >   io_poll_task_func+0x16f/0x1000 io_uring/poll.c:357
> >   io_handle_tw_list+0x172/0x560 io_uring/io_uring.c:1154
> >   tctx_task_work_run+0xaa/0x330 io_uring/io_uring.c:1226
> >   tctx_task_work+0x7b/0xd0 io_uring/io_uring.c:1244
> >   task_work_run+0x16d/0x260 kernel/task_work.c:180
> >   get_signal+0x1cb/0x25a0 kernel/signal.c:2669
> >   arch_do_signal_or_restart+0x81/0x7e0 arch/x86/kernel/signal.c:310
> >   exit_to_user_mode_loop kernel/entry/common.c:105 [inline]
> >   exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
> >   __syscall_exit_to_user_mode_work kernel/entry/common.c:201 [inline]
> >   syscall_exit_to_user_mode+0x156/0x2b0 kernel/entry/common.c:212
> >   do_syscall_64+0xe5/0x270 arch/x86/entry/common.c:89
> >   entry_SYSCALL_64_after_hwframe+0x6f/0x77
> > RIP: 0033:0x7f1bdbc2d88d
> > Code: c3 e8 a7 1f 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffd12f6fa18 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> > RAX: 0000000000000001 RBX: 000000000000220b RCX: 00007f1bdbc2d88d
> > RDX: 0000000000000000 RSI: 0000000000005012 RDI: 0000000000000003
> > RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> > R13: 431bde82d7b634db R14: 00007f1bdbcaa4f0 R15: 0000000000000001
> >   </TASK>
> >
> >
> > Syzkaller reproducer:
> > # {Threaded:false Repeat:true RepeatTimes:0 Procs:1 Slowdown:1
> > Sandbox: SandboxArg:0 Leak:false NetInjection:false NetDevices:false
> > NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false
> > KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false
> > Wifi:false IEEE802154:false Sysctl:false Swap:false UseTmpDir:false
> > HandleSegv:false Repro:false Trace:false LegacyOptions:{Collide:false
> > Fault:false FaultCall:0 FaultNth:0}}
> > r0 =3D syz_io_uring_setup(0x220b, &(0x7f0000000000)=3D{0x0, 0x63db,
> > 0x10000, 0x800}, &(0x7f0000000080)=3D<r1=3D>0x0,
> > &(0x7f0000000200)=3D<r2=3D>0x0)
> > r3 =3D socket$inet(0x2, 0x1, 0x0)
> > syz_io_uring_submit(r1, r2,
> > &(0x7f0000000a80)=3D@IORING_OP_POLL_ADD=3D{0x6, 0x0, 0x0, @fd=3Dr3, 0x0=
,
> > 0x0, 0x1})
> > io_uring_enter(r0, 0x5012, 0x0, 0x0, 0x0, 0x0)
> > ```
> >
> > crepro is in the attachment.
> >
> > Best Regards
> > Xdchase
>
> --
> Pavel Begunkov

