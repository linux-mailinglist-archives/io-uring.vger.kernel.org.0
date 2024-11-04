Return-Path: <io-uring+bounces-4438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 555A99BBE4E
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 20:55:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 163DE2835EC
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 19:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1671CCB56;
	Mon,  4 Nov 2024 19:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FvwIWSGa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430121CCB35
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 19:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730750111; cv=none; b=ZyCh5XJWQ+Qjc5BlbGHpaOiRInpyQcBAHxKGJWVdoQa3HMA/kGi4loOKD0U+OxNR8ZntqLC2iV7OjXClgyY9x8KAdmtf+4BTizsexNQ2sKOBOJ6TvnGJO7yaEXP80WBli5xJG1vG83EcxrTI2Sw1x2VhyGXvUS7SMR1UfQTYPJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730750111; c=relaxed/simple;
	bh=n0tjmfDL6BPyhTjR/b5T4gb0CZuykaLBAss9SlCr3As=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iw2weMR0ti9oG3I1BQ3jXB0SShvQj3uZm1p5wvI2V16ljZ4wqQY3GmGGqNunOgqBRVpi9jGk5ToCFzWxnurshJFtY426NRovEo2b8Tjx5IS8OEvU6A+44qjxmsaN5vyYJC+i+j4uUL30vX7NnkiIEvO6E0IM9ofBIuuSw8XNf2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FvwIWSGa; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a4e54d3cefso33205ab.0
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 11:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730750107; x=1731354907; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N53p+N4N73iQueCAcYjATG0UWlXOJ7UXR8iV8B23S0U=;
        b=FvwIWSGarKum485O44ZJg35EeWpa8rUd/fhLLxjA8mu1f5agLUxfdxiVXU833WiM3f
         4WaIu5GboKAgs0vQszzF1oheBrcplzENsW7f2ilqKZKoUdiPaB9vKW6yQzt2dqN1OU4h
         epwwUfNynACich3nwqqps8/Sxzcyv4YWx+KOUmv0E8mDM1xUAq87uGysiUhdjvGyHkWa
         J4djj/XQkPEfdNOLD/U/Hwsmwo+On36yw5hry2GgWAN9HSFrPDlEp6C0REWlteyWtcpa
         Dpgnnx09xwtAOyDVbivYepGODq9be3RilYGueSzi61ko6utQa2VdiipvYjQXT45Wl9pd
         hCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730750107; x=1731354907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N53p+N4N73iQueCAcYjATG0UWlXOJ7UXR8iV8B23S0U=;
        b=JvdvJfMCnfZptFHx6wyQY0NUIdxOcrvbQwixM8j/pHyrF2/m+vmL4eswX1jcTa2bdf
         ygYpIkQpFpqTj7kG2GlQWnv8DPNYl+hT4dnhxdPG+/2X2EpTOJj0gL+65VV2dgcLw48U
         3fAfOwCczJvfkC/X8wh9YY4vQ4nHQiZ8BwQNxntI7Z8g0Ar5lzYHt1ryHYF1PG9ie6hq
         P/kM7I51Hgo1Tk6L05XKCU9qr0u7avxCBL0dQNiUbwIwlf03HIEXkPiuz8HziLNraIFt
         VILCcpcPcsl05X1fMbTo379/6OzWkfXs6H4EztWkQEBLqpsKc6yZ1W1gZ3jjSp3InpYg
         PxmA==
X-Forwarded-Encrypted: i=1; AJvYcCWwrohGkLDe7k8v8DzRas+Yfe/Omnj228EMASxtue8B2cnBuHgiGcyTY1H5EEmvUruhJ6IuQ+VenQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPxPGlpn0rUFGq0rQ4lV/viGzAVwlqOIQ7UgJ26dugyNzD8TYX
	oJUaaSx/6E5AEaX2yErsrPhWBN214/uznjSZEXb3srGZyN/w8xg83xukYEBfkANoC7ech+dWl3O
	KAMwst6GtEA/El/NepFksKJPhpoC3fWTYje9j
X-Gm-Gg: ASbGnctoSJsi4nFMYwGQO+Ta1GMgnxuuc013/jgB9Gd8JvIEv0RNUHYPSAvsp/0uYmq
	0NgZn74pRoZFsPzBzEnEf0byB+DCyyVxP93j4/koappIrq5jjz0jqPrHmMwjzdw==
X-Google-Smtp-Source: AGHT+IEVf+z3HXNjKKIwO0Wb+qwYQ8MbmzBQqeK9bj1EWmdRHMahC5PcNriDAiiIA0EL9JLTVNKDXu+jSO15BNyefa8=
X-Received: by 2002:a05:6e02:691:b0:3a6:b1c5:e644 with SMTP id
 e9e14a558f8ab-3a6daa961b5mr364675ab.21.1730750106999; Mon, 04 Nov 2024
 11:55:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-12-dw@davidwei.uk>
 <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com> <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
In-Reply-To: <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 4 Nov 2024 11:54:55 -0800
Message-ID: <CAHS8izPEmbepTYsjjsxX_Dt-0Lz1HviuCyPM857-0q4GPdn4Rg@mail.gmail.com>
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 2:09=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 11/1/24 20:06, Mina Almasry wrote:
> ...
> >> +__maybe_unused
> >> +static const struct memory_provider_ops io_uring_pp_zc_ops;
> >> +
> >> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct n=
et_iov *niov)
> >> +{
> >> +       struct net_iov_area *owner =3D net_iov_owner(niov);
> >> +
> >> +       return container_of(owner, struct io_zcrx_area, nia);
> >> +}
> >> +
> >
> > We discussed this before I disappeared on vacation but I'm not too
> > convinced to be honest, sorry.
> >
> > It's invalid to call io_zcrx_iov_to_area on a devmem niov and vice
> > versa, right? So current and future code has to be very careful to
>
> Yes
>
> > call the right helpers on the right niovs.
> >
> > At the very least there needs to be a comment above all these
> > container_of helpers:
> >
> > /* caller must have verified that this niov is devmem/io_zcrx */.
> >
> > However I feel like even a comment is extremely error prone. These
> > container_of's are inside of the call stack of some helpers. I would
> > say we need a check. If we're concerned about performance, the check
> > can be behind DEBUG_NET_WARN_ON(), although even that is a bit iffy,
> > but could be fine. Doing this without a check seems too risky to me.
>
> No, it doesn't need a check nor it needs a comment. The very
> essence of virtual function tables is that they're coupled
> together with objects for which those function make sense and
> called only for those objects. The only way to get here with
> invalid net_iovs is to take one page pool and feed it with
> net_iovs from other another page pool that won't be sane in
> the first place.
>

That could happen. In fact the whole devmem tcp paths are very
carefully written to handle that

net_iovs are allocated from the page_pool, put in skbs, and then sit
in the sk receive queue. In pathological cases (user is
re/misconfiguring flow steering) we can have 1 sk receive queue that
has a mix of page skbs, devmem skbs, and io_uring skbs, and other
skbs.

Code that is processing the skbs in the receive queue has no idea
whether what kind of skb it is. That's why that code needs to check
whether the skb has readable frags, and that's why in this very series
you needed to add a check in tcp_recvmsg_dmabuf to make sure that its
a dmabuf skb, and you need to add a check to io_zcrx_recv_frag that
the frag inside it is io_uring niov. The code would be wrong without
it.

All I'm trying to say is that it's very error prone to rely on folks
writing and reviewing code to check that whenever dmabuf/io_rcrx/etc
handling is done, somewhere in the call stack a type verification
check has been made, and a DEBUG_NET_WARN could help avoid some subtle
memory corruption bugs.

> That would be an equivalent of:
>
> struct file *f1 =3D ...;
> struct file *f2 =3D ...;
>
> f1->f_op->read(f2, ...);
>
> Maybe it looks strange for you in C, but it's same as putting
> comments that a virtual function that it should be called only
> for objects of that class:
>
> struct A {
>         virtual void foo() =3D 0;
> };
> struct B: public A {
>         void foo() override {
>                 // we should only be called with objects of type
>                 // struct B (or anything inheriting it), check that
>                 if (!reinterpret_cast<struct B*>(this))
>                         throw;
>                 ...
>         }
> }
>
>

I'm not really sure I followed here. We do not get any type of
compiler or type safety from this code because the dma-buf niovs and
io_uring niovs are the same net_iov type.

We can get type safety by defining new types for dmabuf_net_iov and
io_uring_net_iov, then provide helpers:

dmabuf_net_iov *net_iov_to_dmabuf();
io_uring_net_iov *net_iov_to_io_uring();

The helpers can check the niov is of the right type once and do a
cast,  then the object with the specific type can be passed to all
future heplers without additional checks. This is one way to do it I
guess.

> >>   static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
> >>                                   struct io_uring_zcrx_ifq_reg *reg)
> >>   {
> >> @@ -99,6 +114,9 @@ static int io_zcrx_create_area(struct io_ring_ctx *=
ctx,
> >>                  goto err;
> >>
> >>          for (i =3D 0; i < nr_pages; i++) {
> >> +               struct net_iov *niov =3D &area->nia.niovs[i];
> >> +
> >> +               niov->owner =3D &area->nia;
> >>                  area->freelist[i] =3D i;
> >>          }
> >>
> >> @@ -230,3 +248,200 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *c=
tx)
> >>   {
> >>          lockdep_assert_held(&ctx->uring_lock);
> >>   }
> >> +
> >> +static bool io_zcrx_niov_put(struct net_iov *niov, int nr)
> >> +{
> >> +       return atomic_long_sub_and_test(nr, &niov->pp_ref_count);
> >> +}
> >> +
> >> +static bool io_zcrx_put_niov_uref(struct net_iov *niov)
> >> +{
> >> +       if (atomic_long_read(&niov->pp_ref_count) < IO_ZC_RX_UREF)
> >> +               return false;
> >> +
> >> +       return io_zcrx_niov_put(niov, IO_ZC_RX_UREF);
> >> +}
> >> +
> >
> > Sorry, I have to push back a bit against this. The refcounting of
> > netmem is already complicated. the paged netmem has 2 refcounts and
> > care needs to be taken when acquiring and dropping refcounts. net_iov
> > inherited the pp_ref_count but not the paged refcount, and again need
> > some special handling. skb_frag_unref takes very special care checking
>
> Which is why it's using net_iovs.
>
> > pp->recycle, is_pp_netmem, and others to figure out the correct
>
> pp->recycle has nothing to do with the series. We don't add
> it in any special way, and if it's broken it's broken even
> for non-proivder buffers.
>
> > refcount to put based on the type of the netmem and skb flag.
>
> Just same as with the ->[un]readable flag, which is not
> functionally needed, and if it's screwed many things can
> go very wrong.
>
> > This code ignores all these generic code
> > skb_frag_unref/napi_pp_put_page/etc paths and uses raw access to
>
> I don't see the point, they are not used because they're not
> needed. Instead of checking whether it came from a page pool
> and whether it's net_iov or not, in the path io_uring returns
> it we already apriori know that they're from a specific page
> pool, net_iov and from the current provider.
>
> Same for optimisations provided by those helpers, they are
> useful when you're transferring buffers from one context to
> another, e.g. task recieve path -> napi / page_pool. In this
> case they're already fetched in the right context without any
> need to additionally jumping through the hoops. If anything,
> it'd be odd to jump out of a window to climb a rope on the
> other side of the building when you could've just walked 5
> meters to the other room.
>

For me, "they are not used because they're not needed." is not enough
justification to ignore the generic code paths that support generic
use cases and add your own freeing path and recycling that needs to
work adjacent to generic paths for posterity. You need to provide
concrete reasons why the current code paths don't work for you and
can't be made to work for you.

Is it very complicated to napi_pp_put_page() niovs as the user puts
them in the refill queue without adding a new syscall? If so, is it
possible to do a niov equivalent of page_pool_put_page_bulk() of the
refill queue while/as you process the RX path?

If you've tested the generic code paths to be performance deficient
and your recycling is indeed better, you could improve the page_pool
to pull netmems when it needs to like you're doing here, but in a
generic way that applies to the page allocator and other providers.
Not a one-off implementation that only applies to your provider.

If you're absolutely set on ignoring the currently supported reffing
and implementing your own reffing and recycling for your use case,
sure, that could work, but please don't overload the
niov->pp_ref_count reserved for the generic use cases for this. Add
io_zcrx_area->io_uring_ref or something and do whatever you want with
it. Since it's not sharing the pp_ref_count with the generic code
paths I don't see them conflicting in the future.

--
Thanks,
Mina

