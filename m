Return-Path: <io-uring+bounces-2964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D0C962D14
	for <lists+io-uring@lfdr.de>; Wed, 28 Aug 2024 17:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 482BE1C21E75
	for <lists+io-uring@lfdr.de>; Wed, 28 Aug 2024 15:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497771A0718;
	Wed, 28 Aug 2024 15:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="u5o1CBcQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Cvgiqf1U";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ceeg/ax1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M2ql/P5W"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E265172767
	for <io-uring@vger.kernel.org>; Wed, 28 Aug 2024 15:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724860635; cv=none; b=WGcJ+Nor3sjjbeYZZ8gaNr43qEE677tcP7sicoUijvpj5hqDcdNJeGnvePVO6MBS6YSHt36DCuvMsNj4+ZQywrIwtBevpy5ZJ7/KAbgiPzhE3039CSChllI7vMlQe2mBh1RIWm19HHk4Is/r5P5AdAE38tTx0Ov1JzLqalXn0Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724860635; c=relaxed/simple;
	bh=me6KxokgyDxJygitM1JWXxD+YXcHjIp9MouWl42Fd1c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cSe2LzQXlanc5gFqLn6qlPXY/rFBw84mNrD+seqzr7vKWIbTnIlYyPUTAA31Hk9gLKFHzxXv85vAfWVba9+MyHbGJf5c7Dap7V4IUQ0tKvX1oRF1OVFoAZOtA4XHidj7OZWo5BbuGxoS25Xoyi9eejQuEpAH4NpX5nYb7+xBIqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u5o1CBcQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Cvgiqf1U; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ceeg/ax1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M2ql/P5W; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A563521B56;
	Wed, 28 Aug 2024 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724860631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pG0rR44lBDRXBjesiR3WF0odPxXtaX02Sroiba8vKaM=;
	b=u5o1CBcQb0Rf/iwEgpkYQ6ySp1Q54cFWuJABgY1bu6jxyJYf6m/99Lp/e0THowWlOdyYC1
	1DMQw1ju0himj/0NjF+e6LuloupWqjcuArKgjVYKcPzzUNUWtI85300e3nlIz44JX4uuEj
	kMrHUYzlhd2eXii78ZWmUd1EmCYWnqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724860631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pG0rR44lBDRXBjesiR3WF0odPxXtaX02Sroiba8vKaM=;
	b=Cvgiqf1U2A5CxUSpfbCLb+hFiAzV0+QhCzcUpdMGlP2mXAPR+zqEwISz/0iyQ2XJ5CRF0q
	XgokwCfMQEGVy4Bw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724860630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pG0rR44lBDRXBjesiR3WF0odPxXtaX02Sroiba8vKaM=;
	b=Ceeg/ax1mxxcTbN5DuY+o60ojhB1P+B5rki7Uq+xUXtOhph7Lqgzb4Lu0sXOqOrHRSbRfP
	uY4GkhUtK3NYsITd0XzNMSQ/fgZgcJOA+lwDILc1vic+9d8+vaOoogd8Kpxx6avDjMnIIH
	ZB3TvE1NvA4GDkex4z8xSaSLxsCkCUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724860630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pG0rR44lBDRXBjesiR3WF0odPxXtaX02Sroiba8vKaM=;
	b=M2ql/P5W7av+gXpfVYhyv1Y2PCZeAZapSJr/lo5swkw5ns2CSAlEc8ygdMV2To8KPzoAu5
	m5h6LlIvSoLuTUBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BFA8138D2;
	Wed, 28 Aug 2024 15:57:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XVAxFNZIz2ZNWgAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 28 Aug 2024 15:57:10 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: ensure compat iovecs are copied correctly
In-Reply-To: <b1fa09cd-ca5a-41ff-bc64-bec43f483a48@kernel.dk> (Jens Axboe's
	message of "Wed, 28 Aug 2024 09:46:14 -0600")
Organization: SUSE
References: <b1fa09cd-ca5a-41ff-bc64-bec43f483a48@kernel.dk>
Date: Wed, 28 Aug 2024 11:57:05 -0400
Message-ID: <871q28ej3i.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mailhost.krisman.be:mid,kernel.dk:email,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> For buffer registration (or updates), a userspace iovec is copied in
> and updated. If the application is within a compat syscall, then the
> iovec type is compat_iovec rather than iovec. However, the type used
> in __io_sqe_buffers_update() and io_sqe_buffers_register() is always
> struct iovec, and hence the source is incremented by the size of a
> non-compat iovec in the loop. This misses every other iovec in the
> source, and will run into garbage half way through the copies and
> return -EFAULT to the application.
>
> Maintain the source address separately and assign to our user vec
> pointer, so that copies always happen from the right source address.
>
> Fixes: f4eaf8eda89e ("io_uring/rsrc: Drop io_copy_iov in favor of iovec API")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Thanks for the fix, Jens. please take:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

>
> ---
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a860516bf448..b38d0ef41ef1 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -394,10 +394,11 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  				   struct io_uring_rsrc_update2 *up,
>  				   unsigned int nr_args)
>  {
> -	struct iovec __user *uvec = u64_to_user_ptr(up->data);
>  	u64 __user *tags = u64_to_user_ptr(up->tags);
>  	struct iovec fast_iov, *iov;
>  	struct page *last_hpage = NULL;
> +	struct iovec __user *uvec;
> +	u64 user_data = up->data;
>  	__u32 done;
>  	int i, err;
>  
> @@ -410,7 +411,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  		struct io_mapped_ubuf *imu;
>  		u64 tag = 0;
>  
> -		iov = iovec_from_user(&uvec[done], 1, 1, &fast_iov, ctx->compat);
> +		uvec = u64_to_user_ptr(user_data);
> +		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
>  		if (IS_ERR(iov)) {
>  			err = PTR_ERR(iov);
>  			break;
> @@ -443,6 +445,10 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  
>  		ctx->user_bufs[i] = imu;
>  		*io_get_tag_slot(ctx->buf_data, i) = tag;
> +		if (ctx->compat)
> +			user_data += sizeof(struct compat_iovec);
> +		else
> +			user_data += sizeof(struct iovec);
>  	}
>  	return done ? done : err;
>  }
> @@ -949,7 +955,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  	struct page *last_hpage = NULL;
>  	struct io_rsrc_data *data;
>  	struct iovec fast_iov, *iov = &fast_iov;
> -	const struct iovec __user *uvec = (struct iovec * __user) arg;
> +	const struct iovec __user *uvec;
>  	int i, ret;
>  
>  	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
> @@ -972,7 +978,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  
>  	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
>  		if (arg) {
> -			iov = iovec_from_user(&uvec[i], 1, 1, &fast_iov, ctx->compat);
> +			uvec = (struct iovec * __user) arg;
> +			iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
>  			if (IS_ERR(iov)) {
>  				ret = PTR_ERR(iov);
>  				break;
> @@ -980,6 +987,10 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  			ret = io_buffer_validate(iov);
>  			if (ret)
>  				break;
> +			if (ctx->compat)
> +				arg += sizeof(struct compat_iovec);
> +			else
> +				arg += sizeof(struct iovec);
>  		}
>  
>  		if (!iov->iov_base && *io_get_tag_slot(data, i)) {

-- 
Gabriel Krisman Bertazi

