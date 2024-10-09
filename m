Return-Path: <io-uring+bounces-3537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DD3997822
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 00:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 249DA1F21EB0
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E971E32A0;
	Wed,  9 Oct 2024 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hOaR3DH/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D96D1C9B99
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 22:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511301; cv=none; b=fvn21bu15ey477ZSUJB4rNfYDt20z0dir0C93+9N9C2qtD5O/kZlJPPLutS2pVHf7od+t5ZtPI/ixkdwf9gm2xLwXdlqU2SRsZXCBuILiYYiNOoqRZh1p3uclbRXrOMUS3p2r99e/YETBgEnQo3bC8MnPo53b0MVJacGhmuz1Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511301; c=relaxed/simple;
	bh=6VgQ+Ix4mkwAGsg5/rBbNWdIIMMHaG75IKBpeDw62bo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SwwR1fwiRiy9AIiO2EIkVNCddAZkYtI/XZaS6RyPBTvPIsjXyF344vfpQAOvT2CbPpsWZVfAFFuoD+sKKbxDxT4vPrS5aYmK47SE4ykpbNlQWv0UNyKGGmSQZNYJ9aBTmOkrXM42CJPREyOMivL5H/+6IxaK7eYGgO5tWlo8e/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hOaR3DH/; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-45fb0ebb1d0so47931cf.1
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 15:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728511297; x=1729116097; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2L0OrPLeMCuy71leQfpJlftgkEac9OpQkQixsKFM4js=;
        b=hOaR3DH/Nt9zi+bP2tWiv7vRHmzTff8bMs6rnX+W8VCoaaAD6c/EO6uVk+979Oy7r2
         c0BSdckwMgssib/5yx8zruoaIE7N6TILlfIRVGTbQkb1uS6lwxwRurS2TW/3D0JOMro5
         AZT/5iIO+2wvyPl3/T0in7ny6zCpvwyNK9ivdFojdU9KIvTJj8weNDlsDqGs9ya8dWjg
         tr99SUljkPnIzz8grZ5nA3EB1Bp9XXR9nIiCccofg2Y+Y+gN344nVu3URwTCDEWYbZa2
         KUNpnhL04LS6MgVlLSdezBnojOg1Vdvt78fxOuwM1YC2ZLts6olNnDwrpA9yD4BhLWaH
         GrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728511297; x=1729116097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2L0OrPLeMCuy71leQfpJlftgkEac9OpQkQixsKFM4js=;
        b=XYWORBk1irK60owop/dVZAunYDk4a591frVW+ycdCNxPI0tQRD60WoF+4aNMkPajk0
         kKuZ8uovOnwUgpPih5L9y7SbzWOmXYHZanRi7FFt7iKBPXXtOGGb5KSXZ1VVdzpbrUgz
         EHqC9ZtPIQ3lJVpPTDr1zmpunii+H91XmNx9Se/GjbCxPOFa66XogPy+jJDU6odOCr7p
         Hz9GhlZYp7edfw96OIqUrfvjmEZyc4r0rJ7ul275OLHKkYtZ71s4qm5jrATFTsG4/ALD
         /qlNWgzUJIi/O5l3Mr2XpP8bzXpkZDvOJyCv0aF+7haICoLpXqenwefAlcOA+ejM6ItN
         QktA==
X-Gm-Message-State: AOJu0YzkkLzPzz14259jHfDUNCgpdhXN/JS6ahbiV0Xv+M7KfgYSW1vX
	JrG674M1k/j33wnRkXJeaO1lc+shMol75Qq5ugu3UScMbKeM6rvyVdFfYSuorwMtawZ6bpFI1NQ
	93r1d3eztF0q3raY5OZhPY0PgjnzOlk67hf+V
X-Google-Smtp-Source: AGHT+IENLoAUwl1/zRzEz6UE5JfyFPmukMRp8NUqhonCeKjuUk4Q5ugOwSeP3V4ufWoDVzhgAjVzcbosGCf6pxYqRu4=
X-Received: by 2002:a05:622a:548a:b0:45e:f6e6:2165 with SMTP id
 d75a77b69052e-4604123cb52mr423201cf.7.1728511296683; Wed, 09 Oct 2024
 15:01:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-12-dw@davidwei.uk>
In-Reply-To: <20241007221603.1703699-12-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Oct 2024 15:01:21 -0700
Message-ID: <CAHS8izO-=ugX7S11dTr5cXp11V+L-gquvwBLQko8hW4AP9vg6g@mail.gmail.com>
Subject: Re: [PATCH v1 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Implement a page pool memory provider for io_uring to receieve in a
> zero copy fashion. For that, the provider allocates user pages wrapped
> around into struct net_iovs, that are stored in a previously registered
> struct net_iov_area.
>
> Unlike with traditional receives, for which pages from a page pool can
> be deallocated right after the user receives data, e.g. via recv(2),
> we extend the lifetime by recycling buffers only after the user space
> acknowledges that it's done processing the data via the refill queue.
> Before handing buffers to the user, we mark them by bumping the refcount
> by a bias value IO_ZC_RX_UREF, which will be checked when the buffer is
> returned back. When the corresponding io_uring instance and/or page pool
> are destroyed, we'll force back all buffers that are currently in the
> user space in ->io_pp_zc_scrub by clearing the bias.
>

This is an interesting design choice. In my experience the page_pool
works the opposite way, i.e. all the netmems in it are kept alive
until the user is done with them. Deviating from that requires custom
behavior (->scrub), which may be fine, but why do this? Isn't it
better for uapi perspective to keep the memory alive until the user is
done with it?

> Refcounting and lifetime:
>
> Initially, all buffers are considered unallocated and stored in
> ->freelist, at which point they are not yet directly exposed to the core
> page pool code and not accounted to page pool's pages_state_hold_cnt.
> The ->alloc_netmems callback will allocate them by placing into the
> page pool's cache, setting the refcount to 1 as usual and adjusting
> pages_state_hold_cnt.
>
> Then, either the buffer is dropped and returns back to the page pool
> into the ->freelist via io_pp_zc_release_netmem, in which case the page
> pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
> likely the buffer will go through the network/protocol stacks and end up
> in the corresponding socket's receive queue. From there the user can get
> it via an new io_uring request implemented in following patches. As
> mentioned above, before giving a buffer to the user we bump the refcount
> by IO_ZC_RX_UREF.
>
> Once the user is done with the buffer processing, it must return it back
> via the refill queue, from where our ->alloc_netmems implementation can
> grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
> there are no more users left. As we place such buffers right back into
> the page pools fast cache and they didn't go through the normal pp
> release path, they are still considered "allocated" and no pp hold_cnt
> is required.

Why is this needed? In general the provider is to allocate free memory
and logic as to where the memory should go (to fast cache, to normal
pp release path, etc) should remain in provider agnostic code paths in
the page_pool. Not maintainable IMO in the long run to have individual
pp providers customizing non-provider specific code or touching pp
private structs.

> For the same reason we dma sync buffers for the device
> in io_zc_add_pp_cache().
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/linux/io_uring/net.h |   5 +
>  io_uring/zcrx.c              | 229 +++++++++++++++++++++++++++++++++++
>  io_uring/zcrx.h              |   6 +
>  3 files changed, 240 insertions(+)
>
> diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
> index b58f39fed4d5..610b35b451fd 100644
> --- a/include/linux/io_uring/net.h
> +++ b/include/linux/io_uring/net.h
> @@ -5,6 +5,11 @@
>  struct io_uring_cmd;
>
>  #if defined(CONFIG_IO_URING)
> +
> +#if defined(CONFIG_PAGE_POOL)
> +extern const struct memory_provider_ops io_uring_pp_zc_ops;
> +#endif
> +
>  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags=
);
>
>  #else
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 8382129402ac..6cd3dee8b90a 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -2,7 +2,11 @@
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
>  #include <linux/mm.h>
> +#include <linux/nospec.h>
> +#include <linux/netdevice.h>
>  #include <linux/io_uring.h>
> +#include <net/page_pool/helpers.h>
> +#include <trace/events/page_pool.h>
>
>  #include <uapi/linux/io_uring.h>
>
> @@ -16,6 +20,13 @@
>
>  #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_INET)
>
> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_=
iov *niov)
> +{
> +       struct net_iov_area *owner =3D net_iov_owner(niov);
> +
> +       return container_of(owner, struct io_zcrx_area, nia);

Similar to other comment in the other patch, why are we sure this
doesn't return garbage (i.e. it's accidentally called on a dmabuf
net_iov?)

> +}
> +
>  static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>                                  struct io_uring_zcrx_ifq_reg *reg)
>  {
> @@ -101,6 +112,9 @@ static int io_zcrx_create_area(struct io_ring_ctx *ct=
x,
>                 goto err;
>
>         for (i =3D 0; i < nr_pages; i++) {
> +               struct net_iov *niov =3D &area->nia.niovs[i];
> +
> +               niov->owner =3D &area->nia;
>                 area->freelist[i] =3D i;
>         }
>
> @@ -233,4 +247,219 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>         lockdep_assert_held(&ctx->uring_lock);
>  }
>
> +static bool io_zcrx_niov_put(struct net_iov *niov, int nr)
> +{
> +       return atomic_long_sub_and_test(nr, &niov->pp_ref_count);
> +}
> +
> +static bool io_zcrx_put_niov_uref(struct net_iov *niov)
> +{
> +       if (atomic_long_read(&niov->pp_ref_count) < IO_ZC_RX_UREF)
> +               return false;
> +
> +       return io_zcrx_niov_put(niov, IO_ZC_RX_UREF);
> +}
> +
> +static inline void io_zc_add_pp_cache(struct page_pool *pp,
> +                                     struct net_iov *niov)
> +{
> +       netmem_ref netmem =3D net_iov_to_netmem(niov);
> +
> +#if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
> +       if (pp->dma_sync && dma_dev_need_sync(pp->p.dev)) {

IIRC we force that dma_sync =3D=3D true for memory providers, unless you
changed that and I missed it.

> +               dma_addr_t dma_addr =3D page_pool_get_dma_addr_netmem(net=
mem);
> +
> +               dma_sync_single_range_for_device(pp->p.dev, dma_addr,
> +                                                pp->p.offset, pp->p.max_=
len,
> +                                                pp->p.dma_dir);
> +       }
> +#endif
> +
> +       page_pool_fragment_netmem(netmem, 1);
> +       pp->alloc.cache[pp->alloc.count++] =3D netmem;

IMO touching pp internals in a provider should not be acceptable.

pp->alloc.cache is a data structure private to the page_pool and
should not be touched at all by any specific memory provider. Not
maintainable in the long run tbh for individual pp providers to mess
with pp private structs and we hunt for bugs that are reproducible
with 1 pp provider or another, or have to deal with the mental strain
of provider specific handling in what is supposed to be generic
page_pool paths.

IMO the provider must implement the 4 'ops' (alloc, free, init,
destroy) and must not touch pp privates while doing so. If you need to
change how pp recycling works then it needs to be done in a provider
agnostic way.

I think both the dmabuf provider and Jakub's huge page provider both
implemented the ops while never touching pp internals. I wonder if we
can follow this lead.

--
Thanks,
Mina

