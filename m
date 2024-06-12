Return-Path: <io-uring+bounces-2190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C05E7905743
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 17:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46A811F2803C
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87B9208CE;
	Wed, 12 Jun 2024 15:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7xCF2Wy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18C11C6BD;
	Wed, 12 Jun 2024 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207201; cv=none; b=GSxtz80cwKtPyptmp7KspnsEcDFDrnbij/Gceus8gpxsNIMr2mXjpAXMvuQqVO9gxKj7pseRtHfEebelP2Xp1Ueyb6hGf0Wojvsqz7BFXNq1qN2mQiCFvKuQtk4Ysb9qrtUHiBDA6i2cddYuw3AyLfp8nLNF9evwZfDCj6Ym4Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207201; c=relaxed/simple;
	bh=pwyXV2gqwAitEUVkBUVsSUVYSSTgx/UCYaTnnIaHQ8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=pskcxRlKoo/JyheRsg+Uiz3vtqqkD2maLwsln6QD0D7Le16gXlA44szd0Dk4mfKN3QcW/a+aenfbUAya/iKdPoys3TkQ0G2MLOQ7dVBrRmQhDGyg9oUKmJM6Pry88fsiEmAm/ieDH5rNV6Y+RuqIpZ3TJxDj5T/Hp4G2k1O3zbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7xCF2Wy; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-627ebbefd85so81287457b3.3;
        Wed, 12 Jun 2024 08:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718207199; x=1718811999; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PwyckEkEliCj8lDpHS+Ob3WHasbxDcvL14yeYreRWFw=;
        b=A7xCF2Wy5rfg1lBBr4vAESoChNqR5an0O7hE7MDlXIu+ggUWVcY+Xb0dIJs8tmw0Gp
         V6wRtk6PV2emcSJWIhtPEkF2cYHqRyhdP51JQvzKwltdakwagXsrUe5rrju4nkFJMkAn
         AgT/MxSWK86AlRHEdUDtmNL9x6KLVT6wiep92uC4NLsaSZtswDgHvwS/9w9aLfWRv5kP
         jwhVjKrBQ73Q7mFMUk9XCbEd1WHhOrVaBxV3PFOWjYIUmrFtxktHorQmyCOls2BdqEcq
         I6BD0ekJXlCxlw5R97WI4aX1DCMmJEjDyD3GDK00AQenuGsWFnJb8BGEpsXvzKnMkycM
         zWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718207199; x=1718811999;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PwyckEkEliCj8lDpHS+Ob3WHasbxDcvL14yeYreRWFw=;
        b=r6e/8IIGTV/JDj3wLze/m+qAatXys1+ePLsbNgBZKeCqwW1DlwhjYVMamJdiVzrklJ
         sapn3YMSZS5b0invAa4c3SyRTiplogLrSDYXinOBrA3d7EykXf5awu1cBIzNyGPgO2YY
         bjkllBM4QESSN9duEcU07qmg2EVxEmA9KGec7KTAusyNvsbi+PsaqHFmawWo5oPMzF7i
         8qYhH/Y+4teh9DP1CMpZjB5o5/gGgYhrBa5uAWFbeuWC1AkFrlGsUuJwkvUwZCoZC2ct
         4DQgtfKbvOhmoEshQIiiGrJXTKqhQ2ydqpCVlZKQniCwd6DhXWcGaOtHOD8/yLZgQL4Q
         +bDw==
X-Forwarded-Encrypted: i=1; AJvYcCUVgn3SxjYM1BBMoK6oM48/wXDqaqsoNa8kkRvZarcIGjHjbjcMIaZoHOfaWUjmgoQaBngIJa0GN3kXe2/VRUGgCTM+AHiC8bVSUbx77fl1wG7ZNGHJcoKWxLZEaVSrs75HeSXTQJk=
X-Gm-Message-State: AOJu0Yx9ygg6npd6LuCZJyAVloH7GV0OFC+YIXnVRpORKt5NBUjYOjPI
	6GJ/MXggAniiyeSdxmZZLzVBCRkrYmVf5xTvgYwMJXEdtUe/h6CTnZQM844+mJT1SDgM0USiD1i
	dRoxDmmFaB7NBI6MfliRBZus22gWzHRyUn0c=
X-Google-Smtp-Source: AGHT+IGjQ3bMnaoz14Ziqp08zGvMzQCqh0n9PJaygB1It1xMzxUvIdJW08/jr16vIotLNiQydeZzTqLOoDtFAgrFuLQ=
X-Received: by 2002:a0d:c0c4:0:b0:62d:315:2a7d with SMTP id
 00721157ae682-62fbdba8ab0mr19639417b3.51.1718207198877; Wed, 12 Jun 2024
 08:46:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDR_Qz7dNVDsJyVSK8HfeSPpoO2ts=C-VbzhvHs3xE53AA@mail.gmail.com>
 <24c12c7d-71fd-4ff8-b67b-20cdfb67bd86@gmail.com>
In-Reply-To: <24c12c7d-71fd-4ff8-b67b-20cdfb67bd86@gmail.com>
From: chase xd <sl1589472800@gmail.com>
Date: Wed, 12 Jun 2024 17:46:29 +0200
Message-ID: <CADZouDSYKVjDry_w535s8d8+3eXyLnMdrnOtbeYSMYWqxFkKbA@mail.gmail.com>
Subject: Re: [io-uring] WARNING in io_issue_sqe
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

here you go

```
# {Threaded:false Repeat:true RepeatTimes:0 Procs:1 Slowdown:1
Sandbox: SandboxArg:0 Leak:false NetInjection:false NetDevices:false
NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false
KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false
Wifi:false IEEE802154:false Sysctl:false Swap:false UseTmpDir:false
HandleSegv:true Repro:false Trace:false LegacyOptions:{Collide:false
Fault:false FaultCall:0 FaultNth:0}}
r0 =3D syz_io_uring_setup(0x4d84, &(0x7f0000000000)=3D{0x0, 0x649b, 0x80,
0x0, 0x4315}, &(0x7f0000000080)=3D<r1=3D>0x0, &(0x7f00000000c0)=3D<r2=3D>0x=
0)
open(&(0x7f0000000100)=3D'./file0\x00', 0x214400, 0x84)
r3 =3D open$dir(&(0x7f0000000140)=3D'./file0\x00', 0x0, 0x0)
r4 =3D socket(0x2a, 0x80800, 0x4)
epoll_create1(0x0)
eventfd2(0xffffffff, 0x100800)
io_uring_register$IORING_UNREGISTER_IOWQ_AFF(r0, 0x12, 0x0, 0x0)
syz_io_uring_submit(r1, r2, &(0x7f00000001c0)=3D@IORING_OP_ACCEPT=3D{0xd,
0x10, 0x1, @sock=3Dr4, &(0x7f0000000200)=3D0x80,
&(0x7f0000000240)=3D@tipc=3D@name, 0x0, 0x800})
io_uring_enter(r0, 0x1, 0x1, 0x9, 0x0, 0x0)
syz_io_uring_complete(r1, &(0x7f0000000380))
io_uring_register$IORING_REGISTER_PROBE(r0, 0x8,
&(0x7f0000002900)=3D{0x0, 0x0, 0x0, '\x00', [{}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {},
{}, {}, {}, {}, {}]}, 0x2e)
clock_gettime(0x0, 0x0)
syz_io_uring_submit(r1, r2, 0x0)
syz_io_uring_submit(r1, r2,
&(0x7f0000001680)=3D@IORING_OP_SYMLINKAT=3D{0x26, 0x22, 0x0, @fd_dir=3Dr3,
&(0x7f0000000180)=3D'./file0\x00', &(0x7f0000000380)=3D'./file0\x00'})
syz_io_uring_submit(r1, r2,
&(0x7f0000002a80)=3D@IORING_OP_ASYNC_CANCEL=3D{0xe, 0x0, 0x0, 0x0, 0x0,
0x0, 0x0, 0x4, 0x1})
syz_io_uring_submit(r1, r2,
&(0x7f0000002ac0)=3D@IORING_OP_ASYNC_CANCEL=3D{0xe, 0x0, 0x0, 0x0, 0x0,
0x0, 0x0, 0x10, 0x1})
io_uring_enter(r0, 0x4, 0x4, 0x5, 0x0, 0x0)
syz_io_uring_complete(r1, 0x0)
```


On Wed, Jun 12, 2024 at 5:41=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 6/12/24 15:29, chase xd wrote:
> > Hi,
> >
> > Syzkaller hits a new bug in branch 6.10.0-rc1-00004-gff802a9f35cf-dirty=
 #7.
> > Note: this is also not a reliable repro, might need to try more times
>
> Do you have a syz repro? It's easier to understand what it's doing,
> which request types are used and such.
>
>
> >
> > ```
> >
> > [  153.857557][T21250] apt-get (21250) used greatest stack depth:
> > 22240 bytes left
> > [  249.711259][T57846] ------------[ cut here ]------------
> > [  249.711626][T57846] WARNING: CPU: 1 PID: 57846 at
> > io_uring/refs.h:38 io_issue_sqe+0x10dc/0x1720
> > [  249.712188][T57846] Modules linked in:
> > [  249.712431][T57846] CPU: 1 PID: 57846 Comm: iou-wrk-57845 Not
> > tainted 6.10.0-rc1-00004-gff802a9f35cf-dirty #7
> > [  249.713020][T57846] Hardware name: QEMU Standard PC (i440FX + PIIX,
> > 1996), BIOS 1.15.0-1 04/01/2014
> > [  249.713566][T57846] RIP: 0010:io_issue_sqe+0x10dc/0x1720
> > [  249.713894][T57846] Code: fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02 00
> > 0f 85 c6 05 00 00 49 89 1c 24 49f
> > [  249.715023][T57846] RSP: 0018:ffffc9000e84fc00 EFLAGS: 00010293
> > [  249.715389][T57846] RAX: 0000000000000000 RBX: 0000000000000000
> > RCX: ffffffff84139c3c
> > [  249.715855][T57846] RDX: ffff88801eaad640 RSI: ffffffff8413a70b
> > RDI: 0000000000000007
> > [  249.716300][T57846] RBP: ffffc9000e84fc80 R08: 0000000000000007
> > R09: 0000000000000000
> > [  249.716676][T57846] R10: 0000000000000000 R11: 0000000000000000
> > R12: ffff8880001c3a00
> > [  249.717042][T57846] R13: 0000000000000000 R14: ffff888010600040
> > R15: ffff8880001c3a48
> > [  249.717428][T57846] FS:  00007f58ce931800(0000)
> > GS:ffff88807ec00000(0000) knlGS:0000000000000000
> > [  249.717837][T57846] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> > [  249.718135][T57846] CR2: 00007f58ce932128 CR3: 000000001b08a000
> > CR4: 00000000000006f0
> > [  249.718497][T57846] Call Trace:
> > [  249.718668][T57846]  <TASK>
> > [  249.718810][T57846]  ? __warn+0xc7/0x2f0
> > [  249.719003][T57846]  ? io_issue_sqe+0x10dc/0x1720
> > [  249.719233][T57846]  ? report_bug+0x347/0x410
> > [  249.719451][T57846]  ? handle_bug+0x3d/0x80
> > [  249.719654][T57846]  ? exc_invalid_op+0x18/0x50
> > [  249.719872][T57846]  ? asm_exc_invalid_op+0x1a/0x20
> > [  249.720127][T57846]  ? io_issue_sqe+0x60c/0x1720
> > [  249.720420][T57846]  ? io_issue_sqe+0x10db/0x1720
> > [  249.720711][T57846]  ? io_issue_sqe+0x10dc/0x1720
> > [  249.721012][T57846]  ? __fget_files+0x1bc/0x3d0
> > [  249.722194][T57846]  ? io_wq_submit_work+0x264/0xcb0
> > [  249.722521][T57846]  io_wq_submit_work+0x264/0xcb0
> > [  249.722826][T57846]  io_worker_handle_work+0x97e/0x1790
> > [  249.723159][T57846]  io_wq_worker+0x38e/0xe50
> > [  249.723435][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> > [  249.723687][T57846]  ? ret_from_fork+0x16/0x70
> > [  249.723907][T57846]  ? __pfx_lock_release+0x10/0x10
> > [  249.724139][T57846]  ? do_raw_spin_lock+0x12c/0x2b0
> > [  249.724392][T57846]  ? __pfx_do_raw_spin_lock+0x10/0x10
> > [  249.724706][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> > [  249.725015][T57846]  ret_from_fork+0x2f/0x70
> > [  249.725300][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> > [  249.725603][T57846]  ret_from_fork_asm+0x1a/0x30
> > [  249.725897][T57846]  </TASK>
> > [  249.726083][T57846] Kernel panic - not syncing: kernel: panic_on_war=
n set ...
> > [  249.726521][T57846] CPU: 1 PID: 57846 Comm: iou-wrk-57845 Not
> > tainted 6.10.0-rc1-00004-gff802a9f35cf-dirty #7
> > [  249.727110][T57846] Hardware name: QEMU Standard PC (i440FX + PIIX,
> > 1996), BIOS 1.15.0-1 04/01/2014
> > [  249.727647][T57846] Call Trace:
> > [  249.727842][T57846]  <TASK>
> > [  249.728018][T57846]  panic+0x4fa/0x5a0
> > [  249.728252][T57846]  ? __pfx_panic+0x10/0x10
> > [  249.728516][T57846]  ? show_trace_log_lvl+0x284/0x390
> > [  249.728832][T57846]  ? io_issue_sqe+0x10dc/0x1720
> > [  249.729120][T57846]  check_panic_on_warn+0x61/0x80
> > [  249.729416][T57846]  __warn+0xd3/0x2f0
> > [  249.729650][T57846]  ? io_issue_sqe+0x10dc/0x1720
> > [  249.729941][T57846]  report_bug+0x347/0x410
> > [  249.730206][T57846]  handle_bug+0x3d/0x80
> > [  249.730460][T57846]  exc_invalid_op+0x18/0x50
> > [  249.730730][T57846]  asm_exc_invalid_op+0x1a/0x20
> > [  249.731031][T57846] RIP: 0010:io_issue_sqe+0x10dc/0x1720
> > [  249.731365][T57846] Code: fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02 00
> > 0f 85 c6 05 00 00 49 89 1c 24 49f
> > [  249.732508][T57846] RSP: 0018:ffffc9000e84fc00 EFLAGS: 00010293
> > [  249.732873][T57846] RAX: 0000000000000000 RBX: 0000000000000000
> > RCX: ffffffff84139c3c
> > [  249.733351][T57846] RDX: ffff88801eaad640 RSI: ffffffff8413a70b
> > RDI: 0000000000000007
> > [  249.733822][T57846] RBP: ffffc9000e84fc80 R08: 0000000000000007
> > R09: 0000000000000000
> > [  249.734285][T57846] R10: 0000000000000000 R11: 0000000000000000
> > R12: ffff8880001c3a00
> > [  249.734757][T57846] R13: 0000000000000000 R14: ffff888010600040
> > R15: ffff8880001c3a48
> > [  249.735236][T57846]  ? io_issue_sqe+0x60c/0x1720
> > [  249.735529][T57846]  ? io_issue_sqe+0x10db/0x1720
> > [  249.735825][T57846]  ? __fget_files+0x1bc/0x3d0
> > [  249.736116][T57846]  ? io_wq_submit_work+0x264/0xcb0
> > [  249.736428][T57846]  io_wq_submit_work+0x264/0xcb0
> > [  249.736731][T57846]  io_worker_handle_work+0x97e/0x1790
> > [  249.737061][T57846]  io_wq_worker+0x38e/0xe50
> > [  249.737353][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> > [  249.737646][T57846]  ? ret_from_fork+0x16/0x70
> > [  249.737861][T57846]  ? __pfx_lock_release+0x10/0x10
> > [  249.738091][T57846]  ? do_raw_spin_lock+0x12c/0x2b0
> > [  249.738398][T57846]  ? __pfx_do_raw_spin_lock+0x10/0x10
> > [  249.738729][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> > [  249.739033][T57846]  ret_from_fork+0x2f/0x70
> > [  249.739308][T57846]  ? __pfx_io_wq_worker+0x10/0x10
> > [  249.739617][T57846]  ret_from_fork_asm+0x1a/0x30
> > [  249.739913][T57846]  </TASK>
> > [  249.740236][T57846] Kernel Offset: disabled
> > [  249.740518][T57846] Rebooting in 86400 seconds..
> >
> > ```
> >
> > crepro is in attachments.
> >
> > Regards
>
> --
> Pavel Begunkov

