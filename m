Return-Path: <io-uring+bounces-13167-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KBSBLL28GkpbgEAu9opvQ
	(envelope-from <io-uring+bounces-13167-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 20:04:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C00348A5E5
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 20:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 633813102D06
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 17:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149704657DC;
	Tue, 28 Apr 2026 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HQwQhovJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KeS3/+np";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x4qf9UHP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vXx51rSe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD2A451051
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777398893; cv=none; b=UMSAtu04IIZ0KSANsrU1up3WC2/+anNGVAAMiN+CqCTVvzZ7NUrf40Ir01qiStkRsMBr6MNhCnWd9W7bRYavDBABt6c2/dQAST4RGm8w/LeArnh2jy8vxjon9PEqFtlo5nW4pySY2TLEU0dUGFACGn5/kLWWhn+R/0NvUXBQwXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777398893; c=relaxed/simple;
	bh=6+QiyC11p4caZuOxYO7BxpVsa5BD6keoa8/BndMYoHk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YXN+ZDUl6otYRCf5rr4QqwJaHJ46At9APndn0vQ1pMIvX0irn7XOYg0eoOG3JmraQ8ZoD93rtwQ95ydFWShvk4JHR/TIzL3YYzYenXQrFA2hDWRHmqpuh7Jn3hegML7Vw8bRnbRCluMogf/A9VDSN/GK9Yf2/TMCBUEvju+ZdrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HQwQhovJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KeS3/+np; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x4qf9UHP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vXx51rSe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 832B75BCE9;
	Tue, 28 Apr 2026 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777398890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9l+tVkBfDUQXp3rnP5e22YXZPAqx+0yS4UkOTNL2AY=;
	b=HQwQhovJAH+HX4eSOUCuaLTwOC0eoEyrMW4wVqyzMHjV7rd6fsV7FK0c9gfIBwTJHt2FRF
	Q9sp6Xlax2aaRNaP99zC9BaZed3OQRli177yvpyzIPFFMJHa1/XfZTwfCZfmFnwmWLicmi
	tj2rvLg355nl+s6cQjrMh7V2n/HrDt8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777398890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9l+tVkBfDUQXp3rnP5e22YXZPAqx+0yS4UkOTNL2AY=;
	b=KeS3/+npSx3AFPT2x/XG4xXHtEpfMVb0gBKxURtgsvcgpvS6xK8fDsHR3i9zk8GAiCSsYV
	o6Rh1eR5ItKilNBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777398889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9l+tVkBfDUQXp3rnP5e22YXZPAqx+0yS4UkOTNL2AY=;
	b=x4qf9UHPQSY9amwp7jlVquJMmchSYBLEw0GbalGMhRo8M1PP0JNFg1NDob7IxF4xCdr+DJ
	5GtOWMjMtjBzEvjy0+DdaKln0JWAQ10nx6UVtILxP/9wYUZXDGBcQmpC1m0n6078H/hvkT
	R6FbiMEFWNliV1rtHmcBk5Avef2/JdU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777398889;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9l+tVkBfDUQXp3rnP5e22YXZPAqx+0yS4UkOTNL2AY=;
	b=vXx51rSeIedAJNWvqcAAySXMzjV8cFPmJ2vgR4uE9FCgHXhX1n9fBo2ou6zexQLGNsnw4G
	f2QV6WN25YMjHqAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32EA3593B0;
	Tue, 28 Apr 2026 17:54:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BiByAGn08GmeeAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 28 Apr 2026 17:54:49 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring/kbuf: kill dead struct io_buffer_list
 'nr_entries' member
In-Reply-To: <20260428154557.2150818-2-axboe@kernel.dk> (Jens Axboe's message
	of "Tue, 28 Apr 2026 09:44:49 -0600")
References: <20260428154557.2150818-1-axboe@kernel.dk>
	<20260428154557.2150818-2-axboe@kernel.dk>
Date: Tue, 28 Apr 2026 13:54:43 -0400
Message-ID: <87ecjzj7h8.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Queue-Id: 5C00348A5E5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13167-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.de:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mailhost.krisman.be:mid,suse.de:dkim,suse.de:email,kernel.dk:email]

Jens Axboe <axboe@kernel.dk> writes:

> This is only ever assigned, never used. The only used part is the
> calculated mask, which is used for indexing. Kill 'nr_entries'.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

> ---
>  io_uring/kbuf.c | 1 -
>  io_uring/kbuf.h | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 8da2ff798170..43e4f8615fe8 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -680,7 +680,6 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
>  	}
>  #endif
>  
> -	bl->nr_entries = reg.ring_entries;
>  	bl->mask = reg.ring_entries - 1;
>  	bl->flags |= IOBL_BUF_RING;
>  	bl->buf_ring = br;
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index bf15e26520d3..abf7052b556e 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -27,7 +27,6 @@ struct io_buffer_list {
>  	__u16 bgid;
>  
>  	/* below is for ring provided buffers */
> -	__u16 nr_entries;
>  	__u16 head;
>  	__u16 mask;

-- 
Gabriel Krisman Bertazi

