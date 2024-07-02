Return-Path: <io-uring+bounces-2412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8D7924225
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 17:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 508DF2887C2
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 15:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236E61BA883;
	Tue,  2 Jul 2024 15:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GcdNhdy1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2NgjuchW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="njiU7C+b";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Rc3iR1CM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DB61BB6BE
	for <io-uring@vger.kernel.org>; Tue,  2 Jul 2024 15:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719933477; cv=none; b=aIBXdYTQp8wnbgJxd1yIxVlXr2g1klhxEPNxE7u3i2mw672dZjIg3nlwZnCUc2gZkjCDpaIZf+L9NBzNp7Zsx+TTJecKw6kLK2yanY3vlFGcIbMm/Nt8OlJkmF7RTqC3ojIofxld92d25t+vbGyBHnq10PgP4wu2SYT6OLHZpts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719933477; c=relaxed/simple;
	bh=+gsCZoT8mffJVsgGx5+3rt7QuLaf9fHGSjGwephCHuI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=t35y/Cx69JKYLkNLDqcLPIbnQ2po8ZTbXxR8jjaC19Z+K//44W5h/KVJqbAlAxXg4O4SfXG2p5/VmSJS3tKMpUzwnuNflDq3XjdpPs/8kNpWMr3bAWrV7F4fxeOfCqUxqUm4/WN5HzssUcxsULzWmYKHSB2bsgtekLNUa3NZ77w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GcdNhdy1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2NgjuchW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=njiU7C+b; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Rc3iR1CM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7D89821B63;
	Tue,  2 Jul 2024 15:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719933473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzPPcLBsR1J+DD2KpWlzeMwTFzSpKzcm1GvuDUllJzY=;
	b=GcdNhdy1KVr93LyKfeoSryKFoo3epobtTI7PCqHlEEsziCCjesC3G9WkeUeWJwNUoVdr+M
	AD0PszLgky3HgyVGhrdt6RHFMbzbvpPRsi9C5VF7mIVrpMSOmYipr32I8e7rq6GWGgfTjo
	IwEKoX+72wseIdlgUzRR1DTIYaYAn8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719933473;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzPPcLBsR1J+DD2KpWlzeMwTFzSpKzcm1GvuDUllJzY=;
	b=2NgjuchWYKtTH8RzSTpzt2vG1FrKhT2yK6rkL/sH67sa4wJze4iLFMgvNDOA2FGcpFGYlp
	HkHupN3Io3TIVPBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=njiU7C+b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Rc3iR1CM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1719933472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzPPcLBsR1J+DD2KpWlzeMwTFzSpKzcm1GvuDUllJzY=;
	b=njiU7C+bXnppbpRQxhqBOwwmczJhu83YSWVX2vhi5N8nTyQLkay/iKjVwjdxhwSiEJczxQ
	vnpvi73mVQ6yxxm1FRok4bAxNTleAh6dhJFPIVjZt1s1CFFCsBaxLBcU4VoJ2COhsgjMnw
	sbE8VH47yH1e7+TLocFEms126Y2/+XY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1719933472;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzPPcLBsR1J+DD2KpWlzeMwTFzSpKzcm1GvuDUllJzY=;
	b=Rc3iR1CMzccr4q39MHSW6UGl0ujQz3GouYI523Qx+dA6bmhdeRHN4nzV9i1qkNudCUvjrV
	HwvyknYeq+LCO3DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4469A1395F;
	Tue,  2 Jul 2024 15:17:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cjhwCiAahGbuIwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 02 Jul 2024 15:17:52 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  asml.silence@gmail.com
Subject: Re: [PATCH 2/2] io_uring/msg_ring: use kmem_cache_free() to free
 request
In-Reply-To: <20240701144908.19602-3-axboe@kernel.dk> (Jens Axboe's message of
	"Mon, 1 Jul 2024 08:48:00 -0600")
References: <20240701144908.19602-1-axboe@kernel.dk>
	<20240701144908.19602-3-axboe@kernel.dk>
Date: Tue, 02 Jul 2024 11:17:43 -0400
Message-ID: <87ikxnzuug.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7D89821B63
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> The change adding caching around the request allocated and freed for
> data messages changed a kmem_cache_free() to a kfree(), which isn't
> correct as the request came from slab in the first place. Fix that up
> and use the right freeing function if the cache is already at its limit.
>
> Fixes: 50cf5f3842af ("io_uring/msg_ring: add an alloc cache for io_kiocb entries")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Fwiw, kfree works fine for kmem_cache_alloc objects since 6.4, when SLOB
was removed.  Either way, it doesn't harm.

> ---
>  io_uring/msg_ring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index c2171495098b..29fa9285a33d 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -82,7 +82,7 @@ static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
>  		spin_unlock(&ctx->msg_lock);
>  	}
>  	if (req)
> -		kfree(req);
> +		kmem_cache_free(req_cachep, req);
>  	percpu_ref_put(&ctx->refs);
>  }

-- 
Gabriel Krisman Bertazi

