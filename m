Return-Path: <io-uring+bounces-5097-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 249109DAF00
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71295B21A10
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 129832036F3;
	Wed, 27 Nov 2024 21:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jjxMZRdn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDD7202F7F
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 21:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732743588; cv=none; b=OhmXeVCu3kBWs5KSgE1JTB4hA+HaRzwlQQRyZPaRvRxil9Fb/E17oLSS5NXZTfWdrdt1zetzl2RNjeOi2stT4E2USEwacsDW7hTxYZh/Y+stjWd8CdKkMbd/p/5RRmZdJPyf/f8J7/voGeyeMhsprb5pd1Pc32MGeRhwlFZeqrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732743588; c=relaxed/simple;
	bh=2lG0JnjK5+PPi9DPvY1jlKZj9+vy7zTJ1p4sdJmPUJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6BGOCIpnbtI8eomsFRE2/un5sfWBVumppcMHb+GezcVuumMHhPoHjFVVCSeuHHRWbxK1xIdzw1vNEXfAjjAMaOfHfb9xSbSI2oKSBpeyWqelwRMihSavb+bjybWgLqlClX7sxaTKjW8xnvG+mV4F5BuRIEOD5IXC6cELJBbS/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jjxMZRdn; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5cfc264b8b6so1873a12.0
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 13:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732743584; x=1733348384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lG0JnjK5+PPi9DPvY1jlKZj9+vy7zTJ1p4sdJmPUJ8=;
        b=jjxMZRdnmk13ytlvvQUwe3HF9nt9vG7d+RbC15GsZeCaafxhkCQlawm7qxaxjuojnQ
         YBfJqrBAQGxQjOsjXZqxRSgylRk/oEeFhR1ECaSvM3PUecrFsgZTCz9XY2iVXpxYFlus
         XXrdb3F7ML5og6IqSyD8q0pWgG38EXcODp2t39C00ryQIHfhqF9rIK4Z5EcTcyekg8R0
         Gg7q7E5hNduMrIsP1iyp8fpgmjdLu/TfS5Z5+22jr8danz2Ov70SnbOQPRIcUuJUpujx
         OqNCDXCirIYJgn5DQ7YlnBZN/o8axG1XrC8cgdKWS4BL6hRLFS6NX0LVPX5LuJmSUnGj
         KShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732743584; x=1733348384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lG0JnjK5+PPi9DPvY1jlKZj9+vy7zTJ1p4sdJmPUJ8=;
        b=A8AjADaZUXAsDEbrVkAKSglUaIhn8QMw04hop69S2yNIUbKgl0RoPwN8o/wZympV1r
         Beho1K3d85blvPCEGbsfhEtLjhhw9kaScSbaT2CdOp7aspMurVLTCAF7r5JHvEBY/17w
         nFdAI3OMGIWLGxOdyVQ9j008mmMgk3BJj1WI+EQxjCE+NFln39QHhjGc7h0dtyP41Mm9
         hSP1obctiJl6ZIiM1rQF65uGmChVaZgu1l6w1IMnte8RFotiCelv3S0uxVpMmLZpou/W
         DRDkW9haUkk9leoXgPycB7pFaPaNWRHjwxr9uvj+hQJirYXMBdrhMpG+x2fYuX1qolWj
         J43w==
X-Forwarded-Encrypted: i=1; AJvYcCUMzF4jKLwm9xTSUdigwLCl5Lnktc+51tL5M+qX/Jkrk/SyOm2KrO6e9hmAX9JidPua9uLLO7ki1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMu9+XwIu0Mumy/FtEhL/mb0GmKgXzl7YBs3usx+yIfJSQxxlg
	dKukHt6la5ONZawK+7F9oFZXGxX+Cs/vnn3OIdXb0Lw5JVIea7eKxdmqEfbYvs1Qh5g4KRjHJx7
	rAbCJuV2+Zi7KZMHN2RFhinKBwgvD7CKVNRiA
X-Gm-Gg: ASbGncsmNtflfx+HjSMFb3Au4JjfXFNb6aDgMk++KEPU356P8YWVQyB/mCTkpN47SBH
	TshVsXv/TqbH8jICeyJMtoSNd97WXezEnyTcSLlOZOCacosukfcrzMNn4jlM=
X-Google-Smtp-Source: AGHT+IG0EXVlkYFMjrMUxp7nRsF4zOeNQ1TrA2jjSUmOP/T4F1OOwL2r+2Gy27ci/nQS+qD45VN9y3fh9iGu/qpcYGE=
X-Received: by 2002:a05:6402:3ca:b0:5d0:3ddd:c773 with SMTP id
 4fb4d7f45d1cf-5d09625b0d4mr10532a12.4.1732743583904; Wed, 27 Nov 2024
 13:39:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk> <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
 <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2> <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
In-Reply-To: <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Nov 2024 22:39:07 +0100
Message-ID: <CAG48ez3BS3rRCBnEHvdLbR29u9ZEB7VeCByfMBDa57JiLUM8zQ@mail.gmail.com>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 10:16=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
> On 11/27/24 2:08 PM, Kent Overstreet wrote:
> > On Wed, Nov 27, 2024 at 09:44:21PM +0100, Jann Horn wrote:
> >> On Wed, Nov 27, 2024 at 9:25?PM Kent Overstreet
> >> <kent.overstreet@linux.dev> wrote:
> >>> On Wed, Nov 27, 2024 at 11:09:14AM -0700, Jens Axboe wrote:
> >>>> On 11/27/24 9:57 AM, Jann Horn wrote:
> >>>>> Hi!
> >>>>>
> >>>>> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointe=
r
> >>>>> to an mm_struct. This pointer is grabbed in bch2_direct_write()
> >>>>> (without any kind of refcount increment), and used in
> >>>>> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> >>>>> which are used to enable userspace memory access from kthread conte=
xt.
> >>>>> I believe kthread_use_mm()/kthread_unuse_mm() require that the call=
er
> >>>>> guarantees that the MM hasn't gone through exit_mmap() yet (normall=
y
> >>>>> by holding an mmget() reference).
> >>>>>
> >>>>> If we reach this codepath via io_uring, do we have a guarantee that
> >>>>> the mm_struct that called bch2_direct_write() is still alive and
> >>>>> hasn't yet gone through exit_mmap() when it is accessed from
> >>>>> bch2_dio_write_continue()?
> >>>>>
> >>>>> I don't know the async direct I/O codepath particularly well, so I
> >>>>> cc'ed the uring maintainers, who probably know this better than me.
> >>>>
> >>>> I _think_ this is fine as-is, even if it does look dubious and bcach=
efs
> >>>> arguably should grab an mm ref for this just for safety to avoid fut=
ure
> >>>> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, whic=
h
> >>>> means that on the io_uring side it cannot do non-blocking issue of
> >>>> requests. This is slower as it always punts to an io-wq thread, whic=
h
> >>>> shares the same mm. Hence if the request is alive, there's always a
> >>>> thread with the same mm alive as well.
> >>>>
> >>>> Now if FMODE_NOWAIT was set, then the original task could exit. I'd =
need
> >>>> to dig a bit deeper to verify that would always be safe and there's =
not
> >>>> a of time today with a few days off in the US looming, so I'll defer
> >>>> that to next week. It certainly would be fine with an mm ref grabbed=
.
> >>>
> >>> Wouldn't delivery of completions be tied to an address space (not a
> >>> process) like it is for aio?
> >>
> >> An io_uring instance is primarily exposed to userspace as a file
> >> descriptor, so AFAIK it is possible for the io_uring instance to live
> >> beyond when the last mmput() happens. io_uring initially only holds an
> >> mmgrab() reference on the MM (a comment above that explains: "This is
> >> just grabbed for accounting purposes"), which I think is not enough to
> >> make it stable enough for kthread_use_mm(); I think in io_uring, only
> >> the worker threads actually keep the MM fully alive (and AFAIK the
> >> uring worker threads can exit before the uring instance itself is torn
> >> down).
> >>
> >> To receive io_uring completions, there are multiple ways, but they
> >> don't use a pointer from the io_uring instance to the MM to access
> >> userspace memory. Instead, you can have a VMA that points to the
> >> io_uring instance, created by calling mmap() on the io_uring fd; or
> >> alternatively, with IORING_SETUP_NO_MMAP, you can have io_uring grab
> >> references to userspace-provided pages.
> >>
> >> On top of that, I think it might currently be possible to use the
> >> io_uring file descriptor from another task to submit work. (That would
> >> probably be fairly nonsensical, but I think the kernel does not
> >> currently prevent it.)
> >
> > Ok, that's a wrinkle.
>
> I'd argue the fact that you are using an mm from a different process
> without grabbing a reference is the wrinkle. I just don't think it's a
> problem right now, but it could be... aio is tied to the mm because of
> how it does completions, potentially, and hence needs this exit_aio()
> hack because of that. aio also doesn't care, because it doesn't care
> about blocking - it'll happily block during issue.
>
> > Jens, is it really FMODE_NOWAIT that controls whether we can hit this? =
A
> > very cursory glance leads me to suspect "no", it seems like this is a
> > bug if io_uring is allowed on bcachefs at all.
>
> I just looked at bcachefs dio writes, which look to be the only case of
> this. And yes, for writes, if FMODE_NOWAIT isn't set, then io-wq is
> always involved for the IO.

I guess it could be an issue if the iocb can outlive the io-wq thread?
Like, a userspace task creates a uring instance and starts a write;
the write will be punted to a uring worker because of missing
FMODE_NOWAIT; then the uring worker enters io_write() and starts a
write on a kiocb. Can this write initiated from the worker be async?
And could the uring worker exit (for example, because the userspace
task exited) while the kiocb is still in flight?

Anyway, I see Kent just posted a patch to make this more robust.

