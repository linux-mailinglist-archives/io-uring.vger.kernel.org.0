Return-Path: <io-uring+bounces-3220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE4B97B318
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 18:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29EF8285397
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 16:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2F68248C;
	Tue, 17 Sep 2024 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Y+3Lfjaz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JZSqKKhq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Y+3Lfjaz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JZSqKKhq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A424C17C990
	for <io-uring@vger.kernel.org>; Tue, 17 Sep 2024 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726591318; cv=none; b=DfwtARi3nYDqlrK3g/DBRMPIzc/uaICcRuDIX5KCJ82q+KITfajNP7pfTBVsyv4o3yKET9NnaYS+XDtz2kpFxCe1iKFDVTysEIqeU826LKefXQYhd91d6w8Plvf2+iMtCBtBSzUXeRfKEp1pm5CQPaPLy9dS24YsO4i7wmvEkkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726591318; c=relaxed/simple;
	bh=5riLJQhXKm+3n0taE1Squ/lRA7/RJPc/i9u5dtg5YO4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BySn4IgB1ux6zGYIJ4iALnJVQYAJOzpcfMbIDUiBCbkqISrLs7nL+BjFCsCr+ZmgLy2rig0ByV8Vv6z09G+2OoWhf8N3LgUi6IEG8VM2XIA21l4/ps7Vy2HsHqJt0N7iZtM6OQ6oTqHslFD15ZXw2tjBahv+ofL9pq1+bojDKkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Y+3Lfjaz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JZSqKKhq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Y+3Lfjaz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JZSqKKhq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B81862233E;
	Tue, 17 Sep 2024 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726591314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B/YYKqvXrQA67EsNBngBCA5AC/oADyVUBNfTyDcdwZY=;
	b=Y+3LfjazJaBn1KS5oEa0vsR5h1ikCnC9XJlglou/fgnvtKVP1aTMKcfGva+De57WjYK9mU
	R/TZvUbDZtQK7ypv+6R4cuoylATHj3/KCVQwyGPn+srwprbmIHlVRi45C7JDraSVvGbEXu
	j1i2u4UlmP8gjR6yK3M3sR2fCmKoFww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726591314;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B/YYKqvXrQA67EsNBngBCA5AC/oADyVUBNfTyDcdwZY=;
	b=JZSqKKhqnWARXonqIcnUwySi/j1E+2rEYGu5wku5/hElc3WJ979RqBvMOvShdZtMr44IJU
	oyt/tEgOkQTAVFCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Y+3Lfjaz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JZSqKKhq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726591314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B/YYKqvXrQA67EsNBngBCA5AC/oADyVUBNfTyDcdwZY=;
	b=Y+3LfjazJaBn1KS5oEa0vsR5h1ikCnC9XJlglou/fgnvtKVP1aTMKcfGva+De57WjYK9mU
	R/TZvUbDZtQK7ypv+6R4cuoylATHj3/KCVQwyGPn+srwprbmIHlVRi45C7JDraSVvGbEXu
	j1i2u4UlmP8gjR6yK3M3sR2fCmKoFww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726591314;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B/YYKqvXrQA67EsNBngBCA5AC/oADyVUBNfTyDcdwZY=;
	b=JZSqKKhqnWARXonqIcnUwySi/j1E+2rEYGu5wku5/hElc3WJ979RqBvMOvShdZtMr44IJU
	oyt/tEgOkQTAVFCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79ACB13AB6;
	Tue, 17 Sep 2024 16:41:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oOVmF1Kx6WZtagAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 17 Sep 2024 16:41:54 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 4/4] io_uring: add IORING_REGISTER_COPY_BUFFERS method
In-Reply-To: <20240912164019.634560-5-axboe@kernel.dk> (Jens Axboe's message
	of "Thu, 12 Sep 2024 10:38:23 -0600")
References: <20240912164019.634560-1-axboe@kernel.dk>
	<20240912164019.634560-5-axboe@kernel.dk>
Date: Tue, 17 Sep 2024 12:41:49 -0400
Message-ID: <87jzfagrle.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: B81862233E
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> Buffers can get registered with io_uring, which allows to skip the
> repeated pin_pages, unpin/unref pages for each O_DIRECT operation. This
> reduces the overhead of O_DIRECT IO.
>
> However, registrering buffers can take some time. Normally this isn't an
> issue as it's done at initialization time (and hence less critical), but
> for cases where rings can be created and destroyed as part of an IO
> thread pool, registering the same buffers for multiple rings become a
> more time sensitive proposition. As an example, let's say an application
> has an IO memory pool of 500G. Initial registration takes:
>
> Got 500 huge pages (each 1024MB)
> Registered 500 pages in 409 msec
>
> or about 0.4 seconds. If we go higher to 900 1GB huge pages being
> registered:
>
> Registered 900 pages in 738 msec
>
> which is, as expected, a fully linear scaling.
>
> Rather than have each ring pin/map/register the same buffer pool,
> provide an io_uring_register(2) opcode to simply duplicate the buffers
> that are registered with another ring. Adding the same 900GB of
> registered buffers to the target ring can then be accomplished in:
>
> Copied 900 pages in 17 usec
>
> While timing differs a bit, this provides around a 25,000-40,000x
> speedup for this use case.

Looks good, but I couldn't get it to apply on top of your branches.  I
have only one comment, if you are doing a v4:
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/uapi/linux/io_uring.h | 13 +++++
>  io_uring/register.c           |  6 +++
>  io_uring/rsrc.c               | 91 +++++++++++++++++++++++++++++++++++
>  io_uring/rsrc.h               |  1 +
>  4 files changed, 111 insertions(+)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h

> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -17,6 +17,7 @@
>  #include "openclose.h"
>  #include "rsrc.h"
>  #include "memmap.h"
> +#include "register.h"
>  
>  struct io_rsrc_update {
>  	struct file			*file;
> @@ -1137,3 +1138,93 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>  
>  	return 0;
>  }
> +
> +static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)


The error handling code in this function is a bit hairy, IMO.  I think
if you check nbufs unlocked and validate it later, it could be much
simpler:

static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
{
	struct io_mapped_ubuf **user_bufs;
	struct io_rsrc_data *data;
	int i, ret, nbufs;

	/* Read nr_user_bufs unlocked.  Must be validated later */
	nbufs = READ_ONCE(src_ctx->nr_user_bufs);
	if (!nbufs)
		return -ENXIO;

	ret = io_rsrc_data_alloc(ctx, IORING_RSRC_BUFFER, NULL, nbufs, &data);
	if (ret)
		return ret;

	user_bufs = kcalloc(nbufs, sizeof(*ctx->user_bufs), GFP_KERNEL);
	if (!user_bufs) {
        	ret = -ENOMEM;
		goto out_free_data;
        }

	mutex_unlock(&ctx->uring_lock);
	mutex_lock(&src_ctx->uring_lock);

 	ret = -EBUSY;
	if (nbufs != src_ctx->nr_user_bufs) {
		mutex_unlock(&src_ctx->uring_lock);
		mutex_lock(&ctx->uring_lock);
		goto out;
	}
	for (i = 0; i < nbufs; i++) {
		struct io_mapped_ubuf *src = src_ctx->user_bufs[i];
		refcount_inc(&src->refs);
		user_bufs[i] = src;
	}

	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
	mutex_unlock(&src_ctx->uring_lock);
	mutex_lock(&ctx->uring_lock);

	if (!ctx->user_bufs)
                goto out_unmap;

	ctx->user_bufs = user_bufs;
	ctx->buf_data = data;
	ctx->nr_user_bufs = nbufs;

	return 0;

out_unmap:
 	/* someone raced setting up buffers, dump ours */
 	for (i = 0; i < nbufs; i++)
 		io_buffer_unmap(ctx, &user_bufs[i]);
out:
	kfree(user_bufs);
out_free_data:
	io_rsrc_data_free(data);
	return ret;
}

Thanks,

-- 
Gabriel Krisman Bertazi

