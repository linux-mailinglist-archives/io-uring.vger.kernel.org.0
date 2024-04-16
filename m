Return-Path: <io-uring+bounces-1569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D3D8A61B2
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 05:29:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC7241F2289A
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 03:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F3B179B7;
	Tue, 16 Apr 2024 03:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="DNUCv+K9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC98617550
	for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 03:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713238165; cv=none; b=U+tk0F+qcHXedkwlskGM1sGvkiKn7HU1xpUtGoBg8sNHH9xdFCu5ZAy0uxzgREL6QCarHJRGiWEcM+weL65AXyJdLklp9hrtBK8s6iNwO73ADB5CmdGiQ4JMg1b2DAv3bTfO8DyTcLUkwUqUwkrzNCrOWD356El0PRw/Qok0LXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713238165; c=relaxed/simple;
	bh=A93IO4HvdgpfXsS09klQBOToK+dCufMV0aKRWmW7s0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nWZz430e8ETXxxeElb0Bp+htIbylqIShOksUoSJhCCc0IAKefUi9SMfDZZiKJLXIkaj9ZX19aNPlUALn6L0gr2ItwjR9Q1AaLK4jkxKFjFkrElFsVpXZoHILRFu3TsEt0R85F/GAR63dgGTCCMsAmeCPsjldIxc1TbPoooIWK1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=DNUCv+K9; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-61acfd3fd3fso19082977b3.1
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 20:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1713238163; x=1713842963; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGU3riBnl9ZTwSW5EEFvJ7BCn2g6uO4o7k4olkwpexs=;
        b=DNUCv+K9ZvZFidPv16bFz44ON4WtnDn0yHYaeZPHD298x06F48wnI3n6KcWFZtZqWo
         xTvXdeVsnaKmGOTwTSRaccyBpud0PndjqoyAZ6Ibx2Hf+teKkrBHdDH46L/OVBevfVoA
         W8JB7MjVLgxwuWA2UdzLbQ4oxWN2t2kqK+d64VGlQuFX3FPuoEqmEenFfYCAiIO834qa
         bArkkswvq3ovaZEnoNU/4TN6xo74DadyVAXED3Yy/mRddGedBgTOef668wQeZmfwvpSz
         k78cV8MAvoJ3gRIcIhEThvqBwFIR8jQ8kfPjqAbw9ydh6/HczxL638LT1trBBkJWfgER
         Q8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713238163; x=1713842963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BGU3riBnl9ZTwSW5EEFvJ7BCn2g6uO4o7k4olkwpexs=;
        b=KHWi8eEgFEhPSv5m5gNB7RdB9zqA34n2uNcSPDblW0QGnUpZLUJXHrb7gm2KBGSb/0
         Wg1osooL8sOxCJZim7hjPMBcQxf3y+KYGY1FveK6efuvGapdyl/JLafnFdX7taupH0MZ
         BolYauxVmptR5qelGtOzkZGQ16ZZVWww/8LrQURtHiji0JQ6+xL06EnHdNEAzBTivkjN
         oeLLPUd+9ouOFxRjX4iB3alYjpyygWKOozDoRTuOQiOb33kr9yBpQvv619Q20aX/PoYr
         lMzRSYHn6tboT2eGWyxThX0zlmlhr/e0NSaGkJt5rlv4mr1IzsM279eH120yALrFTpfw
         4f7A==
X-Gm-Message-State: AOJu0YwiG6rqN5khuATe1ednO4W3TPqqCOdOM9WUBPxZ7mVUX5+hCmam
	Tnr43B21yL64FN/R0Q8ovxwbV9RjFEeHUyqs57Ph5ktWCN5GCq+rNgearKO4S4G8tiGkXn7ZYvq
	QuLJqN4rzIErIbQX92bDt0tsswjOlmKfFIAnO
X-Google-Smtp-Source: AGHT+IFoeZvlkKM52OEEsMkrF2vtc+mcmOAsIupUvt5STjHaZfym7Opuj1v4/lXlp9MJVtwnwQjL4IPFECAFjA7yzXU=
X-Received: by 2002:a81:4884:0:b0:615:2d5a:e398 with SMTP id
 v126-20020a814884000000b006152d5ae398mr11832089ywa.21.1713238162641; Mon, 15
 Apr 2024 20:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0cea7b29-5c31-409a-a8d3-de53c7ce40eb@linux.microsoft.com>
In-Reply-To: <0cea7b29-5c31-409a-a8d3-de53c7ce40eb@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 15 Apr 2024 23:29:11 -0400
Message-ID: <CAHC9VhTWbFu8vbapWG5ndt=r-y5SkSSe=AA3YEufreYtjPMrUw@mail.gmail.com>
Subject: Re: io_uring: worker thread NULL dereference during openat op
To: Dan Clash <daclash@linux.microsoft.com>
Cc: io-uring@vger.kernel.org, audit@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 7:26=E2=80=AFPM Dan Clash <daclash@linux.microsoft.=
com> wrote:
>
> Below is a test program that causes multiple io_uring worker threads to
> hit a NULL dereference while executing openat ops.
>
> The test program hangs forever in a D state.  The test program can be
> run again after the NULL dereferences.  However, there are long delays
> at reboot time because the io_uring_cancel() during do_exit() attempts
> to wake the worker threads.
>
> The test program is single threaded but it queues multiple openat and
> close ops with IOSQE_ASYNC set before waiting for completions.
>
> I collected trace with /sys/kernel/tracing/events/io_uring/enable
> enabled if that is helpful.
>
> The test program reproduces similar problems in the following releases.
>
> mainline v6.9-rc3
> stable 6.8.5
> Ubuntu 6.5.0-1018-azure
>
> The test program does not reproduce the problem in Ubuntu
> 5.15.0-1052-azure, which does not have the io_uring audit changes.
>
> The following is the first io_uring worker thread backtrace in the repro
> against v6.9-rc3.
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> CPU: 0 PID: 4628 Comm: iou-wrk-4605 Not tainted 6.9.0-rc3 #2
> Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine,
> BIOS Hyper-V UEFI Release v4.1 11/28/2023
> RIP: 0010:strlen (lib/string.c:402)
> Call Trace:
>   <TASK>
> ? show_regs (arch/x86/kernel/dumpstack.c:479)
> ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434)
> ? page_fault_oops (arch/x86/mm/fault.c:713)
> ? do_user_addr_fault (arch/x86/mm/fault.c:1261)
> ? exc_page_fault (./arch/x86/include/asm/irqflags.h:37
> ./arch/x86/include/asm/irqflags.h:72 arch/x86/mm/fault.c:1513
> arch/x86/mm/fault.c:1563)
> ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:623)
> ? __pfx_strlen (lib/string.c:402)
> ? parent_len (kernel/auditfilter.c:1284).
> __audit_inode (kernel/auditsc.c:2381 (discriminator 4))

Thanks for the well documented bug report!

That's interesting, it looks like audit_inode() is potentially being
passed a filename struct with a NULL name field (filename::name =3D=3D
NULL).  Given the IOSQE_ASYNC and what looks like io_uring calling
getname() from within the __io_openat_prep() function, I suspect the
issue is that we aren't associating the filename information we
collect in getname() with the proper audit_context().  In other words,
we do the getname() in one context, and then the actual open operation
in another, and the audit filename info is lost in the switch.

I think this is related to another issue that Jens and I have been
discussing relating to connect() and sockaddrs.  We had been hoping
that the issue we were seeing with sockaddrs was just a special case
with connect, but it doesn't look like that is the case.

I'm going to be a bit busy this week with conferences, but given the
previous discussions with Jens as well as this new issue, I suspect
that we are going to need to do some work to support creation of a
thin, or lazily setup, audit_context that we can initialize in the
io_uring prep routines for use by getname(), move_addr_to_kernel(),
etc., store in the io_kiocb struct, and then fully setup in
audit_uring_entry().

> ? link_path_walk.part.0.constprop.0 (fs/namei.c:2324)
> path_openat (fs/namei.c:3550 fs/namei.c:3796)
> do_filp_open (fs/namei.c:3826)
> ? alloc_fd (./arch/x86/include/asm/paravirt.h:589 (discriminator 10)
> ./arch/x86/include/asm/qspinlock.h:57 (discriminator 10)
> ./include/linux/spinlock.h:204 (discriminator 10)
> ./include/linux/spinlock_api_smp.h:142 (discriminator 10)
> ./include/linux/spinlock.h:391 (discriminator 10) fs/file.c:553
> (discriminator 10))
> io_openat2 (io_uring/openclose.c:140)
> io_openat (io_uring/openclose.c:178)
> io_issue_sqe (io_uring/io_uring.c:1897)
> io_wq_submit_work (io_uring/io_uring.c:2006)
> io_worker_handle_work (io_uring/io-wq.c:540 io_uring/io-wq.c:597)
> io_wq_worker (io_uring/io-wq.c:258 io_uring/io-wq.c:648)
> ? __pfx_io_wq_worker (io_uring/io-wq.c:627)
> ? raw_spin_rq_unlock (./arch/x86/include/asm/paravirt.h:589
> ./arch/x86/include/asm/qspinlock.h:57 ./include/linux/spinlock.h:204
> ./include/linux/spinlock_api_smp.h:142 kernel/sched/core.c:603)
> ? finish_task_switch.isra.0 (./arch/x86/include/asm/irqflags.h:42
> ./arch/x86/include/asm/irqflags.h:77 kernel/sched/sched.h:1397
> kernel/sched/core.c:5163 kernel/sched/core.c:5281)
> ? __pfx_io_wq_worker (io_uring/io-wq.c:627)
> ret_from_fork (arch/x86/kernel/process.c:156)
> ? __pfx_io_wq_worker (io_uring/io-wq.c:627)
> ret_from_fork_asm (arch/x86/entry/entry_64.S:256)

--=20
paul-moore.com

