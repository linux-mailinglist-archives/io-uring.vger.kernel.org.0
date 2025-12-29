Return-Path: <io-uring+bounces-11320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DBA9CE843A
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 23:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 30F9C3014AD7
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 22:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D222725EFBE;
	Mon, 29 Dec 2025 22:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1QkCUYQN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yV5vLkBk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1QkCUYQN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yV5vLkBk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A515303C97
	for <io-uring@vger.kernel.org>; Mon, 29 Dec 2025 22:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767045659; cv=none; b=toYJ9SWj7L8YfS9gW1+GmKgj9irt/O7h19T3jC7y3do8nFJnfGdXiR91KWEwbaWmeZt0bacMNr9sy5j2w+5TM4byIjAeyGrHVThVRNOPXn0L7DGWUTlED59obCggFKpu0F/+6/jWseMXJmkmcLCbtJkz9JY1ffeR+dpknit3xaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767045659; c=relaxed/simple;
	bh=sntnZlAICPXBNZSxt65ZqnHZoytGWVX3S6pcq8IRGjA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OkZZWSB3aLFO1CmrBy6NW63/m5QprWNnA6iolOR/UR3he82YI4RsaqGKEZHFad4qbokt5MTSM+lDYyGw+M5TKN19sUZcUvgg4UTf1h6kR3qPTGzs6crT/e4wAWxLriJx769hh7SzbuvZyU88Sy+ac1FepNnw2L+MoWo5mRyVpRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1QkCUYQN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yV5vLkBk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1QkCUYQN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yV5vLkBk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 537105BCD9;
	Mon, 29 Dec 2025 22:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767045648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=orUTOI32+kH3+k30IytIJFtDUhAgcQ4E3IvdkoWPXCw=;
	b=1QkCUYQN6p5JwMHfCDPI+Tz8dNOwVCtsZqFWi0PIwxcqSgBWQbtmFea7bntFDtAeKzhurB
	De9IdBnfU284XYwpLCBiERhy2Kh6KOggdNF2vTXMlGMy7gEiETla6IRa8hPe4YxErLjUwq
	whmJpM0GoeyX6kXVPczxyCi9iG0ujPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767045648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=orUTOI32+kH3+k30IytIJFtDUhAgcQ4E3IvdkoWPXCw=;
	b=yV5vLkBkPxH3RkgbeDGFRwRfFx0MokAzAiFo/C8FZseUeA8UaPInbAoWomeuYALsv3o2zY
	ePSKApUptwpZpXBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767045648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=orUTOI32+kH3+k30IytIJFtDUhAgcQ4E3IvdkoWPXCw=;
	b=1QkCUYQN6p5JwMHfCDPI+Tz8dNOwVCtsZqFWi0PIwxcqSgBWQbtmFea7bntFDtAeKzhurB
	De9IdBnfU284XYwpLCBiERhy2Kh6KOggdNF2vTXMlGMy7gEiETla6IRa8hPe4YxErLjUwq
	whmJpM0GoeyX6kXVPczxyCi9iG0ujPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767045648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=orUTOI32+kH3+k30IytIJFtDUhAgcQ4E3IvdkoWPXCw=;
	b=yV5vLkBkPxH3RkgbeDGFRwRfFx0MokAzAiFo/C8FZseUeA8UaPInbAoWomeuYALsv3o2zY
	ePSKApUptwpZpXBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0416F13A8F;
	Mon, 29 Dec 2025 22:00:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BxwTMA/6UmmcbAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 29 Dec 2025 22:00:47 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu,  axboe@kernel.dk,  bschubert@ddn.com,
  asml.silence@gmail.com,  io-uring@vger.kernel.org,
  csander@purestorage.com,  xiaobing.li@samsung.com,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 07/25] io_uring/kbuf: add recycling for kernel
 managed buffer rings
In-Reply-To: <20251223003522.3055912-8-joannelkoong@gmail.com> (Joanne Koong's
	message of "Mon, 22 Dec 2025 16:35:04 -0800")
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
	<20251223003522.3055912-8-joannelkoong@gmail.com>
Date: Mon, 29 Dec 2025 17:00:30 -0500
Message-ID: <87tsx9ymm9.fsf@mailhost.krisman.be>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[szeredi.hu,kernel.dk,ddn.com,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[mailhost.krisman.be:mid,imap1.dmz-prg2.suse.org:helo];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

Joanne Koong <joannelkoong@gmail.com> writes:

> Add an interface for buffers to be recycled back into a kernel-managed
> buffer ring.
>
> This is a preparatory patch for fuse over io-uring.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h | 13 +++++++++++
>  io_uring/kbuf.c              | 42 ++++++++++++++++++++++++++++++++++++
>  io_uring/kbuf.h              |  3 +++
>  io_uring/uring_cmd.c         | 11 ++++++++++
>  4 files changed, 69 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 424f071f42e5..7169a2a9a744 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -88,6 +88,11 @@ int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd, unsigned buf_group,
>  			      unsigned issue_flags, struct io_buffer_list **bl);
>  int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
>  				unsigned issue_flags);
> +
> +int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
> +				  unsigned int buf_group, u64 addr,
> +				  unsigned int len, unsigned int bid,
> +				  unsigned int issue_flags);
>  #else
>  static inline int
>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> @@ -143,6 +148,14 @@ static inline int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd,
>  {
>  	return -EOPNOTSUPP;
>  }
> +static inline int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
> +						unsigned int buf_group,
> +						u64 addr, unsigned int len,
> +						unsigned int bid,
> +						unsigned int issue_flags)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 03e05bab023a..f12d000b71c5 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -101,6 +101,48 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
>  	req->kbuf = NULL;
>  }
>  
> +int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
> +		     unsigned int len, unsigned int bid,
> +		     unsigned int issue_flags)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_uring_buf_ring *br;
> +	struct io_uring_buf *buf;
> +	struct io_buffer_list *bl;
> +	int ret = -EINVAL;
> +
> +	if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
> +		return ret;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	bl = io_buffer_get_list(ctx, bgid);
> +
> +	if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
> +	    WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
> +		goto done;

Hi Joanne,

WARN_ONs are not supposed to be reached by the user, but I think that is
possible here, i.e. by passing the bgid of legacy provided buffers.

> +
> +	br = bl->buf_ring;
> +
> +	if (WARN_ON_ONCE((br->tail - bl->head) >= bl->nr_entries))
> +		goto done;

> +
> +	buf = &br->bufs[(br->tail) & bl->mask];
> +
> +	buf->addr = addr;
> +	buf->len = len;
> +	buf->bid = bid;
> +
> +	req->flags &= ~REQ_F_BUFFER_RING;
> +
> +	br->tail++;
> +	ret = 0;
> +
> +done:
> +	io_ring_submit_unlock(ctx, issue_flags);
> +	return ret;
> +}
> +
>  bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index c4368f35cf11..4d8b7491628e 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -146,4 +146,7 @@ int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
>  		     unsigned issue_flags, struct io_buffer_list **bl);
>  int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
>  		       unsigned issue_flags);
> +int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
> +		     unsigned int len, unsigned int bid,
> +		     unsigned int issue_flags);
>  #endif
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8ac79ead4158..b6b675010bfd 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -416,3 +416,14 @@ int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
>  	return io_kbuf_ring_unpin(req, buf_group, issue_flags);
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_unpin);
> +
> +int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *ioucmd,
> +				  unsigned int buf_group, u64 addr,
> +				  unsigned int len, unsigned int bid,
> +				  unsigned int issue_flags)
> +{
> +	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +
> +	return io_kmbuf_recycle(req, buf_group, addr, len, bid, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_kmbuffer_recycle);

-- 
Gabriel Krisman Bertazi

