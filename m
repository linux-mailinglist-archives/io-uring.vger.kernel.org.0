Return-Path: <io-uring+bounces-10563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E057EC56CE2
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:21:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 91C064E9691
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A07114AD20;
	Thu, 13 Nov 2025 10:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qQpTctel";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0ICGhdz4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qQpTctel";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0ICGhdz4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB282C1589
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029023; cv=none; b=KQXxMnZ2mcHZd5VNkgj9mkX1yQ91J8JDXQtfhsWy2RIUxP3VMK+wl/w4Wn7h43cUJTIRrZCF5rvC/hNaj2hTSrXFG9RjSDAA83ApTggD/GqdLkH63q6NdK8Ctp70NIN88wQrqnvWu1XA9PPLm3IisrdlOmx4OZ9pufIMZZ8mfH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029023; c=relaxed/simple;
	bh=jyOKaWfyuth3TnTe7FdsWLIUlUrwciLsugeidJUoL0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=noLAN/7vjXLqBodMfHUuUDZH7Tf4CID8ztqEKnzVGqfXoa1WqUVg+3zUIDZXo+t92iNFpIFNrVrm0Xlr47GbdqexjLJtPJ6xZXZldXvQ1Vhsy91wFpc+yfK1jGQEqYSaRtVNc/KNzBZ1oX7HyxqEXc48JUu8bb4X4iCWgxroRD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qQpTctel; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0ICGhdz4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qQpTctel; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0ICGhdz4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC89121753;
	Thu, 13 Nov 2025 10:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xf+r9VapMFdQVFaBf3eysa/hMVnqT5Mw4yKTQP9VTFA=;
	b=qQpTctel0S61H2HfCLSGRhfPHGxYikQ9yJtJ68+qMENLmzqVQdHDL9qCYsIPoHO9QhEjuc
	oz5NcJpTTD7Qt1um2m4UoHmz2cU7gzKTFBOFBd7a8/9RauyAwR/6HAoDhmVIIg2L6PGhFN
	mXCy/7r5yxKwvrPt+NLO1xIDH9Iaehs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xf+r9VapMFdQVFaBf3eysa/hMVnqT5Mw4yKTQP9VTFA=;
	b=0ICGhdz44sILc2SVZrivQXGinTnfKxe5ZjW1lM84sNbtEOio2dcLH6C1eUnO9UDs7sQI4l
	D4ypad3RhY1/b5CQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qQpTctel;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0ICGhdz4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xf+r9VapMFdQVFaBf3eysa/hMVnqT5Mw4yKTQP9VTFA=;
	b=qQpTctel0S61H2HfCLSGRhfPHGxYikQ9yJtJ68+qMENLmzqVQdHDL9qCYsIPoHO9QhEjuc
	oz5NcJpTTD7Qt1um2m4UoHmz2cU7gzKTFBOFBd7a8/9RauyAwR/6HAoDhmVIIg2L6PGhFN
	mXCy/7r5yxKwvrPt+NLO1xIDH9Iaehs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xf+r9VapMFdQVFaBf3eysa/hMVnqT5Mw4yKTQP9VTFA=;
	b=0ICGhdz44sILc2SVZrivQXGinTnfKxe5ZjW1lM84sNbtEOio2dcLH6C1eUnO9UDs7sQI4l
	D4ypad3RhY1/b5CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2B5A3EA61;
	Thu, 13 Nov 2025 10:16:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DQm4JxqwFWmhJAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:16:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54F15A0976; Thu, 13 Nov 2025 11:16:54 +0100 (CET)
Date: Thu, 13 Nov 2025 11:16:54 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 05/13] chdir(2): import pathname only once
Message-ID: <qthk7sbmazfhp7c55lizukktgisnupianwppottre3fjlgikrj@s2mjmkspifo3>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-6-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-6-viro@zeniv.linux.org.uk>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: AC89121753
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email]
X-Spam-Score: -4.01

On Sun 09-11-25 06:37:37, Al Viro wrote:
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
> index e5110f5e80c7..8bc2f313f4a9 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -558,8 +558,9 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
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
> @@ -576,6 +577,7 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
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

