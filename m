Return-Path: <io-uring+bounces-11125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22D33CC17E7
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 09:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ABEE43031246
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 08:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4928F34CFCD;
	Tue, 16 Dec 2025 08:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1M3wO0B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8E234CFCE
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 08:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765872887; cv=none; b=sHhTjlRj3DF6kdzRjs6B+p+LpD5w2bubsfJ8kGOh87Ptmmoc1QEjx8kSAH7l2XKs259lR6/1mwx+yHtiXWHPWbiH7i9UMdIEGBaJhMxMvtcKdFIUn3VBdqGAkinGHPZR4tn4G63vzMw/NvVI3JRzC9MM2Pbf2K7iUkMrL1kAxLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765872887; c=relaxed/simple;
	bh=J4lqY4Z2tcVvD9LSajGGpuAMb1wEG/DuQOlPJ+d0frA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LOzPUamxI7FdWOFYVUV6+Zos2ijjhjEcaHtgeIpTerbWpmEyUbPQp9cCvkT644dMonP+DOEi7PPVDlcghWCOfJobmY6B96sjdkwjEf4WJC/dQy56nSxqgdBxyf8flmjWJYiD4MsEj06AHbt5reWoffDrCzbsLxtswrLw84kAIA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1M3wO0B; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2d32b9777so643806885a.2
        for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 00:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765872884; x=1766477684; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdnNr/hrj7cM//9XRVgXbfL4x3L+2QEttDDQbyhzLTU=;
        b=k1M3wO0B22Hgi5T8vyIEC81bndj6N1G1bhH4AsKJRFreeTAXX+auqE7EvqRdNEnLPj
         cmYTSzfFMLE8JxjcNrWhlE0qSdH4S7AwXJFfbe6R9oQVSKRsJjvGAl6aZCMuM8Wxlxad
         JgRpqA/IYeXxeBnNJbkNZnDt3n1owb0bVRlGXcixiJc/rFkpA/0CAWPtaY3QcmtCb7f2
         cPCb+U4std21akg7Z8vzs9cG/NSnv3Z9nw+/eKyeiyqrD5xAIkkB3uYQlbrZ/wtwRUuE
         /lvFS19XG4NDYumadEAsLQaczT4BNMQ4gTF0aULng0no1NSju9oty4rlBmFVmuqmWSXH
         SNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765872884; x=1766477684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WdnNr/hrj7cM//9XRVgXbfL4x3L+2QEttDDQbyhzLTU=;
        b=soNxUKwPFd/j+xiak0G2YUwiVc5yKpE6UoxM39k4lXneN22KcSpkqr5gZdU8R3RvDN
         HowzDUvoSY9nthMllbvxGDyyBxEJDL1jBSD75hmMD+oIfQ+L9brBsldKMNYlRWRtiEM4
         F91H1xUOAew1C7P5TiE3TqEOqR6zXaKa8UJcAHAchVOWw3Q6VyupszmnhTUNEgclY5gF
         29xYZEXK4Xw998twd2FoC1VbzxOnLTFfJaC65tLvE+h7lY3MlKPEzOhYzJzktKMesZJv
         7lhy2TUWW9wmueekpkxzm5ePvXVVy81PtPrTX6FqJk8CRsl4mrK7b/2i9tqrwhGpl+kq
         hcbg==
X-Forwarded-Encrypted: i=1; AJvYcCVqiwkvOwRNAxQ3GQgBeGAQHMENvKdTdGr/sseDpJtdOPHPHXtx+thdKtCHolZ8E7X2sis8MmmTUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMhGku8qyiIkmXIdZyITluBChNW2n/H3cRzNasTpcuQ5jH0/TW
	NfgKuQCWaOYAaR735n/DX9r44iIT0nBGdLOlKKJyif486T2ydBy5Jx+nMoXygg8a15ZcoqQd3Oj
	eiEZn7qv30nN5uHGcYRoDHGXYpxyHxtQ=
X-Gm-Gg: AY/fxX4lGquN1htiB318SI0f7hUj/t3wAFIVDUfnd+bZe9qi/B4rtpZYUrkiIT7sGBm
	5mta/OW3Bo9lj3/JaBddHU+Ejl1z4LX2xilSyMoHk+FjN4+5n4NL60eLTC/JBFGzrowMFyEtXz9
	rq4xd9sH/2/ln8d4EOrchrEJo0yiupYIJP1+cHzdEf/q2CiToRX12SceGTn7EzVHCotxNSzxPDo
	CkJbB3KQwN13mn/7GCYjZmNoY8fn8KPVDH1+6oKyVxoznm2qtFj8dnc/zOXr5n/tFdsOTUcEHQ7
	VlJz6ylAhCw=
X-Google-Smtp-Source: AGHT+IEbg6oPYV7wItb0ko8RC1BIA+1cxYxWmJ97+ix9eBksy2MBu2sJtpW8VjTSwa9NauHxakQa/JPFzy/bcsiFO8o=
X-Received: by 2002:a05:622a:8c3:b0:4f0:2d9d:a3ba with SMTP id
 d75a77b69052e-4f1d062bc34mr200447341cf.77.1765872884249; Tue, 16 Dec 2025
 00:14:44 -0800 (PST)
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
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 16 Dec 2025 16:14:32 +0800
X-Gm-Features: AQt7F2oCTotSmaShQgVFWEBAAE51JDLkYNm5fLZeMmFLLfmyuTbtlITbZeVOMqA
Message-ID: <CAJnrk1Z0so5okNnEERiamB=6C8GBQ9c1nzwnfG5u_7GUoWTNmw@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 3:47=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
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
>

Hmm, thinking about this buffer cloning + IORING_SINGLE_ISSUER
submitter task's buffer unregistration stuff some more though...
doesn't this same race with the corrupted values exist if the cloning
logic acquires the mutex before the submitter task formally runs and
then the submitter task starts executing immediately right after with
the buffer unregistration logic while the cloning logic is
simultaneously executing the logic inside the mutex section? In the
io_ring_ctx_lock_nested() logic, I'm not seeing where this checks
whether the lock is currently acquired by other tasks or am I missing
something here and this is already accounted for?

Thanks,
Joanne

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

