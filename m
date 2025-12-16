Return-Path: <io-uring+bounces-11123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05170CC1272
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 07:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AEE163032FE8
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 06:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A1A33DEC4;
	Tue, 16 Dec 2025 06:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="dirWNfxo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2578433E36B
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 06:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765866265; cv=none; b=Fn3S8uXqG5hVsrUEF9+DwJYiywHC7nuDzPyd06pxmEoQNGhVW79LN6d+AfKyLqbgAWGtnTonoWcofwFhAbJDjf5FrID0qpOnzbxraP5o+O+Rj800m22bM5AGBGK9od/mOeWs7lBT0FevgQzJZaf9N7BR4frbMGnnjH57joFrr24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765866265; c=relaxed/simple;
	bh=5MADeMQ67KGE8aZL89gezf8Ki3kwC0mS4BcLJydqzUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UYy6CWfpRPwNAhLa4Yk/cpR8LZ6cziWvhEWPr0NUbfqJ9L/Kzxu0JB/l6lwO1y+pA+gQ8p4D+7ToRmHtkhBqSLgFFHyfcmobK7+M9V3BTXbNEgu7nUu3qCqwM15QEUCnC0dJHT0/GK+pwF9AOPVUGHGzGK4uMwgB5ye4j0akJYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=dirWNfxo; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29f2d829667so7905005ad.0
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 22:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765866256; x=1766471056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgX1yvHPcxHEjBLInWMCv3FNL3iU1ZNsaFWkPhAK4BY=;
        b=dirWNfxo77vr8prIqhxGZzgP00vuc6YSNRYC/OwdArsu2qThllpe5miTWlIRCyuvHq
         GFASsusVCMqobtxc782jS41e0tC/Az/MS9NsZ5dFMprXk+BLGEn5GBgUvv1rXwQ4sVt+
         o0xad8VB8C2GPIv0PCN8aOD6g9ZFK6K1lzTbstmcX+hInptbJv+fmGcYRGe5ZqVSg+rd
         XuCsVWDi/pS6zOUiKY/GIw2AuLhBPXMN/+PfqRNwSnGYV2SeXEg+H1kYHdTYhtfJOJXX
         Wslf35uA4KljUK56yxWQ/115BS+R+SUasSTmrsx+aGqTtaSsAXFdvuJCxvE+TE9phiXA
         tIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765866256; x=1766471056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IgX1yvHPcxHEjBLInWMCv3FNL3iU1ZNsaFWkPhAK4BY=;
        b=C2y6RnDOkMHocRC2X+rsCA75WXo+sDixSw1tIqUuRg5sG3SR8+7BFfDIF6MAVQM3Yv
         MQzPUMt+4oFcFbo5JkVatsexcyXk3NLAtd+7g9daVGzAXXf5qddmA9n5UbIbkQymrG0V
         TpIsHNiScuvjQWVA+uz7N5hjMMmOC+yKgfjL3IVFKY9j4P0a5LLabTofgDjOKoZUmiHN
         CrYdLRrDU9V4eKEZW8J6/zbwBo/IBTp8XjYouGjYaMEnTDS0mM3sBJa/M99ciMgRkVnm
         7Dw1Wn1n+7mkkPinxQ0QyqEUN8BHf7Ouv6xh2MmFT+TvHkZ2DeMQ0XA1mtBSW+sd1Rfc
         fSLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtg44hHGwGmZU26NAVXKUJGxdybw2OulD2FJZaA+vlGg13OTggKG6A6YU53Wd4kB0o0Xhq+CdfRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYvx288yqo/h6PZEu/uArHGdJbwxXE1DVXnYqG2mBJy5mG6acu
	gpPPUJVOFJwtT//n89XHRtlSo+h2l+Tl/1EmHCNWYh+9QIFPoUasthxrUKxWXDX8OCOt9cQ2m2V
	TEciI6n0kTYxY8SBZN0rD9wLeJL8mnR8xWwK45mWqvQ==
X-Gm-Gg: AY/fxX5MJQUW9qpI1Y/Eg9bbNurgBQNpOYV2XM6+g745FY9bJu+a/MYfQ1nj/vXFPcK
	dCziQjI1K/xX94ncfiKfFja49tlwMElT57TQCmaZnrsaDnEfzkEpViMBJKc8gzZB5PrNofIrRQz
	GHKgKRIiXUWp0+MgKafjYCI2/NCExn5sL564ZOcwkqXgHfdGBhkJYanVpphCWU2xMqGhtfyXq+o
	1Ip+uckRnRHMvRxwEvNr4bazS+fHnTj2N0o2LiT94cPE7qb2jY+3+tk1ndKOB74QFtQj4If3EAX
	YXgJ/6U=
X-Google-Smtp-Source: AGHT+IFTgkcVdlz9fFN3SLQ6y1FDO1m+c+tdKFeYda7K7FBpsim2pS/QEtA+9nxVX8z6/laCs+90B3uuG24ufzy4aGE=
X-Received: by 2002:a05:7022:e1c:b0:11a:2020:ac85 with SMTP id
 a92af1059eb24-11f34c47b8cmr6184916c88.4.1765866256323; Mon, 15 Dec 2025
 22:24:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com>
 <20251215200909.3505001-7-csander@purestorage.com> <CAJnrk1Zhku-_ayXqCisYOCWnDf31YDyiWWEHJeMU=BDYoQR9mA@mail.gmail.com>
In-Reply-To: <CAJnrk1Zhku-_ayXqCisYOCWnDf31YDyiWWEHJeMU=BDYoQR9mA@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Dec 2025 22:24:04 -0800
X-Gm-Features: AQt7F2qd2ZXUh4VdvFDH6l2zVQ-sSd_mMa83WAsY8nbe4m-l62D2i1BgXLnU7mI
Message-ID: <CADUfDZr_aTixiUQUN0yRj=AbuBLTrgk5SXXsjwao54ZmMajUOA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 8:46=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Tue, Dec 16, 2025 at 4:10=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > io_ring_ctx's mutex uring_lock can be quite expensive in high-IOPS
> > workloads. Even when only one thread pinned to a single CPU is accessin=
g
> > the io_ring_ctx, the atomic CASes required to lock and unlock the mutex
> > are very hot instructions. The mutex's primary purpose is to prevent
> > concurrent io_uring system calls on the same io_ring_ctx. However, ther=
e
> > is already a flag IORING_SETUP_SINGLE_ISSUER that promises only one
> > task will make io_uring_enter() and io_uring_register() system calls on
> > the io_ring_ctx once it's enabled.
> > So if the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, skip th=
e
> > uring_lock mutex_lock() and mutex_unlock() on the submitter_task. On
> > other tasks acquiring the ctx uring lock, use a task work item to
> > suspend the submitter_task for the critical section.
>
> Does this open the pathway to various data corruption issues since the
> submitter task can be suspended while it's in the middle of executing
> a section of logic that was previously protected by the mutex? With

I don't think so. The submitter task is suspended by having it run a
task work item that blocks it until the uring lock is released by the
other task. Any section where the uring lock is held should either be
on kernel threads, contained within an io_uring syscall, or contained
within a task work item, none of which run other task work items. So
whenever the submitter task runs the suspend task work, it shouldn't
be in a uring-lock-protected section.

> this patch (if I'm understandng it correctly), there's now no
> guarantee that the logic inside the mutexed section for
> IORING_SETUP_SINGLE_ISSUER submitter tasks is "atomically bundled", so
> if it gets suspended between two state changes that need to be atomic
> / bundled together, then I think the task that does the suspend would
> now see corrupt state.

Yes, I suppose there's nothing that prevents code from holding the
uring lock across syscalls or task work items, but that would already
be problematic. If a task holds the uring lock on return from a
syscall or task work and then runs another task work item that tries
to acquire the uring lock, it would deadlock.

>
> I did a quick grep and I think one example of this race shows up in
> io_uring/rsrc.c for buffer cloning where if the src_ctx has
> IORING_SETUP_SINGLE_ISSUER set and the cloning happens at the same
> time the submitter task is unregistering the buffers, then this chain
> of events happens:
> * submitter task is executing the logic in io_sqe_buffers_unregister()
> -> io_rsrc_data_free(), and frees data->nodes but data->nr is not yet
> updated
> * submitter task gets suspended through io_register_clone_buffers() ->
> lock_two_rings() -> mutex_lock_nested(&ctx2->uring_lock, ...)

I think what this is missing is that the submitter task can't get
suspended at arbitrary points. It gets suspended in task work, and
task work only runs when returning from the kernel to userspace. At
which point "nothing" should be running on the task in userspace or
the kernel and it should be safe to run arbitrary task work items on
the task. Though Ming recently found an interesting deadlock caused by
acquiring a mutex in task work that runs on an unlucky ublk server
thread[1].

[1] https://lore.kernel.org/linux-block/20251212143415.485359-1-ming.lei@re=
dhat.com/

Best,
Caleb

> * after suspending the src ctx, -> io_clone_buffers() runs, which will
> get the incorrect "nbufs =3D src_ctx->buf_table.nr;" value
> * io_clone_buffers() calls io_rsrc_node_lookup() which will
> dereference a NULL pointer
>
> Thanks,
> Joanne
>
> > If the io_ring_ctx is IORING_SETUP_R_DISABLED (possible during
> > io_uring_setup(), io_uring_register(), or io_uring exit), submitter_tas=
k
> > may be set concurrently, so acquire the uring_lock before checking it.
> > If submitter_task isn't set yet, the uring_lock suffices to provide
> > mutual exclusion.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > Tested-by: syzbot@syzkaller.appspotmail.com
> > ---
> >  io_uring/io_uring.c |  12 +++++
> >  io_uring/io_uring.h | 114 ++++++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 123 insertions(+), 3 deletions(-)
> >

