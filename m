Return-Path: <io-uring+bounces-10564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 086DCC56CEE
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AEEB14EAAE6
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732E12D8782;
	Thu, 13 Nov 2025 10:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wbPNY2dU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O+RXwkl0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wbPNY2dU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O+RXwkl0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78C735CBAF
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029084; cv=none; b=uVx9vtW+drsCsjVzIYbD8vEaJp95tPr3GiuHYr4zgWdBNmr4We5jOg/sG+W4J2u/DfgGk8+UH6VK5w5WIf3DgINIoVhB8sUgOf7qhg9XAP6K6gJGjINYgwqy0Q8hEQP4TUvIeLW8hI7FZpI+XlAqKQ2VaB5+Jn7/bbQRIPC59og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029084; c=relaxed/simple;
	bh=GBzV1SUhyhpS4br1P35y7K7qWIR0kry4aj2PAwUM0ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MpV3mcePvRoGo+l39Ap9VTReY1mM9fY+KU2wQ7Nw/BYovJkfgzBxE6lUZpBjlyu6Wybx1DgHnGbE38daDDYcd8ZyuWDRRUjk3zI+lyXDahSwyUNi3FTk9ri38yZ+NVFJc8jCjwiz8nkcj/sh1nYSUq1Ds9FKzz676bJZ4+8rOyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wbPNY2dU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O+RXwkl0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wbPNY2dU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O+RXwkl0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 05C2B1F791;
	Thu, 13 Nov 2025 10:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1VdZFWGXD88wKfx0Dqzdj8ViL6YS9ZGikXFrMamkso=;
	b=wbPNY2dUaCESVuF7GaGZngyi6g8fq5x7i6yzkr1gyITS7i3gIfvrvp7iK/pdNESVQoqZnm
	bROSLIAd6u1SS8V79p0ib5LUBbxzhgemIV8xDDNVJasSroUGOGwEcv3eqiJdVAezOmCgzO
	/CgaRHCj5l60+H96dk3xJ2fqot/0jps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1VdZFWGXD88wKfx0Dqzdj8ViL6YS9ZGikXFrMamkso=;
	b=O+RXwkl0sUt8krhVxKjSmIr9XSocvFjkyPbPguzMj5DBVcY0EsJDQGNoyYMXPq8QYNbu6U
	JOf4dGuEzZQAFQCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wbPNY2dU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O+RXwkl0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1VdZFWGXD88wKfx0Dqzdj8ViL6YS9ZGikXFrMamkso=;
	b=wbPNY2dUaCESVuF7GaGZngyi6g8fq5x7i6yzkr1gyITS7i3gIfvrvp7iK/pdNESVQoqZnm
	bROSLIAd6u1SS8V79p0ib5LUBbxzhgemIV8xDDNVJasSroUGOGwEcv3eqiJdVAezOmCgzO
	/CgaRHCj5l60+H96dk3xJ2fqot/0jps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1VdZFWGXD88wKfx0Dqzdj8ViL6YS9ZGikXFrMamkso=;
	b=O+RXwkl0sUt8krhVxKjSmIr9XSocvFjkyPbPguzMj5DBVcY0EsJDQGNoyYMXPq8QYNbu6U
	JOf4dGuEzZQAFQCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF53E3EA61;
	Thu, 13 Nov 2025 10:18:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mctsOliwFWlyJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:18:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AF64EA0976; Thu, 13 Nov 2025 11:18:00 +0100 (CET)
Date: Thu, 13 Nov 2025 11:18:00 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 06/13] chroot(2): import pathname only once
Message-ID: <kmyqhxqnqjkaxgp4h3xqw7vi72fjki5yppqjxfv7wctcspuujy@iltngslimz2w>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-7-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-7-viro@zeniv.linux.org.uk>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 05C2B1F791
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux-foundation.org,kernel.org,suse.cz,gmail.com,paul-moore.com,kernel.dk];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email]
X-Spam-Score: -4.01

On Sun 09-11-25 06:37:38, Al Viro wrote:
> Convert the user_path_at() call inside a retry loop into getname_flags() +
> filename_lookup() + putname() and leave only filename_lookup() inside
> the loop.
> 
> In this case we never pass LOOKUP_EMPTY, so getname_flags() is equivalent
> to plain getname().
> 
> The things could be further simplified by use of cleanup.h stuff, but
> let's not clutter the patch with that.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/open.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 8bc2f313f4a9..e67baae339fc 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -603,8 +603,9 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
>  	struct path path;
>  	int error;
>  	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
> +	struct filename *name = getname(filename);
>  retry:
> -	error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
> +	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
>  	if (error)
>  		goto out;
>  
> @@ -628,6 +629,7 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
>  		goto retry;
>  	}
>  out:
> +	putname(name);
>  	return error;
>  }
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

