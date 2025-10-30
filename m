Return-Path: <io-uring+bounces-10303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2021BC22AB8
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9A83934ED15
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743CD33BBB9;
	Thu, 30 Oct 2025 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G54P4vzf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03EB33B969
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761866023; cv=none; b=BLQhIJBLU+4zsY9OeqgXtaxSQp5SFX7RYVvBPngmQXwE0vM9Kzo2GzLRDzdDUdyg2iJ+MRXX+wLKQnUGKyoZy69fxS0jLJm2IriOaiB0vpfFjpBZWZ11vfIhwzRM4YoSReTSVH9k3zALpp2iNicfywMx94pY/5w+2KSY6auc/Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761866023; c=relaxed/simple;
	bh=yEtzt+ACQ2k5tiNLfM9NtdifAsHbSXHjIdMgIqj0kI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LzqjX4jYmhXGkN9rDGo4HuXEf2qyXXnZVmeDhmUm354wQKQXBDn55ZNpaO+ArDFVnuIxwa8Gdtr7LG2SU1mtbIiyszkMIXYuOn5d7wvHWyIZnmh/hWNRmZKkYfXm0C5bJbTl+nzsGUR9cj4FIZDNf2BS/zrJuHduiCRBxVZFmgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G54P4vzf; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-89ec7919a62so169594985a.2
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 16:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761866020; x=1762470820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEtzt+ACQ2k5tiNLfM9NtdifAsHbSXHjIdMgIqj0kI4=;
        b=G54P4vzfl7HkNssigNTAy4fAnK29+0qCnI2D6cVg6a3rEIr1F4E/IHgMSn/YvZbBT+
         BhrkaxX6vg4KgzwUG83DU8Glc8Zhg8MJSVCpzulRGvC3Wtgost8B1o+iF1SASxfLILE+
         jzrEabu7MsF/zo+/4cBGBeE2DHMSAtD/C3np0f+k7nJpmVGd8RHrZ6ZpPYMM8CWM6nXS
         hJsXf0o/A33CgeCriD/r1zllQk/kFfmjLU14pa3edThJfQjfdk6STiA/9wvKbVRAi0Zq
         229zLa7qA/q/qGJt5O5BhTc6TJsCIovewgkZaaDneM+RmijheoJK89eXyuj1TD6IUClp
         Ta0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761866020; x=1762470820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEtzt+ACQ2k5tiNLfM9NtdifAsHbSXHjIdMgIqj0kI4=;
        b=rhnbvdEu9R5U43YXraeVBWXdaXGBx+UEsHAfpgReC1Gdo6xzNLAFd4xeOsb4zhWBqt
         ptdhrSwLLpHP1pxVswJp82X/OR4soXXAGLTuln/ejD7W1V8/Bbt3GSthAZd+ZQiDTKP0
         tAlbKcA2w6+BrLPpo+5h4io6hqp5eTm21E3+IGXJkqWKW4Lyzmxhql2UPpo+NY0c7vDD
         qjrEXsJ0phR8T53fBFYeoOjSWadxv5yry9KIfYkvp54I+TX0ZGRgzh0i5OI9zcljxHFS
         Bz4yN9ZGlFhsmRtVPVVecPjAoot2CXBqvkjY++m3l7Er1XkeXcjyFcUFFbWtxh6+YeDm
         ym+A==
X-Forwarded-Encrypted: i=1; AJvYcCVbNI2yv1mVkUvXWG+DVtAskPQNIqnnZGxblMqIaIUc4afgu7fgh3Z1pyYNRRkVe5qbL0mtz4SqHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZzR4yGKbEotUbTohYfVymd7Xs1hIA1MzQ/I9ntPOjOkhDE9W8
	6sTBQ101CMxUmQ9ItYVIzLHw1Qh7DbTK2b/aq8gZ9aU4Ad3qB92SZcMOTkm4Qnjik5kMrV/HIn7
	UjKrjgCD65FfXxRXy+WfgljL4jTZ04XY=
X-Gm-Gg: ASbGncsZc6fHY9h+ZN0QNogNw/bZcJ208GtRK+0soP6tPwMJBfZLFSLhKtWOx8nHeZJ
	aUa8b/6zMBre+aiIvrfrsevwQcs3P+VKjzmpkFuDmW16a2soOyRHK8eZ48z3PUq4wS12y9C9rPA
	wlR0jGxU2jL+fXP18o4TsNECY8i2yaZHeKYZZXfriHkgE3P/q0K1QzbPiue8v77nrd3d4tBnKkh
	P2U0PwsJD7Xe3G8MDQUFkmk52C/giEs78+CNl8ohKQ6E2hz1pspKR8ttgRopDd+gN87cLGaaOAP
	fHmxUSDUC7dUHdNMYrgspLXYXg==
X-Google-Smtp-Source: AGHT+IHCDMgKUMiTMGJsi4GifMtivCpfB8uu8c8prul7f0VaIBLqZ/8E4J4mWouM+Pk1Ujqz0kIO1egGZMKkolkvBZM=
X-Received: by 2002:a05:620a:471f:b0:858:f56:a6f4 with SMTP id
 af79cd13be357-8ab996879dfmr163824685a.31.1761866020507; Thu, 30 Oct 2025
 16:13:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com> <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com> <9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com>
In-Reply-To: <9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 30 Oct 2025 16:13:29 -0700
X-Gm-Features: AWmQ_bmn68jujD5w185WEpQFER72YPWNqpKNDNy9TS9pwDWhAeFvDroekIqXiO8
Message-ID: <CAJnrk1Yng2MrAGHkMiSQfu8hDeVgGknCiyfejD1fY83yG+x6eg@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add io_uring_cmd_import_fixed_full()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	csander@purestorage.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 11:06=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 10/29/25 18:37, Joanne Koong wrote:
> > On Wed, Oct 29, 2025 at 7:01=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> >>
> >> On 10/27/25 22:28, Joanne Koong wrote:
> >>> Add an API for fetching the registered buffer associated with a
> >>> io_uring cmd. This is useful for callers who need access to the buffe=
r
> >>> but do not have prior knowledge of the buffer's user address or lengt=
h.
> >>
> >> Joanne, is it needed because you don't want to pass {offset,size}
> >> via fuse uapi? It's often more convenient to allocate and register
> >> one large buffer and let requests to use subchunks. Shouldn't be
> >> different for performance, but e.g. if you try to overlay it onto
> >> huge pages it'll be severely overaccounted.
> >>
> >
> > Hi Pavel,
> >
> > Yes, I was thinking this would be a simpler interface than the
> > userspace caller having to pass in the uaddr and size on every
> > request. Right now the way it is structured is that userspace
> > allocates a buffer per request, then registers all those buffers. On
> > the kernel side when it fetches the buffer, it'll always fetch the
> > whole buffer (eg offset is 0 and size is the full size).
> >
> > Do you think it is better to allocate one large buffer and have the
> > requests use subchunks?
>
> I think so, but that's general advice, I don't know the fuse
> implementation details, and it's not a strong opinion. It'll be great
> if you take a look at what other server implementations might want and
> do, and if whether this approach is flexible enough, and how amendable
> it is if you change it later on. E.g. how many registered buffers it
> might need? io_uring caps it at some 1000s. How large buffers are?
> Each separate buffer has memory footprint. And because of the same
> footprint there might be cache misses as well if there are too many.
> Can you always predict the max number of buffers to avoid resizing
> the table? Do you ever want to use huge pages while being
> restricted by mlock limits? And so on.

Thanks for your thoughts, I'll think about this some more.
>
> In either case, I don't have a problem with this patch, just
> found it a bit off.
>
> > My worry with this is that it would lead to
> > suboptimal cache locality when servers offload handling requests to
> > separate thread workers. From a code perspective it seems a bit
>
> It wouldn't affect locality of the user buffers, that depends on
> the user space implementation. Are you sharing an io_uring instance
> between threads?

For request offloading, the different threads would share the io uring
instance. When the main thread that does the io_uring_wait_cqe()
receives a cqe, it'll dispatch the cqe to a worker thread to fulfill
while it then looks at the next cqe to send off to the next worker
thread and so on.

If there's one registered buffer that maps to the one big buffer
allocated by the server for the ring, then each worker thread might be
executing on different cpus when it accesses that buffer, which seems
like that could lead to cache line bouncing. Or at least that's the
scenario I was thinking of for suboptimal cache locality with the one
big buffer. But I do like how a big buffer would save on the memory
overhead that would be internally incurred in iouring for tracking
every registered buffer.

>
> > simpler to have each request have its own buffer, but it wouldn't be
> > much more complicated to have it all be part of one large buffer.
> >
> > Right now, we are fetching the bvec iter every time there's a request
> > because of the possibility that the buffer might have been
> > unregistered (libfuse will not do this, but some other rogue userspace
> > program could). If we added a flag to tell io uring that attempts at
> > unregistration should return -EBUSY, then we could just fetch the bvec
> > iter once and use that for the lifetime of the server connection
> > instead of having to fetch it every request, and then when the
> > connection is aborted, we could unset the flag so that userspace can
> > then successfully unregister their buffers. Do you think this is a
> > good idea to have in io-uring? If this is fine to add then I'll add
> > this to v3.
> The devil is in details, i.e. synchronisation. Taking a long term
> node reference might be fine. Does this change the uapi for this
> patchset? If not, I'd do it as a follow up. It also sounds like
> you can apply this optimisation regardless of whether you take
> a full registered buffer or go with sub ranges.

Thanks, this is helpful.
>
> --
> Pavel Begunkov
>

