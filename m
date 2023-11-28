Return-Path: <io-uring+bounces-161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 716567FBF45
	for <lists+io-uring@lfdr.de>; Tue, 28 Nov 2023 17:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D032282A0C
	for <lists+io-uring@lfdr.de>; Tue, 28 Nov 2023 16:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317504F8B8;
	Tue, 28 Nov 2023 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ic1RryLi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B55CD53
	for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 08:37:13 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso11206a12.1
        for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 08:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701189432; x=1701794232; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dcliY1XQfKK+/dtT+85ru7HI6htSCnB/zKwxrnWgARo=;
        b=Ic1RryLi+zzyOBwb40F0pEBKuPJbVkDgdRcpv1LkA5tG1TFVKSDyyS0kEc51eexNGq
         hQCTlVXNiSsdrSrEILgcdyH9b6GxdB6PcD4ZzoSRx/lGh9Wrv0Xray5XjBuMUVXk92al
         ipdmaP2Wo/WZK+yhhSwmm2vqLw1QhEPdl2mN29xOzv+wT5IN4UzjutOOO4aQRn4D2KTZ
         +z5KGemi8x/DyfiyZ044dEVjBTU+38avbJmy3SUGskuWeN2HTRlwtsPrj/OY/YQEeqeh
         M8sCNW+OqlYJzQ7s51Viu/vnSYNgEaf/PtBn7712TG0tK5oxNdE0RIzj5DXKjUCraPQs
         Y89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701189432; x=1701794232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dcliY1XQfKK+/dtT+85ru7HI6htSCnB/zKwxrnWgARo=;
        b=SivZAKpxpSU6lIMB/LHrFgvJGmZ52/1kPhZDWZExBfHtnFR6RcqxWvg1PbKwfP+4kV
         KJDird8Zqka/8qe7rvLlrd9HLAtYiUWX671NSlA0EQLKD4UuDV7nweOFJvsEZQtEvHty
         fMEYLZ1T1m7797LKgZsZ+oFtOxg0IrfNNEhET7QjqJgXG29PxaqIuxMuKWAPpeWwxDBa
         PiKn1aTW7g/gKFUphFmHSkQZYYt2C/PjEADC91P9dgUWCyLMQi3QW/VsXke5D9yEGzTc
         CI1qdBORDXWVs5SWaKuB9CvZaF0poWMg/4r3GmfUlnOHRoufCEadQrfghapxjDkh+qXu
         nu9Q==
X-Gm-Message-State: AOJu0YxihNj6FHuYegQ+isA8kimemnpddJGCytmMGqokaU4shKgrncra
	6bMpWSVqHPoH4fB6hyjkCsk821C84cYOUxBEaVth/k3C1mv6Qbt4ZaOX3w==
X-Google-Smtp-Source: AGHT+IH50DkbrNmQe8Ary9utpKHr6FuZl6BUx5im1i0g0jg3xN/CCNpo4qAjdR/cIbCvtTWXVrt1AohJe2jknEdLqBw=
X-Received: by 2002:a05:6402:b83:b0:544:e249:be8f with SMTP id
 cf3-20020a0564020b8300b00544e249be8fmr709918edb.1.1701189431791; Tue, 28 Nov
 2023 08:37:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez1htVSO3TqmrF8QcX2WFuYTRM-VZ_N10i-VZgbtg=NNqw@mail.gmail.com>
 <fadbb6b5-a288-40e2-9bb8-7299ea14f0a7@kernel.dk> <af45ad55-c002-4bbd-9226-88439bbd4916@kernel.dk>
In-Reply-To: <af45ad55-c002-4bbd-9226-88439bbd4916@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Tue, 28 Nov 2023 17:36:34 +0100
Message-ID: <CAG48ez2PeV8WiMdHakqTrVHtbO=N8RKtqAq1v6bNbNOMdMJ9QA@mail.gmail.com>
Subject: Re: io_uring: risky use of task work, especially wrt fdget()
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2023 at 5:19=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 11/28/23 8:58 AM, Jens Axboe wrote:
> > On 11/27/23 2:53 PM, Jann Horn wrote:
> >> Hi!
> >>
> >> I noticed something that I think does not currently cause any
> >> significant security issues, but could be problematic in the future:
> >>
> >> io_uring sometimes processes task work in the middle of syscalls,
> >> including between fdget() and fdput(). My understanding of task work
> >> is that it is expected to run in a context similar to directly at
> >> syscall entry/exit: task context, no locks held, sleeping is okay, and
> >> it doesn't execute in the middle of some syscall that expects private
> >> state of the task_struct to stay the same.
> >>
> >> An example of another user of task work is the keyring subsystem,
> >> which does task_work_add() in keyctl_session_to_parent() to change the
> >> cred pointers of another task.
> >>
> >> Several places in io_uring process task work while holding an fdget()
> >> reference to some file descriptor. For example, the io_uring_enter
> >> syscall handler calls io_iopoll_check() while the io_ring_ctx is only
> >> referenced via fdget(). This means that if there were another kernel
> >> subsystem that uses task work to close file descriptors, io_uring
> >> would become unsafe. And io_uring does _almost_ that itself, I think:
> >> io_queue_worker_create() can be run on a workqueue, and uses task work
> >> to launch a worker thread from the context of a userspace thread; and
> >> this worker thread can then accept commands to close file descriptors.
> >> Except it doesn't accept commands to close io_uring file descriptors.
> >>
> >> A closer miss might be io_sync_cancel(), which holds a reference to
> >> some normal file with fdget()/fdput() while calling into
> >> io_run_task_work_sig(). However, from what I can tell, the only things
> >> that are actually done with this file pointer are pointer comparisons,
> >> so this also shouldn't have significant security impact.
> >>
> >> Would it make sense to use fget()/fput() instead of fdget()/fdput() in
> >> io_sync_cancel(), io_uring_enter and io_uring_register? These
> >> functions probably usually run in multithreaded environments anyway
> >> (thanks to the io_uring worker threads), so I would think fdget()
> >> shouldn't bring significant performance savings here?
> >
> > Let me run some testing on that. It's a mistake to think that it's
> > usually multithreaded, generally if you end up using io-wq then it's no=
t
> > a fast path. A fast networked setup, for example, would never touch the
> > threads and hence no threading would be implied by using io_uring. Ditt=
o
> > on the storage front, if you're just reading/writing or eg doing polled
> > IO. That said, those workloads are generally threaded _anyway_ - not
> > because of io_uring, but because that's how these kinds of workloads ar=
e
> > written to begin with.

Aah, because with polled I/O, when the fd is signalled as ready, the
actual execution of work is done via task_work? Thanks for the
explanation, I missed that.

> > So probably won't be much of a concern to do the swap. The only
> > "interesting" part of the above mix of cancel/register/enter is
> > obviously the enter part. The rest are not really fast path.
>
> Did all three and ran the usual testing, which just so happens to be
> multithreaded to begin with anyway. No discernable change from using
> fget/fput over fdget/fdput.

Oh, nice!

> IOW, we may as well do this. Do you want to send a patch? Or I can send
> out mine, up to you.

Ah, if you already cooked up a patch to do the testing, I guess it's
easier if you commit that?

