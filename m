Return-Path: <io-uring+bounces-937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 971F387B463
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 23:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 065571F2372A
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 22:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CEE14691;
	Wed, 13 Mar 2024 22:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fvVLrNmH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RWUnBX5H";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fvVLrNmH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RWUnBX5H"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7748D5D461
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 22:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710369167; cv=none; b=py5o86ECtkUnBidgYnJKcPVZXd3QUZwAJZTe3MROMOFhF7PCRz+cDQFzR2QC3dqmn54xQrdcLPr1qulGMMXr9y6mrid6tisep/Qh0RP8RHfA2hWlgCww8+KREI/jG+9eBEOIGIFfFkQLIBHt1ZTp4NARjGFpzOW6KYkAongfENc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710369167; c=relaxed/simple;
	bh=7Jwkde3Hfzek69e7td06GMmpyWac0RO9whdJPJhE+AA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=j0JnMtIY3vtRt44YIZTt1zqvXn+4f2PjNeY+ZXtT6fqMyEnqSPWdEFLfGq4PBmCQyFPfZZRUmlgGcK2o3V2SlJtqwdz/fZnK/e25AH9y9C6MJDVjNbCwqsaPyWkIyPFZcBwfL2n1hZs79wVDuaSeIievT/tvBPTvzxCEKtZzqBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fvVLrNmH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RWUnBX5H; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fvVLrNmH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RWUnBX5H; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 67667218EE;
	Wed, 13 Mar 2024 22:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710369163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=om0aaFdvZMLmXTL2lG1M3EGoQzIANgnUoT8c2O1yZoU=;
	b=fvVLrNmHRCdgC0uZtUfV+zLWZJAx5TABKr6xZFUO29G/LiCBr9WQwH5b2d/a1ShMeQLfQ6
	pPijHjxnSABTELij94Juho0YkpaERwN9/uboRnHJ3qlkUluUwbs+SFx+6k5wbG2Wg9fqp0
	ydgnmD7oXAoLAmE3tZgX5092dUyA7Qs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710369163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=om0aaFdvZMLmXTL2lG1M3EGoQzIANgnUoT8c2O1yZoU=;
	b=RWUnBX5HIMBHW2ohz+/84a2Vj5cLbNhn3KjPmrJa7SdHFfxtqisAkNxy2UuehWDGmol8J7
	B6boRccu/d357BCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710369163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=om0aaFdvZMLmXTL2lG1M3EGoQzIANgnUoT8c2O1yZoU=;
	b=fvVLrNmHRCdgC0uZtUfV+zLWZJAx5TABKr6xZFUO29G/LiCBr9WQwH5b2d/a1ShMeQLfQ6
	pPijHjxnSABTELij94Juho0YkpaERwN9/uboRnHJ3qlkUluUwbs+SFx+6k5wbG2Wg9fqp0
	ydgnmD7oXAoLAmE3tZgX5092dUyA7Qs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710369163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=om0aaFdvZMLmXTL2lG1M3EGoQzIANgnUoT8c2O1yZoU=;
	b=RWUnBX5HIMBHW2ohz+/84a2Vj5cLbNhn3KjPmrJa7SdHFfxtqisAkNxy2UuehWDGmol8J7
	B6boRccu/d357BCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BD651397F;
	Wed, 13 Mar 2024 22:32:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fmW9BIsp8mWzdwAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 13 Mar 2024 22:32:43 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,  Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] io_uring: simplify io_mem_alloc return values
In-Reply-To: <ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
	(Pavel Begunkov's message of "Wed, 13 Mar 2024 15:52:39 +0000")
References: <cover.1710343154.git.asml.silence@gmail.com>
	<ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
Date: Wed, 13 Mar 2024 18:32:42 -0400
Message-ID: <87plvxkbjp.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-0.40 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FREEMAIL_TO(0.00)[gmail.com];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.30)[75.01%]
X-Spam-Score: -0.40
X-Spam-Flag: NO

Pavel Begunkov <asml.silence@gmail.com> writes:

> io_mem_alloc() returns a pointer on success and a pointer-encoded error
> otherwise. However, it can only fail with -ENOMEM, just return NULL on
> failure. PTR_ERR is usually pretty error prone.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 14 +++++---------
>  io_uring/kbuf.c     |  4 ++--
>  2 files changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index e7d7a456b489..1d0eac0cc8aa 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2802,12 +2802,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>  void *io_mem_alloc(size_t size)
>  {
>  	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
> -	void *ret;
>  
> -	ret = (void *) __get_free_pages(gfp, get_order(size));
> -	if (ret)
> -		return ret;
> -	return ERR_PTR(-ENOMEM);
> +	return (void *) __get_free_pages(gfp, get_order(size));
>  }
>  
>  static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
> @@ -3762,8 +3758,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>  	else
>  		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
>  
> -	if (IS_ERR(rings))
> -		return PTR_ERR(rings);
> +	if (!rings)
> +		return -ENOMEM;
>

Sorry, I started reviewing this, got excited about the error path quick
fix, and didn't finish the review before it got it.

I think this change is broken for the ctx->flags & IORING_SETUP_NO_MMAP
case, because io_rings_map returns ERR_PTR, and not NULL.  In addition,
io_rings_map might fail for multiple reasons, and we want to propagate
the different error codes up here.

-- 
Gabriel Krisman Bertazi

