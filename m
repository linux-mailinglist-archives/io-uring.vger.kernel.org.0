Return-Path: <io-uring+bounces-11366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F02ECF52EC
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 19:12:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB66031426C3
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 18:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59340336ED4;
	Mon,  5 Jan 2026 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EM/zF6k1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c1NEwxwb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EM/zF6k1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c1NEwxwb"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716613246E4
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767636462; cv=none; b=F6FDLV7SP1xmc1nyjTPJwAsfErYRQLleCZMB7n723bez7aGAfuoMdlbVYU4REbsPnq1xltEhcl6pJdgohO3bXz0tQk4sc0PFF9fmiOmFEHkBYOkP/+7e6DEIv8+YDNoqJC0Tgz26rDAKaQrhHjOXaCOzvJoMsISOHjJ4xDBp5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767636462; c=relaxed/simple;
	bh=JrnFzWJd+pqa+/NCTUBDHcwWH4P1IT1/neVEm5S8YGQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=e3E/VaoRk0kxkIcd/0Q9ZFoZkdEmv0k2lUsGPzVofuL0JL4ZIjz5uGcr4ekEDpgq557fgUzxjDZbb2cW85eN8IWU9hGBDQ0xoJEYgMZzZ628FOnPyHIRPv+Fwa6X9hpOryAc8WWENhJnTjos0yD5MQOGGJdlap3akhlGGEf03Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EM/zF6k1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c1NEwxwb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EM/zF6k1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c1NEwxwb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62EA333740;
	Mon,  5 Jan 2026 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767636458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgeTl7K8a4waXn1GMi3AHXtSKh3aqqy4XItxZCM1n8s=;
	b=EM/zF6k1a0wYL92jP4XYSV6JPzDHW8o3woWHkOaiBgaRUOTzakG6A8ErzYmKrL2Ipm6hBr
	lkD0YK72RgNdQjs2ud2qpzhrxvJZCSDTjLvwH1pfxeIXlCmVbaDphZgvL3EWt9Qn5PCPL/
	aFgSRYGpNXjLr9gohc8Cn1+mIx/GZfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767636458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgeTl7K8a4waXn1GMi3AHXtSKh3aqqy4XItxZCM1n8s=;
	b=c1NEwxwb3GxO3loCXAduAbtfVmG2j6JyG5MyCY4eGNqkd//85WEoNy6bi1E6aG+AnAlnCM
	P9o1FQqooarB5YBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="EM/zF6k1";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c1NEwxwb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767636458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgeTl7K8a4waXn1GMi3AHXtSKh3aqqy4XItxZCM1n8s=;
	b=EM/zF6k1a0wYL92jP4XYSV6JPzDHW8o3woWHkOaiBgaRUOTzakG6A8ErzYmKrL2Ipm6hBr
	lkD0YK72RgNdQjs2ud2qpzhrxvJZCSDTjLvwH1pfxeIXlCmVbaDphZgvL3EWt9Qn5PCPL/
	aFgSRYGpNXjLr9gohc8Cn1+mIx/GZfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767636458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgeTl7K8a4waXn1GMi3AHXtSKh3aqqy4XItxZCM1n8s=;
	b=c1NEwxwb3GxO3loCXAduAbtfVmG2j6JyG5MyCY4eGNqkd//85WEoNy6bi1E6aG+AnAlnCM
	P9o1FQqooarB5YBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11EAB3EA63;
	Mon,  5 Jan 2026 18:07:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nfDUM+n9W2lMMQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 05 Jan 2026 18:07:37 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,  Max Kellermann
 <max.kellermann@ionos.com>
Subject: Re: [PATCH v2] io_uring/io-wq: fix incorrect
 io_wq_for_each_worker() termination logic
In-Reply-To: <f98f318f-0c3b-4b01-afb2-2b276f3fe6cd@kernel.dk> (Jens Axboe's
	message of "Mon, 5 Jan 2026 09:57:43 -0700")
References: <f98f318f-0c3b-4b01-afb2-2b276f3fe6cd@kernel.dk>
Date: Mon, 05 Jan 2026 13:07:27 -0500
Message-ID: <87y0mc6ihs.fsf@mailhost.krisman.be>
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,suse.de:dkim,suse.de:email];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 62EA333740
X-Spam-Flag: NO
X-Spam-Score: -4.51

Jens Axboe <axboe@kernel.dk> writes:

> A previous commit added this helper, and had it terminate if false is
> returned from the handler. However, that is completely opposite, it
> should abort the loop if true is returned.
>
> Fix this up by having io_wq_for_each_worker() keep iterating as long
> as false is returned, and only abort if true is returned.

The fix is good, but the API is just weird.

io_acct_for_each_worker returning true indicates an error that will
abort the wq walk.  It is a non-issue, since all the two callers cannot
fail and always return false for success :-)

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


> Cc: stable@vger.kernel.org
> Fixes: 751eedc4b4b7 ("io_uring/io-wq: move worker lists to struct io_wq_acct")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> v2: fix the actual bug, rather than work-around it for the exit
>     condition only.
>
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index cd13d8aac3d2..6c5ef629e59a 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -952,11 +952,11 @@ static bool io_wq_for_each_worker(struct io_wq *wq,
>  				  void *data)
>  {
>  	for (int i = 0; i < IO_WQ_ACCT_NR; i++) {
> -		if (!io_acct_for_each_worker(&wq->acct[i], func, data))
> -			return false;
> +		if (io_acct_for_each_worker(&wq->acct[i], func, data))
> +			return true;
>  	}
>  
> -	return true;
> +	return false;
>  }
>  
>  static bool io_wq_worker_wake(struct io_worker *worker, void *data)

-- 
Gabriel Krisman Bertazi

