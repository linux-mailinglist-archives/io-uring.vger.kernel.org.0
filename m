Return-Path: <io-uring+bounces-10565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F30C56CB8
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5B25F351282
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27B81FF7B3;
	Thu, 13 Nov 2025 10:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uq4k+Flh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DxPN5IHg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uq4k+Flh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DxPN5IHg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2460530AAB4
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029132; cv=none; b=bA51S8pYCdjKNvNKTOqwVHzDdfceTqWY/PQDj4Noo6jPjqY9Ev2tvRpRHwx9X19K3UsmgFUYMYx9HGGnpGJGFAAwq8Y05j9WgvytbmhKTOyw/unK0XkvCDXFvJnNSTSKRbcp+M+LaPZVRqujOUlEwFnvjIZvP+aauxChA5/ZqOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029132; c=relaxed/simple;
	bh=TUAHQyiEiWAOH/AUxj4xpx7MVxEsaOb5qUr+KYy+u4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNhW5c0ja5QzuGwjRBGonVYxPoNHeYVulWEnMIRnUE8s12ng3T73jAJOYfqF45KBcwlvAqR5y+zk8sFHS5e0n5QxTrQY9txojaX8EDwdiTTTiZn6jeheLU77BEg1BnFLauN98Wl+N/2vUyPMFdjhmPCNtjDPzliP1JkTmoDFjzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uq4k+Flh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DxPN5IHg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uq4k+Flh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DxPN5IHg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2976421849;
	Thu, 13 Nov 2025 10:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zXsOeXInTJFwL13KogZe+R2I6non9sIlj1vYWbb0T9o=;
	b=uq4k+FlhAZJ5kJij2rmy43Ea+3qbeYpGBD2T0lwZCKR+PIqTW081ulJjuwZYsrLxdmhEZO
	XfCYnqnYhoH3+KGJYZx6kwFPm8ZfSdbUCmq/nDsjohz77JI8BVJd1YBLC+K9TX7+xF35tp
	x2xEwTmgAKr4RsLoc8x2XYtK0Ni+RVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zXsOeXInTJFwL13KogZe+R2I6non9sIlj1vYWbb0T9o=;
	b=DxPN5IHgjHbyS9AymYNH9j0JKvxuDn55285zGPQmodqHR5CDl4rsKxyJF6B/nSHd2PNSvd
	PU1FC1Ux/WtKnRCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uq4k+Flh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DxPN5IHg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zXsOeXInTJFwL13KogZe+R2I6non9sIlj1vYWbb0T9o=;
	b=uq4k+FlhAZJ5kJij2rmy43Ea+3qbeYpGBD2T0lwZCKR+PIqTW081ulJjuwZYsrLxdmhEZO
	XfCYnqnYhoH3+KGJYZx6kwFPm8ZfSdbUCmq/nDsjohz77JI8BVJd1YBLC+K9TX7+xF35tp
	x2xEwTmgAKr4RsLoc8x2XYtK0Ni+RVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zXsOeXInTJFwL13KogZe+R2I6non9sIlj1vYWbb0T9o=;
	b=DxPN5IHgjHbyS9AymYNH9j0JKvxuDn55285zGPQmodqHR5CDl4rsKxyJF6B/nSHd2PNSvd
	PU1FC1Ux/WtKnRCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D8C23EA61;
	Thu, 13 Nov 2025 10:18:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eFU0B4mwFWnYJgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:18:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D637AA0976; Thu, 13 Nov 2025 11:18:33 +0100 (CET)
Date: Thu, 13 Nov 2025 11:18:33 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 07/13] user_statfs(): import pathname only once
Message-ID: <emxajufuojjhec3afuqopsvl5ysogkxnwtskfoxj5tw2tqobup@4gvrhzrkdk2x>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-8-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-8-viro@zeniv.linux.org.uk>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 2976421849
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

On Sun 09-11-25 06:37:39, Al Viro wrote:
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
>  fs/statfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/statfs.c b/fs/statfs.c
> index a45ac85e6048..a5671bf6c7f0 100644
> --- a/fs/statfs.c
> +++ b/fs/statfs.c
> @@ -99,8 +99,9 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
>  	struct path path;
>  	int error;
>  	unsigned int lookup_flags = LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT;
> +	struct filename *name = getname(pathname);
>  retry:
> -	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
> +	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
>  	if (!error) {
>  		error = vfs_statfs(&path, st);
>  		path_put(&path);
> @@ -109,6 +110,7 @@ int user_statfs(const char __user *pathname, struct kstatfs *st)
>  			goto retry;
>  		}
>  	}
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

