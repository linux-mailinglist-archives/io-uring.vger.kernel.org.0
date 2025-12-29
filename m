Return-Path: <io-uring+bounces-11319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD602CE8307
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 22:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C2E5A300AB0A
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 21:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A9C2853F8;
	Mon, 29 Dec 2025 21:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ki2p6sic";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n1nCYHjd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q+jAk7nA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YK/out0l"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10A227B336
	for <io-uring@vger.kernel.org>; Mon, 29 Dec 2025 21:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767042449; cv=none; b=gw8OC64i3GzypuwOM4GVDcBAyU770HcCK/yOtoV+WsonNxCUsyJWImqmyYxtWzkCwPSJApxSsXvGgVHh1xEgyXxrTj/RHclJFQeH78hjs8GLHP//GIvsrIBpm/Ht/WR5L4h328I9jqsILJAjQofqSfhkarXY3bfkYzBMzlq+4/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767042449; c=relaxed/simple;
	bh=JYL/Hx0G+duCnR1w/LphUkqH8DKMRMPn31iS2tqmV58=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fjxgO/7WFy5mz7nAj6pddq7kdiVjwKtAivn3O9FXta/A90GMKvJy2EtIYMioWlfBbFzIHM0TykiScujhsWQygUWzQDP3LfX3tbXPFY3oYX+g4LTCOHjAS90ND1EGNMAHYUxhcC6yTwsPce2a7RVev2BxWg14d/yzB8dfKE1rU7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ki2p6sic; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n1nCYHjd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q+jAk7nA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YK/out0l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EB09E336B5;
	Mon, 29 Dec 2025 21:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767042446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y9tKAQT75iqCX5Pv+ILhSLqtyAl4KGwU3u3z3Glje2A=;
	b=ki2p6sicHviAhmI6hD9hqogb4z/AtNM/dbAKCR0ICbcjviL0XwBBKu+4EB2h0zjVNg7den
	yOLCKJskUmClkx3toal2RnZB8WLuHtWgKtR3aBQlUzvOSxQQGSRq1vI2XU5M8MKQSa3kLF
	noszqsEKkl2duS0pGCyuVxKZWHNOarQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767042446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y9tKAQT75iqCX5Pv+ILhSLqtyAl4KGwU3u3z3Glje2A=;
	b=n1nCYHjdas2DayLk24JrBBBlZ9HXS4kGWGgbB4vjYQf2Yzhd/pKKJKZ7NwiyvM8QyGrExZ
	zTE83MaEpr/TOmDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767042444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y9tKAQT75iqCX5Pv+ILhSLqtyAl4KGwU3u3z3Glje2A=;
	b=q+jAk7nAVzzqPGt5XFTJwUO3gx3YGVHY/U1tbj/elA+vcbAAT6NpCmG0eR7dreM75nXAyD
	AlIid3MNN/F6jixveSUgFSsrNJDS029x+MEU2ukl9nL8PWzvXGdSHfxDc1P/XiRSnWpdzv
	BBcOBWQ9JoURmF6VmEhayvMn94WMKR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767042444;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y9tKAQT75iqCX5Pv+ILhSLqtyAl4KGwU3u3z3Glje2A=;
	b=YK/out0lRn5iDTlrhypL3LyTgst4ec3RbFmY/jPT0ZpS+gvmibgMTB7nM6hz7KmBTEfeJK
	y0TOs0Y8W6UqC5CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACE76137C3;
	Mon, 29 Dec 2025 21:07:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hylfI4ztUmmJYwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 29 Dec 2025 21:07:24 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu,  axboe@kernel.dk,  bschubert@ddn.com,
  asml.silence@gmail.com,  io-uring@vger.kernel.org,
  csander@purestorage.com,  xiaobing.li@samsung.com,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
In-Reply-To: <20251223003522.3055912-7-joannelkoong@gmail.com> (Joanne Koong's
	message of "Mon, 22 Dec 2025 16:35:03 -0800")
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
	<20251223003522.3055912-7-joannelkoong@gmail.com>
Date: Mon, 29 Dec 2025 16:07:14 -0500
Message-ID: <87y0mlyp31.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,mailhost.krisman.be:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[szeredi.hu,kernel.dk,ddn.com,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mailhost.krisman.be:mid,imap1.dmz-prg2.suse.org:helo]

Joanne Koong <joannelkoong@gmail.com> writes:

> +int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
> +		     unsigned issue_flags, struct io_buffer_list **bl)
> +{
> +	struct io_buffer_list *buffer_list;
> +	struct io_ring_ctx *ctx = req->ctx;
> +	int ret = -EINVAL;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	buffer_list = io_buffer_get_list(ctx, buf_group);
> +	if (likely(buffer_list) && likely(buffer_list->flags & IOBL_BUF_RING)) {

FWIW, the likely construct is unnecessary here. At least, it should
encompass the entire expression:

    if (likely(buffer_list && buffer_list->flags & IOBL_BUF_RING))

But you can just drop it.

> +		if (unlikely(buffer_list->flags & IOBL_PINNED)) {
> +			ret = -EALREADY;
> +		} else {
> +			buffer_list->flags |= IOBL_PINNED;
> +			ret = 0;
> +			*bl = buffer_list;
> +		}
> +	}
> +
> +	io_ring_submit_unlock(ctx, issue_flags);
> +	return ret;
> +}
> +
> +int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
> +		       unsigned issue_flags)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_buffer_list *bl;
> +	int ret = -EINVAL;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	bl = io_buffer_get_list(ctx, buf_group);
> +	if (likely(bl) && likely(bl->flags & IOBL_BUF_RING) &&
> +	    likely(bl->flags & IOBL_PINNED)) {

likewise.

> +		bl->flags &= ~IOBL_PINNED;
> +		ret = 0;
> +	}
> +
> +	io_ring_submit_unlock(ctx, issue_flags);
> +	return ret;
> +}
> +
>  /* cap it at a reasonable 256, will be one page even for 4K */
>  #define PEEK_MAX_IMPORT		256
>  
> @@ -744,6 +788,8 @@ int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
>  		return -ENOENT;
>  	if (!(bl->flags & IOBL_BUF_RING))
>  		return -EINVAL;
> +	if (bl->flags & IOBL_PINNED)
> +		return -EBUSY;
>  
>  	scoped_guard(mutex, &ctx->mmap_lock)
>  		xa_erase(&ctx->io_bl_xa, bl->bgid);
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index 11d165888b8e..c4368f35cf11 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -12,6 +12,11 @@ enum {
>  	IOBL_INC		= 2,
>  	/* buffers are kernel managed */
>  	IOBL_KERNEL_MANAGED	= 4,
> +	/*
> +	 * buffer ring is pinned and cannot be unregistered by userspace until
> +	 * it has been unpinned
> +	 */
> +	IOBL_PINNED		= 8,
>  };
>  
>  struct io_buffer_list {
> @@ -136,4 +141,9 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
>  		return 0;
>  	return __io_put_kbufs(req, bl, len, nbufs);
>  }
> +
> +int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
> +		     unsigned issue_flags, struct io_buffer_list **bl);
> +int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
> +		       unsigned issue_flags);
>  #endif
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 197474911f04..8ac79ead4158 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -398,3 +398,21 @@ bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(io_uring_mshot_cmd_post_cqe);
> +
> +int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd, unsigned buf_group,
> +			      unsigned issue_flags, struct io_buffer_list **bl)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +
> +	return io_kbuf_ring_pin(req, buf_group, issue_flags, bl);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_pin);
> +
> +int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
> +				unsigned issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +
> +	return io_kbuf_ring_unpin(req, buf_group, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_unpin);

-- 
Gabriel Krisman Bertazi

