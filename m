Return-Path: <io-uring+bounces-11327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D287CCE9F9E
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 15:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 15A103015D10
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 14:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C36431813A;
	Tue, 30 Dec 2025 14:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=negrel.dev header.i=@negrel.dev header.b="n/xI/dMH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-24422.protonmail.ch (mail-24422.protonmail.ch [109.224.244.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB7E3191BF;
	Tue, 30 Dec 2025 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767106271; cv=none; b=tRRWBSPBHZWcS+5vGb5qWpT8G46GonLHAjSaRpW8o4NkHXp2ISZQslrN2QTBhpVn3defA/6M2Q8pSajkh3uBtcc6WUBdSy8/fpdyizrTRawkOqexqxjtvtOZAUEz40XS7qEiFdqnUCVfEmh4hASe8NQ8PwtEpH059ABi9wbUR+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767106271; c=relaxed/simple;
	bh=tK7YO9knJ/DW82/r5AhBZTgDme/v04xvtjbuM9hsP+E=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+CS8ZSdhTqmhINs7yICer5VIDAqaVfKsTV+JOYGVivR3S3ytr2lIpwXDlnRQ1YarSrHSK5mHo563axG1PUi6oNOK76Ii4kjr5DVg/eIp7krYByhvOUuNmvS4SgPSnjm5KaSMtnK8IoeezyKTWxGWyofnYlrIZQpweG2BT+/yhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=negrel.dev; spf=pass smtp.mailfrom=negrel.dev; dkim=pass (2048-bit key) header.d=negrel.dev header.i=@negrel.dev header.b=n/xI/dMH; arc=none smtp.client-ip=109.224.244.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=negrel.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=negrel.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=negrel.dev;
	s=protonmail3; t=1767106256; x=1767365456;
	bh=4qRGLq+jb6QfB1gWgKvjE0mVl7ig4/OHtKJRWVWj+G0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=n/xI/dMHbKk1tdnn++Mo5QCSbUiT4gJbF69YrTwqsP67kmWdNbLp74TqAu1VMIHDP
	 ZgdQiWafEcmbFbU+lMkN3ltiKACeXaTTErGSvqXhjN8NuXnvWaqsYcX2zTV0UGAthh
	 jGUipkfqH5MSSORKiNnR3qJvz9nitLpaKEPAVMoCEYUFss4hvJX96QjdudFA6uF0+l
	 KYdYdlnqdJXzldi0/i/jy5L/XmwbW4NqqbokaJ3znYSBbfU5ddE1LckYgw6YdAeQkn
	 U6VDzK27n2+aAFLXgGmTsag3X/WuOPnrVC9eiVESDgUuPJy8q4+QYL9iMhHfMC5Ayw
	 pX3QDARLs7l7g==
Date: Tue, 30 Dec 2025 14:50:51 +0000
To: Jens Axboe <axboe@kernel.dk>
From: Alexandre Negrel <alexandre@negrel.dev>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: make overflowing cqe subject to OOM
Message-ID: <5YHjvAsQKKhRWwp95PB0tGlW7nmplpjVW0b5mruoUD73qmg89ntObcPe63oCPf1mhBUh-Y3ARNMcPueF2dUttoWCyWv_KiG3VMIbguuOJHY=@negrel.dev>
In-Reply-To: <a8a832b9-bfa6-4c1e-bdcc-a89467add5d1@kernel.dk>
References: <20251229201933.515797-1-alexandre@negrel.dev> <a8a832b9-bfa6-4c1e-bdcc-a89467add5d1@kernel.dk>
Feedback-ID: 71418123:user:proton
X-Pm-Message-ID: 67f31fbf4ec9a768ec6adc9f25fc8f6c01a229ba
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tuesday, December 30th, 2025 at 1:23 AM, Jens Axboe <axboe@kernel.dk> wr=
ote:

> On 12/29/25 1:19 PM, Alexandre Negrel wrote:
>=20
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 6cb24cdf8e68..5ff1a13fed1c 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -545,31 +545,12 @@ void __io_commit_cqring_flush(struct io_ring_ctx =
*ctx)
> > io_eventfd_signal(ctx, true);
> > }
> >=20
> > -static inline void __io_cq_lock(struct io_ring_ctx *ctx)
> > -{
> > - if (!ctx->lockless_cq)
> > - spin_lock(&ctx->completion_lock);
> > -}
> > -
> > static inline void io_cq_lock(struct io_ring_ctx *ctx)
> > __acquires(ctx->completion_lock)
> > {
> > spin_lock(&ctx->completion_lock);
> > }
> >=20
> > -static inline void __io_cq_unlock_post(struct io_ring_ctx ctx)
> > -{
> > - io_commit_cqring(ctx);
> > - if (!ctx->task_complete) {
> > - if (!ctx->lockless_cq)
> > - spin_unlock(&ctx->completion_lock);
> > - / IOPOLL rings only need to wake up if it's also SQPOLL */
> > - if (!ctx->syscall_iopoll)
> > - io_cqring_wake(ctx);
> > - }
> > - io_commit_cqring_flush(ctx);
> > -}
> > -
> > static void io_cq_unlock_post(struct io_ring_ctx *ctx)
> > __releases(ctx->completion_lock)
> > {
> > @@ -1513,7 +1494,6 @@ void __io_submit_flush_completions(struct io_ring=
_ctx *ctx)
> > struct io_submit_state *state =3D &ctx->submit_state;
> > struct io_wq_work_node *node;
> >=20
> > - __io_cq_lock(ctx);
> > __wq_list_for_each(node, &state->compl_reqs) {
> > struct io_kiocb *req =3D container_of(node, struct io_kiocb,
> > comp_list);
> > @@ -1525,13 +1505,17 @@ void __io_submit_flush_completions(struct io_ri=
ng_ctx *ctx)
> > /
> > if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
> > unlikely(!io_fill_cqe_req(ctx, req))) {
> > - if (ctx->lockless_cq)
> > - io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
> > - else
> > - io_cqe_overflow_locked(ctx, &req->cqe, &req->big_cqe);
> > + io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
> > }
> > }
> > - __io_cq_unlock_post(ctx);
> > +
> > + io_commit_cqring(ctx);
> > + if (!ctx->task_complete) {
> > + / IOPOLL rings only need to wake up if it's also SQPOLL */
> > + if (!ctx->syscall_iopoll)
> > + io_cqring_wake(ctx);
> > + }
> > + io_commit_cqring_flush(ctx);
> >=20
> > if (!wq_list_empty(&state->compl_reqs)) {
> > io_free_batch_list(ctx, state->compl_reqs.first);
>=20
>=20
> You seem to just remove the lock around posting CQEs, and hence then it
> can use GFP_KERNEL? That's very broken... I'm assuming the issue here is
> that memcg will look at __GFP_HIGH somehow and allow it to proceed?
> Surely that should not stop OOM, just defer it?
>=20
> In any case, then below should then do the same. Can you test?
>=20
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 6cb24cdf8e68..709943fedaf4 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -864,7 +864,7 @@ static __cold bool io_cqe_overflow_locked(struct io_r=
ing_ctx *ctx,
> {
> struct io_overflow_cqe *ocqe;
>=20
> - ocqe =3D io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
> + ocqe =3D io_alloc_ocqe(ctx, cqe, big_cqe, GFP_NOWAIT);
> return io_cqring_add_overflow(ctx, ocqe);
> }
>=20
>=20
> --
> Jens Axboe

> You seem to just remove the lock around posting CQEs, and hence then it
> can use GFP_KERNEL? That's very broken...

This is my first time contributing to the linux kernel, sorry if my patch i=
s
broken.

> I'm assuming the issue here is that memcg will look at __GFP_HIGH somehow=
 and
> allow it to proceed?

Exactly, the allocation succeed even though it exceed cgroup limits. After
digging through try_charge_memcg(), it seems that OOM killer isn't involved
unless __GFP_DIRECT_RECLAIM bit is set (see gfpflags_allow_blocking).

https://github.com/torvalds/linux/blob/8640b74557fc8b4c300030f6ccb8cd078f66=
5ec8/mm/memcontrol.c#L2329
https://github.com/torvalds/linux/blob/8640b74557fc8b4c300030f6ccb8cd078f66=
5ec8/include/linux/gfp.h#L38

> In any case, then below should then do the same. Can you test?

I tried it and it seems to fix the issue but in a different way.
try_charge_memcg now returns -ENOMEM and the allocation failed. The complet=
ion
queue entry is "dropped on the floor" in io_cqring_add_overflow.

So I see 3 options here:
* use GFP_NOWAIT if dropping CQE is ok
* allocate using GFP_KERNEL_ACCOUNT without holding the lock then adding
  overflowing entries while holding the completion_lock (iterating twice ov=
er
  compl_reqs)
* charge memory after releasing the lock. I don't know if this is possible =
but
  doing kfree(kmalloc(1, GFP_KERNEL_ACCOUNT)) after releasing the lock does=
 the
  job (even though it's dirty).

Let me know what you think

Alexandre Negrel
https://www.negrel.dev/

