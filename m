Return-Path: <io-uring+bounces-11036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2C6CBA5F0
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 07:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF01E30557BC
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 06:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BA21E1C1A;
	Sat, 13 Dec 2025 06:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JCMqEvRg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD998219E8
	for <io-uring@vger.kernel.org>; Sat, 13 Dec 2025 06:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765606091; cv=none; b=ZtRgvTztSFvWYsc3paXuCKRkES8ajwguKOdAYNb4SnkIFmTaFOBNIzbMUe8EiM3UaaPSm+45ZtSyMUMbQYg4mKU6fQPAgqm+GwWQCqScPVpGptjpRMuu7IG3PwRW914NcA4B3sMsnRnByOjBrvmBGmUlymSa42dLLYgmCkoxE1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765606091; c=relaxed/simple;
	bh=zRKFnu0NmmDnPi9SemF4++R7e3d1FEbjOyULSQGxrpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qv0AppBk4Y6DGMT2PNN+X+YUP0Haham5qaMyjOi4k7LRyxPaWGXeDZCzV7Gcz1nkleHctDIWfQb3loFWGb5DnMrR0uetxln+sb00cfp+yyWTfjARjG9yyMYyuTWwkEf/Ubxz4Q1N1UWmwWOgK6YLOADGsv1A5SV60OyDk6qdsPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JCMqEvRg; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee13dc0c52so16482301cf.2
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 22:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765606089; x=1766210889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRKFnu0NmmDnPi9SemF4++R7e3d1FEbjOyULSQGxrpI=;
        b=JCMqEvRg1AwPvhb9SrllGYHC3+KsgL7Djf/zd+FjJNnzqFuqGQkbCldKMsFzJXy38d
         YlKKKXXLY52cjevJwo9DTCG9ZhBF4maA0T2AHOpvVvOKEee7tBLDkmC0GsdGG+R7p4ct
         BglQ+g/jWwKgnDpbNQSxpBuIkJDSRuEqUtWxEPN5FZlBuj8RFPIGROX3pQG0cwA9x74W
         qxTQ7+pIBxY7JLcbjx7K0q2td3mvXBiXC+gqs7oXf3hzaoiSCh4oUzn2j7Wb3wolfzj9
         AS0nRPSd3onqUIwCynuRCNJdV2oiqbnai56Ztdiq+IeB6lPotsg+TARrwoz6gZn1Yrv9
         iY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765606089; x=1766210889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zRKFnu0NmmDnPi9SemF4++R7e3d1FEbjOyULSQGxrpI=;
        b=Psda3fvvceuEV27vCWFGVW45UtX+Anee+cFn1X7GYBk3TD0Koe1CpT5hQ3NiwmF6mM
         VTS8BfKyJe4/wSd6rLbrszyvnchWaWFcLiS8kWFlbo1zf4CI54Fn1RVDLyyjdh0cp1mg
         uZz5ZX79h0ZgnUy5gYMfIKTIUtQkEUhjjcvDPVbzixO1URzdJUNmE+Bl9kqTqu6GVkN8
         DnFJqLT2qyxwAuWP/2bObk3UD8rNpFLQX8qD1sG8SR+HsB6qDTqH77iMXVj+SlivQJWQ
         uy+QiUVeGfSuxxsvtn/NgVcWQ8jmNUOgmKKONK5MyIyY+MABZRZn9BgBH92AGdNdHTwC
         FnuA==
X-Forwarded-Encrypted: i=1; AJvYcCXCC0ehb96oDN9949SKZ2whLvZvoZH60UPsvkzwQGyrWl8LN65WBaKsriTDJN2Yr9aRn5fSG06FRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxS22zKnoEkfpQS+ZmKM7n7lnNfEet/h5sA0ejf1+E4GhVnp16X
	tyIYQbPVcw/dMMguj8TpGeT7wB1SyEBCQZRNQ0p9LIZdlMtNWrXuWcLj3YJgyxaD9EmEEDIDmkE
	p9NQUPwOmJyq0PnEMcXNIOH2IEGGThHo=
X-Gm-Gg: AY/fxX5mB7sGch0Y3S5ZU4gtlxljaJWTxNxpPiSV3uIjUxysdM2xZLlm61n7aZhpddl
	SZuA5oT4831bEzsUGC7GHBRFziBOKweCMWZHb2Ip/6/A5V+drU3e5djaIKmz5Y9neNzQgNS2/7s
	ululOlJ5EjuGBBspLMfcPx5BRhOBmDQQakB/D9Vv0NznLUF8CZR2m5KkiTuydzKJQzqpHynuSax
	6D9pil2eABebzrOBdBBvtNsmF7eFbWMNWSQJsZyCzOSIeUTw4g4yI3vZY/QU9w2u2k7lSLj
X-Google-Smtp-Source: AGHT+IHJ0txwnPsAht3VxboI8v76IVHsJulav2N27Jvg+a8js1xcDal6jC13qaK4/DRtaZTWQ21olCu8SAG0QmBpovg=
X-Received: by 2002:a05:622a:40ce:b0:4ee:1b37:c9da with SMTP id
 d75a77b69052e-4f1d049ff57mr52002411cf.17.1765606088551; Fri, 12 Dec 2025
 22:08:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-8-joannelkoong@gmail.com> <CADUfDZosVLf4vGm4_kNFReaNH3wSi2RoLXwZBc6TN0Jw__s1OQ@mail.gmail.com>
 <CAJnrk1Z_UZxmppmXXQr3joGzMSdU4ycnnGt=SacQT+6DbALDmA@mail.gmail.com>
 <CADUfDZov3Nk81k8cvdz1ZoXrbTDJfJryHjNza3ZUJyXtfE5YgQ@mail.gmail.com>
 <CAJnrk1ZmJ8V3MOpcEYks5i3dG431C7PmB14J7N2k22rn41ROuw@mail.gmail.com> <CADUfDZqmj0X0e+DzFG-8W7cOkjj1emNzovitCL4E8SyLHmR4Ag@mail.gmail.com>
In-Reply-To: <CADUfDZqmj0X0e+DzFG-8W7cOkjj1emNzovitCL4E8SyLHmR4Ag@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Sat, 13 Dec 2025 15:07:57 +0900
X-Gm-Features: AQt7F2qzMwag5i8xnGgtiMEd9IUOAjhjS5w_iZhuc6q1hdfDaVTTCSZp3mPtv-c
Message-ID: <CAJnrk1ZorOeUkUkCsZ6xYj8CKFPEa5WbACTNgm7_kZ4LLvLoCA@mail.gmail.com>
Subject: Re: [PATCH v1 07/30] io_uring/rsrc: add fixed buffer table pinning/unpinning
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 12:35=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Thu, Dec 4, 2025 at 12:07=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Wed, Dec 3, 2025 at 5:24=E2=80=AFPM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > On Wed, Dec 3, 2025 at 2:52=E2=80=AFPM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > > >
> > > > On Tue, Dec 2, 2025 at 8:49=E2=80=AFPM Caleb Sander Mateos
> > > > <csander@purestorage.com> wrote:
> > > > >
> > > > > On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong=
@gmail.com> wrote:
> > > > > >
> > > > > > Add kernel APIs to pin and unpin the buffer table for fixed buf=
fers,
> > > > > > preventing userspace from unregistering or updating the fixed b=
uffers
> > > > > > table while it is pinned by the kernel.

After discussing this a bit with Jens at lpc, he's not a fan of the
pinning idea for fixed buffers, so for v2 I am going to abandon this
and instead just do the lookup every time.

This ends up making the discussion below irrelevant, but adding my
comments below anyways for completeness.

> > > > > >
> > > > > > This has two advantages:
> > > > > > a) Eliminating the overhead of having to fetch and construct an=
 iter for
> > > > > > a fixed buffer per every cmd. Instead, the caller can pin the b=
uffer
> > > > > > table, fetch/construct the iter once, and use that across cmds =
for
> > > > > > however long it needs to until it is ready to unpin the buffer =
table.
> > > > > >
> > > > > > b) Allowing a fixed buffer lookup at any index. The buffer tabl=
e must be
> > > > > > pinned in order to allow this, otherwise we would have to keep =
track of
> > > > > > all the nodes that have been looked up by the io_kiocb so that =
we can
> > > > > > properly adjust the refcounts for those nodes. Ensuring that th=
e buffer
> > > > > > table must first be pinned before being able to fetch a buffer =
at any
> > > > > > index makes things logistically a lot neater.
> > > > >
> > > > > Why is it necessary to pin the entire buffer table rather than
> > > > > specific entries? That's the purpose of the existing io_rsrc_node=
 refs
> > > > > field.
> > > >
> > > > How would this work with userspace buffer unregistration (which wor=
ks
> > > > at the table level)? If buffer unregistration should still succeed
> > > > then fuse would need a way to be notified that the buffer has been
> > > > unregistered since the buffer belongs to userspace (eg it would be
> > > > wrong if fuse continues using it even though fuse retains a refcoun=
t
> > > > on it). If buffer unregistration should fail, then we would need to
> > > > track this pinned state inside the node instead of relying just on =
the
> > > > refs field, as buffers can be unregistered even if there are in-fli=
ght
> > > > refs (eg we would need to differentiate the ref being from a pin vs
> > > > from not a pin), and I think this would make unregistration more
> > > > cumbersome as well (eg we would have to iterate through all the
> > > > entries looking to see if any are pinned before iterating through t=
hem
> > > > again to do the actual unregistration).
> > >
> > > Not sure I would say buffer unregistration operates on the table as a
> > > whole. Each registered buffer node is unregistered individually and
> >
> > I'm looking at the liburing interface for it and I'm only seeing
> > io_uring_unregister_buffers() / IORING_UNREGISTER_BUFFERS which works
> > on the entire table, so I'm wondering how that interface would work if
> > pinning/unpinning was at the entry level?
>
> IORING_REGISTER_BUFFERS_UPDATE can be used to update individual
> registered buffers. For each updated slot, if there is an existing
> buffer, it will be unregistered (decrementing the buffer node's
> reference count). A new buffer may or may not be registered in its
> place; it can be skipped by specifying a struct iovec with a NULL
> iov_base.
>

I think we would still need to account for the
IORING_UNREGISTER_BUFFERS path since that is callable by users.

> >
> > > stores its own reference count. io_put_rsrc_node() will be called on
> > > each buffer node in the table. However, io_put_rsrc_node() just
> > > removes the one reference from the buffer node. If there are other
> > > references on the buffer node (such as an inflight io_uring request
> > > using it), io_free_rsrc_node() won't be called to free the buffer nod=
e
> > > until all those references are dropped too. So fuse holding a
> > > reference on the buffer node would allow it to be unregistered, but
> > > prevent it from being freed until fuse dropped its reference.
> > > I'm not sure I understand the problem with fuse continuing to hold
> > > onto a registered buffer node after userspace has unregistered it fro=
m
> > > the buffer table. (It looks like the buffer node in question is the
> >
> > For fuse, it holds the reference to the buffer for the lifetime of the
> > connection, which could be a very long time. I'm not seeing how we
> > could let userspace succeed in unregistering with fuse continuing to
> > hold that reference, since as I understand it conceptually,
> > unregistering the buffer should give ownership of the buffer
> > completely back to userspace.
>
> I'm not quite sure what you mean by "give ownership of the buffer
> completely back to userspace". My understanding is that registering a
> buffer with io_uring just pins the physical pages as a perf
> optimization. I'm not aware of a way for userspace to observe directly
> whether or not certain physical pages are pinned. There's already no
> guarantee that the physical pages are unpinned as soon as a buffer is
> unregistered; if there are any inflight io_uring requests using the
> registered buffer, they will continue to hold a reference count on the
> buffer, preventing it from being released. The only guarantee is that
> the unregistered slot in the buffer table is now empty.
>
> Presumably fuse must release its reference count (or pin) eventually,
> or otherwise there would be a resource leak? I don't see an issue with
> holding references to registered buffers for the lifetime of a fuse
> connection. As long as there's a way for the fuse server to tell the
> kernel to release those resources if they are no longer needed (which
> it sounds like already exists from your description of aborting a fuse
> connection).

The way I view it is that conceptually, userspace "owns" the buffer.
Userspace allocated the buffer and is later responsible for freeing it
when it's done using it. When userspace registers the buffer to the
ring, it can expect the buffer to be written to / read from by the
kernel code, but it should also be able to expect that when it
unregisters the buffer from the ring and any of the concurrent
inflight requests are fulfilled, the kernel will not be accessing that
buffer anymore and userspace has complete sovereignty over the buffer.

With fuse continuing to hold the reference on the buffer (for the
lifetime of the connection) and continuing to read to / write from it
after unregistration, that violates that contract.

>
> >
> > > one at FUSE_URING_FIXED_HEADERS_INDEX?) Wouldn't pinning the buffer
> >
> > Yep you have that right, the buffer node in question is the one at
> > FUSE_URING_FIXED_HEADERS_INDEX which is where all the headers for
> > requests are placed.
> >
> > > table present similar issues? How would userspace get fuse to drop it=
s
> >
> > I don't think pinning the buffer table has a similar issue because we
> > disallow unregistration if it's pinned.
>
> It sounds like you're saying that buffer unregistration just isn't
> expected to work together with fuse's use of registered buffers, is
> that accurate? Does it matter then whether the buffer unregistration
> returns -EBUSY because the buffer table is pinned vs. succeeding but
> not actually releasing the buffer resource because fuse still holds a
> reference on it? My preference would be to just use the existing

Yes, I think the difference is that returning -EBUSY signals to the
caller that the buffer cannot be unregistered and will still be used.
Whereas succeeding but not actually releasing the buffer resource and
still continuing to use it beyond the inflight cmds is
contrary/deceptive behavior to what the user should be able to expect.

> reference counting mechanism rather than introducing another mechanism
> if both provide safety equally well.
>
> >
> > > pin if it wants to modify the buffer registrations? I would imagine
> >
> > For the fuse use case, the server never really modifies its buffer
> > registrations as it sets up everything before initiating the
> > connection. But if it wanted to in the future, the server could send a
> > fuse notification to the kernel to unpin the buf table.
>
> This seems to assume that all the registered buffers are used
> exclusively for fuse purposes. But it seems plausible that a fuse
> server might want to use io_uring for other non-fuse purposes and want
> to use registered buffers there too as a perf optimization? Then it
> would be nice for the process to be able to update the other
> registered buffers even while the kernel pins (or holds a reference
> count on) the ones used for fuse.

I don't think this is likely. I think it's more likely that a
high-performance fuse server would use a separate ring for
non-fuse-related I/O, as doing it on the same ring it's using to
communicate with the fuse kernel would lead to more contention for
ring entries which would result in higher latency for servicing
incoming/outgoing fuse requests. I guess the caller could make the
ring very big to accommodate for that, but then that leads to more
memory overhead (eg allocating the headers buffers for all the
potential entries).

>
> Best,
> Caleb

Thanks,
Joanne

