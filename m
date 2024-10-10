Return-Path: <io-uring+bounces-3568-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 324B7998FAD
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 20:19:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC5E31F21D34
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 18:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9DF19C563;
	Thu, 10 Oct 2024 18:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bV226qJp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89704A15
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584365; cv=none; b=jGL51o57+DY3ddChKBIdBsmiq5xQkqhN783RSw5Bw/BXxHb6FXmqLY9DlP4GcGqLyAxg+AkmKpJa7oTPq7cNMQqstbA6bgJ+c0iK5g52M2aR6d2ax/wLi4ndRtWdIJhYz0fum2xmyJQMYeySNdZJoSUOpL8e/8sSkLoub4mZ8Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584365; c=relaxed/simple;
	bh=seg6PtxdKCw6658t/6NR1j0MiC5hlzZnwwtAhGtHVfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ms6v5M1o0Ns9/o78PPIhlUhVll4MigCixpCoHGv8gX76M6OHjlHseE+PFzWCxzk2wm3IJ94iyp+xMEP19snCsnapWlZPUpAlnH8MS5u0WsCUXRqVwTqJ+9QeEMzGOXxh7Oke02bQa7MBVtY9rsZ04xQH6t87kuU+w8Ys3jD/wDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bV226qJp; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4603d3e0547so37151cf.0
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 11:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584362; x=1729189162; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHYB0Fms1iMmJeXSNk7809G+fS3DYVxsl+/gdvz9aeY=;
        b=bV226qJppKo0w9CG5Gqw/5WKDEhkgD1CjzRIKNHksglfoDAAKcKGr9fCErD1iJ5qdH
         Mpnyy7ae1KEycOQtuynw1OTtvuZ1YV9pLGDKN/zOA/xCgNYqZWY5N+EM0h+r2q8NZSc9
         1Uv5glE6j1Rd37F1M46ttnGu9ajBLLXJhBJRbuN2+2nbelFv3SXM+fupVbLrVvHpXw1r
         q5zu/A0rVTEc/eH5vHHzzKg8WDfMaKKTRnUuowndj03eZnE4PkJ4S1OfV7tKhXSNSNud
         A+lsCYTmn9X3EA5X+quCdZhsD5OrQuQTilZYadfRL/roolLYrOFAXiMOXaVLY87/Ob47
         Etuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584362; x=1729189162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yHYB0Fms1iMmJeXSNk7809G+fS3DYVxsl+/gdvz9aeY=;
        b=dIhx+NUWlEz8FVrdUNGjzJcxxlqlOSe0dafuwNYYRe7VjoR6ERoHRggvdOvmQiAq8x
         50TrUt01hiX4c0s6FqUTiLmVZgxmzINOs7kfMwtWR62reu53A4HpabwO0hWoxK279o7O
         1F5nyaGmx8HpIVg5ja7H2uimSEzMv3VxbFAjM9WH+mye4gQAjkvLgMLCRO/P5pcl+e3m
         XvBS9R8y0w68v8XX7X/211SHBFUGEBe7P6ubt+caTE7nSV/Gqv47LOF1HAUBhOYgpkWb
         7Q1+u6sJ1/k6cI7NRVVZ2i1xv9POnflISVFCgnwZTIJ0vnpZ0NyN341sphqVZZBEBhwV
         CcWg==
X-Forwarded-Encrypted: i=1; AJvYcCXGlKpjZxez7gNKnompk8rsCWswbkeLdpRqxMsT1+NBfvYr6/4p5gRRzV3aeGPMICA9zyoj7XisSw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq5wS8kUclP9DR3YdVG/liVrZ2n/JqHfw3V1mS758kfynrFbj9
	1yTeHA6UVrT/HfyJTG1DwE4Wvx98PNah/89DoygUHyQU2FBSaZGD0ZFPTyPs7CvrhH+3q+0PmXA
	gQ9dXaERYrEYCmV9wT/W29iGWTGDin5ieKVyL
X-Google-Smtp-Source: AGHT+IFCTPnVHq+c88/tOkZYn15HiMN/SkgvHU1nzR91Y4dEF/ooNzJiMjoYRo1jH7+bhU2oHUoV1gPX/PH431Dl8B4=
X-Received: by 2002:a05:622a:5f0b:b0:453:5b5a:e77c with SMTP id
 d75a77b69052e-4604ac30a8cmr308901cf.10.1728584362284; Thu, 10 Oct 2024
 11:19:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-12-dw@davidwei.uk>
 <CAHS8izO-=ugX7S11dTr5cXp11V+L-gquvwBLQko8hW4AP9vg6g@mail.gmail.com> <94a22079-0858-473c-b07f-89343d9ba845@gmail.com>
In-Reply-To: <94a22079-0858-473c-b07f-89343d9ba845@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 10 Oct 2024 11:19:08 -0700
Message-ID: <CAHS8izPjHv_J8=Hz6xZmfa857st+zyA7MLSe+gCJTdZewPOmEw@mail.gmail.com>
Subject: Re: [PATCH v1 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 3:57=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 10/9/24 23:01, Mina Almasry wrote:
> > On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote=
:
> >>
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >>
> >> Implement a page pool memory provider for io_uring to receieve in a
> >> zero copy fashion. For that, the provider allocates user pages wrapped
> >> around into struct net_iovs, that are stored in a previously registere=
d
> >> struct net_iov_area.
> >>
> >> Unlike with traditional receives, for which pages from a page pool can
> >> be deallocated right after the user receives data, e.g. via recv(2),
> >> we extend the lifetime by recycling buffers only after the user space
> >> acknowledges that it's done processing the data via the refill queue.
> >> Before handing buffers to the user, we mark them by bumping the refcou=
nt
> >> by a bias value IO_ZC_RX_UREF, which will be checked when the buffer i=
s
> >> returned back. When the corresponding io_uring instance and/or page po=
ol
> >> are destroyed, we'll force back all buffers that are currently in the
> >> user space in ->io_pp_zc_scrub by clearing the bias.
> >>
> >
> > This is an interesting design choice. In my experience the page_pool
> > works the opposite way, i.e. all the netmems in it are kept alive
> > until the user is done with them. Deviating from that requires custom
> > behavior (->scrub), which may be fine, but why do this? Isn't it
> > better for uapi perspective to keep the memory alive until the user is
> > done with it?
>
> It's hardly interesting, it's _exactly_ the same thing devmem TCP
> does by attaching the lifetime of buffers to a socket's xarray,
> which requires custom behaviour. Maybe I wasn't clear on one thing
> though, it's accounting from the page pool's perspective. Those are
> user pages, likely still mapped into the user space, in which case
> they're not going to be destroyed.
>

I think we miscommunicated. Both devmem TCP and io_uring seem to bump
the refcount of memory while the user is using it, yes. But devmem TCP
doesn't scrub the memory when the page_pool dies. io_uring seems to
want to scrub the memory when the page_pool dies. I'm wondering about
this difference. Seems it's better from a uapi prespective to keep the
memory alive until the user returns it or crash. Otherwise you could
have 1 thread reading user memory and 1 thread destroying the
page_pool and the memory will be pulled from under the read, right?

> >> Refcounting and lifetime:
> >>
> >> Initially, all buffers are considered unallocated and stored in
> >> ->freelist, at which point they are not yet directly exposed to the co=
re
> >> page pool code and not accounted to page pool's pages_state_hold_cnt.
> >> The ->alloc_netmems callback will allocate them by placing into the
> >> page pool's cache, setting the refcount to 1 as usual and adjusting
> >> pages_state_hold_cnt.
> >>
> >> Then, either the buffer is dropped and returns back to the page pool
> >> into the ->freelist via io_pp_zc_release_netmem, in which case the pag=
e
> >> pool will match hold_cnt for us with ->pages_state_release_cnt. Or mor=
e
> >> likely the buffer will go through the network/protocol stacks and end =
up
> >> in the corresponding socket's receive queue. From there the user can g=
et
> >> it via an new io_uring request implemented in following patches. As
> >> mentioned above, before giving a buffer to the user we bump the refcou=
nt
> >> by IO_ZC_RX_UREF.
> >>
> >> Once the user is done with the buffer processing, it must return it ba=
ck
> >> via the refill queue, from where our ->alloc_netmems implementation ca=
n
> >> grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer i=
f
> >> there are no more users left. As we place such buffers right back into
> >> the page pools fast cache and they didn't go through the normal pp
> >> release path, they are still considered "allocated" and no pp hold_cnt
> >> is required.
> >
> > Why is this needed? In general the provider is to allocate free memory
>
> I don't get it, what "this"? If it's refill queue, that's because
> I don't like actively returning buffers back via syscall / setsockopt
> and trying to transfer them into the napi context (i.e.
> napi_pp_put_page) hoping it works / cached well.
>
> If "this" is IO_ZC_RX_UREF, it's because we need to track when a
> buffer is given to the userspace, and I don't think some kind of
> map / xarray in the hot path is the best for performance solution.
>

Sorry I wasn't clear. By 'this' I'm referring to:

"from where our ->alloc_netmems implementation can grab it, check
references, put IO_ZC_RX_UREF, and recycle the buffer if there are no
more users left"

This is the part that I'm not able to stomach at the moment. Maybe if
I look deeper it would make more sense, but my first feelings is that
it's really not acceptable.

alloc_netmems (and more generically page_pool_alloc_netmem), just
allocates a netmem and gives it to the page_pool code to decide
whether to put it in the cache, in the ptr ring, or directly to the
user, etc.

The provider should not be overstepping or overriding the page_pool
logic to recycle pages or deliver them to the user. alloc_netmem
should just just alloc the netmem and hand it to the page_pool to
decide what to do with it.

> > and logic as to where the memory should go (to fast cache, to normal
> > pp release path, etc) should remain in provider agnostic code paths in
> > the page_pool. Not maintainable IMO in the long run to have individual
>
> Please do elaborate what exactly is not maintainable here
>

In the future we will have N memory providers. It's not maintainable
IMO for each of them to touch pp->alloc.cache and other internals in M
special ways and for us to have to handle N * M edge cases in the
page_pool code because each provider is overstepping on our internals.

The provider should just provide memory. The page_pool should decide
to fill its alloc.cache & ptr ring & give memory to the pp caller as
it sees fit.

> > pp providers customizing non-provider specific code or touching pp
> > private structs.
>
> ...
> >> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> >> index 8382129402ac..6cd3dee8b90a 100644
> >> --- a/io_uring/zcrx.c
> >> +++ b/io_uring/zcrx.c
> >> @@ -2,7 +2,11 @@
> ...
> >> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct n=
et_iov *niov)
> >> +{
> >> +       struct net_iov_area *owner =3D net_iov_owner(niov);
> >> +
> >> +       return container_of(owner, struct io_zcrx_area, nia);
> >
> > Similar to other comment in the other patch, why are we sure this
> > doesn't return garbage (i.e. it's accidentally called on a dmabuf
> > net_iov?)
>
> There couldn't be any net_iov at this point not belonging to
> the current io_uring instance / etc. Same with devmem TCP,
> devmem callbacks can't be called for some random net_iov, the
> only place you need to explicitly check is where it comes
> from generic path to a devmem aware path like that patched
> chunk in tcp.c
>
> >> +static inline void io_zc_add_pp_cache(struct page_pool *pp,
> >> +                                     struct net_iov *niov)
> >> +{
> >> +       netmem_ref netmem =3D net_iov_to_netmem(niov);
> >> +
> >> +#if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
> >> +       if (pp->dma_sync && dma_dev_need_sync(pp->p.dev)) {
> >
> > IIRC we force that dma_sync =3D=3D true for memory providers, unless yo=
u
> > changed that and I missed it.
>
> I'll take a look, might remove it.
>
> >> +               dma_addr_t dma_addr =3D page_pool_get_dma_addr_netmem(=
netmem);
> >> +
> >> +               dma_sync_single_range_for_device(pp->p.dev, dma_addr,
> >> +                                                pp->p.offset, pp->p.m=
ax_len,
> >> +                                                pp->p.dma_dir);
> >> +       }
> >> +#endif
> >> +
> >> +       page_pool_fragment_netmem(netmem, 1);
> >> +       pp->alloc.cache[pp->alloc.count++] =3D netmem;
> >
> > IMO touching pp internals in a provider should not be acceptable.
>
> Ok, I can add a page pool helper for that.
>

To be clear, adding a helper will not resolve the issue I'm seeing.
IMO nothing in the alloc_netmem or any helpers its calling should
touch pp->alloc.cache. alloc_netmem should just allocate the memory
and let the non-provider pp code decide what to do with the memory.

> > pp->alloc.cache is a data structure private to the page_pool and
> > should not be touched at all by any specific memory provider. Not
> > maintainable in the long run tbh for individual pp providers to mess
> > with pp private structs and we hunt for bugs that are reproducible
> > with 1 pp provider or another, or have to deal with the mental strain
> > of provider specific handling in what is supposed to be generic
> > page_pool paths.
>
> I get what you're trying to say about not touching internals,
> I agree with that, but I can't share the sentiment about debugging.
> It's a pretty specific api, users running io_uring almost always
> write directly to io_uring and we solve it. If happens it's not
> the case, please do redirect the issue.
>
> > IMO the provider must implement the 4 'ops' (alloc, free, init,
>
> Doing 1 buffer per callback wouldn't be scalable at speeds
> we're looking at.
>

I doubt this is true or at least there needs to be more info here. The
page_pool_alloc_netmem() pretty much allocates 1 buffer per callback
for all its current users (regular memory & dmabuf), and that's good
enough to drive 200gbps NICs. What is special about io_uring use case
that this is not good enough?

The reason it is good enough in my experience is that
page_pool_alloc_netmem() is a slow path. netmems are allocated from
that function and heavily recycled by the page_pool afterwards.


--=20
Thanks,
Mina

