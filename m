Return-Path: <io-uring+bounces-11818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69371D3B634
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 19:51:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2AF293012746
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 18:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F23D38BF9A;
	Mon, 19 Jan 2026 18:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyphar.com header.i=@cyphar.com header.b="JNHelXAs"
X-Original-To: io-uring@vger.kernel.org
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3403C38B7AF
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 18:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768848694; cv=none; b=cPcxV+yuwa1h/RathbZnla5yATCHfTFjEyP06igzqx24v1iF3mrJoUlml1eBgyrR50IGYWomNwMMSSjL4SHAifxXmQk0G1HStA2/NGlfPr3grDe70VUCS3RD1R0fmBu0PCAiwdK4bD+EKM7mUpgcSlxqZDh/wlDze8XcjbvuRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768848694; c=relaxed/simple;
	bh=T6fIC6+wWXt7S2X6xXEbfRY0Q0ALRdlOxYangR4PImA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7Y/IRGcNLwD2c5xd2HXBDzYfJWr5iwA6GfaWErJyES/8/JSraQpLlq3zpFfFJrnlpHmCxPB8sFb4Iyy34jpnVIOBBBaquGms9SpCcnJeFhmJgr9t+XiW9515w0ZmyJSLr9KlOqUlBw+7fCMCJvObeER3ohXF2WNYulZCrQTsoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cyphar.com; spf=pass smtp.mailfrom=cyphar.com; dkim=pass (2048-bit key) header.d=cyphar.com header.i=@cyphar.com header.b=JNHelXAs; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cyphar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyphar.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4dw00t2HMnz9t0n;
	Mon, 19 Jan 2026 19:51:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
	t=1768848686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/f/y7ZWouIKPU5gJKvu2nHpvobhiF+1aj/ukmhevnOU=;
	b=JNHelXAsZ2puoTC79w5QG/zq8HwVfIjhaehVZzVAUWtdnNyAIDSzErO5EmAylwBUDyuAWA
	LtYbacXmMc3vSphPijYCqACjTwvhMdZe+P5ClcJMbFWYy5Fno6oUm6JXAiEgWzo6RlYZvO
	yb3zgmz5rV2RzlJc1grXerOLgX2tZpa/a6ZffdX2jGMaGEle3rHVbR5SpCIEmpNBRatbp5
	PVqFKo473jrzVQWo8nityDUx0U2pjsoa23u3DeC1vs397GMT0WTfl9wWyb4TjsuQVB56sF
	vFU+TaY14Zj9d2efhWVKTKWLo8oHoQ15d97KCo7yWZIkMRQpFladWJaHbWYBDw==
Date: Mon, 19 Jan 2026 19:51:21 +0100
From: Aleksa Sarai <cyphar@cyphar.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, brauner@kernel.org, 
	Kees Cook <kees@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 1/6] io_uring: add support for BPF filtering for opcode
 restrictions
Message-ID: <2026-01-19-tinted-shifty-storage-skulls-4614XX@cyphar.com>
References: <20260118172328.1067592-1-axboe@kernel.dk>
 <20260118172328.1067592-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uhbbdtny5n35hj3e"
Content-Disposition: inline
In-Reply-To: <20260118172328.1067592-2-axboe@kernel.dk>


--uhbbdtny5n35hj3e
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/6] io_uring: add support for BPF filtering for opcode
 restrictions
MIME-Version: 1.0

On 2026-01-18, Jens Axboe <axboe@kernel.dk> wrote:
> This adds support for loading BPF programs with io_uring, which can
> restrict the opcodes executed. Unlike IORING_REGISTER_RESTRICTIONS,
> using BPF programs allow fine grained control over both the opcode in
> question, as well as other data associated with the request. This
> initial patch just supports whatever is in the io_kiocb for filtering,
> but shortly opcode specific support will be added.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h           |   9 +
>  include/uapi/linux/io_uring.h            |   3 +
>  include/uapi/linux/io_uring/bpf_filter.h |  47 ++++
>  io_uring/Kconfig                         |   5 +
>  io_uring/Makefile                        |   1 +
>  io_uring/bpf_filter.c                    | 328 +++++++++++++++++++++++
>  io_uring/bpf_filter.h                    |  42 +++
>  io_uring/io_uring.c                      |   8 +
>  io_uring/register.c                      |   8 +
>  9 files changed, 451 insertions(+)
>  create mode 100644 include/uapi/linux/io_uring/bpf_filter.h
>  create mode 100644 io_uring/bpf_filter.c
>  create mode 100644 io_uring/bpf_filter.h
>=20
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 211686ad89fd..37f0a5f7b2f4 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -219,9 +219,18 @@ struct io_rings {
>  	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
>  };
> =20
> +struct io_bpf_filter;
> +struct io_bpf_filters {
> +	refcount_t refs;	/* ref for ->bpf_filters */
> +	spinlock_t lock;	/* protects ->bpf_filters modifications */
> +	struct io_bpf_filter __rcu **filters;
> +	struct rcu_head rcu_head;
> +};
> +
>  struct io_restriction {
>  	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
> +	struct io_bpf_filters *bpf_filters;
>  	u8 sqe_flags_allowed;
>  	u8 sqe_flags_required;
>  	/* IORING_OP_* restrictions exist */
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b5b23c0d5283..94669b77fee8 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -700,6 +700,9 @@ enum io_uring_register_op {
>  	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
>  	IORING_REGISTER_ZCRX_CTRL		=3D 36,
> =20
> +	/* register bpf filtering programs */
> +	IORING_REGISTER_BPF_FILTER		=3D 37,
> +
>  	/* this goes last */
>  	IORING_REGISTER_LAST,
> =20
> diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linu=
x/io_uring/bpf_filter.h
> new file mode 100644
> index 000000000000..14bd5b7468a7
> --- /dev/null
> +++ b/include/uapi/linux/io_uring/bpf_filter.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
> +/*
> + * Header file for the io_uring BPF filters.
> + */
> +#ifndef LINUX_IO_URING_BPF_FILTER_H
> +#define LINUX_IO_URING_BPF_FILTER_H
> +
> +#include <linux/types.h>
> +
> +struct io_uring_bpf_ctx {
> +	__u8	opcode;
> +	__u8	sqe_flags;
> +	__u8	pad[6];
> +	__u64	user_data;
> +	__u64	resv[6];
> +};

I had more envisioned this as operating on SQEs directly, not on an
intermediate representation.

I get why this is much simpler to deal with (operating on the SQE
directly is going to be racy as a malicious process could change the
argument values after the filters have run -- this is kind of like the
classic ptrace-seccomp hole), but since SQEs are a fixed size it seems
like the most natural analogue to seccomp's model.

While it is a tad ugly, AFAICS (looking at io_socket_prep) this would
also let you filter socket(2) directly which would obviate the need for
the second patch in this series.

That being said, if you do really want to go with a custom
representation, I would suggest including a size and making it variable
size so that filtering pointers (especially of extensible struct
syscalls like openat2) is more trivial to accomplish in the future. [1]
is the model we came up with for seccomp, which suffers from having to
deal with arbitrary syscall bodies but if you have your own
representation you can end up with something reasonably extensible
without the baggage.

[1]: https://www.youtube.com/watch?v=3DCHpLLR0CwSw

> +
> +enum {
> +	/*
> +	 * If set, any currently unset opcode will have a deny filter attached
> +	 */
> +	IO_URING_BPF_FILTER_DENY_REST	=3D 1,
> +};
> +
> +struct io_uring_bpf_filter {
> +	__u32	opcode;		/* io_uring opcode to filter */
> +	__u32	flags;
> +	__u32	filter_len;	/* number of BPF instructions */
> +	__u32	resv;
> +	__u64	filter_ptr;	/* pointer to BPF filter */
> +	__u64	resv2[5];
> +};

Since io_uring_bpf_ctx contains the opcode, it seems a little strange
that you would require userspace to set up a separate filter for every
opcode they wish to filter. seccomp lets you just have one filter for
all syscall numbers -- I can see the argument that this lets you build
optimised filters for each opcode but having to set up filters for 65
opcodes (at time of writing) seems less than optimal...

The optimisation seccomp uses for filters that simply blanket allow a
syscall is to pre-compute a cached bitmap of those syscalls to avoid
running the filter for those syscalls (see seccomp_cache_prepare). That
seems like a more practical solution which provides a similar (if not
better) optimisation for the allow-filter case.

Doing it this way would also remove the need for
IO_URING_BPF_FILTER_DENY_REST, because the filters could just implement
that themselves.

> +
> +enum {
> +	IO_URING_BPF_CMD_FILTER	=3D 1,
> +};
> +
> +struct io_uring_bpf {
> +	__u16	cmd_type;	/* IO_URING_BPF_* values */
> +	__u16	cmd_flags;	/* none so far */
> +	__u32	resv;
> +	union {
> +		struct io_uring_bpf_filter	filter;
> +	};
> +};
> +
> +#endif
> diff --git a/io_uring/Kconfig b/io_uring/Kconfig
> index 4b949c42c0bf..a7ae23cf1035 100644
> --- a/io_uring/Kconfig
> +++ b/io_uring/Kconfig
> @@ -9,3 +9,8 @@ config IO_URING_ZCRX
>  	depends on PAGE_POOL
>  	depends on INET
>  	depends on NET_RX_BUSY_POLL
> +
> +config IO_URING_BPF
> +	def_bool y
> +	depends on BPF
> +	depends on NET
> diff --git a/io_uring/Makefile b/io_uring/Makefile
> index bc4e4a3fa0a5..f3c505caa91e 100644
> --- a/io_uring/Makefile
> +++ b/io_uring/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+=3D napi.o
>  obj-$(CONFIG_NET) +=3D net.o cmd_net.o
>  obj-$(CONFIG_PROC_FS) +=3D fdinfo.o
>  obj-$(CONFIG_IO_URING_MOCK_FILE) +=3D mock_file.o
> +obj-$(CONFIG_IO_URING_BPF) +=3D bpf_filter.o
> diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
> new file mode 100644
> index 000000000000..48c7ea6f8d63
> --- /dev/null
> +++ b/io_uring/bpf_filter.c
> @@ -0,0 +1,328 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * BPF filter support for io_uring. Supports SQE opcodes for now.
> + */
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/io_uring.h>
> +#include <linux/filter.h>
> +#include <linux/bpf.h>
> +#include <uapi/linux/io_uring.h>
> +
> +#include "io_uring.h"
> +#include "bpf_filter.h"
> +#include "net.h"
> +
> +struct io_bpf_filter {
> +	struct bpf_prog		*prog;
> +	struct io_bpf_filter	*next;
> +};
> +
> +/* Deny if this is set as the filter */
> +static const struct io_bpf_filter dummy_filter;
> +
> +static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
> +				      struct io_kiocb *req)
> +{
> +	memset(bctx, 0, sizeof(*bctx));
> +	bctx->opcode =3D req->opcode;
> +	bctx->sqe_flags =3D (__force int) req->flags & SQE_VALID_FLAGS;
> +	bctx->user_data =3D req->cqe.user_data;
> +}
> +
> +/*
> + * Run registered filters for a given opcode. For filters, a return of 0=
 denies
> + * execution of the request, a return of 1 allows it. If any filter for =
an
> + * opcode returns 0, filter processing is stopped, and the request is de=
nied.
> + * This also stops the processing of filters.
> + *
> + * __io_uring_run_bpf_filters() returns 0 on success, allow running the
> + * request, and -EACCES when a request is denied.
> + */
> +int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kio=
cb *req)
> +{
> +	struct io_bpf_filter *filter;
> +	struct io_uring_bpf_ctx bpf_ctx;
> +	int ret;
> +
> +	/* Fast check for existence of filters outside of RCU */
> +	if (!rcu_access_pointer(res->bpf_filters->filters[req->opcode]))
> +		return 0;
> +
> +	/*
> +	 * req->opcode has already been validated to be within the range
> +	 * of what we expect, io_init_req() does this.
> +	 */
> +	rcu_read_lock();
> +	filter =3D rcu_dereference(res->bpf_filters->filters[req->opcode]);
> +	if (!filter) {
> +		ret =3D 1;
> +		goto out;
> +	} else if (filter =3D=3D &dummy_filter) {
> +		ret =3D 0;
> +		goto out;
> +	}
> +
> +	io_uring_populate_bpf_ctx(&bpf_ctx, req);
> +
> +	/*
> +	 * Iterate registered filters. The opcode is allowed IFF all filters
> +	 * return 1. If any filter returns denied, opcode will be denied.
> +	 */
> +	do {
> +		if (filter =3D=3D &dummy_filter)
> +			ret =3D 0;
> +		else
> +			ret =3D bpf_prog_run(filter->prog, &bpf_ctx);
> +		if (!ret)
> +			break;
> +		filter =3D filter->next;
> +	} while (filter);

I understand why you didn't want to replicate the messiness of seccomp's
arbitrary errno feature (it's almost certainly for the best), but maybe
it would be prudent to make the expected return values some special
(large) value so that you have some wiggle room for future expansion?

For instance, if you ever wanted to add support for logging (a-la
SECCOMP_RET_LOG) then it would need to be lower priority than blocking
the operation and you would need to have something like the logic in
seccomp_run_filters to return the highest priority filter return value.

(You could validate that the filter only returns IO_URING_BPF_RET_BLOCK
or 0 in the verifier.)

> +out:
> +	rcu_read_unlock();
> +	return ret ? 0 : -EACCES;
> +}
> +
> +static void io_free_bpf_filters(struct rcu_head *head)
> +{
> +	struct io_bpf_filter __rcu **filter;
> +	struct io_bpf_filters *filters;
> +	int i;
> +
> +	filters =3D container_of(head, struct io_bpf_filters, rcu_head);
> +	spin_lock(&filters->lock);
> +	filter =3D filters->filters;
> +	if (!filter) {
> +		spin_unlock(&filters->lock);
> +		return;
> +	}
> +	spin_unlock(&filters->lock);
> +
> +	for (i =3D 0; i < IORING_OP_LAST; i++) {
> +		struct io_bpf_filter *f;
> +
> +		rcu_read_lock();
> +		f =3D rcu_dereference(filter[i]);
> +		while (f) {
> +			struct io_bpf_filter *next =3D f->next;
> +
> +			/*
> +			 * Even if stacked, dummy filter will always be last
> +			 * as it can only get installed into an empty spot.
> +			 */
> +			if (f =3D=3D &dummy_filter)
> +				break;
> +			bpf_prog_destroy(f->prog);
> +			kfree(f);
> +			f =3D next;
> +		}
> +		rcu_read_unlock();
> +	}
> +	kfree(filters->filters);
> +	kfree(filters);
> +}
> +
> +static void __io_put_bpf_filters(struct io_bpf_filters *filters)
> +{
> +	if (refcount_dec_and_test(&filters->refs))
> +		call_rcu(&filters->rcu_head, io_free_bpf_filters);
> +}
> +
> +void io_put_bpf_filters(struct io_restriction *res)
> +{
> +	if (res->bpf_filters)
> +		__io_put_bpf_filters(res->bpf_filters);
> +}
> +
> +static struct io_bpf_filters *io_new_bpf_filters(void)
> +{
> +	struct io_bpf_filters *filters;
> +
> +	filters =3D kzalloc(sizeof(*filters), GFP_KERNEL_ACCOUNT);
> +	if (!filters)
> +		return ERR_PTR(-ENOMEM);
> +
> +	filters->filters =3D kcalloc(IORING_OP_LAST,
> +				   sizeof(struct io_bpf_filter *),
> +				   GFP_KERNEL_ACCOUNT);
> +	if (!filters->filters) {
> +		kfree(filters);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	refcount_set(&filters->refs, 1);
> +	spin_lock_init(&filters->lock);
> +	return filters;
> +}
> +
> +/*
> + * Validate classic BPF filter instructions. Only allow a safe subset of
> + * operations - no packet data access, just context field loads and basic
> + * ALU/jump operations.
> + */
> +static int io_uring_check_cbpf_filter(struct sock_filter *filter,
> +				      unsigned int flen)
> +{
> +	int pc;
> +
> +	for (pc =3D 0; pc < flen; pc++) {
> +		struct sock_filter *ftest =3D &filter[pc];
> +		u16 code =3D ftest->code;
> +		u32 k =3D ftest->k;
> +
> +		switch (code) {
> +		case BPF_LD | BPF_W | BPF_ABS:
> +			ftest->code =3D BPF_LDX | BPF_W | BPF_ABS;
> +			/* 32-bit aligned and not out of bounds. */
> +			if (k >=3D sizeof(struct io_uring_bpf_ctx) || k & 3)
> +				return -EINVAL;
> +			continue;
> +		case BPF_LD | BPF_W | BPF_LEN:
> +			ftest->code =3D BPF_LD | BPF_IMM;
> +			ftest->k =3D sizeof(struct io_uring_bpf_ctx);
> +			continue;
> +		case BPF_LDX | BPF_W | BPF_LEN:
> +			ftest->code =3D BPF_LDX | BPF_IMM;
> +			ftest->k =3D sizeof(struct io_uring_bpf_ctx);
> +			continue;
> +		/* Explicitly include allowed calls. */
> +		case BPF_RET | BPF_K:
> +		case BPF_RET | BPF_A:
> +		case BPF_ALU | BPF_ADD | BPF_K:
> +		case BPF_ALU | BPF_ADD | BPF_X:
> +		case BPF_ALU | BPF_SUB | BPF_K:
> +		case BPF_ALU | BPF_SUB | BPF_X:
> +		case BPF_ALU | BPF_MUL | BPF_K:
> +		case BPF_ALU | BPF_MUL | BPF_X:
> +		case BPF_ALU | BPF_DIV | BPF_K:
> +		case BPF_ALU | BPF_DIV | BPF_X:
> +		case BPF_ALU | BPF_AND | BPF_K:
> +		case BPF_ALU | BPF_AND | BPF_X:
> +		case BPF_ALU | BPF_OR | BPF_K:
> +		case BPF_ALU | BPF_OR | BPF_X:
> +		case BPF_ALU | BPF_XOR | BPF_K:
> +		case BPF_ALU | BPF_XOR | BPF_X:
> +		case BPF_ALU | BPF_LSH | BPF_K:
> +		case BPF_ALU | BPF_LSH | BPF_X:
> +		case BPF_ALU | BPF_RSH | BPF_K:
> +		case BPF_ALU | BPF_RSH | BPF_X:
> +		case BPF_ALU | BPF_NEG:
> +		case BPF_LD | BPF_IMM:
> +		case BPF_LDX | BPF_IMM:
> +		case BPF_MISC | BPF_TAX:
> +		case BPF_MISC | BPF_TXA:
> +		case BPF_LD | BPF_MEM:
> +		case BPF_LDX | BPF_MEM:
> +		case BPF_ST:
> +		case BPF_STX:
> +		case BPF_JMP | BPF_JA:
> +		case BPF_JMP | BPF_JEQ | BPF_K:
> +		case BPF_JMP | BPF_JEQ | BPF_X:
> +		case BPF_JMP | BPF_JGE | BPF_K:
> +		case BPF_JMP | BPF_JGE | BPF_X:
> +		case BPF_JMP | BPF_JGT | BPF_K:
> +		case BPF_JMP | BPF_JGT | BPF_X:
> +		case BPF_JMP | BPF_JSET | BPF_K:
> +		case BPF_JMP | BPF_JSET | BPF_X:
> +			continue;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +}
> +
> +#define IO_URING_BPF_FILTER_FLAGS	IO_URING_BPF_FILTER_DENY_REST
> +
> +int io_register_bpf_filter(struct io_restriction *res,
> +			   struct io_uring_bpf __user *arg)
> +{
> +	struct io_bpf_filter *filter, *old_filter;
> +	struct io_bpf_filters *filters;
> +	struct io_uring_bpf reg;
> +	struct bpf_prog *prog;
> +	struct sock_fprog fprog;
> +	int ret;
> +
> +	if (copy_from_user(&reg, arg, sizeof(reg)))
> +		return -EFAULT;
> +	if (reg.cmd_type !=3D IO_URING_BPF_CMD_FILTER)
> +		return -EINVAL;
> +	if (reg.cmd_flags || reg.resv)
> +		return -EINVAL;
> +
> +	if (reg.filter.opcode >=3D IORING_OP_LAST)
> +		return -EINVAL;
> +	if (reg.filter.flags & ~IO_URING_BPF_FILTER_FLAGS)
> +		return -EINVAL;
> +	if (reg.filter.resv)
> +		return -EINVAL;
> +	if (!mem_is_zero(reg.filter.resv2, sizeof(reg.filter.resv2)))
> +		return -EINVAL;
> +	if (!reg.filter.filter_len || reg.filter.filter_len > BPF_MAXINSNS)
> +		return -EINVAL;

Similar question to my other mail about copy_struct_from_user().

> +
> +	fprog.len =3D reg.filter.filter_len;
> +	fprog.filter =3D u64_to_user_ptr(reg.filter.filter_ptr);
> +
> +	ret =3D bpf_prog_create_from_user(&prog, &fprog,
> +					io_uring_check_cbpf_filter, false);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * No existing filters, allocate set.
> +	 */
> +	filters =3D res->bpf_filters;
> +	if (!filters) {
> +		filters =3D io_new_bpf_filters();
> +		if (IS_ERR(filters)) {
> +			ret =3D PTR_ERR(filters);
> +			goto err_prog;
> +		}
> +	}
> +
> +	filter =3D kzalloc(sizeof(*filter), GFP_KERNEL_ACCOUNT);
> +	if (!filter) {
> +		ret =3D -ENOMEM;
> +		goto err;
> +	}
> +	filter->prog =3D prog;
> +	res->bpf_filters =3D filters;
> +
> +	/*
> +	 * Insert filter - if the current opcode already has a filter
> +	 * attached, add to the set.
> +	 */
> +	rcu_read_lock();
> +	spin_lock_bh(&filters->lock);
> +	old_filter =3D rcu_dereference(filters->filters[reg.filter.opcode]);
> +	if (old_filter)
> +		filter->next =3D old_filter;
> +	rcu_assign_pointer(filters->filters[reg.filter.opcode], filter);
> +
> +	/*
> +	 * If IO_URING_BPF_FILTER_DENY_REST is set, fill any unregistered
> +	 * opcode with the dummy filter. That will cause them to be denied.
> +	 */
> +	if (reg.filter.flags & IO_URING_BPF_FILTER_DENY_REST) {
> +		for (int i =3D 0; i < IORING_OP_LAST; i++) {
> +			if (i =3D=3D reg.filter.opcode)
> +				continue;
> +			old_filter =3D rcu_dereference(filters->filters[i]);
> +			if (old_filter)
> +				continue;
> +			rcu_assign_pointer(filters->filters[i], &dummy_filter);
> +		}
> +	}
> +
> +	spin_unlock_bh(&filters->lock);
> +	rcu_read_unlock();
> +	return 0;
> +err:
> +	if (filters !=3D res->bpf_filters)
> +		__io_put_bpf_filters(filters);
> +err_prog:
> +	bpf_prog_destroy(prog);
> +	return ret;
> +}
> diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
> new file mode 100644
> index 000000000000..27eae9705473
> --- /dev/null
> +++ b/io_uring/bpf_filter.h
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef IO_URING_BPF_FILTER_H
> +#define IO_URING_BPF_FILTER_H
> +
> +#include <uapi/linux/io_uring/bpf_filter.h>
> +
> +#ifdef CONFIG_IO_URING_BPF
> +
> +int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kio=
cb *req);
> +
> +int io_register_bpf_filter(struct io_restriction *res,
> +			   struct io_uring_bpf __user *arg);
> +
> +void io_put_bpf_filters(struct io_restriction *res);
> +
> +static inline int io_uring_run_bpf_filters(struct io_restriction *res,
> +					   struct io_kiocb *req)
> +{
> +	if (res->bpf_filters)
> +		return __io_uring_run_bpf_filters(res, req);
> +
> +	return 0;
> +}
> +
> +#else
> +
> +static inline int io_register_bpf_filter(struct io_restriction *res,
> +					 struct io_uring_bpf __user *arg)
> +{
> +	return -EINVAL;
> +}
> +static inline int io_uring_run_bpf_filters(struct io_restriction *res,
> +					   struct io_kiocb *req)
> +{
> +	return 0;
> +}
> +static inline void io_put_bpf_filters(struct io_restriction *res)
> +{
> +}
> +#endif /* CONFIG_IO_URING_BPF */
> +
> +#endif
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 2cde22af78a3..67533e494836 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -93,6 +93,7 @@
>  #include "rw.h"
>  #include "alloc_cache.h"
>  #include "eventfd.h"
> +#include "bpf_filter.h"
> =20
>  #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
>  			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
> @@ -2261,6 +2262,12 @@ static inline int io_submit_sqe(struct io_ring_ctx=
 *ctx, struct io_kiocb *req,
>  	if (unlikely(ret))
>  		return io_submit_fail_init(sqe, req, ret);
> =20
> +	if (unlikely(ctx->restrictions.bpf_filters)) {
> +		ret =3D io_uring_run_bpf_filters(&ctx->restrictions, req);
> +		if (ret)
> +			return io_submit_fail_init(sqe, req, ret);
> +	}
> +
>  	trace_io_uring_submit_req(req);
> =20
>  	/*
> @@ -2850,6 +2857,7 @@ static __cold void io_ring_ctx_free(struct io_ring_=
ctx *ctx)
>  	percpu_ref_exit(&ctx->refs);
>  	free_uid(ctx->user);
>  	io_req_caches_free(ctx);
> +	io_put_bpf_filters(&ctx->restrictions);
> =20
>  	WARN_ON_ONCE(ctx->nr_req_allocated);
> =20
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 8551f13920dc..30957c2cb5eb 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -33,6 +33,7 @@
>  #include "memmap.h"
>  #include "zcrx.h"
>  #include "query.h"
> +#include "bpf_filter.h"
> =20
>  #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
>  				 IORING_REGISTER_LAST + IORING_OP_LAST)
> @@ -830,6 +831,13 @@ static int __io_uring_register(struct io_ring_ctx *c=
tx, unsigned opcode,
>  	case IORING_REGISTER_ZCRX_CTRL:
>  		ret =3D io_zcrx_ctrl(ctx, arg, nr_args);
>  		break;
> +	case IORING_REGISTER_BPF_FILTER:
> +		ret =3D -EINVAL;
> +
> +		if (nr_args !=3D 1)
> +			break;
> +		ret =3D io_register_bpf_filter(&ctx->restrictions, arg);
> +		break;
>  	default:
>  		ret =3D -EINVAL;
>  		break;
> --=20
> 2.51.0
>=20
>=20

--=20
Aleksa Sarai
https://www.cyphar.com/

--uhbbdtny5n35hj3e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQS2TklVsp+j1GPyqQYol/rSt+lEbwUCaW59KRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQKJf60rfpRG/0HwD/bZiQfE4oynffIKyhSwyb
9YZ29W7TYYXHxxBUeilGG9cBAPffmsoVLB9Iq3HgYSuQGgafbj+0xYcpAYofGvWf
wtAO
=uZ6s
-----END PGP SIGNATURE-----

--uhbbdtny5n35hj3e--

