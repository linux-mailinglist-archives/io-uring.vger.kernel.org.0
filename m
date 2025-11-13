Return-Path: <io-uring+bounces-10566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE1CC56D00
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C8D814EDFF4
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9176299A87;
	Thu, 13 Nov 2025 10:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EEK1IAlt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7NL5ZGFf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EEK1IAlt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7NL5ZGFf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FB71FF7B3
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029142; cv=none; b=ahzfCqAxJ+XUsZLCsm4cebRnsj5prxB8nsAeamba6i33ZU7+DjtuSbJH5Fd5Fqg/I6sgamDKANDYDpXVUITs4sLX0nH/NnPTl10Dm3QYUS1VyZq7QVDebPCK4rBaXJza7MRPguvAXIuXwoIZp0viYgrKQlvscKRKnPzD96uOYSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029142; c=relaxed/simple;
	bh=3fmrTSAjsbZy3B2YOioL8lGu5erGvT9lQTGefONp5Sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vq7i9bz+RU+8TwkWFo+fm9if6aYHQ/MPTs/8tCx5WKrJ0qoVQlWa1kdhy2Tt9+hKZz/Nrr6M7JO0wog8rFD2vAAeRxiNbjKFO5VYAh/nADaOawKqX2bnM5Rm8HxAoUgzeJZM09SuK1gl0DWwHY7f7m2VWn847mD0J+TrAJyVtZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EEK1IAlt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7NL5ZGFf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EEK1IAlt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7NL5ZGFf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 780DB21849;
	Thu, 13 Nov 2025 10:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7Kjct+mk1VhLueUFXbgMPdVkcfU/C5IfafVKNGHSUc=;
	b=EEK1IAltTTXdKxBpVPiAV1TxWP9QwaCZvQhCZTSIhHUfgmHMYPCLWPDtw99XAdzQfoB+UA
	etFouwOY7lmp64r68hOWxYeMKcG/nNvYwb1cVX5T8nQ9gbDOl2O4HZIfCwL4aoRXezqU/p
	V3Cd6m/AR8M5T7n4biaiDkK3rw0o7j8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7Kjct+mk1VhLueUFXbgMPdVkcfU/C5IfafVKNGHSUc=;
	b=7NL5ZGFfy1nh4gZhwcY9xvD1vSV7johmY0pgo+NkVzwrcUI2OSbVJ1Kf3y85zzW9ez5CGO
	fM3UlzN3EYigQIAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EEK1IAlt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7NL5ZGFf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763029139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7Kjct+mk1VhLueUFXbgMPdVkcfU/C5IfafVKNGHSUc=;
	b=EEK1IAltTTXdKxBpVPiAV1TxWP9QwaCZvQhCZTSIhHUfgmHMYPCLWPDtw99XAdzQfoB+UA
	etFouwOY7lmp64r68hOWxYeMKcG/nNvYwb1cVX5T8nQ9gbDOl2O4HZIfCwL4aoRXezqU/p
	V3Cd6m/AR8M5T7n4biaiDkK3rw0o7j8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763029139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7Kjct+mk1VhLueUFXbgMPdVkcfU/C5IfafVKNGHSUc=;
	b=7NL5ZGFfy1nh4gZhwcY9xvD1vSV7johmY0pgo+NkVzwrcUI2OSbVJ1Kf3y85zzW9ez5CGO
	fM3UlzN3EYigQIAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C4A43EA61;
	Thu, 13 Nov 2025 10:18:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lbhsGpOwFWnlJgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:18:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 34BF8A0976; Thu, 13 Nov 2025 11:18:59 +0100 (CET)
Date: Thu, 13 Nov 2025 11:18:59 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 08/13] do_sys_truncate(): import pathname only once
Message-ID: <arcknrpnyknuqttlqehrjwveufd2xpzdlq3ao4bizwdmkz2kog@aj77rfxxcdah>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-9-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-9-viro@zeniv.linux.org.uk>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 780DB21849
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux-foundation.org,kernel.org,suse.cz,gmail.com,paul-moore.com,kernel.dk];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -4.01

On Sun 09-11-25 06:37:40, Al Viro wrote:
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
>  fs/open.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index e67baae339fc..eb2ff940393d 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -129,14 +129,16 @@ EXPORT_SYMBOL_GPL(vfs_truncate);
>  int do_sys_truncate(const char __user *pathname, loff_t length)
>  {
>  	unsigned int lookup_flags = LOOKUP_FOLLOW;
> +	struct filename *name;
>  	struct path path;
>  	int error;
>  
>  	if (length < 0)	/* sorry, but loff_t says... */
>  		return -EINVAL;
>  
> +	name = getname(pathname);
>  retry:
> -	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
> +	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
>  	if (!error) {
>  		error = vfs_truncate(&path, length);
>  		path_put(&path);
> @@ -145,6 +147,7 @@ int do_sys_truncate(const char __user *pathname, loff_t length)
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

