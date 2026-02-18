Return-Path: <io-uring+bounces-12318-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JD2Kk8zlmktcAIAu9opvQ
	(envelope-from <io-uring+bounces-12318-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 22:46:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 334BD15A60E
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 22:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBE2C3046068
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 21:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2D52EDD78;
	Wed, 18 Feb 2026 21:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBsvktCw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6BE2ECEA3
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 21:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771451032; cv=pass; b=RX7DE/Fpy27abbgYPXvctu+kdfFrzcsz88v2QDJi1RxnE5VS0xFmLFgIvGzVrk0rscGH3g4C6eAq7WlJaEUt/hNF4T85hr1SWhCiiMYE7VIr6Sbf7b+WRm00DvLd6+dBLt9gQ67XpPngq4eC33LI6E+o9k8jF1SUS1sUgdzZI38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771451032; c=relaxed/simple;
	bh=qX0LDVMsqZdnLPM2lEcNnwd+pl+lyNHsI03w52dL6tE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=btsjd0Ue5eLs+jeTXqCAcbP1+QqHA9gAqLYhTqUYsMf8qYYGUatQpuk5FqIQjGwhDHFeeDfiPekSdshL6ZmyKkWlS1rEiFgbIj2b1kAcaYf+RMHsInQsuLCwo4N0U+azj0O+GDpL+6UVxkzsEurin24xggrKBU/NoX9H9MbBSOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WBsvktCw; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506c02ec1b3so4019201cf.0
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 13:43:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771451030; cv=none;
        d=google.com; s=arc-20240605;
        b=Bt15U0vLbrUYAJ/brYRry+7BCPj6Oz3OsTXN0YtsuM+XPI+5sFgXmgqB/vrlX+Xl18
         Jpj+eSImgqNK2Vu7tJcve4ji5hrJj7lRZqH9xljOoumzB2pkOHpuZBTvP63ul5ceP+v7
         FnOqT3FFY3Lqk5ipI21D2OtPJETtDKGR4ub3Ui+kKvF5utmXvYzFGBzhcYabVQN6S2S9
         odXgIbWSBC5mtsGt+GesIAZOC/R8un9xB2T1T5jwAT27s+ztzcKWLXF7CI98dzS/Kl1E
         t7X46hvvjPM5HueGHSZWP3+ViBUzWGNAOnpXAJw8c14Xyg5JhaybS4+0cm4UJxaW79su
         Srqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YHberZFO3Y1iLXyo8ErvXMVuNK1B1SS6/EiJjxZd6uM=;
        fh=nHCvkF7WuWkIBaOk25vLTnccO0pVr8yAgbCGELmPB14=;
        b=FaX6N0hKhFk13U7dpqeACAgCKb4n4/JD+izSsD0RqVF4TYIVybghrXvabvgn2SLl1j
         Sibb3NOKBIqzzLX+nwVAep0JHd7qjQZ6bXi07tL/ZvK45FCWRiXkko/uxMJ3lBgFeN7I
         hcaTetqFwM1DkBy1aNFgn2G0dG084O78X9o6fQdDHwWi20bCfoXJ3cZ0NiDGR8bFhWTm
         c+pDQyHqC6hkjVKXLW77Gxuva2qtknGmzW6yOW2ETGVNZRPqCAIf3Wi1MBPrSRLuUSzY
         gi7TatsT6jX+eTyxhaHL0lSrDme3e7YaaqExdZdU21f13kvByv7KpWNEiDFOhEeyPCAq
         8Ykg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771451030; x=1772055830; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHberZFO3Y1iLXyo8ErvXMVuNK1B1SS6/EiJjxZd6uM=;
        b=WBsvktCw/cIrNeABWNEB3cPG3rzmw3j3dYxQ2ns9wpkwYkes2Qb9j+Gr+OE9KEEbjX
         IZZ6ldTzdeTb/gHh9yxel/tf13ROBlv315d36A7YNBEMZYTnFAhmbza6O3tb6rSUweCC
         L7JMj0IGYrSFUJwL6TeMV7hvpqAFF67hdNOpk+qibRm92B3Ux3YpOsxRbjiQZXyEJ0Aj
         PznOuMKWeZCvQLzBE5KloHr7MXp406ZBm5z+nZeVCOZVN7iDPyL2n3ksTHI35GYzJXgh
         c5Ux41QE1KIiQplWKAuu0r9mXVP2Yu9yFM9U1jeiNGfdiUFCcT/tu9tJdj7OTuoLE29K
         UwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771451030; x=1772055830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YHberZFO3Y1iLXyo8ErvXMVuNK1B1SS6/EiJjxZd6uM=;
        b=K2jyFBtT6oa7iBNibZnyhKQoOpm7CEtUZ0mF67xPRJ3K2cX0R4R8V+0zVm5U0T86+z
         07WP5qr7kFMmizgajg/WLZEokxpS0JgXI5/GwQSRCEi8UFyJ4jKexnVTLFd7P6kVf81Q
         alktXKnJ2E2DGE66WHaG0IBdVpylN69qYfGbggQdWo5YbhoDOORbc5FbxLJh8Q1wRJre
         uk8DGrZ89eBo1hCpyq71oKpcKHPHzuWdZFnmVR05aZJc8pgJ/SClhJdhL6dWHaKJCKh5
         IJKTTE1RgygueiJmi82eK1/ZLpJFEg3efbjdp0WrglrQXcBS60SuDgXQdyHyWCR4PyEm
         HZgA==
X-Forwarded-Encrypted: i=1; AJvYcCXzkWluFbqnX7XKuYsBF9g2xqrjwh6ZEV5DJHE+4iOy63sZ9ukfkgTKLsMoP2N/k4jU7yYQ+uZeSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyklf3we1wO3jJQCqt6CXrbE2sQAbagnpixNuzz6IkyUfAC+F82
	YisIWHcdmkjLitjx0p0/uEHc3pcdePOi0a+F3KpzcbYF6nVbYos9T2kAVgoe6SpfMCe7XW7eG3V
	sQ5hu6oAkz+9tj4FwibsJ4no37vDZD+4=
X-Gm-Gg: AZuq6aKEeQbRIB8szYqHzgXRGxnZ3P8bpAlcs/PnwJ+EPC+5vEn0rfPDH/yNM/Vu4HO
	Q129WBtoebJbN2XAzz4s+Ti4qM5i15+OMvBOfK3tpj+whNnRbJe1oH7hp09CPQxh67W+0jhQZUm
	qumJDIiGgCe6otQ6CUNsK5E4yZaGfBzglUHbhmNaIWvqMerpy1u2JCJDsTk/WD2ahPiaJ+IORgE
	b2/6iMOJAODQnRpIfL5XSnxEaX7Y5VnnMNwbYgP1IpRgzVjKoCb5RRL9n7Ogv+9X0qPiU/zOxPU
	bbD8PtG8Uf7C8074JWnpguZXO/aJXOxf
X-Received: by 2002:a05:622a:130a:b0:4ee:13dc:1040 with SMTP id
 d75a77b69052e-506e90ee106mr48365201cf.3.1771451029849; Wed, 18 Feb 2026
 13:43:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com> <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <aYykILfX_u9-feH-@infradead.org> <bd488a4e-a856-4fa5-b2bb-427280e6a053@gmail.com>
 <aY7QX-BIW-SMJ3h_@infradead.org> <34cf24a3-f7f3-46ed-96be-bf716b2db060@gmail.com>
 <CAJnrk1a+YuPpoLghA01uJhEKrhmrLhQ+5bw2OeeuLG3tG8p6Ew@mail.gmail.com> <7a62c5a9-1ac2-4cc2-a22f-e5b0c52dabea@gmail.com>
In-Reply-To: <7a62c5a9-1ac2-4cc2-a22f-e5b0c52dabea@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 18 Feb 2026 13:43:38 -0800
X-Gm-Features: AaiRm53ZIrIbhHkRmBir04HFJMRfboSpG_IEl5gxGTO1Fte-lO33dYAJ5JN2-Lc
Message-ID: <CAJnrk1Y5iTOhj4_RbnR7RJPkr7fFcCdh1gY=3Hm72M91D-SnyQ@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	csander@purestorage.com, krisman@suse.de, bernd@bsbernd.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12318-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 334BD15A60E
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 4:36=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 2/13/26 22:04, Joanne Koong wrote:
> > On Fri, Feb 13, 2026 at 4:41=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> ...
> >> Fuse is doing both adding (kernel) buffers to the ring and consuming
> >> them. At which point it's not clear:
> >>
> >> 1. Why it even needs io_uring provided buffer rings, it can be all
> >>      contained in fuse. Maybe it's trying to reuse pbuf ring code as
> >>      basically an internal memory allocator, but then why expose buffe=
r
> >>      rings as an io_uring uapi instead of keeping it internally.
> >>
> >>      That's also why I mentioned whether those buffers are supposed to
> >>      be used with other types of io_uring requests like recv, etc.
> >
> > On the userspace/server side, it uses the buffers for other io-uring
> > operations (eg reading or writing the contents from/to a
> > locally-backed file).
>

Sorry, I submitted v2 last night thinking the conversation on this
thread had died. After reading through your reply, I'll modify v2.

> Oops, typo. I was asking whether the buffer rings (not buffers) are
> supposed to be used with other requests. E.g. submitting a
> IORING_OP_RECV with IOSQE_BUFFER_SELECT set and the bgid specifying
> your kernel-managed buffer ring.

Yes the buffer rings are intended to be used with other io-uring
requests. The ideal scenario is that the user can then do the
equivalent of IORING_OP_READ/WRITE_FIXED operations on the
kernel-managed buffers and avoid the per-i/o page pinning overhead
costs.

>
> >> 2. Why making io_uring to allocate payload memory. The answer to which
> >>      is probably to reuse the region api with mmap and so on. And why
> >>      payload buffers are inseparably created together with the ring
> >
> > My main motivation for this is simplicity. I see (and thanks for
> > explaining) that using a registered mem region allows the use of some
> > optimizations (the only one I know of right now is the PMD one you
> > mentioned but maybe there's more I'm missing) that could be useful for
> > some workloads, but I don't think (and this could just be my lack of
> > understanding of what more optimizations there are) most use cases of
> > kmbufs benefit from those optimizations, so to me it feels like we're
> > adding non-trivial complexity for no noticeable benefit.
>
> There are two separate arguments. The first is about not making buffers
> inseparable from buffer rings in the io_uring user API. Whether it's
> IORING_REGISTER_MEM_REGION or something else is not that important.
> I have no objection if it's a part of fuse instead though, e.g. if
> fuse binds two objects together when you register it with fuse, or even
> if fuse create a buffer ring internally (assuming it doesn't indirectly
> leak into io_uring uapi).
>
> And the second was about optionally allowing user memory for buffer
> creation as you're reusing the region abstraction. You can find pros
> and cons for both modes, and funnily enough, SQ/CQ were first kernel
> allocated and then people asked for backing it by user memory, and IIRC
> it was in the reverse order for pbuf rings.
>
> Implementing this is trivial as well, you just need to pass an argument
> while creating a region. All new region users use struct
> io_uring_region_desc for uapi and forward it to io_create_region()
> without caring if it's user or kernel allocated memory.
>
> > I feel like we get the best of both worlds by letting users have both:
> > the simple kernel-managed pbuf where the kernel allocates the buffers
> > and the buffers are tied to the lifecycle of the ring, and the more
> > advanced kernel-managed pbuf where buffers are tied to a registered
> > memory region that the subsystem is responsible for later populating
> > the ring with.
> >
> >>      and via a new io_uring uapi.
> >
> > imo it felt cleaner to have a new uapi for it because kmbufs and pbufs
>
> The stress is on why it's an _io_uring_ API. It doesn't matter to me
> whether it's a separate opcode or not. Currently, buffer rings don't give
> you anything that can't be pure fuse, and it might be simpler to have
> it implemented in fuse than binding to some io_uring object. Or it could
> create buffer rings internally to reuse code but it doesn't become an
> io_uring uapi but rather implementation detail. And that predicates on
> whether km rings are intended to be used with other / non-fuse requests.
>
> > have different expectations and behaviors (eg pbufs only work with
> > user-provided buffers and requires userspace to populate the ring
> > before using it, whereas for kmbufs the kernel allocates the buffers
> > and populates it for you; pbufs require userspace to recycle back the
> > buffer, whereas for kmbufs the kernel is the one in control of
> > recycling) and from the user pov it seemed confusing to have kmbufs as
> > part of the pbuf ring uapi, instead of separating it out as a
> > different type of ringbuffer with a different expectation and
>
> I believe the source of disagreement is that you're thinking
> about how it's going to look like for fuse specifically, and I
> believe you that it'll be nicer for the fuse use case. However,
> on the other hand it's an io_uring uapi, and if it is an io_uring
> uapi, we need reusable blocks that are not specific to particular
> users.

I agree 100%. The api we add should be what's best for io-uring, not fuse.

For the majority of use cases, it seemed to me that having the buffers
separated from the buffer rings didn't yield perceptible benefits but
added complexity and more restrictions like having to statically know
up front how big the mem region needs to be across the lifetime of the
io-uring for anything the io-uring might use the mem region for. It
seems more generically useful as a concept to have the buffers owned
by the ring and tied to the lifetime of the ring. I like how with this
design everything is self-contained and multiple subsystems can use it
without having to reimplement functionality locally in the subsystem.
On the other hand, I see your point about how it might be something
users want in the future if they want complete control over which
parts of the mem region get used as the backing buffers to do stuff
like PMD optimizations.

I think this is a matter of opinion/preference and I think in general
for anything io-uring related, yours should take precedence.

With it going through a mem region, I don't think it should even go
through the "pbuf ring" interface then if it's not going to specify
the number of entries and buffer sizes upfront, if support is added
for io-uring normal requests (eg IORING_OP_READ/WRITE) to use the
backing pages from a memory region and if we're able to guarantee that
the registered memory region will never be able to be unregistered by
the user. I think if we repurpose the

union {
  __u64 addr; /* pointer to buffer or iovecs */
  __u64 splice_off_in;
};

fields in the struct io_uring_sqe to

union {
  __u64 addr; /* pointer to buffer or iovecs */
  __u64 splice_off_in;
  __u64 offset; /* offset into registered mem region */
};

and add some IOSQE_ flag to indicate it should find the pages from the
registered mem region, then that should work for normal requests.
Where on the kernel side, it looks up the associated pages stored in
the io_mapped_region's pages array for the offset passed in.

Right now there's only a uapi to register a memory region and none to
unregister one. Is it guaranteed that io-uring will never add
something in the future that will let userspace unregister the memory
region or at least unregister it while it's being used (eg if we add
future refcounting to it to track active uses of it)?

If so, then end-to-end, with it going through the mem region, it would
be something like:
* user creates a mem region for the io-uring
* user mmaps the mem region
* user passes in offset into region, length of each buffer, and number
of entries in the ring to the subsystem
* subsystem creates a locally managed bufring and adds buffers to that
ring from the mem region
* on the cqe side, it sends the buffer id of the registered mem region
through the same "IORING_CQE_F_BUFFER |  (buf_id <<
IORING_CQE_BUFFER_SHIFT)" mechanism

Does this design match what you had in mind / prefer?

I think the above works for Christoph's use case too (as his and my
use case are the same) but if not, please let me know.

Thanks,
Joanne

