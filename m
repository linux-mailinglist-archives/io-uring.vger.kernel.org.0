Return-Path: <io-uring+bounces-11124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47416CC15C1
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 08:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC8B13021E59
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 07:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA86346E6E;
	Tue, 16 Dec 2025 07:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uv5Y0+xP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB780346E69
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 07:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765871265; cv=none; b=dvk5bs+z35z6IAVJ8CuQZMAPco+R8K7YviKa7CtX5pncoyO6CfxmBivOn1UM2Hm9K+LX/qEvlF8ri6C9OvejzFLrK4eNRmARgtMqksvkzOBjBhf+ISqZJWrO2FQCC5m0AdiWsT2BpIvAqBU6jYxY/WM/HykmdqflFadwz+sFTLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765871265; c=relaxed/simple;
	bh=L2umdyo70lIWSvGgu1EVpv779lGK5KiH2IrpRKXULx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YQAHQen+6mLW414lvok2KiFA5qnAmYDXYuNXIAkxWVtwDddTWd/nxs9kD1T5scKL9BeHhoCOS5pBkJlGsPE0kxQwRh3aMuzTQNGaUiOCUAqK1DFMTWWRmXg+ElKEDPiMDHSBx1PRj4QjvEqpZ7xI89TQK4dj2Z4ubAfgstPrkBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uv5Y0+xP; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ed82ee9e57so57382511cf.0
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 23:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765871263; x=1766476063; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHKKOCG7uLrhCNNavohz/3D45xj0Qe4VO/A8R9uLies=;
        b=Uv5Y0+xPkOrxDy2VZmfVH1LK22DvEg3HMYDrIiBTEAok3AKCTJGhnu3Hf6OrJ509jT
         gYNmiSrDWUZhXtw2bV2ImP1ZomjnB1fFcqekeOqdZvZT9HmMmrqwZk6Cu0Tv+VJqzyEC
         Zi38dT0NqGmitpbxGkQKN/xbTkRZV7A4T8phgsSuoFJDXF81LKwHU6KGSUKxU3S8OlYC
         PhOK6KHwwhIqD2BXFc2EkEnnO/WqdW5wlQP+RKnItmGLesmIRPSzQtOMdfWncgZma8pZ
         94iQXfNbt2JXCQQkAnSz+9aBxQhVmcyItl6KfPrN24/Ub0PTT90mINlkO7o6Wen1lnz/
         WEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765871263; x=1766476063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FHKKOCG7uLrhCNNavohz/3D45xj0Qe4VO/A8R9uLies=;
        b=TyQycsOueBiqgW7JW2H2XvkY6N7gulXouHBpdugbyJYlgzJBTZ035JRzErbRFSFB4R
         iDX2wTJCaghqZAPfMGD5dTi7WCga9DSI99IFm15qgPRBYZibkAlAwGVAr6mJi/zgu6HS
         tInmPcCCOgYEgwTpWQcb3h/RQ2pQagiaHMDPAM++2alH3pUjKE19vOv5L4SwMiaAoxGR
         RZKL4vN7t26s4XqaeboanOs0+W+Qft0Wc2iyI4unueGkm43rP8ca+9u0j/QycTrhCkyW
         0BGN4oWatwcrDcgi4ChpnkImSBcNjGO6yVr20WqKPU5efudQFQXBRjvOUXOoWFThwVRe
         boNg==
X-Forwarded-Encrypted: i=1; AJvYcCUxZdUYtniE7FW4JloMm8KEtIKtFVWS+8LsnNhQrg5CsK7BxvOpy3BjB4xe//U6m30xNzOvFlcg+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPnQtK2yX6iar+ocvFm2qcnIVWUNK+gZ4rAMAk2EHHUhedLmLR
	2228xXcceN4jVqC7djnJ9gJv99GuUCDibQGovaYbp7CtwT5ctwaxOYgxikWmZsSff0Wjm9TV+DT
	yPFSCyuGI4gyWynOMux+DiKIKCyltSPw=
X-Gm-Gg: AY/fxX6+u8OP8uybxcmRPCWkwgXiK1q6ww6P2QWPEEmMjYwwfq501PaK09D0p2e6DMP
	x0CxkPrtBdD9wZJi/rYyOG0n6clYKHE8yWek4xE4hPewtMZf/THqlBg66IjQgeM3ow8ejYDWxKT
	huIqzb8X9KPhLRCRLQ42ilhccasAfoIvix8G94JDpBwRVCbM7aSWGmOqqaS3Z+FHeAPTTNvfYEv
	36Ash6KJLx3Cx1zzTbmFQuLMyIb0TWzajH7b/jQiqNKrKSMq2wUTA6g0VdL1cwFK5lFzM0kBbzm
	XrxYtNklVPJk6zTCPFIkzw==
X-Google-Smtp-Source: AGHT+IEPCLoxWHxDLAb15PwxdYwo6H3ywrys5dNTBFizbe9oK9h4fQnba9OCeVaJfkJU33prP3xXBHV2w4LhSZ0dx+o=
X-Received: by 2002:a05:622a:7509:b0:4f1:def3:cc00 with SMTP id
 d75a77b69052e-4f1ece5d9a8mr68952841cf.82.1765871262588; Mon, 15 Dec 2025
 23:47:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com>
 <20251215200909.3505001-7-csander@purestorage.com> <CAJnrk1Zhku-_ayXqCisYOCWnDf31YDyiWWEHJeMU=BDYoQR9mA@mail.gmail.com>
 <CADUfDZr_aTixiUQUN0yRj=AbuBLTrgk5SXXsjwao54ZmMajUOA@mail.gmail.com>
In-Reply-To: <CADUfDZr_aTixiUQUN0yRj=AbuBLTrgk5SXXsjwao54ZmMajUOA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 16 Dec 2025 15:47:31 +0800
X-Gm-Features: AQt7F2r_ekS89i3T5hkwQwS2gHSZECZ7VyC6nR8Plu6A4QaNgrV4x6jfnOHm9Gc
Message-ID: <CAJnrk1bdkWVLDBrPKFVa7oPNqAw5BCbNo1N393ESp-zQOT0w5A@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 2:24=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Dec 15, 2025 at 8:46=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Tue, Dec 16, 2025 at 4:10=E2=80=AFAM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > io_ring_ctx's mutex uring_lock can be quite expensive in high-IOPS
> > > workloads. Even when only one thread pinned to a single CPU is access=
ing
> > > the io_ring_ctx, the atomic CASes required to lock and unlock the mut=
ex
> > > are very hot instructions. The mutex's primary purpose is to prevent
> > > concurrent io_uring system calls on the same io_ring_ctx. However, th=
ere
> > > is already a flag IORING_SETUP_SINGLE_ISSUER that promises only one
> > > task will make io_uring_enter() and io_uring_register() system calls =
on
> > > the io_ring_ctx once it's enabled.
> > > So if the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, skip =
the
> > > uring_lock mutex_lock() and mutex_unlock() on the submitter_task. On
> > > other tasks acquiring the ctx uring lock, use a task work item to
> > > suspend the submitter_task for the critical section.
> >
> > Does this open the pathway to various data corruption issues since the
> > submitter task can be suspended while it's in the middle of executing
> > a section of logic that was previously protected by the mutex? With
>
> I don't think so. The submitter task is suspended by having it run a
> task work item that blocks it until the uring lock is released by the
> other task. Any section where the uring lock is held should either be
> on kernel threads, contained within an io_uring syscall, or contained
> within a task work item, none of which run other task work items. So
> whenever the submitter task runs the suspend task work, it shouldn't
> be in a uring-lock-protected section.
>
> > this patch (if I'm understandng it correctly), there's now no
> > guarantee that the logic inside the mutexed section for
> > IORING_SETUP_SINGLE_ISSUER submitter tasks is "atomically bundled", so
> > if it gets suspended between two state changes that need to be atomic
> > / bundled together, then I think the task that does the suspend would
> > now see corrupt state.
>
> Yes, I suppose there's nothing that prevents code from holding the
> uring lock across syscalls or task work items, but that would already
> be problematic. If a task holds the uring lock on return from a
> syscall or task work and then runs another task work item that tries
> to acquire the uring lock, it would deadlock.
>
> >
> > I did a quick grep and I think one example of this race shows up in
> > io_uring/rsrc.c for buffer cloning where if the src_ctx has
> > IORING_SETUP_SINGLE_ISSUER set and the cloning happens at the same
> > time the submitter task is unregistering the buffers, then this chain
> > of events happens:
> > * submitter task is executing the logic in io_sqe_buffers_unregister()
> > -> io_rsrc_data_free(), and frees data->nodes but data->nr is not yet
> > updated
> > * submitter task gets suspended through io_register_clone_buffers() ->
> > lock_two_rings() -> mutex_lock_nested(&ctx2->uring_lock, ...)
>
> I think what this is missing is that the submitter task can't get
> suspended at arbitrary points. It gets suspended in task work, and
> task work only runs when returning from the kernel to userspace. At

Ahh I see, thanks for the explanation. The documentation for
TWA_SIGNAL in task_work_add() says "@TWA_SIGNAL works like signals, in
that the it will interrupt the targeted task and run the task_work,
regardless of whether the task is currently running in the kernel or
userspace" so i had assumed this preempts the kernel.

Thanks,
Joanne

> which point "nothing" should be running on the task in userspace or
> the kernel and it should be safe to run arbitrary task work items on
> the task. Though Ming recently found an interesting deadlock caused by
> acquiring a mutex in task work that runs on an unlucky ublk server
> thread[1].
>
> [1] https://lore.kernel.org/linux-block/20251212143415.485359-1-ming.lei@=
redhat.com/
>
> Best,
> Caleb
>
> > * after suspending the src ctx, -> io_clone_buffers() runs, which will
> > get the incorrect "nbufs =3D src_ctx->buf_table.nr;" value
> > * io_clone_buffers() calls io_rsrc_node_lookup() which will
> > dereference a NULL pointer
> >
> > Thanks,
> > Joanne
> >
> > > If the io_ring_ctx is IORING_SETUP_R_DISABLED (possible during
> > > io_uring_setup(), io_uring_register(), or io_uring exit), submitter_t=
ask
> > > may be set concurrently, so acquire the uring_lock before checking it=
.
> > > If submitter_task isn't set yet, the uring_lock suffices to provide
> > > mutual exclusion.
> > >
> > > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > > Tested-by: syzbot@syzkaller.appspotmail.com
> > > ---
> > >  io_uring/io_uring.c |  12 +++++
> > >  io_uring/io_uring.h | 114 ++++++++++++++++++++++++++++++++++++++++++=
--
> > >  2 files changed, 123 insertions(+), 3 deletions(-)
> > >

