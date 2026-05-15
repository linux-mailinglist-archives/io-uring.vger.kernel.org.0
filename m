Return-Path: <io-uring+bounces-13367-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eDr3KKNdB2qw0QIAu9opvQ
	(envelope-from <io-uring+bounces-13367-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 19:53:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B7A555ABA
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 19:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E23431D620A
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4BE380FD3;
	Fri, 15 May 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s46AgSbC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FG/7LPI5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vT5hGjb9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kWc+ZUwe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD847380FE1
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864458; cv=none; b=p1VcuS5RoSvMmywuNd9UB3xKC1xuDHmUh501V8wN5ZM0z034MNt7hvLMvlypaj/7aeTavmDTtwhKy5IiZ0+WILhholTn29y8x0pGt70HEtEq44ED2do2Ea5MygGlva/cZuFL1kSXpMJkhUQ6E83B78d2UGyj+GLwgqgazAyaM8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864458; c=relaxed/simple;
	bh=/TLXnS93AtysXOQAjmTGMKgF6JIjmGgEefeEDP90Amk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jCklBzS2s046if7e4wqFbQJvpuFMJF15MoMRhtsnBq87lWF1NhYVyyFkR3LzcWL7lFNPEyQpYgwk+2yYeZUtcRakAanlLfV0e1GhqfqRBn+V89W8yDHYgksc/1ZDXujASX8fc3VICcTb1uKVK0ViwJmFI4UwWsxApxmOFcq8LGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s46AgSbC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FG/7LPI5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vT5hGjb9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kWc+ZUwe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C35DB6B686;
	Fri, 15 May 2026 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778864455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jDQiPc9pfyGBWxX8ndPhqdoc30mlRUgOmkothmid6uU=;
	b=s46AgSbCcFP8yOyfq06z0FEZXMt3jq78R6PaCPtoKcEYGcIrY+or5LrIWtyyLLNZUs1zgO
	iRHdAbkkvG+61KTkWdsgG+7iBiQqwb297lonhH3kgWBnuqclMPRP7Kkba3Skb4Vc152MiK
	ZrK7e5Rzp5F8kb2aIZQNuYCLQlqVK3s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778864455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jDQiPc9pfyGBWxX8ndPhqdoc30mlRUgOmkothmid6uU=;
	b=FG/7LPI5Eys4Xt7npUsNFmIpx3XCJ2akY+Ky6ogpUhck7YIxeMjHRyjsWCZaCEAFL7u4MU
	/EIC7AB06eK3kxAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778864454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jDQiPc9pfyGBWxX8ndPhqdoc30mlRUgOmkothmid6uU=;
	b=vT5hGjb9eVpAMgde+FpkOUx9/KE+UnNAJ10ifQAX8QItvJOmtTQXFRNuzGPeU4uLy5d8de
	VUnSMwMrNBnWOuOoYZmAty8sCcwYhR36V7MkeeXJHEmSd23Id89vdiOFfMu4aaTWdkp11Y
	To9eJbVhzS3uG3vn+JxryWjzYMnTfaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778864454;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jDQiPc9pfyGBWxX8ndPhqdoc30mlRUgOmkothmid6uU=;
	b=kWc+ZUweQvF9kUJ3DAwkPEeO77oCNEEUaBo/53c04YkJ/PGPDaZBA/spqyX+1abEnguNAW
	QSxX8kc7qHzx+PBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74332593A9;
	Fri, 15 May 2026 17:00:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cZ76D0ZRB2qyPgAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 15 May 2026 17:00:54 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/net: punt IORING_OP_BIND async if it needs
 file create
In-Reply-To: <37dbe977-6d1f-401e-b1dc-5d448ea27a8c@kernel.dk> (Jens Axboe's
	message of "Fri, 15 May 2026 10:37:44 -0600")
References: <37dbe977-6d1f-401e-b1dc-5d448ea27a8c@kernel.dk>
Date: Fri, 15 May 2026 13:00:52 -0400
Message-ID: <875x4o620r.fsf@mailhost.krisman.be>
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
X-Rspamd-Queue-Id: 17B7A555ABA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13367-lists,io-uring=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email,suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action

Jens Axboe <axboe@kernel.dk> writes:

> For two reasons:
>
> 1) An opcode cannot block inside io_uring_enter() doing submissions, as
>    it'll stall the submission side pipeline.
>
> 2) Ending up in sb_start_write() -> __sb_start_write() ->
>    percpu_down_read_freezable() introduces a new lockdep edge, which it
>    correctly complains about.
>
> Check if the socket type is AF_UNIX and has a non-empty pathname. If it
> does, mark it REQ_F_FORCE_ASYNC to punt the submission to io-wq rather
> than attempt to do it inline.
>
> Fixes: 7481fd93fa0a ("io_uring: Introduce IORING_OP_BIND")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 30cd22c0b934..1f5fd8c37a5a 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -4,6 +4,7 @@
>  #include <linux/file.h>
>  #include <linux/slab.h>
>  #include <linux/net.h>
> +#include <linux/un.h>
>  #include <linux/compat.h>
>  #include <net/compat.h>
>  #include <linux/io_uring.h>
> @@ -1799,11 +1800,29 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>  	return IOU_COMPLETE;
>  }
>  
> +/*
> + * Check if bind request would potentiall end up with filename_create(),

potentially

> + * which in turn end up in mnt_want_write() which will grab the fs
> + * percpu start write sem. This can trigger a lockdep warning.
> + */
> +static int io_bind_file_create(const struct io_async_msghdr *io, int addr_len)
> +{
> +	const struct sockaddr_un *sun;
> +
> +	if (io->addr.ss_family != AF_UNIX)
> +		return 0;
> +	if (addr_len <= offsetof(struct sockaddr_un, sun_path))
> +		return 0;
> +	sun = (const struct sockaddr_un *) &io->addr;
> +	return sun->sun_path[0] != '\0';
> +}
> +
>  int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
>  	struct sockaddr __user *uaddr;
>  	struct io_async_msghdr *io;
> +	int ret;
>  
>  	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
>  		return -EINVAL;
> @@ -1814,7 +1833,12 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	io = io_msg_alloc_async(req);
>  	if (unlikely(!io))
>  		return -ENOMEM;
> -	return move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
> +	ret = move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
> +	if (unlikely(ret))
> +		return ret;
> +	if (io_bind_file_create(io, bind->addr_len))
> +		req->flags |= REQ_F_FORCE_ASYNC;
> +	return 0;
>  }

Patch looks ok. I will add a TODO to myself to look into the bind call
getting a flag and returning -EWOULDBLOCK, so we can eventually drop the
workaround.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


>  
>  int io_bind(struct io_kiocb *req, unsigned int issue_flags)

-- 
Gabriel Krisman Bertazi

