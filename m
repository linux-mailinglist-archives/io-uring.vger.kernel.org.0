Return-Path: <io-uring+bounces-5100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 816BD9DAF1D
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD025B2079A
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE57B202F7F;
	Wed, 27 Nov 2024 21:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KYS5sx9/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2254F9DD
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 21:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732744456; cv=none; b=gd+0z37Cmgb/kf8FNDKRg/slvvMLEOQF/ozKlbpZS6U3K35vKuTVKriyvFDYSQ8rDLuRYWe2qXHVxWgUdpS82W0Lp07+0/d3v1EmQnOdxN9GTYYqsN3PRP/ySIfnz2Tf1SzvAAA4vRfeBe2PFc8kWHts8D4QVaw9fUhJn2PVhsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732744456; c=relaxed/simple;
	bh=BzWo99LgAykWkkECe4S20T2utKSqQYpfQe9ca8hnIaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dT109lUKyp1oPjMuJm7DCPGFHrovmNF7Nq6eflRw44o8UpRV1eJFZLpiZNdgFlNNcK0FmjauTY/Q7BZ22PYvTtsanOjXemkTB045uSsmL+HzJVHm+Aw1ozXOoOFMkQ0X9RxjiYEoEjU8fo4rGkBtYSc9gwrUFQq8I5fKd9Vpt1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KYS5sx9/; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cfc18d5259so1699a12.1
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 13:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732744453; x=1733349253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzWo99LgAykWkkECe4S20T2utKSqQYpfQe9ca8hnIaA=;
        b=KYS5sx9/XZ/s/kUIT0MKZoH67Vq/SL5AWLNsTLSf2nPZ/JHNzuqH1mAHPt05CSUlWt
         /0L2I3IqfVCsm6xKQucvZ0C3Rz5LeB8ZtGdcp/+UySQuP1U6RZJ5z28FyeL4iEPwUqHb
         Q+QPk/0+V/Jg17Fwb0UmldSrhHPVWI6hIpzxiCAW2CZLkHSLcVRCaokON/rCHV9hKiv8
         +6N/GOc+LaI7W4n89vy/ICAmTfQwIsbSbxt07KuYa3jxWLsRUSQD/T9vtsWZ2WxQBvzy
         wKXZFAq6TTUK2WvjZYWPt1F2/MVfQdeIFTxqlYS8+PKgSZwaJaxoNQ934IJ7NFkoGz/v
         Stow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732744453; x=1733349253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BzWo99LgAykWkkECe4S20T2utKSqQYpfQe9ca8hnIaA=;
        b=U2ZMQX2ILZHQIAEUuArvBThfrVgBDjKhSD+lKZsRtrw76f/g95hD1ftt74blmtWe86
         75xHaqADLM7W3e3VcPHxeHypIdY+wKhGLpG6rR8I5auS1m5Gxyc8D0+E2ODuu1ciKHa7
         UbG4ze1zxRIVszaoL3tEGhAOAwnfBNuV/ENnE/uJsbDdDSn26fL+dbxtBg/C/vncB1YA
         ErzX+FnUy9MisoVPz3XXV4d9OZgh9fofxyr2egYCkMyA4CZyeDpu+JhbGBnQpTF8fjtU
         AyEFHhX7ZEPmI7qY3HGkKyjv/DvIUl1Eaf7HasyG4cUczymEWb0NoVT7juITXi4nPN36
         Edlg==
X-Forwarded-Encrypted: i=1; AJvYcCUsSbrJTugwh3nLJepxaCWSOkAPLTBrZTnppL7Q9L54WNyGXIKKyH/S1SSjD4KF6RJMl3MesxFQ0A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxUXfWkXQWShtWYKWrVAU8Wk7txl8Ke5EGuztQvw26OPM2lQw+
	YjdrrHWVI0LCsymLy+9v2WXOIycB0iPLtKdmuRcMPWmpCkIPcj2Kp4y5LYX4TDEeq5HlMbb4aJy
	ikqAY26my41NcGHgST82W6E2g8fLmara/AXdj
X-Gm-Gg: ASbGncvnEe7NQhSY5iZ8U0rm4JkhKUKr9qxlANEyBbfA0O4l2estft2Oxn/bqSkH3Or
	6UQgmXcjUNObe6k8N9uAeNYTY0NDJUyrt2mlrg2JnzBcxWWpkk5RJogmtG0w=
X-Google-Smtp-Source: AGHT+IENj72ZN7fFJn5+FNTqJuSc3X6Ilyvz5fzsyVoYjzl1sga8qD5O/eDU49aBM4SqrvumkC14rDnlRl5sAXlxeQk=
X-Received: by 2002:a05:6402:2209:b0:5d0:78d0:f845 with SMTP id
 4fb4d7f45d1cf-5d095b57cd4mr13953a12.2.1732744452851; Wed, 27 Nov 2024
 13:54:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk> <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
 <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
 <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk> <CAG48ez3BS3rRCBnEHvdLbR29u9ZEB7VeCByfMBDa57JiLUM8zQ@mail.gmail.com>
 <4715a920-ae4b-41d4-97ae-0fb92b4fa024@kernel.dk>
In-Reply-To: <4715a920-ae4b-41d4-97ae-0fb92b4fa024@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Nov 2024 22:53:36 +0100
Message-ID: <CAG48ez2p+zB+c+TpDgGBhdk9CAKHCiFKTn9HYmcwv4gGnzUFmg@mail.gmail.com>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 10:52=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
> > On Wed, Nov 27, 2024 at 10:16?PM Jens Axboe <axboe@kernel.dk> wrote:
> > > On 11/27/24 2:08 PM, Kent Overstreet wrote:
> > > > On Wed, Nov 27, 2024 at 09:44:21PM +0100, Jann Horn wrote:
> > > >> On Wed, Nov 27, 2024 at 9:25?PM Kent Overstreet
> > > >> <kent.overstreet@linux.dev> wrote:
> > > >>> On Wed, Nov 27, 2024 at 11:09:14AM -0700, Jens Axboe wrote:
> > > >>>> On 11/27/24 9:57 AM, Jann Horn wrote:
> > > >>>>> Hi!
> > > >>>>>
> > > >>>>> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a po=
inter
> > > >>>>> to an mm_struct. This pointer is grabbed in bch2_direct_write()
> > > >>>>> (without any kind of refcount increment), and used in
> > > >>>>> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm=
()
> > > >>>>> which are used to enable userspace memory access from kthread c=
ontext.
> > > >>>>> I believe kthread_use_mm()/kthread_unuse_mm() require that the =
caller
> > > >>>>> guarantees that the MM hasn't gone through exit_mmap() yet (nor=
mally
> > > >>>>> by holding an mmget() reference).
> > > >>>>>
> > > >>>>> If we reach this codepath via io_uring, do we have a guarantee =
that
> > > >>>>> the mm_struct that called bch2_direct_write() is still alive an=
d
> > > >>>>> hasn't yet gone through exit_mmap() when it is accessed from
> > > >>>>> bch2_dio_write_continue()?
> > > >>>>>
> > > >>>>> I don't know the async direct I/O codepath particularly well, s=
o I
> > > >>>>> cc'ed the uring maintainers, who probably know this better than=
 me.
> > > >>>>
> > > >>>> I _think_ this is fine as-is, even if it does look dubious and b=
cachefs
> > > >>>> arguably should grab an mm ref for this just for safety to avoid=
 future
> > > >>>> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, =
which
> > > >>>> means that on the io_uring side it cannot do non-blocking issue =
of
> > > >>>> requests. This is slower as it always punts to an io-wq thread, =
which
> > > >>>> shares the same mm. Hence if the request is alive, there's alway=
s a
> > > >>>> thread with the same mm alive as well.
> > > >>>>
> > > >>>> Now if FMODE_NOWAIT was set, then the original task could exit. =
I'd need
> > > >>>> to dig a bit deeper to verify that would always be safe and ther=
e's not
> > > >>>> a of time today with a few days off in the US looming, so I'll d=
efer
> > > >>>> that to next week. It certainly would be fine with an mm ref gra=
bbed.
> > > >>>
> > > >>> Wouldn't delivery of completions be tied to an address space (not=
 a
> > > >>> process) like it is for aio?
> > > >>
> > > >> An io_uring instance is primarily exposed to userspace as a file
> > > >> descriptor, so AFAIK it is possible for the io_uring instance to l=
ive
> > > >> beyond when the last mmput() happens. io_uring initially only hold=
s an
> > > >> mmgrab() reference on the MM (a comment above that explains: "This=
 is
> > > >> just grabbed for accounting purposes"), which I think is not enoug=
h to
> > > >> make it stable enough for kthread_use_mm(); I think in io_uring, o=
nly
> > > >> the worker threads actually keep the MM fully alive (and AFAIK the
> > > >> uring worker threads can exit before the uring instance itself is =
torn
> > > >> down).
> > > >>
> > > >> To receive io_uring completions, there are multiple ways, but they
> > > >> don't use a pointer from the io_uring instance to the MM to access
> > > >> userspace memory. Instead, you can have a VMA that points to the
> > > >> io_uring instance, created by calling mmap() on the io_uring fd; o=
r
> > > >> alternatively, with IORING_SETUP_NO_MMAP, you can have io_uring gr=
ab
> > > >> references to userspace-provided pages.
> > > >>
> > > >> On top of that, I think it might currently be possible to use the
> > > >> io_uring file descriptor from another task to submit work. (That w=
ould
> > > >> probably be fairly nonsensical, but I think the kernel does not
> > > >> currently prevent it.)
> > > >
> > > > Ok, that's a wrinkle.
> > >
> > > I'd argue the fact that you are using an mm from a different process
> > > without grabbing a reference is the wrinkle. I just don't think it's =
a
> > > problem right now, but it could be... aio is tied to the mm because o=
f
> > > how it does completions, potentially, and hence needs this exit_aio()
> > > hack because of that. aio also doesn't care, because it doesn't care
> > > about blocking - it'll happily block during issue.
> > >
> > > > Jens, is it really FMODE_NOWAIT that controls whether we can hit th=
is? A
> > > > very cursory glance leads me to suspect "no", it seems like this is=
 a
> > > > bug if io_uring is allowed on bcachefs at all.
> > >
> > > I just looked at bcachefs dio writes, which look to be the only case =
of
> > > this. And yes, for writes, if FMODE_NOWAIT isn't set, then io-wq is
> > > always involved for the IO.
> >
> > I guess it could be an issue if the iocb can outlive the io-wq thread?
> > Like, a userspace task creates a uring instance and starts a write;
> > the write will be punted to a uring worker because of missing
> > FMODE_NOWAIT; then the uring worker enters io_write() and starts a
> > write on a kiocb. Can this write initiated from the worker be async?
> > And could the uring worker exit (for example, because the userspace
> > task exited) while the kiocb is still in flight?
>
> No, any write (or read, whatever) from an io-wq worker is always
> blocking / sync. That's the main reason for them existing, to be able to
> do blocking issue. And that's what they always do.

Aaah, ok, thanks for the explanation.

