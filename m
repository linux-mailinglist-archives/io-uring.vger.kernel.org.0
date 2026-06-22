Return-Path: <io-uring+bounces-13815-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id I7uHIFmVOWpbvQcAu9opvQ
	(envelope-from <io-uring+bounces-13815-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 22:04:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D746B234C
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 22:04:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0Z65KrMP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iETszE90;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1uDJ2xtz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PV5c+J4W;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13815-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13815-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 59C1D30210C4
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 20:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5D5723507B;
	Mon, 22 Jun 2026 20:04:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACF529D27D
	for <io-uring@vger.kernel.org>; Mon, 22 Jun 2026 20:04:35 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782158677; cv=none; b=i9Q3TKzx/faGEMh4rSaxJq4ljyEt50Ah+RKDvRbyQPww5MhQnXyGJBmY+HdOuG6UMox5s3JAe3zSNYG1naED+n8/QX5HGjV6wngCudNl98LRrNdm5bY1Pd2O4RnilWLl4yi5QLQ8yZv+wPqJVqBvflNdf8VRZzNX8/a1ypJcBrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782158677; c=relaxed/simple;
	bh=ax34Mm2Ug7TBtmvFu0ZPNofqnI2cRzVmpuoQy7ChFS4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cUHXFKp/UBKmDuoZjNBFd63SWOZZdxz/dDw+9yaXvmE1koG7Z3GHZlm+M7uBDjzhq5x753w14+euNQwjk4OPX1NRoo7+g4ErOVf398RlLk6p5HQKNCeSTg+ini3RL/t5tDXlU/r/x4ekKoh4YgL65DXKGSDITvXNHbTtptHIOmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0Z65KrMP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iETszE90; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1uDJ2xtz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PV5c+J4W; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E1B2F75DAF;
	Mon, 22 Jun 2026 20:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782158674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+VX6ZJ5oyzU9vu6Dyu7pFS1sghuqBTFoVYH+Nmk/Fc=;
	b=0Z65KrMPDMjMz3Vys6i2dJ4rtWNqZHDhwgnvysqoYFzJgJAhE1aWAZPqd7nFOpmTCWI6Xe
	8wU++O5KCsIStJvPnq0wu9vm7rAEMzaNgOZ5iLVz5b7QmfMmppna/EI9O3yqt61KdFY1+R
	gXDJfNpNHCc5EYWfCt4UgaqfUddI8m0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782158674;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+VX6ZJ5oyzU9vu6Dyu7pFS1sghuqBTFoVYH+Nmk/Fc=;
	b=iETszE90ApUnuwB8ObD6XzGdGlrvKelU2MHDwJRg/CYpV+ENmi5YLcWAMAwJ/HJ9XinJ+s
	BED38gjOIW7ZXHAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782158673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+VX6ZJ5oyzU9vu6Dyu7pFS1sghuqBTFoVYH+Nmk/Fc=;
	b=1uDJ2xtzNM9tnXIfjSIfgDLGOx7BTebz0n84zjzkiWLX0kHwDUDDtH3rroVrqt+1CGa45t
	WfDTNVMtNZU1ATKGFoZuCT55P8ytRorilp8x84FZ0x1feSJURrB4EZJXxkgt3snJhgksXp
	3tQtw6SJb8AmV3iNpQ0BhtqDE9S72yw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782158673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+VX6ZJ5oyzU9vu6Dyu7pFS1sghuqBTFoVYH+Nmk/Fc=;
	b=PV5c+J4Wluy3E6d87w1ihTPvWlkWozX3XXgjxAxjO8Cl71g7oKx74xvDMtfwnFQ7viIWhA
	aN2cBwvTD0m00OCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7535F779A8;
	Mon, 22 Jun 2026 20:04:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F7F2EFGVOWrBHAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 22 Jun 2026 20:04:33 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Harshal Chavan <harshal24.chavan@gmail.com>, io-uring@vger.kernel.org,
 axboe@kernel.dk
Cc: gregkh@linuxfoundation.org, kees@kernel.org, gustavoars@kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, Harshal
 Chavan <harshal24.chavan@gmail.com>
Subject: Re: [PATCH v4] io_uring/register: add IORING_REGISTER_CLONE_FILES
 opcode
In-Reply-To: <20260619093641.25339-1-harshal24.chavan@gmail.com>
Organization: SUSE
References: <20260619093641.25339-1-harshal24.chavan@gmail.com>
Date: Mon, 22 Jun 2026 16:04:27 -0400
Message-ID: <871pdyxrxw.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13815-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[linuxfoundation.org,kernel.org,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:harshal24.chavan@gmail.com,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:gregkh@linuxfoundation.org,m:kees@kernel.org,m:gustavoars@kernel.org,m:linux-kernel@vger.kernel.org,m:linux-hardening@vger.kernel.org,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.de:dkim,suse.de:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C9D746B234C

Harshal Chavan <harshal24.chavan@gmail.com> writes:

> Currently, if an application wants to duplicate registered file
> descriptors from one io_uring instance to another, it must manually
> unregister and re-register them, incurring unnecessary overhead.
>
> Add IORING_REGISTER_CLONE_FILES to allow direct cloning of the file
> table from a source ring to a destination ring. This implementation
> strictly mirrors the io_clone_buffers UAPI, supporting partial offsets
> and the IORING_REGISTER_DST_REPLACE flag.
>
> To ensure lock synchronization safety, destination nodes are strictly
> allocated as new, private io_rsrc_nodes rather than sharing references
> across rings.
>
> Signed-off-by: Harshal Chavan <harshal24.chavan@gmail.com>

Hello,

Do you have the liburing side and test cases?

A few comments inline.

> ---
>  include/uapi/linux/io_uring.h |  12 +++
>  io_uring/register.c           |   6 ++
>  io_uring/rsrc.c               | 149 ++++++++++++++++++++++++++++++++++
>  io_uring/rsrc.h               |   1 +
>  4 files changed, 168 insertions(+)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 909fb7aea638..0727602ce12f 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -723,6 +723,9 @@ enum io_uring_register_op {
>  	/* register bpf filtering programs */
>  	IORING_REGISTER_BPF_FILTER		= 37,
>  
> +	/* clone file descriptors from another ring*/
                                                   ^ spacing

> +	IORING_REGISTER_CLONE_FILES		= 38,
> +
>  	/* this goes last */
>  	IORING_REGISTER_LAST,
>  
> @@ -854,6 +857,15 @@ struct io_uring_clone_buffers {
>  	__u32	pad[3];
>  };
>  
> +struct io_uring_clone_files {
> +	__u32 src_fd;
> +	__u32 flags;
> +	__u32 src_off;
> +	__u32 dst_off;
> +	__u32 nr;
> +	__u32 pad[3];
> +};
> +
>  struct io_uring_buf {
>  	__u64	addr;
>  	__u32	len;
> diff --git a/io_uring/register.c b/io_uring/register.c
> index dce5e2f9cf77..bbc8c506ea2d 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -924,6 +924,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			break;
>  		ret = io_register_clone_buffers(ctx, arg);
>  		break;
> +	case IORING_REGISTER_CLONE_FILES:
> +		ret = -EINVAL;
> +		if (!arg || nr_args != 1)
> +			break;
> +		ret = io_register_clone_files(ctx, arg);
> +		break;
>  	case IORING_REGISTER_ZCRX_IFQ:
>  		ret = -EINVAL;
>  		if (!arg || nr_args != 1)
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 650303626be6..a598e5af4c0a 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1303,6 +1303,155 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
>  	return ret;
>  }
>  
> +static int io_clone_file_node(struct io_ring_ctx *ctx,
> +			      struct io_rsrc_node *src_node,
> +			      int dst_index,
> +			      struct io_file_table *new_table)
> +{
> +	struct io_rsrc_node *dst_node;
> +	struct file *file;
> +
> +	dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
> +	if (!dst_node)
> +		return -ENOMEM;
> +
> +	file = io_slot_file(src_node);
> +	get_file(file);
> +	io_fixed_file_set(dst_node, file);
> +
> +	new_table->data.nodes[dst_index] = dst_node;
> +	io_file_bitmap_set(new_table, dst_index);
> +
> +	return 0;
> +}
> +
> +static int io_clone_files(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
> +			  struct io_uring_clone_files *arg)
> +{
> +	struct io_file_table new_file_table;
> +	unsigned int dst_nr = ctx->file_table.data.nr;
> +	unsigned int src_nr = src_ctx->file_table.data.nr;
> +	unsigned int new_nr, i;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +	lockdep_assert_held(&src_ctx->uring_lock);
> +
> +	if (ctx->user != src_ctx->user || ctx->mm_account != src_ctx->mm_account)
> +		return -EINVAL;

I don't think it makes sense to check ->user here.  But is mm_account
necessary either?  How could you get the src_ctx from another process?

> +
> +	if (dst_nr && !(arg->flags & IORING_REGISTER_DST_REPLACE))
> +		return -EBUSY;
> +
> +	if (!src_nr)
> +		return -ENXIO;
> +
> +	if (!arg->nr)
> +		arg->nr = src_nr;
> +	else if (arg->nr > src_nr)
> +		return -EINVAL;
> +
> +	if (check_add_overflow(arg->src_off, arg->nr, &i) || i > src_nr)
> +		return -EINVAL;
> +	if (check_add_overflow(arg->dst_off, arg->nr, &i))
> +		return -EINVAL;
> +
> +	new_nr = max(dst_nr, arg->dst_off + arg->nr);
> +	if (new_nr > IORING_MAX_FIXED_FILES)
> +		return -EINVAL;
> +
> +	memset(&new_file_table, 0, sizeof(new_file_table));
> +	if (!io_alloc_file_tables(ctx, &new_file_table, new_nr))
> +		return -ENOMEM;
> +
> +	/* Copy original nodes from before the cloned range */
> +	for (i = 0; i < min(arg->dst_off, dst_nr); i++) {
> +		struct io_rsrc_node *src_node = io_rsrc_node_lookup(&ctx->file_table.data, i);
> +
> +		if (!src_node)
> +			continue;
> +		if (io_clone_file_node(ctx, src_node, i, &new_file_table))
> +			goto out;
> +	}
> +
> +	/* Copy the actual cloned range from the source ring */
> +	for (i = 0; i < arg->nr; i++) {
> +		struct io_rsrc_node *src_node = io_rsrc_node_lookup(&src_ctx->file_table.data,
> +				arg->src_off + i);
> +
> +		if (!src_node)
> +			continue;
> +		if (io_clone_file_node(ctx, src_node, arg->dst_off + i, &new_file_table))
> +			goto out;
> +	}
> +
> +	/* Copy original nodes from after the cloned range */
> +	for (i = arg->dst_off + arg->nr; i < dst_nr; i++) {
> +		struct io_rsrc_node *src_node = io_rsrc_node_lookup(&ctx->file_table.data, i);
> +
> +		if (!src_node)
> +			continue;
> +		if (io_clone_file_node(ctx, src_node, i, &new_file_table))
> +			goto out;
> +	}
> +
> +	/* free the old file table if there is any data present */
> +	if (dst_nr)
> +		io_free_file_tables(ctx, &ctx->file_table);
> +
> +	WARN_ON_ONCE(ctx->file_table.data.nr);
> +	ctx->file_table = new_file_table;
> +	io_file_table_set_alloc_range(ctx, 0, ctx->file_table.data.nr);
> +	return 0;
> +
> +out:
> +	/* Error Path: Safely destroy whatever we partially built */
> +	io_free_file_tables(ctx, &new_file_table);
> +	return -ENOMEM;
> +}
> +
> +int io_register_clone_files(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +	struct io_uring_clone_files clone_arg;
> +	struct io_ring_ctx *src_ctx;
> +	bool registered_src;
> +	struct file *file;
> +	int ret;
> +
> +	if (copy_from_user(&clone_arg, arg, sizeof(clone_arg)))
> +		return -EFAULT;
> +	if (clone_arg.flags &
> +	    ~(IORING_REGISTER_SRC_REGISTERED | IORING_REGISTER_DST_REPLACE))
> +		return -EINVAL;
> +
> +	if (memchr_inv(clone_arg.pad, 0, sizeof(clone_arg.pad)))
> +		return -EINVAL;
> +
> +	registered_src = (clone_arg.flags & IORING_REGISTER_SRC_REGISTERED) != 0;

This is better written as

registered_src = !!(clone_arg.flags & IORING_REGISTER_SRC_REGISTERED);

> +	file = io_uring_ctx_get_file(clone_arg.src_fd, registered_src);
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +
> +	src_ctx = file->private_data;
> +	/* Same ring clone is not allowed */
> +	if (src_ctx == ctx) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	mutex_unlock(&ctx->uring_lock);
> +	lock_two_rings(ctx, src_ctx);
> +
> +	ret = io_clone_files(ctx, src_ctx, &clone_arg);
> +
> +out:
> +	if (src_ctx != ctx)
> +		mutex_unlock(&src_ctx->uring_lock);

Make the mutex_unlock unconditionally above the out label.  It is never
locked in the error context.

-- 
Gabriel Krisman Bertazi

