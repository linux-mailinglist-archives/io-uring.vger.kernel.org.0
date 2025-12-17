Return-Path: <io-uring+bounces-11130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 389A8CC5CB5
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 03:42:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5566D30054A6
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 02:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43EE28003A;
	Wed, 17 Dec 2025 02:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dieqMWTW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04C72749CB
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 02:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765939324; cv=none; b=cKYUEMDCz/YbCt1iAmv/jyWZTPuXbXAB15iRhQbW8V4VSeEx/M5NR93l0HLKTSOJV0OxDw5guGR988dpB5YqD38obYFg0V0jb6sYhXfxWvQAU2fuX0jatpUd0T/Ln195qqjyIhI9+HntJHP4y7dP2T9bdkpeyIbnvX4mxS9FZ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765939324; c=relaxed/simple;
	bh=OxQColHWX4V5TFbL+PFCdxoTABwl9zclMt/do34CcTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fv878MAumuH9xT6PD+K8Z7iHvQDks/qeRWUvWjt8+imX2uSFjMf3RXgNiKwJ2s6PTT3vavx99JtDGi8LcnXO/eEr/AV6anw9lZE44Thz2tdCFvHCwD7CzasQ748ogsVv+1qdi+bLRN69kKBCj/4NfpvEA+2jiTO8qcEBxwx1S3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dieqMWTW; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b2ea5a44a9so570051685a.0
        for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 18:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765939319; x=1766544119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OxQColHWX4V5TFbL+PFCdxoTABwl9zclMt/do34CcTk=;
        b=dieqMWTWuAs0V52OvYrrECh0iZOAAozD2fkkCcwUcJwfMIbs3e/euqLJzQT8r4A3XB
         X3lEVcMDahiaEM+tuPIFziz21zS/8FwUimfkYTCu+KXQossoWSu2R0HiAPWHSldYOmcz
         xIqT414pMCzWJjUC9m6fj9xtwaBwNvrx+hzXik4KL348aGu45ZFhIse2GKhWSOsMvCxN
         je8qu57ztTpAxUoiCQhIlMN4ESwwTuBsqQzNSDe+6V/mRY4jIMil/tLoDI39qg17fD6k
         fhRdGR8+Sz2qyIboO597YBNS8k7jZBzewAvkoy81WCSugpO01RrbaImmNimtLhltwfpr
         /tfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765939319; x=1766544119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OxQColHWX4V5TFbL+PFCdxoTABwl9zclMt/do34CcTk=;
        b=ilrMTUl4OzyLcax56gN7rf5wf08QlaX+m1PIn8by5srArgGLTTbKQI91F0UHRHRbfP
         2rBDGJ0/58rw0LP/fMYOrBJIPq9JaEvYXGkCMF1loJ5/0pdLzoLWL1zysVCJ0nEdHNBf
         xZWDXHU/uGFXpGQVfDFfaqzXUjWfIz3AVvLrUjwRVW1a2O+V5k7oDPrC8pZ40Hw02ABS
         CQBvACKxjTp6glgwsT2bnKtBA03fO8cj3exhUDeBmLaiO9QYZBSZ8zs92dqYOkP8jQQn
         tnj1YZ9D7w0c2NmcFWi5ftZiEj7uvxAimvqqqbDQi01eF52xoLNFWK37alL46g3OVY7Z
         YQBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvIRBCXnItSNkmPF3z8F46+7xIntdv4R11eaKKUu/SDrv+a/aA9G0E6gO+JMcye1VnG9xhz+RVfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTvaNBq+mQg3CxrETWUu8R3PIe9pnqAZ/Ivvamg/6s4Yxi9PHd
	soWVQGPqg0gVHrYPSYX+HaOKcmi08Zh8+nZNTlEFwPTNyE4hxI0XMu8iqGDSJCRs78R44xHUIMR
	OLACCeN/h86R4fPMdBw15ZLDrRYb4P+o=
X-Gm-Gg: AY/fxX7A5mXdAlDkoOiAhuMjR3IxKr3RD1vUSdYMH6QNZfPl/N0ViyNnvZ3qeRUKIMc
	wTsR6DWwrqDeEu50Q/RK/0vD/BFWTkMGbT0+BSlGODZFfcRiIqDVRQ6NUhbI1x45SfyvJjFtPMV
	xyRBAmbIyYWqPCiEd12vhcEthFhkcBY0pJuo30rNaAy/srqICoJSeDk5dh/2xv+5dx9iD09ghx/
	uJbhYbu4clnZvt0ThtRBINp6jKvXa9IBv/x9W0cQV+E1DM5pCjv6wqYTbuxcHJ9aZmhiLXF+RE1
	uuZOF5Y5uf8=
X-Google-Smtp-Source: AGHT+IGgXEKvIvZl87EjWOSX+RCgpRrL07bBDB/sBjhGm1WPfeJ5ziBAiz+jZdONlrvxRzCarYlwfNik2eJ8MNA9Ymw=
X-Received: by 2002:a05:622a:1e96:b0:4ee:12e0:f071 with SMTP id
 d75a77b69052e-4f1d04a585cmr261930251cf.20.1765939318596; Tue, 16 Dec 2025
 18:41:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com>
 <20251215200909.3505001-7-csander@purestorage.com> <CAJnrk1Zhku-_ayXqCisYOCWnDf31YDyiWWEHJeMU=BDYoQR9mA@mail.gmail.com>
 <CADUfDZr_aTixiUQUN0yRj=AbuBLTrgk5SXXsjwao54ZmMajUOA@mail.gmail.com>
 <CAJnrk1bdkWVLDBrPKFVa7oPNqAw5BCbNo1N393ESp-zQOT0w5A@mail.gmail.com>
 <CAJnrk1Z0so5okNnEERiamB=6C8GBQ9c1nzwnfG5u_7GUoWTNmw@mail.gmail.com> <CADUfDZrK-SQczz7cjjS+SFHUbQ-dpjvtaaNJic1s3nYzokoMEQ@mail.gmail.com>
In-Reply-To: <CADUfDZrK-SQczz7cjjS+SFHUbQ-dpjvtaaNJic1s3nYzokoMEQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 17 Dec 2025 10:41:47 +0800
X-Gm-Features: AQt7F2oWEnvAuoqPyFpC6tTtrjupdbYoSFvL5lYJxdFGgSYpEfKeNfxdqCdjsio
Message-ID: <CAJnrk1ZmSYk09q2CLtBLeDA+hASka-S3K4x08B_+XXzxcOZ5-Q@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 12:03=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Tue, Dec 16, 2025 at 12:14=E2=80=AFAM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> >
> > On Tue, Dec 16, 2025 at 3:47=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > On Tue, Dec 16, 2025 at 2:24=E2=80=AFPM Caleb Sander Mateos
> > > <csander@purestorage.com> wrote:
> > > >
> > > > On Mon, Dec 15, 2025 at 8:46=E2=80=AFPM Joanne Koong <joannelkoong@=
gmail.com> wrote:
> >
> > Hmm, thinking about this buffer cloning + IORING_SINGLE_ISSUER
> > submitter task's buffer unregistration stuff some more though...
> > doesn't this same race with the corrupted values exist if the cloning
> > logic acquires the mutex before the submitter task formally runs and
>
> What do you mean by "before the submitter task formally runs"? The
> submitter task is running all the time, it's the one that created (or
> enabled) the io_uring and will make all the io_uring_enter() and
> io_uring_register() syscalls for the io_uring.

Ok, that's the part I was missing. I was mistakenly thinking of the
submitter task as something that gets scheduled in/out for io_uring
work specifically, rather than being the persistent task that owns and
operates the ring. That clears it up, thanks.

>
> > then the submitter task starts executing immediately right after with
> > the buffer unregistration logic while the cloning logic is
> > simultaneously executing the logic inside the mutex section? In the
> > io_ring_ctx_lock_nested() logic, I'm not seeing where this checks
> > whether the lock is currently acquired by other tasks or am I missing
> > something here and this is already accounted for?
>
> In the IORING_SETUP_SINGLE_ISSUER case, which task holds the uring
> lock is determined by which io_ring_suspend_work() task work item (if
> any) is running on the submitter_task. If io_ring_suspend_work() isn't
> running, then only submitter_task can acquire the uring lock. And it
> can do so without any additional checks because no other task can
> acquire the uring lock. (We assume the task doesn't already hold the
> uring lock, otherwise this would be a deadlock.) If an
> io_ring_suspend_work() task work item is running, then the uring lock
> has been acquired by whichever task enqueued the task work. And
> io_ring_suspend_work() won't return until that task releases the uring
> lock. So mutual exclusion is guaranteed by the fact that at most one
> task work item is executing on submitter_task at a time.
>
> Best,
> Caleb
>
> >
> > Thanks,
> > Joanne

