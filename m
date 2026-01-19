Return-Path: <io-uring+bounces-11816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2C8D3B4EE
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 18:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F2343043935
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 17:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932DA26C39E;
	Mon, 19 Jan 2026 17:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyphar.com header.i=@cyphar.com header.b="gCnis/iF"
X-Original-To: io-uring@vger.kernel.org
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74941224AF0
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768845310; cv=none; b=FmHBb9WkHLaFcuQQ/wmIqJXxkoBiyhtBj6wDq7DjVN+eu5ApG7gTpXf8qfR5HFhj1S8G9b7OUjY0pcoygP2lTWh4AyDsnKUTvI9N8/oEup2VIMPC2N47d9bW3wFs417ZnIzWj62Sme2DrcWTmgyG+lwCg+uzlRhMVxx+KwNDQls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768845310; c=relaxed/simple;
	bh=zmRfWYvn5kXmGhkESo02tZpAvZ/DPYevZw5EFr0IPDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvJZu0okZZXEhRFMD4VP1W17JM4R1pxqKJdZNHJc2UM1KhuFXp2v07l+pl8Yop7F442SXjwjnqsueRXVwtTSnNSeCJfCuCn0zrp+Jl/RqGt4UqaKwL8ByCHQgDZq5pS6awoi/4ooKHKjpWsmkBLGcpxQPjTgWzPBBb9BP4VlGVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cyphar.com; spf=pass smtp.mailfrom=cyphar.com; dkim=pass (2048-bit key) header.d=cyphar.com header.i=@cyphar.com header.b=gCnis/iF; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cyphar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyphar.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4dvylg6hBxz9tyf;
	Mon, 19 Jan 2026 18:54:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
	t=1768845296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fCTHj6lkkig8ze/G9xtprzSIJZ5duy/YriJATrynzSI=;
	b=gCnis/iFYT6EypxCFcEweSYBW1xG/wSwMyi/nE/Mvr6ayQ2PBGDlb7e5TMk+p7SUN2jZnp
	bWuBI6cl56W0hrWbB89S0Z3ITBgbUD03Ukv56tvGScl+H5Mb1rMdn0EbMV20vFe+Jj8/Qa
	Q88X4kOQQrqWFfnoUIl56G0eez5BLLvK5EaCTxIdM/i9TR1Ybv8jUYNQ6cGFZmB93WRaE7
	zYmLiwO4FCQLN87tQLwXVNTf2jgf1iliTG/aItBfivH79gjVnLgR53TSbwAMFdzsRVJBKp
	NNwsvJsQ7dpiCoHOviSiOVRt3DEjPev4cEZJgN7gQrr0WwnqB4oW5qai4tMnGQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of cyphar@cyphar.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=cyphar@cyphar.com
Date: Mon, 19 Jan 2026 18:54:52 +0100
From: Aleksa Sarai <cyphar@cyphar.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, brauner@kernel.org, 
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 6/6] io_uring: allow registration of per-task restrictions
Message-ID: <2026-01-19-undead-spiral-scalpel-grandson-R0Uhz9@cyphar.com>
References: <20260118172328.1067592-1-axboe@kernel.dk>
 <20260118172328.1067592-7-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6ngpeux4x727wsrc"
Content-Disposition: inline
In-Reply-To: <20260118172328.1067592-7-axboe@kernel.dk>
X-Rspamd-Queue-Id: 4dvylg6hBxz9tyf


--6ngpeux4x727wsrc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6/6] io_uring: allow registration of per-task restrictions
MIME-Version: 1.0

On 2026-01-18, Jens Axboe <axboe@kernel.dk> wrote:
> Currently io_uring supports restricting operations on a per-ring basis.
> To use those, the ring must be setup in a disabled state by setting
> IORING_SETUP_R_DISABLED. Then restrictions can be set for the ring, and
> the ring can then be enabled.
>=20
> This commit adds support for IORING_REGISTER_RESTRICTIONS with ring_fd
> =3D=3D -1, like the other "blind" register opcodes which work on the task
> rather than a specific ring. This allows registration of the same kind
> of restrictions as can been done on a specific ring, but with the task
> itself. Once done, any ring created will inherit these restrictions.
>=20
> If a restriction filter is registered with a task, then it's inherited
> on fork for its children. Children may only further restrict operations,
> not extend them.
>=20
> Inheriting restrictions include both the classic
> IORING_REGISTER_RESTRICTIONS based restrictions, as well as the BPF
> filters that have been registered with the task via
> IORING_REGISTER_BPF_FILTER.

Adding Kees and Jann to Cc, since this is pretty much the "seccomp but
for io_uring" stuff that has been discussed quite a few times. (Though I
guess they'll find this thread from LWN soon enough.)

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  2 +
>  include/uapi/linux/io_uring.h  |  7 +++
>  io_uring/bpf_filter.c          | 86 +++++++++++++++++++++++++++++++++-
>  io_uring/bpf_filter.h          |  6 +++
>  io_uring/io_uring.c            | 33 +++++++++++++
>  io_uring/io_uring.h            |  1 +
>  io_uring/register.c            | 65 +++++++++++++++++++++++++
>  io_uring/tctx.c                | 17 +++++++
>  8 files changed, 216 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 366927635277..15ed7fa2bca3 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -231,6 +231,8 @@ struct io_restriction {
>  	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
>  	struct io_bpf_filters *bpf_filters;
> +	/* ->bpf_filters needs COW on modification */
> +	bool bpf_filters_cow;
>  	u8 sqe_flags_allowed;
>  	u8 sqe_flags_required;
>  	/* IORING_OP_* restrictions exist */
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 94669b77fee8..aeeffcf27fee 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -808,6 +808,13 @@ struct io_uring_restriction {
>  	__u32 resv2[3];
>  };
> =20
> +struct io_uring_task_restriction {
> +	__u16 flags;
> +	__u16 nr_res;
> +	__u32 resv[3];
> +	__DECLARE_FLEX_ARRAY(struct io_uring_restriction, restrictions);
> +};
> +
>  struct io_uring_clock_register {
>  	__u32	clockid;
>  	__u32	__resv[3];
> diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
> index 545acd480ffd..b3a66b4793b3 100644
> --- a/io_uring/bpf_filter.c
> +++ b/io_uring/bpf_filter.c
> @@ -249,13 +249,77 @@ static int io_uring_check_cbpf_filter(struct sock_f=
ilter *filter,
>  	return 0;
>  }
> =20
> +void io_bpf_filter_clone(struct io_restriction *dst, struct io_restricti=
on *src)
> +{
> +	if (!src->bpf_filters)
> +		return;
> +
> +	rcu_read_lock();
> +	/*
> +	 * If the src filter is going away, just ignore it.
> +	 */
> +	if (refcount_inc_not_zero(&src->bpf_filters->refs)) {
> +		dst->bpf_filters =3D src->bpf_filters;
> +		dst->bpf_filters_cow =3D true;
> +	}
> +	rcu_read_unlock();
> +}
> +
> +/*
> + * Allocate a new struct io_bpf_filters. Used when a filter is cloned and
> + * modifications need to be made.
> + */
> +static struct io_bpf_filters *io_bpf_filter_cow(struct io_restriction *s=
rc)
> +{
> +	struct io_bpf_filters *filters;
> +	struct io_bpf_filter *srcf;
> +	int i;
> +
> +	filters =3D io_new_bpf_filters();
> +	if (IS_ERR(filters))
> +		return filters;
> +
> +	/*
> +	 * Iterate filters from src and assign in destination. Grabbing
> +	 * a reference is enough, we don't need to duplicate the memory.
> +	 * This is safe because filters are only ever appended to the
> +	 * front of the list, hence the only memory ever touched inside
> +	 * a filter is the refcount.
> +	 */
> +	rcu_read_lock();
> +	for (i =3D 0; i < IORING_OP_LAST; i++) {
> +		srcf =3D rcu_dereference(src->bpf_filters->filters[i]);
> +		if (!srcf) {
> +			continue;
> +		} else if (srcf =3D=3D &dummy_filter) {
> +			rcu_assign_pointer(filters->filters[i], &dummy_filter);
> +			continue;
> +		}
> +
> +		/*
> +		 * Getting a ref on the first node is enough, putting the
> +		 * filter and iterating nodes to free will stop on the first
> +		 * one that doesn't hit zero when dropping.
> +		 */
> +		if (!refcount_inc_not_zero(&srcf->refs))
> +			goto err;
> +		rcu_assign_pointer(filters->filters[i], srcf);
> +	}
> +	rcu_read_unlock();
> +	return filters;
> +err:
> +	rcu_read_unlock();
> +	__io_put_bpf_filters(filters);
> +	return ERR_PTR(-EBUSY);
> +}
> +
>  #define IO_URING_BPF_FILTER_FLAGS	IO_URING_BPF_FILTER_DENY_REST
> =20
>  int io_register_bpf_filter(struct io_restriction *res,
>  			   struct io_uring_bpf __user *arg)
>  {
> +	struct io_bpf_filters *filters, *old_filters =3D NULL;
>  	struct io_bpf_filter *filter, *old_filter;
> -	struct io_bpf_filters *filters;
>  	struct io_uring_bpf reg;
>  	struct bpf_prog *prog;
>  	struct sock_fprog fprog;
> @@ -297,6 +361,17 @@ int io_register_bpf_filter(struct io_restriction *re=
s,
>  			ret =3D PTR_ERR(filters);
>  			goto err_prog;
>  		}
> +	} else if (res->bpf_filters_cow) {
> +		filters =3D io_bpf_filter_cow(res);
> +		if (IS_ERR(filters)) {
> +			ret =3D PTR_ERR(filters);
> +			goto err_prog;
> +		}
> +		/*
> +		 * Stash old filters, we'll put them once we know we'll
> +		 * succeed. Until then, res->bpf_filters is left untouched.
> +		 */
> +		old_filters =3D res->bpf_filters;
>  	}
> =20
>  	filter =3D kzalloc(sizeof(*filter), GFP_KERNEL_ACCOUNT);
> @@ -306,6 +381,15 @@ int io_register_bpf_filter(struct io_restriction *re=
s,
>  	}
>  	refcount_set(&filter->refs, 1);
>  	filter->prog =3D prog;
> +
> +	/*
> +	 * Success - install the new filter set now. If we did COW, put
> +	 * the old filters as we're replacing them.
> +	 */
> +	if (old_filters) {
> +		__io_put_bpf_filters(old_filters);
> +		res->bpf_filters_cow =3D false;
> +	}
>  	res->bpf_filters =3D filters;
> =20
>  	/*
> diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
> index 9f3cdb92eb16..66a776cf25b4 100644
> --- a/io_uring/bpf_filter.h
> +++ b/io_uring/bpf_filter.h
> @@ -13,6 +13,8 @@ int io_register_bpf_filter(struct io_restriction *res,
> =20
>  void io_put_bpf_filters(struct io_restriction *res);
> =20
> +void io_bpf_filter_clone(struct io_restriction *dst, struct io_restricti=
on *src);
> +
>  static inline int io_uring_run_bpf_filters(struct io_bpf_filter __rcu **=
filters,
>  					   struct io_kiocb *req)
>  {
> @@ -37,6 +39,10 @@ static inline int io_uring_run_bpf_filters(struct io_b=
pf_filter __rcu **filters,
>  static inline void io_put_bpf_filters(struct io_restriction *res)
>  {
>  }
> +static inline void io_bpf_filter_clone(struct io_restriction *dst,
> +				       struct io_restriction *src)
> +{
> +}
>  #endif /* CONFIG_IO_URING_BPF */
> =20
>  #endif
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 62aeaf0fad74..e190827d2436 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3569,6 +3569,32 @@ int io_prepare_config(struct io_ctx_config *config)
>  	return 0;
>  }
> =20
> +void io_restriction_clone(struct io_restriction *dst, struct io_restrict=
ion *src)
> +{
> +	memcpy(&dst->register_op, &src->register_op, sizeof(dst->register_op));
> +	memcpy(&dst->sqe_op, &src->sqe_op, sizeof(dst->sqe_op));
> +	dst->sqe_flags_allowed =3D src->sqe_flags_allowed;
> +	dst->sqe_flags_required =3D src->sqe_flags_required;
> +	dst->op_registered =3D src->op_registered;
> +	dst->reg_registered =3D src->reg_registered;
> +
> +	io_bpf_filter_clone(dst, src);
> +}
> +
> +static void io_ctx_restriction_clone(struct io_ring_ctx *ctx,
> +				     struct io_restriction *src)
> +{
> +	struct io_restriction *dst =3D &ctx->restrictions;
> +
> +	io_restriction_clone(dst, src);
> +	if (dst->bpf_filters)
> +		WRITE_ONCE(ctx->bpf_filters, dst->bpf_filters->filters);
> +	if (dst->op_registered)
> +		ctx->op_restricted =3D 1;
> +	if (dst->reg_registered)
> +		ctx->reg_restricted =3D 1;
> +}
> +
>  static __cold int io_uring_create(struct io_ctx_config *config)
>  {
>  	struct io_uring_params *p =3D &config->p;
> @@ -3629,6 +3655,13 @@ static __cold int io_uring_create(struct io_ctx_co=
nfig *config)
>  	else
>  		ctx->notify_method =3D TWA_SIGNAL;
> =20
> +	/*
> +	 * If the current task has restrictions enabled, then copy them to
> +	 * our newly created ring and mark it as registered.
> +	 */
> +	if (current->io_uring_restrict)
> +		io_ctx_restriction_clone(ctx, current->io_uring_restrict);
> +
>  	/*
>  	 * This is just grabbed for accounting purposes. When a process exits,
>  	 * the mm is exited and dropped before the files, hence we need to hang
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index c5bbb43b5842..feb9f76761e9 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -195,6 +195,7 @@ void io_task_refs_refill(struct io_uring_task *tctx);
>  bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
> =20
>  void io_activate_pollwq(struct io_ring_ctx *ctx);
> +void io_restriction_clone(struct io_restriction *dst, struct io_restrict=
ion *src);
> =20
>  static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
>  {
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 40de9b8924b9..e8a68b04a6f4 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -190,6 +190,67 @@ static __cold int io_register_restrictions(struct io=
_ring_ctx *ctx,
>  	return 0;
>  }
> =20
> +static int io_register_restrictions_task(void __user *arg, unsigned int =
nr_args)
> +{
> +	struct io_uring_task_restriction __user *ures =3D arg;
> +	struct io_uring_task_restriction tres;
> +	struct io_restriction *res;
> +	int ret;

You almost certainly want to copy the seccomp logic of disallowing the
setting of restrictions unless no_new_privs is set or the process has
CAP_SYS_ADMIN.

While seccomp is more dangerous in this respect (as it allows you to
modify the return value of a syscall), being able to alter the execution
of setuid binaries usually leads to security issues, so it's probably
best to just copy what seccomp does here.

> +	/* Disallow if task already has registered restrictions */
> +	if (current->io_uring_restrict)
> +		return -EPERM;

I guess specifying "stacked" restrictions (a-la seccomp) is intended as
future work?

This is kind of critical for both nesting use-cases and for making this
usable more widely (I imagine systemd will want to set system-wide
restrictions which would lock out programs from being able to set their
own process-wide restrictions -- nested containers are also a fairly
common use-case these days too).

(For containers we would probably only really use the cBPF stuff but it
would be nice for them to both be stackable -- if only for the reason
that you could set them in any order.)

> +	if (nr_args !=3D 1)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&tres, arg, sizeof(tres)))
> +		return -EFAULT;
> +
> +	if (tres.flags)
> +		return -EINVAL;
> +	if (!mem_is_zero(tres.resv, sizeof(tres.resv)))
> +		return -EINVAL;

I would suggest using copy_struct_from_user() to make extensions easier,
but I don't know if that is the kind of thing you feel necessary for
io_uring APIs.

> +
> +	res =3D kzalloc(sizeof(*res), GFP_KERNEL_ACCOUNT);
> +	if (!res)
> +		return -ENOMEM;
> +
> +	ret =3D io_parse_restrictions(ures->restrictions, tres.nr_res, res);
> +	if (ret < 0) {
> +		kfree(res);
> +		return ret;
> +	}
> +	current->io_uring_restrict =3D res;
> +	return 0;
> +}
> +
> +static int io_register_bpf_filter_task(void __user *arg, unsigned int nr=
_args)
> +{
> +	struct io_restriction *res;
> +	int ret;
> +
> +	if (nr_args !=3D 1)
> +		return -EINVAL;

Same comment as above about no_new_privs / CAP_SYS_ADMIN.

> +
> +	/* If no task restrictions exist, setup a new set */
> +	res =3D current->io_uring_restrict;
> +	if (!res) {
> +		res =3D kzalloc(sizeof(*res), GFP_KERNEL_ACCOUNT);
> +		if (!res)
> +			return -ENOMEM;
> +	}
> +
> +	ret =3D io_register_bpf_filter(res, arg);
> +	if (ret) {
> +		if (res !=3D current->io_uring_restrict)
> +			kfree(res);
> +		return ret;
> +	}
> +	if (!current->io_uring_restrict)
> +		current->io_uring_restrict =3D res;
> +	return 0;
> +}
> +
>  static int io_register_enable_rings(struct io_ring_ctx *ctx)
>  {
>  	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
> @@ -912,6 +973,10 @@ static int io_uring_register_blind(unsigned int opco=
de, void __user *arg,
>  		return io_uring_register_send_msg_ring(arg, nr_args);
>  	case IORING_REGISTER_QUERY:
>  		return io_query(arg, nr_args);
> +	case IORING_REGISTER_RESTRICTIONS:
> +		return io_register_restrictions_task(arg, nr_args);
> +	case IORING_REGISTER_BPF_FILTER:
> +		return io_register_bpf_filter_task(arg, nr_args);
>  	}
>  	return -EINVAL;
>  }
> diff --git a/io_uring/tctx.c b/io_uring/tctx.c
> index d4f7698805e4..e3da31fdf16f 100644
> --- a/io_uring/tctx.c
> +++ b/io_uring/tctx.c
> @@ -11,6 +11,7 @@
> =20
>  #include "io_uring.h"
>  #include "tctx.h"
> +#include "bpf_filter.h"
> =20
>  static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
>  					struct task_struct *task)
> @@ -66,6 +67,11 @@ void __io_uring_free(struct task_struct *tsk)
>  		kfree(tctx);
>  		tsk->io_uring =3D NULL;
>  	}
> +	if (tsk->io_uring_restrict) {
> +		io_put_bpf_filters(tsk->io_uring_restrict);
> +		kfree(tsk->io_uring_restrict);
> +		tsk->io_uring_restrict =3D NULL;
> +	}
>  }
> =20
>  __cold int io_uring_alloc_task_context(struct task_struct *task,
> @@ -356,5 +362,16 @@ int io_ringfd_unregister(struct io_ring_ctx *ctx, vo=
id __user *__arg,
> =20
>  int __io_uring_fork(struct task_struct *tsk)
>  {
> +	struct io_restriction *res, *src =3D tsk->io_uring_restrict;
> +
> +	/* Don't leave it dangling on error */
> +	tsk->io_uring_restrict =3D NULL;
> +
> +	res =3D kzalloc(sizeof(*res), GFP_KERNEL_ACCOUNT);
> +	if (!res)
> +		return -ENOMEM;
> +
> +	tsk->io_uring_restrict =3D res;
> +	io_restriction_clone(res, src);
>  	return 0;
>  }
> --=20
> 2.51.0
>=20
>=20

--=20
Aleksa Sarai
https://www.cyphar.com/

--6ngpeux4x727wsrc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQS2TklVsp+j1GPyqQYol/rSt+lEbwUCaW5v6RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQKJf60rfpRG9OvQEA0QuniVvD/Ym/yyZqzod6
2rMo1z306CHKZeQerj77aBoBAMQZs/DLUccQcCMpH56j7I66apZHMJRMSzqwBsgH
AbYF
=MZRT
-----END PGP SIGNATURE-----

--6ngpeux4x727wsrc--

