Return-Path: <io-uring+bounces-11127-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B0799CC433E
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 17:18:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D74783017F05
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 16:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B801B23EABB;
	Tue, 16 Dec 2025 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="c1KYMW5j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EEB21FF26
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 16:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765901024; cv=none; b=DvJHHNhe6zEvBLxCD34CaODMdJbKhVIPI0sm/eiX3OaXPPCytv/VUqqPmQ0qD9k/5Obu2ak6tXYswbnry01fkZd5J4R0+RCBqLgIgUV64d+l5rytnMHmmG32nwSQIgDyyrf13+Ot55llYcVmf2TY5k2LYQgvPBMBJ98zkOz5qtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765901024; c=relaxed/simple;
	bh=wZyyXt3/XyWwBfVODlXOFjxoE5sULCLSENjYC7U+qiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jvhCDvqvyU3J8mHrtb298jtJDdRd4CDvRbjvXg5KLWXrYlfOcYwWCVCXOXBuMBkKDI7blKyqZjJ3dbpHx94h49PJpTIRv6bt4N/iaqQ53F2S0STwOYkqR0GHLjnf90UeYGmzv+5og+N1KrBg43PdUVxm03pR9d+ZAuMIMM/o8Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=c1KYMW5j; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7f6bc8a4787so272694b3a.3
        for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 08:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765901020; x=1766505820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCCUsrtfWsPHIl5q5b+aYNXCSu6slgTM1+bKznSRppI=;
        b=c1KYMW5jG1FiQ0yYsjlKjWepF6RQNJuD7a2qD2iYe/jB4TTxbQD876PYE1QfPmZOja
         hkdI8s/Y3x/hnbV8t0XzItRZoI5MZRoMMauAbhKru9odL9/nwQTf02H0WSnwbG604IeG
         ODl0iXpix111Lcv7/Pf9gD5RNJf2yokCQu5c46S4YvqDxmCDENMkCZLGocdRMU69sSAJ
         cQAvFdIBsdIByvQtbdSOlQ80oaMoJw8YqLwp8JEWkkOTCogwNBSsqWI2KTuZCDtVTdQR
         XyKnJYkgIZGXW+Sl8maP2hG+FXOvmNoyhhCs+zKJ7eA4du5lMbpItRbkrr54QoVmP8sG
         SJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765901020; x=1766505820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iCCUsrtfWsPHIl5q5b+aYNXCSu6slgTM1+bKznSRppI=;
        b=qen41Tcm7MEM4ncYSznH5wlvMpX34k44AD2VnGO1AZe1r4r6PjkkSA6zwf6lSpXXBJ
         qQkirHmCbf/dK9xhlnLlkv1a9Axkf/ACA6Fan55wmogBUYGBYhja7jM1ju2wCW5YOFK8
         ZSCtpTx4lohrbAfX43NyL1lQ3HPrB133ktDJ/RmbNzdvxxjfTlMiUrIQBkC+YzS3++Wr
         aianr9PCtFW5P19KNQER1kWx5EchpCNmCUTNywI3sJfCxOFUNp+6NaECi+xkZM8nwk00
         iiultdau8BcPEj7WTqLDlbHsAGCg/6Ow4NyXv+x32/N4NNKBg8wTUBaX4/A236iCHBi+
         kT1A==
X-Forwarded-Encrypted: i=1; AJvYcCWPIiU4kjUh9q1lbEgT4ue9QK+qIBWIHgKSl/UfGe9+QKeRlGiY1nQBs/KMSitESPnHgBe+62I3EQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYmse/bPbR3ss69HXiRe+SNqi/9wLaeMz+1WnEr/pGx60vQ6wU
	c6mVhDEXuzfOxBTNDVZTNwX77WX7zSjfedFHa5Jz+dNx1fdQ+1dNbLVo+cZY1UrN3JcRUh2iAS4
	brnibiH/t30xTvt/1LDLOAc+/VU4qwq/UEHNYchDV8A==
X-Gm-Gg: AY/fxX5Qe1p1BqBpMl4DoH9EwDydGjjfzm9ZMsumEVjHK15KlOoAABwrsNoOD7ykOhd
	v/9Y81WdMLebqVBvRbywkkBdt4Waak04I5nyLAw6Tl+x/o7rnAC4IIWwII92Dzg+Ey9J6fIOFbG
	d4eQXxYoDbl6LSBvHXEvltWgLx2foUw1wJ+MB4yNjmpR8GbkWC2I5VUtSE9GoaJDBDEelScHkRF
	rj1bnSvS6HYT/42rN1YREYNRHLINqgo25dxl3AFWeNdYa7K5ww6+jyG48FNkXMAQMEziUY=
X-Google-Smtp-Source: AGHT+IHZsYEVUBeOV0WlRr/PSBac7mgS2D3pNchzpgB94s/5lh6B1lx9RCbSm5/zgXnwM3TcTC1cWImhpXZtMViIyJw=
X-Received: by 2002:a05:701b:2908:b0:11e:3e9:3e9b with SMTP id
 a92af1059eb24-11f34c1d3f5mr3439168c88.6.1765901019774; Tue, 16 Dec 2025
 08:03:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com>
 <20251215200909.3505001-7-csander@purestorage.com> <CAJnrk1Zhku-_ayXqCisYOCWnDf31YDyiWWEHJeMU=BDYoQR9mA@mail.gmail.com>
 <CADUfDZr_aTixiUQUN0yRj=AbuBLTrgk5SXXsjwao54ZmMajUOA@mail.gmail.com>
 <CAJnrk1bdkWVLDBrPKFVa7oPNqAw5BCbNo1N393ESp-zQOT0w5A@mail.gmail.com> <CAJnrk1Z0so5okNnEERiamB=6C8GBQ9c1nzwnfG5u_7GUoWTNmw@mail.gmail.com>
In-Reply-To: <CAJnrk1Z0so5okNnEERiamB=6C8GBQ9c1nzwnfG5u_7GUoWTNmw@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 16 Dec 2025 08:03:28 -0800
X-Gm-Features: AQt7F2rOnn-cx9lANSvkvK8c8F8ZVwaoTYjSjDW8STjF9eYJxCYRqCPYWbyYolA
Message-ID: <CADUfDZrK-SQczz7cjjS+SFHUbQ-dpjvtaaNJic1s3nYzokoMEQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 12:14=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Tue, Dec 16, 2025 at 3:47=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Tue, Dec 16, 2025 at 2:24=E2=80=AFPM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > On Mon, Dec 15, 2025 at 8:46=E2=80=AFPM Joanne Koong <joannelkoong@gm=
ail.com> wrote:
> > > >
> > > > On Tue, Dec 16, 2025 at 4:10=E2=80=AFAM Caleb Sander Mateos
> > > > <csander@purestorage.com> wrote:
> > > > >
> > > > > io_ring_ctx's mutex uring_lock can be quite expensive in high-IOP=
S
> > > > > workloads. Even when only one thread pinned to a single CPU is ac=
cessing
> > > > > the io_ring_ctx, the atomic CASes required to lock and unlock the=
 mutex
> > > > > are very hot instructions. The mutex's primary purpose is to prev=
ent
> > > > > concurrent io_uring system calls on the same io_ring_ctx. However=
, there
> > > > > is already a flag IORING_SETUP_SINGLE_ISSUER that promises only o=
ne
> > > > > task will make io_uring_enter() and io_uring_register() system ca=
lls on
> > > > > the io_ring_ctx once it's enabled.
> > > > > So if the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, s=
kip the
> > > > > uring_lock mutex_lock() and mutex_unlock() on the submitter_task.=
 On
> > > > > other tasks acquiring the ctx uring lock, use a task work item to
> > > > > suspend the submitter_task for the critical section.
> > > >
> > > > Does this open the pathway to various data corruption issues since =
the
> > > > submitter task can be suspended while it's in the middle of executi=
ng
> > > > a section of logic that was previously protected by the mutex? With
> > >
> > > I don't think so. The submitter task is suspended by having it run a
> > > task work item that blocks it until the uring lock is released by the
> > > other task. Any section where the uring lock is held should either be
> > > on kernel threads, contained within an io_uring syscall, or contained
> > > within a task work item, none of which run other task work items. So
> > > whenever the submitter task runs the suspend task work, it shouldn't
> > > be in a uring-lock-protected section.
> > >
> > > > this patch (if I'm understandng it correctly), there's now no
> > > > guarantee that the logic inside the mutexed section for
> > > > IORING_SETUP_SINGLE_ISSUER submitter tasks is "atomically bundled",=
 so
> > > > if it gets suspended between two state changes that need to be atom=
ic
> > > > / bundled together, then I think the task that does the suspend wou=
ld
> > > > now see corrupt state.
> > >
> > > Yes, I suppose there's nothing that prevents code from holding the
> > > uring lock across syscalls or task work items, but that would already
> > > be problematic. If a task holds the uring lock on return from a
> > > syscall or task work and then runs another task work item that tries
> > > to acquire the uring lock, it would deadlock.
> > >
> > > >
> > > > I did a quick grep and I think one example of this race shows up in
> > > > io_uring/rsrc.c for buffer cloning where if the src_ctx has
> > > > IORING_SETUP_SINGLE_ISSUER set and the cloning happens at the same
> > > > time the submitter task is unregistering the buffers, then this cha=
in
> > > > of events happens:
> > > > * submitter task is executing the logic in io_sqe_buffers_unregiste=
r()
> > > > -> io_rsrc_data_free(), and frees data->nodes but data->nr is not y=
et
> > > > updated
> > > > * submitter task gets suspended through io_register_clone_buffers()=
 ->
> > > > lock_two_rings() -> mutex_lock_nested(&ctx2->uring_lock, ...)
> > >
> > > I think what this is missing is that the submitter task can't get
> > > suspended at arbitrary points. It gets suspended in task work, and
> > > task work only runs when returning from the kernel to userspace. At
> >
> > Ahh I see, thanks for the explanation. The documentation for
> > TWA_SIGNAL in task_work_add() says "@TWA_SIGNAL works like signals, in
> > that the it will interrupt the targeted task and run the task_work,
> > regardless of whether the task is currently running in the kernel or
> > userspace" so i had assumed this preempts the kernel.
> >
>
> Hmm, thinking about this buffer cloning + IORING_SINGLE_ISSUER
> submitter task's buffer unregistration stuff some more though...
> doesn't this same race with the corrupted values exist if the cloning
> logic acquires the mutex before the submitter task formally runs and

What do you mean by "before the submitter task formally runs"? The
submitter task is running all the time, it's the one that created (or
enabled) the io_uring and will make all the io_uring_enter() and
io_uring_register() syscalls for the io_uring.

> then the submitter task starts executing immediately right after with
> the buffer unregistration logic while the cloning logic is
> simultaneously executing the logic inside the mutex section? In the
> io_ring_ctx_lock_nested() logic, I'm not seeing where this checks
> whether the lock is currently acquired by other tasks or am I missing
> something here and this is already accounted for?

In the IORING_SETUP_SINGLE_ISSUER case, which task holds the uring
lock is determined by which io_ring_suspend_work() task work item (if
any) is running on the submitter_task. If io_ring_suspend_work() isn't
running, then only submitter_task can acquire the uring lock. And it
can do so without any additional checks because no other task can
acquire the uring lock. (We assume the task doesn't already hold the
uring lock, otherwise this would be a deadlock.) If an
io_ring_suspend_work() task work item is running, then the uring lock
has been acquired by whichever task enqueued the task work. And
io_ring_suspend_work() won't return until that task releases the uring
lock. So mutual exclusion is guaranteed by the fact that at most one
task work item is executing on submitter_task at a time.

Best,
Caleb

>
> Thanks,
> Joanne
>
> > Thanks,
> > Joanne
> >
> > > which point "nothing" should be running on the task in userspace or
> > > the kernel and it should be safe to run arbitrary task work items on
> > > the task. Though Ming recently found an interesting deadlock caused b=
y
> > > acquiring a mutex in task work that runs on an unlucky ublk server
> > > thread[1].
> > >
> > > [1] https://lore.kernel.org/linux-block/20251212143415.485359-1-ming.=
lei@redhat.com/
> > >
> > > Best,
> > > Caleb
> > >
> > > > * after suspending the src ctx, -> io_clone_buffers() runs, which w=
ill
> > > > get the incorrect "nbufs =3D src_ctx->buf_table.nr;" value
> > > > * io_clone_buffers() calls io_rsrc_node_lookup() which will
> > > > dereference a NULL pointer
> > > >
> > > > Thanks,
> > > > Joanne
> > > >
> > > > > If the io_ring_ctx is IORING_SETUP_R_DISABLED (possible during
> > > > > io_uring_setup(), io_uring_register(), or io_uring exit), submitt=
er_task
> > > > > may be set concurrently, so acquire the uring_lock before checkin=
g it.
> > > > > If submitter_task isn't set yet, the uring_lock suffices to provi=
de
> > > > > mutual exclusion.
> > > > >
> > > > > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > > > > Tested-by: syzbot@syzkaller.appspotmail.com
> > > > > ---
> > > > >  io_uring/io_uring.c |  12 +++++
> > > > >  io_uring/io_uring.h | 114 ++++++++++++++++++++++++++++++++++++++=
++++--
> > > > >  2 files changed, 123 insertions(+), 3 deletions(-)
> > > > >

