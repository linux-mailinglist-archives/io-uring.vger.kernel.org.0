Return-Path: <io-uring+bounces-11126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 019DDCC4155
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 16:57:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F000310C88F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 15:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5E92D5C61;
	Tue, 16 Dec 2025 15:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RKjDnD4m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C6929B200
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765900190; cv=none; b=q51Ns35/J08x2dYQ8UxrKl8WNYFE3d1Ab5E+d6abmdaeR1w6+eO8+Kvw33UeXtkCTc55knV6DMgha8mkZ1Vufg+K9/M0MEq6K6mrIOpQg+0MTU38Ul20vNk4u4JIwPrNhF3Jk/FXU6NfyQe5UHtXHm0ELl6T002eTtLVFNuIAv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765900190; c=relaxed/simple;
	bh=Cyp+CNr3Xlkfyks4HLZM+uAUAlcU0l5rmduEkQyJ4rU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GgSqtP9YxyGgDpmTYavC7pKoTElnmhC/xsdT+TtUL0QZe5COjdbHJDrHYkl1T8KASRqCvorwI7baPDDLf2mfLMAri41N8LRFft02wMKU3dCFkIbW1bFLczbkHRBiCtDyFpHLFuQQSMQLpv15tV+7u7c5sM85UNVa6PgpereqdLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RKjDnD4m; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-bc0d28903c9so190531a12.1
        for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 07:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765900187; x=1766504987; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=szC6Jhas+jyxVZXU9ORkuFWqSp9Zh7eGvf/5vN3tpkI=;
        b=RKjDnD4mXNoRaqCnfU2mwS9qrzx6UVr9rNMILVUhEjd2cCmRgSoT1vZztwNzbVXyoJ
         iRLUd2VdrJfc8G5hX4zT3kKvlxVbKUGNlrHsYROUL11/GWY6WyRYUhWUIjdmhHSJnOzG
         OLqeRxfb61FeU6zEmk1KlrT2x0cgNhSH/CUg4UgOtVQdppVvz/QrVmoUxG28jF4AV+RL
         lVJckk8YGw75506SuGKUX/UkdU5yJRZymkQ9tOalYaZWLaoNXV7yVO/hEDvHPOxxJkWq
         EaaOw1rRjEyLSxQodbpw7L08gT4Cb6BWtT2UGOZ33z7Q4gaC/Ewe2kIty7+CpPqvnD5R
         Siuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765900187; x=1766504987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=szC6Jhas+jyxVZXU9ORkuFWqSp9Zh7eGvf/5vN3tpkI=;
        b=g0aX+4b1ddrtz2mM7gBis9zvvKV47yiWXwxc2x9OVGV8oHYv8pH7c3etYry9rCvrNf
         dFC3Hdk9eP+KzeenNonyEt6Sm7debpJsGXlYhTO50hygLIuRxjN5dmH2f/HkaYpLMLPh
         wTsTdY4HXI+F8v1f1iU3BUaEvLOp6pDeO98OcgnSZI30Z2dmBwiJnD2od5Ly+JE9G+Q9
         fG/E6y87bSce9SETWZ98XsCHOv/NmEOlaB/8BXxlmq4FA2zGMfsb1fQLe/Ten9bbjEbH
         bGGRBra+kLiQxVR4KEN6clYq+MLcZBZmv0zxRZOGG5I+OxRciwpyXZamnH7ax92ilxhN
         MpwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtDkUni3sB6naDCB0WQxvAhJ/ytwUkdr4ijZUOxFywUTA3j9qUYZXzMrcAfA0iT5n9u3c44GpWvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpBTDTfbfUkoSa8G3n58g7unedAVd9YUnqUBEqzfsnDbg6key9
	PxNaQ9iCPPRMLIwp5GY1EDDyQdjz2C6UEKQBmGvCTvufWNa2mH8XCpEoVWyzr87WQ6OTe4Me3lH
	ZEgh8F97f8ZsIT/CpzO49bNhn8tQbEDP9HPFvLrKcvN0Bndq+hVPITyw=
X-Gm-Gg: AY/fxX6TirhW/8oTeCsfmo/ApCQhFa7RzN84yrp5DAjFvlSbznInAWRROmndA8SjaFm
	L/Vl11jAYR4p3v3khm1nfp82ubHZ4oSMz7qefEofVcjch8RG/5vsAzVMvfv78q265Ww7eQwRW7F
	IczzyZjz1IhAibqA8RmhxQGLc2lTTDDHunqefEPs8YMS+8vOma2wdvL/lj+ow2Q0BsTuY2XXqXy
	fP+vlWEwrm7TAD+w8WR0WN+Kabx0ry6+81STZeeD3GjyA2AOlEfI+48xhfN30475xqhhbY=
X-Google-Smtp-Source: AGHT+IHsvZoO1ya/Ovow/Y6DWjX1g9izC6zLdkO8PAcaiNAQG4cy6wKuRB+Jz9WyuObZA+5qPSFIaSHVRiQHlNIeTgk=
X-Received: by 2002:a05:7022:f503:b0:11b:98e8:624e with SMTP id
 a92af1059eb24-11f34c4828cmr3166391c88.4.1765900186741; Tue, 16 Dec 2025
 07:49:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com>
 <20251215200909.3505001-7-csander@purestorage.com> <CAJnrk1Zhku-_ayXqCisYOCWnDf31YDyiWWEHJeMU=BDYoQR9mA@mail.gmail.com>
 <CADUfDZr_aTixiUQUN0yRj=AbuBLTrgk5SXXsjwao54ZmMajUOA@mail.gmail.com> <CAJnrk1bdkWVLDBrPKFVa7oPNqAw5BCbNo1N393ESp-zQOT0w5A@mail.gmail.com>
In-Reply-To: <CAJnrk1bdkWVLDBrPKFVa7oPNqAw5BCbNo1N393ESp-zQOT0w5A@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 16 Dec 2025 07:49:34 -0800
X-Gm-Features: AQt7F2rIVLRwb4mmIeLpmFkZ0RGkDDokOlQuEOEZRYdDpVLQp92sEMT1lhrx7f8
Message-ID: <CADUfDZqZce=8LGtjZquxyQDfciOYu4fgtPFqwfkirWS5f6ALow@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 11:47=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Tue, Dec 16, 2025 at 2:24=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Mon, Dec 15, 2025 at 8:46=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > On Tue, Dec 16, 2025 at 4:10=E2=80=AFAM Caleb Sander Mateos
> > > <csander@purestorage.com> wrote:
> > > >
> > > > io_ring_ctx's mutex uring_lock can be quite expensive in high-IOPS
> > > > workloads. Even when only one thread pinned to a single CPU is acce=
ssing
> > > > the io_ring_ctx, the atomic CASes required to lock and unlock the m=
utex
> > > > are very hot instructions. The mutex's primary purpose is to preven=
t
> > > > concurrent io_uring system calls on the same io_ring_ctx. However, =
there
> > > > is already a flag IORING_SETUP_SINGLE_ISSUER that promises only one
> > > > task will make io_uring_enter() and io_uring_register() system call=
s on
> > > > the io_ring_ctx once it's enabled.
> > > > So if the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, ski=
p the
> > > > uring_lock mutex_lock() and mutex_unlock() on the submitter_task. O=
n
> > > > other tasks acquiring the ctx uring lock, use a task work item to
> > > > suspend the submitter_task for the critical section.
> > >
> > > Does this open the pathway to various data corruption issues since th=
e
> > > submitter task can be suspended while it's in the middle of executing
> > > a section of logic that was previously protected by the mutex? With
> >
> > I don't think so. The submitter task is suspended by having it run a
> > task work item that blocks it until the uring lock is released by the
> > other task. Any section where the uring lock is held should either be
> > on kernel threads, contained within an io_uring syscall, or contained
> > within a task work item, none of which run other task work items. So
> > whenever the submitter task runs the suspend task work, it shouldn't
> > be in a uring-lock-protected section.
> >
> > > this patch (if I'm understandng it correctly), there's now no
> > > guarantee that the logic inside the mutexed section for
> > > IORING_SETUP_SINGLE_ISSUER submitter tasks is "atomically bundled", s=
o
> > > if it gets suspended between two state changes that need to be atomic
> > > / bundled together, then I think the task that does the suspend would
> > > now see corrupt state.
> >
> > Yes, I suppose there's nothing that prevents code from holding the
> > uring lock across syscalls or task work items, but that would already
> > be problematic. If a task holds the uring lock on return from a
> > syscall or task work and then runs another task work item that tries
> > to acquire the uring lock, it would deadlock.
> >
> > >
> > > I did a quick grep and I think one example of this race shows up in
> > > io_uring/rsrc.c for buffer cloning where if the src_ctx has
> > > IORING_SETUP_SINGLE_ISSUER set and the cloning happens at the same
> > > time the submitter task is unregistering the buffers, then this chain
> > > of events happens:
> > > * submitter task is executing the logic in io_sqe_buffers_unregister(=
)
> > > -> io_rsrc_data_free(), and frees data->nodes but data->nr is not yet
> > > updated
> > > * submitter task gets suspended through io_register_clone_buffers() -=
>
> > > lock_two_rings() -> mutex_lock_nested(&ctx2->uring_lock, ...)
> >
> > I think what this is missing is that the submitter task can't get
> > suspended at arbitrary points. It gets suspended in task work, and
> > task work only runs when returning from the kernel to userspace. At
>
> Ahh I see, thanks for the explanation. The documentation for
> TWA_SIGNAL in task_work_add() says "@TWA_SIGNAL works like signals, in
> that the it will interrupt the targeted task and run the task_work,
> regardless of whether the task is currently running in the kernel or
> userspace" so i had assumed this preempts the kernel.

Yeah, that documentation seems a bit misleading. Task work doesn't run
in interrupt context, otherwise it wouldn't be safe to take mutexes
like the uring lock. I think the comment is trying to say that
TWA_SIGNAL immediately kicks the task into the kernel, interrupting
any *userspace work*. But if the task is already in the kernel, it
won't run task work until returning to userspace. Though I could also
be misunderstanding how task work works.

Best,
Caleb

>
> Thanks,
> Joanne
>
> > which point "nothing" should be running on the task in userspace or
> > the kernel and it should be safe to run arbitrary task work items on
> > the task. Though Ming recently found an interesting deadlock caused by
> > acquiring a mutex in task work that runs on an unlucky ublk server
> > thread[1].
> >
> > [1] https://lore.kernel.org/linux-block/20251212143415.485359-1-ming.le=
i@redhat.com/
> >
> > Best,
> > Caleb
> >
> > > * after suspending the src ctx, -> io_clone_buffers() runs, which wil=
l
> > > get the incorrect "nbufs =3D src_ctx->buf_table.nr;" value
> > > * io_clone_buffers() calls io_rsrc_node_lookup() which will
> > > dereference a NULL pointer
> > >
> > > Thanks,
> > > Joanne
> > >
> > > > If the io_ring_ctx is IORING_SETUP_R_DISABLED (possible during
> > > > io_uring_setup(), io_uring_register(), or io_uring exit), submitter=
_task
> > > > may be set concurrently, so acquire the uring_lock before checking =
it.
> > > > If submitter_task isn't set yet, the uring_lock suffices to provide
> > > > mutual exclusion.
> > > >
> > > > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > > > Tested-by: syzbot@syzkaller.appspotmail.com
> > > > ---
> > > >  io_uring/io_uring.c |  12 +++++
> > > >  io_uring/io_uring.h | 114 ++++++++++++++++++++++++++++++++++++++++=
++--
> > > >  2 files changed, 123 insertions(+), 3 deletions(-)
> > > >

