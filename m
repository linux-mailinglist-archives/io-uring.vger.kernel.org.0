Return-Path: <io-uring+bounces-10567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A08EC56CD6
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 426BE3A66C0
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830671FF7B3;
	Thu, 13 Nov 2025 10:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Uc7TzN2h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mHZyhbYa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Uc7TzN2h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mHZyhbYa"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2792E2840
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029233; cv=none; b=KYRnCu/z6f9Q2+FjHxl7sOsemzoEL/eWb620L/6gts8CRugCHlsM3Di/k/mGJYAxx8i/1MUXr1fKjbVE1IbTfSXlXu4+tbiQ6JmKdRFeh012zasA3QemD8Xmsu9iVKcYUD6Ycu5g9mtJb4ob4c+vie5ZEF6vvtuMgW5Ehm2dR6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029233; c=relaxed/simple;
	bh=fw+6V0FMKa/CBAYLIhgIMiBZyXj1lC2RCKSfpqLQspQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENx4HU5GgCT94f+sg00nVC72ledsr+7an/CIp2ysJMNyzJn5d2rajD6dFtpzCZ4nzptGgs0BLHTjvM8j/zP0EbOznB/554+FsE1ypUXucLJyee8gJyZjVQwn+z12oZw50/PHI0qELatIGwpPYR1XKLoQ50WtSijnvsPMOyztVR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Uc7TzN2h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mHZyhbYa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Uc7TzN2h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mHZyhbYa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F28B1F800;
	Thu, 13 Nov 2025 10:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQue0PJ82vfOnPaqwxVX5IIj+rLKofDJBjoEcobmjs8=;
	b=Uc7TzN2hcaRNZxIYkqk0p1Fsx1YyNKYQA5TlYgCNz3JzLIGO0Re7eO56hQc6al8EJnUIrV
	/O6pX9jexTscSmVJMsBCymnjo/8aJWg04fZhoVEmUVlZiED9TGRFereukZ/MW93M8xiqTq
	3CywRm3WUO1udYY8twnH9iBzgjS3eXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQue0PJ82vfOnPaqwxVX5IIj+rLKofDJBjoEcobmjs8=;
	b=mHZyhbYaSrs1zSgLGPmkfAoIf7E08yMR24VJzG63ZI4IoftJE3sgm0BvVxTE4+3bj8f1ne
	/0BP3cd0ytoGiTDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Uc7TzN2h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mHZyhbYa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQue0PJ82vfOnPaqwxVX5IIj+rLKofDJBjoEcobmjs8=;
	b=Uc7TzN2hcaRNZxIYkqk0p1Fsx1YyNKYQA5TlYgCNz3JzLIGO0Re7eO56hQc6al8EJnUIrV
	/O6pX9jexTscSmVJMsBCymnjo/8aJWg04fZhoVEmUVlZiED9TGRFereukZ/MW93M8xiqTq
	3CywRm3WUO1udYY8twnH9iBzgjS3eXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQue0PJ82vfOnPaqwxVX5IIj+rLKofDJBjoEcobmjs8=;
	b=mHZyhbYaSrs1zSgLGPmkfAoIf7E08yMR24VJzG63ZI4IoftJE3sgm0BvVxTE4+3bj8f1ne
	/0BP3cd0ytoGiTDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 201B43EA61;
	Thu, 13 Nov 2025 10:20:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 387XB+6wFWkEKAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:20:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D809CA0976; Thu, 13 Nov 2025 11:20:25 +0100 (CET)
Date: Thu, 13 Nov 2025 11:20:25 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 09/13] do_readlinkat(): import pathname only once
Message-ID: <ynfg5hg2ndye7f4d2crubmwq5br7rzi2pn3ka6vqsd7ndihzke@jnf743scaayv>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-10-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-10-viro@zeniv.linux.org.uk>
X-Rspamd-Queue-Id: 2F28B1F800
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux-foundation.org,kernel.org,suse.cz,gmail.com,paul-moore.com,kernel.dk];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.org.uk:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Sun 09-11-25 06:37:41, Al Viro wrote:
> Take getname_flags() and putname() outside of retry loop.
> 
> Since getname_flags() is the only thing that cares about LOOKUP_EMPTY,
> don't bother with setting LOOKUP_EMPTY in lookup_flags - just pass it
> to getname_flags() and be done with that.
> 
> The things could be further simplified by use of cleanup.h stuff, but
> let's not clutter the patch with that.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/stat.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/stat.c b/fs/stat.c
> index 6c79661e1b96..ee9ae2c3273a 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -566,13 +566,13 @@ static int do_readlinkat(int dfd, const char __user *pathname,
>  	struct path path;
>  	struct filename *name;
>  	int error;
> -	unsigned int lookup_flags = LOOKUP_EMPTY;
> +	unsigned int lookup_flags = 0;
>  
>  	if (bufsiz <= 0)
>  		return -EINVAL;
>  
> +	name = getname_flags(pathname, LOOKUP_EMPTY);
>  retry:
> -	name = getname_flags(pathname, lookup_flags);
>  	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
>  	if (unlikely(error)) {
>  		putname(name);
> @@ -593,11 +593,11 @@ static int do_readlinkat(int dfd, const char __user *pathname,
>  		error = (name->name[0] == '\0') ? -ENOENT : -EINVAL;
>  	}
>  	path_put(&path);
> -	putname(name);
>  	if (retry_estale(error, lookup_flags)) {
>  		lookup_flags |= LOOKUP_REVAL;
>  		goto retry;
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

