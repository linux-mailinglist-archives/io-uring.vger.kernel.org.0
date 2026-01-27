Return-Path: <io-uring+bounces-11933-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0MF7EDaOeGmqqwEAu9opvQ
	(envelope-from <io-uring+bounces-11933-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:06:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1A80926B1
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:06:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9082B300491E
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279522E6CC8;
	Tue, 27 Jan 2026 10:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i59VNhM5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D312E06EF;
	Tue, 27 Jan 2026 10:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508402; cv=none; b=J/I/leG/S5CRY132kJG46UXrCwiuDa9jN6WcB5gqbD4U2gq/80VvcenyyHaoTBitInB1yaLi2LtkXxQ/FR8Uz/B3/grmEEtp4EyNRAGh9FyC3RC4V32efr9Ktf/hSsMrJq3FStToDvkpu/dUUe7+HpqzZ+ABHIdspSCGhHChstY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508402; c=relaxed/simple;
	bh=IKhI3uaNxbMlmWUhTz1obYo3QNWrH1RoEEY8kyv2YPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MG9Qs5UNwTnoYCsSpJlgrNYfLYXkGfPSSTAeGaaA+BtnVXn5SXu3S8sXvCj/FlFw6hz/CQsQM4+jfxLa2q+3e+jpGypoVWV00K/Tj0e9rMa11pITLurZCP77SooxEhQmKfFVuQ3vz2F8Ak4XM3ERrhYOly2tQj1aRkriRrSaU6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i59VNhM5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC3FC116C6;
	Tue, 27 Jan 2026 10:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769508401;
	bh=IKhI3uaNxbMlmWUhTz1obYo3QNWrH1RoEEY8kyv2YPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i59VNhM5ovVzwHafi8SRec4mhDHRdkiJGDYFN7FSZdihJeUmXXzkEgnES8BYfeTFq
	 vyahlt7uxEa7/u7NCNWPYlXTrdzrScpamEurf9GFkKIbga2IDaBCRCRvhpMvpaz9EC
	 PkSlszQkp3SUwiZEMt8XwRMtORxb9P3ytHfNLXzFtg1kd4cvQbHiZjWzokKbG83MEF
	 ggfBaDwY2tW6NsD1otC1bWT5zKpE21Ee1LviMbXlTxwiw7n2lQLp9jIOtJw4b/xNtg
	 HIbIuGLN7SpCW/Sq1vnNrUUlv0CKB+ZWtA/RYVwGot/zvPDaH1G8p4W2jNSYbu8A/E
	 yGoP/zD4HjcJg==
Date: Tue, 27 Jan 2026 11:06:37 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, jannh@google.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] io_uring: add support for BPF filtering for opcode
 restrictions
Message-ID: <20260127-lobgesang-lautsprecher-3805340711c8@brauner>
References: <20260119235456.1722452-1-axboe@kernel.dk>
 <20260119235456.1722452-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260119235456.1722452-2-axboe@kernel.dk>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11933-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D1A80926B1
X-Rspamd-Action: no action

On Mon, Jan 19, 2026 at 04:54:24PM -0700, Jens Axboe wrote:
> Add support for loading classic BPF programs with io_uring to provide
> fine-grained filtering of SQE operations. Unlike
> IORING_REGISTER_RESTRICTIONS which only allows bitmap-based allow/deny
> of opcodes, BPF filters can inspect request attributes and make dynamic
> decisions.
> 
> The filter is registered via IORING_REGISTER_BPF_FILTER with a struct
> io_uring_bpf:
> 
> struct io_uring_bpf_filter {
> 	__u32	opcode;		/* io_uring opcode to filter */
> 	__u32	flags;
> 	__u32	filter_len;	/* number of BPF instructions */
> 	__u32	resv;
> 	__u64	filter_ptr;	/* pointer to BPF filter */
> 	__u64	resv2[5];
> };
> 
> enum {
> 	IO_URING_BPF_CMD_FILTER	= 1,
> };
> 
> struct io_uring_bpf {
> 	__u16	cmd_type;	/* IO_URING_BPF_* values */
> 	__u16	cmd_flags;	/* none so far */
> 	__u32	resv;
> 	union {
> 		struct io_uring_bpf_filter	filter;
> 	};
> };
> 
> and the filters get supplied a struct io_uring_bpf_ctx:
> 
> struct io_uring_bpf_ctx {
> 	__u64	user_data;
> 	__u8	opcode;
> 	__u8	sqe_flags;
> 	__u8	pad[6];
> 	__u64	resv[6];
> };
> 
> where it's possible to filter on opcode and sqe_flags, with resv[6]
> being set aside for specific finer grained filtering inside an opcode.
> An example of that for sockets is in one of the following patches.
> Anything the opcode supports can end up in this struct, populated by
> the opcode itself, and hence can be filtered for.
> 
> Filters have the following semantics:
>   - Return 1 to allow the request
>   - Return 0 to deny the request with -EACCES
>   - Multiple filters can be stacked per opcode. All filters must
>     return 1 for the opcode to be allowed.
>   - Filters are evaluated in registration order (most recent first)
> 
> The implementation uses classic BPF (cBPF) rather than eBPF for as
> that's required for containers, and since they can be used by any
> user in the system.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h           |   9 +
>  include/uapi/linux/io_uring.h            |   3 +
>  include/uapi/linux/io_uring/bpf_filter.h |  50 ++++
>  io_uring/Kconfig                         |   5 +
>  io_uring/Makefile                        |   1 +
>  io_uring/bpf_filter.c                    | 329 +++++++++++++++++++++++
>  io_uring/bpf_filter.h                    |  42 +++
>  io_uring/io_uring.c                      |   8 +
>  io_uring/register.c                      |   8 +
>  9 files changed, 455 insertions(+)
>  create mode 100644 include/uapi/linux/io_uring/bpf_filter.h
>  create mode 100644 io_uring/bpf_filter.c
>  create mode 100644 io_uring/bpf_filter.h
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 211686ad89fd..37f0a5f7b2f4 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -219,9 +219,18 @@ struct io_rings {
>  	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
>  };
>  
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
>  	IORING_REGISTER_ZCRX_CTRL		= 36,
>  
> +	/* register bpf filtering programs */
> +	IORING_REGISTER_BPF_FILTER		= 37,
> +
>  	/* this goes last */
>  	IORING_REGISTER_LAST,
>  
> diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
> new file mode 100644
> index 000000000000..8334a40e0f06
> --- /dev/null
> +++ b/include/uapi/linux/io_uring/bpf_filter.h
> @@ -0,0 +1,50 @@
> +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
> +/*
> + * Header file for the io_uring BPF filters.
> + */
> +#ifndef LINUX_IO_URING_BPF_FILTER_H
> +#define LINUX_IO_URING_BPF_FILTER_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * Struct passed to filters.
> + */
> +struct io_uring_bpf_ctx {
> +	__u64	user_data;
> +	__u8	opcode;
> +	__u8	sqe_flags;
> +	__u8	pad[6];
> +	__u64	resv[6];
> +};
> +
> +enum {
> +	/*
> +	 * If set, any currently unset opcode will have a deny filter attached
> +	 */
> +	IO_URING_BPF_FILTER_DENY_REST	= 1,
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
> +
> +enum {
> +	IO_URING_BPF_CMD_FILTER	= 1,
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
> @@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
>  obj-$(CONFIG_NET) += net.o cmd_net.o
>  obj-$(CONFIG_PROC_FS) += fdinfo.o
>  obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
> +obj-$(CONFIG_IO_URING_BPF) += bpf_filter.o
> diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
> new file mode 100644
> index 000000000000..08ca30545228
> --- /dev/null
> +++ b/io_uring/bpf_filter.c
> @@ -0,0 +1,329 @@
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
> +	bctx->opcode = req->opcode;
> +	bctx->sqe_flags = (__force int) req->flags & SQE_VALID_FLAGS;
> +	bctx->user_data = req->cqe.user_data;
> +	/* clear residual */
> +	memset(bctx->pad, 0, sizeof(bctx->pad) + sizeof(bctx->resv));
> +}
> +
> +/*
> + * Run registered filters for a given opcode. For filters, a return of 0 denies
> + * execution of the request, a return of 1 allows it. If any filter for an
> + * opcode returns 0, filter processing is stopped, and the request is denied.
> + * This also stops the processing of filters.
> + *
> + * __io_uring_run_bpf_filters() returns 0 on success, allow running the
> + * request, and -EACCES when a request is denied.
> + */
> +int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
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
> +	filter = rcu_dereference(res->bpf_filters->filters[req->opcode]);
> +	if (!filter) {
> +		ret = 1;
> +		goto out;
> +	} else if (filter == &dummy_filter) {
> +		ret = 0;
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
> +		if (filter == &dummy_filter)
> +			ret = 0;
> +		else
> +			ret = bpf_prog_run(filter->prog, &bpf_ctx);
> +		if (!ret)
> +			break;
> +		filter = filter->next;
> +	} while (filter);
> +out:
> +	rcu_read_unlock();
> +	return ret ? 0 : -EACCES;
> +}

Maybe we can write this a little nicer?:

int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
{
	struct io_bpf_filter *filter;
	struct io_uring_bpf_ctx bpf_ctx;

	/* Fast check for existence of filters outside of RCU */
	if (!rcu_access_pointer(res->bpf_filters->filters[req->opcode]))
		return 0;

	/*
	 * req->opcode has already been validated to be within the range
	 * of what we expect, io_init_req() does this.
	 */
	guard(rcu)();
	filter = rcu_dereference(res->bpf_filters->filters[req->opcode]);
	if (!filter)
		return 0;

	if (filter == &dummy_filter)
		return -EACCES;

	io_uring_populate_bpf_ctx(&bpf_ctx, req);

	/*
	 * Iterate registered filters. The opcode is allowed IFF all filters
	 * return 1. If any filter returns denied, opcode will be denied.
	 */
	for (; filter ; filter = filter->next) {
		int ret;

		if (filter == &dummy_filter)
			return -EACCES;

		ret = bpf_prog_run(filter->prog, &bpf_ctx);
		if (!ret)
			return -EACCES;
	}

	return 0;
}

> +
> +static void io_free_bpf_filters(struct rcu_head *head)
> +{
> +	struct io_bpf_filter __rcu **filter;
> +	struct io_bpf_filters *filters;
> +	int i;
> +
> +	filters = container_of(head, struct io_bpf_filters, rcu_head);
> +	spin_lock(&filters->lock);
> +	filter = filters->filters;
> +	if (!filter) {
> +		spin_unlock(&filters->lock);
> +		return;
> +	}
> +	spin_unlock(&filters->lock);

This is minor but I prefer:

	scoped_guard(spinlock)(&filters->lock) {
		filters = container_of(head, struct io_bpf_filters, rcu_head);
		filter = filters->filters;
		if (!filter)
			return;
	}

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
> +	filters = kzalloc(sizeof(*filters), GFP_KERNEL_ACCOUNT);
> +	if (!filters)
> +		return ERR_PTR(-ENOMEM);
> +
> +	filters->filters = kcalloc(IORING_OP_LAST,
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

static struct io_bpf_filters *io_new_bpf_filters(void)
{
	struct io_bpf_filters *filters __free(kfree) = NULL;

	filters = kzalloc(sizeof(*filters), GFP_KERNEL_ACCOUNT);
	if (!filters)
		return ERR_PTR(-ENOMEM);

	filters->filters = kcalloc(IORING_OP_LAST,
				   sizeof(struct io_bpf_filter *),
				   GFP_KERNEL_ACCOUNT);
	if (!filters->filters)
		return ERR_PTR(-ENOMEM);

	refcount_set(&filters->refs, 1);
	spin_lock_init(&filters->lock);
	return no_free_ptr(filters);
}

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

Seems fine to me but I can't meaningfully review this.

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
> +	if (reg.cmd_type != IO_URING_BPF_CMD_FILTER)
> +		return -EINVAL;
> +	if (reg.cmd_flags || reg.resv)
> +		return -EINVAL;
> +
> +	if (reg.filter.opcode >= IORING_OP_LAST)
> +		return -EINVAL;

So you only support per-op-code filtering with cbpf. I assume that you
would argue that people can use the existing io_uring restrictions. But
that's not inherited, right? So then this forces users to have a bpf
program for all opcodes that io_uring on their system supports.

I think that this is a bit unfortunate and wasteful for both userspace
and io_uring. Can't we do a combined thing where we also allow filters
to attach to all op-codes. Then userspace could start with an allow-list
or deny-list filter and then attach further per-op-code bpf programs to
the op-codes they want to manage specifically. Then you also get
inheritance of the restrictions per-task.

That would be nicer imho.

