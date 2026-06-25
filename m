Return-Path: <io-uring+bounces-13840-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id aJPdFbSQPWqL4AgAu9opvQ
	(envelope-from <io-uring+bounces-13840-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 22:33:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDBA36C8862
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 22:33:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LZESkP17;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BqCyE1WD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LZESkP17;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BqCyE1WD;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13840-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13840-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3B494303D805
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 20:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43FA133A6E2;
	Thu, 25 Jun 2026 20:33:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9716C1DD9AC
	for <io-uring@vger.kernel.org>; Thu, 25 Jun 2026 20:33:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782419634; cv=none; b=siEJ4Y/qkTQyF9AaVPIzR2X1kKT02v+v6lBvMJnWAlZjImv1Pkp/Yoskbv6pIINReljp2bTlloBoJMpWZ6wv+aLmKHYt2S1aks8a0vzBkkiKqGxXo8m80Oftp4xN+2NmO85+1gsUCg+hEjWXggPgxdh+cntLV4oP7za2dgG1FR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782419634; c=relaxed/simple;
	bh=Jq+pg6GhB2q8fBv7zUES4bi4CAGo5PUnEtcGWPVMb48=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HHf7mZxaOmug+c72p2Lmaf3SWfRMj/MhlbSPEfixNCNVu34+Ebnp7V4ecJ37nIqWTP+0K+9pI6CBf8XNrF3dp272jVsCGWfu96bPP7pleQujcf2AwxkG1K3ipGUbggi+snlEJQq00pv3lSJTZaIvkuevVidpy28vG6I5Xwj7bAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LZESkP17; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BqCyE1WD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LZESkP17; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BqCyE1WD; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF3AD76149;
	Thu, 25 Jun 2026 20:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782419630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tmaXBRwks5HZgwEdu4JXmkHMazhZTMB/sJtYFpAeTWA=;
	b=LZESkP177VQhK6yzpqJmv8OZraY9SDVva+/cjhb2DT/UD5+vqTHC9ZGRnfkTO2zvsQrGwP
	ClEhRsIoGfLpg9OcAKxT+IU+x22MZb/Vvi6Y+4CvbW6CNWwi/dpcWqz7vVotNiXKkMLCgb
	T8NF8nxQI1HJkFW8HjopzlcLKkkfVoc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782419630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tmaXBRwks5HZgwEdu4JXmkHMazhZTMB/sJtYFpAeTWA=;
	b=BqCyE1WDgfmB+j8SXEt9C6Ahj2yDuG21O26zsEyibaTggTdfPQ6yhsYqPd87oLwDyqoaHU
	vxVY8fAULKd1AoBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782419630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tmaXBRwks5HZgwEdu4JXmkHMazhZTMB/sJtYFpAeTWA=;
	b=LZESkP177VQhK6yzpqJmv8OZraY9SDVva+/cjhb2DT/UD5+vqTHC9ZGRnfkTO2zvsQrGwP
	ClEhRsIoGfLpg9OcAKxT+IU+x22MZb/Vvi6Y+4CvbW6CNWwi/dpcWqz7vVotNiXKkMLCgb
	T8NF8nxQI1HJkFW8HjopzlcLKkkfVoc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782419630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tmaXBRwks5HZgwEdu4JXmkHMazhZTMB/sJtYFpAeTWA=;
	b=BqCyE1WDgfmB+j8SXEt9C6Ahj2yDuG21O26zsEyibaTggTdfPQ6yhsYqPd87oLwDyqoaHU
	vxVY8fAULKd1AoBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7EA4D779A8;
	Thu, 25 Jun 2026 20:33:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ER8SFK6QPWqObgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 25 Jun 2026 20:33:50 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Harshal Chavan <harshal24.chavan@gmail.com>, harshal24.chavan@gmail.com
Cc: axboe@kernel.dk, gregkh@linuxfoundation.org, gustavoars@kernel.org,
 io-uring@vger.kernel.org, kees@kernel.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] io_uring/register: add IORING_REGISTER_CLONE_FILES
 opcode
In-Reply-To: <20260624124019.4521-1-harshal24.chavan@gmail.com>
Organization: SUSE
References: <20260624073921.11037-1-harshal24.chavan@gmail.com>
 <20260624124019.4521-1-harshal24.chavan@gmail.com>
Date: Thu, 25 Jun 2026 16:33:40 -0400
Message-ID: <87fr2auzq3.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13840-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:harshal24.chavan@gmail.com,m:axboe@kernel.dk,m:gregkh@linuxfoundation.org,m:gustavoars@kernel.org,m:io-uring@vger.kernel.org,m:kees@kernel.org,m:linux-hardening@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DDBA36C8862

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
>
> ---
> Sorry for the noise on the previous email! I accidentally sent the patch 
> before running checkpatch and missed a whitespace error. This v6 corrects it.
>
> v6:
>   - Fixed trailing whitespace checkpatch error.
> v5:
>   - Added missing spacing in comment (Gabriel).
>   - Removed ctx->user and mm_account checks (Gabriel).
>   - Used !! for boolean conversion (Gabriel).
>   - Moved mutex_unlock unconditionally above the out label (Gabriel).
>   - liburing implementation and tests: https://github.com/axboe/liburing/pull/1606
> v4:
>   - Updated Signed-off-by to use real name and moved above the scissors line (Greg KH).
> v3:
>   - Rewrote the cloning loop to allocate private destination nodes via io_rsrc_node_alloc to fix non-atomic ref lock synchronization (Jens).
>   - Maintained partial offset/copy support to mirror io_clone_buffers UAPI (Jens).
>   - Gated the replacement free check on ctx->file_table.data.nr (Gabriel).
>   - Prevented self-cloning by checking ctx == src_ctx (Gabriel).
>   - Removed submitter_task check to allow cross-thread pooling setups (Gabriel).
> v2:
>   - Dropped unrelated whitespace formatting changes from v1

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

don't you need to copy the src_node->tag here as well?

I didn't get a chance to run it yet, sorry.  I'd suggest you wait for
Jens feedback before pushing the v7 too, so you don't need to keep
iterating drop by drop :)

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
> +	registered_src = !!(clone_arg.flags & IORING_REGISTER_SRC_REGISTERED);
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
> +	mutex_unlock(&src_ctx->uring_lock);
> +
> +out:
> +	if (!registered_src)
> +		fput(file);
> +	return ret;
> +}
> +
>  void io_vec_free(struct iou_vec *iv)
>  {
>  	if (!iv->iovec)
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 44e3386f7c1c..32f5c47c46af 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -75,6 +75,7 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
>  			const struct iovec __user *uvec, size_t uvec_segs);
>  
>  int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
> +int io_register_clone_files(struct io_ring_ctx *ctx, void __user *arg);
>  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
>  int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  			    unsigned int nr_args, u64 __user *tags);
> -- 
> 2.54.0
>

-- 
Gabriel Krisman Bertazi

