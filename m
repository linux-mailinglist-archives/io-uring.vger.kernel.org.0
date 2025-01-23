Return-Path: <io-uring+bounces-6103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8791A1AA96
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 20:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FDE218820C9
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 19:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EEB31552ED;
	Thu, 23 Jan 2025 19:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LDtz3R/z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vyx/cobQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LDtz3R/z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vyx/cobQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447C51474CF
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 19:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737661654; cv=none; b=n+FwMK0PPfLGhbBYkEBDc8OPOdQmUexl0zIymmtGoucjcsZfLhq2MGLuRXlajiKcZOPG51c0ZlJq0RLed/s2JFukvgWvYV5eb5iIX/fTuhFbWxNnE83mx+qQV8i6KTpKZxiFsEuzUvRGJ7XfqCHnIhkO/e5cgpnZS4ykJGLhZ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737661654; c=relaxed/simple;
	bh=HD/FM52i0dOtlzmx/LeqQR9J71qHIco8NUy1v2GQA7w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pDQ3/4HPQowW3TgMTEfd02B4ZmX5ZHDH1qgpIo+rbK3ieDMjyRmkcbGSuTCTnQhPEnLpWNEbufq+SgqUnmsZs4JvzjrDLqEn3xk3z3xrllG13mGrhXU6709HEP8KJNiYlxuR0viUz34pAuG4dr9W/rtyQ2+f43iPDufWZGtg+UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LDtz3R/z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vyx/cobQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LDtz3R/z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vyx/cobQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 10A9321171;
	Thu, 23 Jan 2025 19:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737661650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7aiS5lkXkiXHry1H4l5AM8U+LIpLusKdxy48ylmBbRY=;
	b=LDtz3R/zHLuImt5LgaGJDjtFDH5z4OiV0CLihJmfvgeUdN2ATpZCqv9e69CbZGAiVw3Xrr
	29aSgeTeAK0/uRKTPK3qufoJ7LnRI3AvsnKHxWAXNX8eT8d2S2U1UgSddNTnJsziy6AJ2/
	H0+ayf2NdXAtYCmI+7NItriTUGey8u4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737661650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7aiS5lkXkiXHry1H4l5AM8U+LIpLusKdxy48ylmBbRY=;
	b=vyx/cobQ4lrKzPpVkRI1M9sEoY5FFmgoCPaJNjXQAS7US8LfMAVz3Q48/sPr3G/p3BhIZP
	K3K4LU3qLE3/YfCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="LDtz3R/z";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="vyx/cobQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737661650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7aiS5lkXkiXHry1H4l5AM8U+LIpLusKdxy48ylmBbRY=;
	b=LDtz3R/zHLuImt5LgaGJDjtFDH5z4OiV0CLihJmfvgeUdN2ATpZCqv9e69CbZGAiVw3Xrr
	29aSgeTeAK0/uRKTPK3qufoJ7LnRI3AvsnKHxWAXNX8eT8d2S2U1UgSddNTnJsziy6AJ2/
	H0+ayf2NdXAtYCmI+7NItriTUGey8u4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737661650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7aiS5lkXkiXHry1H4l5AM8U+LIpLusKdxy48ylmBbRY=;
	b=vyx/cobQ4lrKzPpVkRI1M9sEoY5FFmgoCPaJNjXQAS7US8LfMAVz3Q48/sPr3G/p3BhIZP
	K3K4LU3qLE3/YfCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C906C1351A;
	Thu, 23 Jan 2025 19:47:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rW1nK9GckmfJbAAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 23 Jan 2025 19:47:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] io_uring: get rid of alloc cache init_once handling
In-Reply-To: <20250123184754.555270-3-axboe@kernel.dk> (Jens Axboe's message
	of "Thu, 23 Jan 2025 11:45:26 -0700")
Organization: SUSE
References: <20250123184754.555270-1-axboe@kernel.dk>
	<20250123184754.555270-3-axboe@kernel.dk>
Date: Thu, 23 Jan 2025 14:47:24 -0500
Message-ID: <87jzaljos3.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 10A9321171
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> init_once is called when an object doesn't come from the cache, and
> hence needs initial clearing of certain members. While the whole
> struct could get cleared by memset() in that case, a few of the cache
> members are large enough that this may cause unnecessary overhead if
> the caches used aren't large enough to satisfy the workload. For those
> cases, some churn of kmalloc+kfree is to be expected.
>
> Ensure that the 3 users that need clearing put the members they need
> cleared at the start of the struct, and wrap the rest of the struct in
> a struct group so the offset is known.
>
> While at it, improve the interaction with KASAN such that when/if
> KASAN writes to members inside the struct that should be retained over
> caching, it won't trip over itself. For rw and net, the retaining of
> the iovec over caching is disabled if KASAN is enabled. A helper will
> free and clear those members in that case.
>
> @@ -1813,11 +1798,10 @@ void io_netmsg_cache_free(const void *entry)
>  {
>  	struct io_async_msghdr *kmsg = (struct io_async_msghdr *) entry;
>  
> -	if (kmsg->free_iov) {
> -		kasan_mempool_unpoison_object(kmsg->free_iov,
> -				kmsg->free_iov_nr * sizeof(struct iovec));
> +#if !defined(CONFIG_KASAN)
> +	if (kmsg->free_iov)
>  		io_netmsg_iovec_free(kmsg);
> -	}
> +#endif

Among mostly ugly choices, this is an improvement over the init_once
callback.  I'd just fold the above codeguard into the code:

  if (IS_DEFINED(CONFIG_KASAN) && kmsg->free_iov)

Other than that,

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


>  	kfree(kmsg);
>  }
>  #endif
> diff --git a/io_uring/net.h b/io_uring/net.h
> index 52bfee05f06a..b804c2b36e60 100644
> --- a/io_uring/net.h
> +++ b/io_uring/net.h
> @@ -5,16 +5,20 @@
>  
>  struct io_async_msghdr {
>  #if defined(CONFIG_NET)
> -	struct iovec			fast_iov;
> -	/* points to an allocated iov, if NULL we use fast_iov instead */
>  	struct iovec			*free_iov;
> +	/* points to an allocated iov, if NULL we use fast_iov instead */
>  	int				free_iov_nr;
> -	int				namelen;
> -	__kernel_size_t			controllen;
> -	__kernel_size_t			payloadlen;
> -	struct sockaddr __user		*uaddr;
> -	struct msghdr			msg;
> -	struct sockaddr_storage		addr;
> +	struct_group(clear,

-- 
Gabriel Krisman Bertazi

