Return-Path: <io-uring+bounces-10559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 920E5C56C51
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 318D334A622
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E502E091B;
	Thu, 13 Nov 2025 10:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UN5rYj6F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y2cTM4Lz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UN5rYj6F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y2cTM4Lz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEC02DF707
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028672; cv=none; b=gJBVtHrxuS2KCuOwpLTRskCYtRscir79uaEFFPdbl064Dya48xY3NQGMlTazwfAg+lWJk0xPBQaBq26eUWYoUgJudSt9PogMDUdeE3CD29yBH6P2fKMCucGORCKUsftEVmIL1d27iauyrdkosY63+ZS9h3PzE4m60LtWsELymLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028672; c=relaxed/simple;
	bh=zgRFi3u7a6nGZXuIEF1Khfjkui3bqgs5nGnibG5m/vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1V6V78KH++FpJz3lTt1rcaZCPR0Gmv4zRy1RUT7HmSkkx4JFzv59U5XuTW39EWaO4NfsSGQukdj4z7E+HxpJaVarg9oKltswxrJ7E6+grw53BP9Ku5wI2ETuJxQ253A8v/bTjwq4SgVwLvctQZ00gBCP3J2c6No6mk2W17mE2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UN5rYj6F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y2cTM4Lz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UN5rYj6F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y2cTM4Lz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F16821747;
	Thu, 13 Nov 2025 10:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763028668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SeiVtudgHN1hofwS4ktOJQIzcYNLapUABaiXBIABs28=;
	b=UN5rYj6FAcEl+rcTEn0STzroiUWmI+Bdp/xpQnwfjxA0DaOQr2ZMviTbOYlk2Rmb6Ovtha
	78U9vHAbOpQcQ+G8f1uC+v8IOs62C8i07Eik7qOt7ZPpgpQBspcpr76CVmSu9RMhWsJYK2
	egu5D9HPoR7cxHP4qFnps04++ayhIwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763028668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SeiVtudgHN1hofwS4ktOJQIzcYNLapUABaiXBIABs28=;
	b=Y2cTM4Lz4z9vSnOiYnoS5wLeynj2Vv9uVO6fJgoI14wFIkus2YK27MNF2mqt536hqtGSoy
	oLFg0eBAARUtGdAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763028668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SeiVtudgHN1hofwS4ktOJQIzcYNLapUABaiXBIABs28=;
	b=UN5rYj6FAcEl+rcTEn0STzroiUWmI+Bdp/xpQnwfjxA0DaOQr2ZMviTbOYlk2Rmb6Ovtha
	78U9vHAbOpQcQ+G8f1uC+v8IOs62C8i07Eik7qOt7ZPpgpQBspcpr76CVmSu9RMhWsJYK2
	egu5D9HPoR7cxHP4qFnps04++ayhIwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763028668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SeiVtudgHN1hofwS4ktOJQIzcYNLapUABaiXBIABs28=;
	b=Y2cTM4Lz4z9vSnOiYnoS5wLeynj2Vv9uVO6fJgoI14wFIkus2YK27MNF2mqt536hqtGSoy
	oLFg0eBAARUtGdAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8524A3EA61;
	Thu, 13 Nov 2025 10:11:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xGF5ILyuFWmMHgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:11:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3C6ACA0976; Thu, 13 Nov 2025 11:11:04 +0100 (CET)
Date: Thu, 13 Nov 2025 11:11:04 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 01/13] do_faccessat(): import pathname only once
Message-ID: <ar5w6zlak3mhwo6b5u2p2mxyquvzlzj5hovvnu54vpoxcfnfdp@6rnfonz3vfme>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-2-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-2-viro@zeniv.linux.org.uk>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux-foundation.org,kernel.org,suse.cz,gmail.com,paul-moore.com,kernel.dk];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Sun 09-11-25 06:37:33, Al Viro wrote:
> Convert the user_path_at() call inside a retry loop into getname_flags() +
> filename_lookup() + putname() and leave only filename_lookup() inside
> the loop.
> 
> Since we have the default logics for use of LOOKUP_EMPTY (passed iff
> AT_EMPTY_PATH is present in flags), just use getname_uflags() and
> don't bother with setting LOOKUP_EMPTY in lookup_flags - getname_uflags()
> will pass the right thing to getname_flags() and filename_lookup()
> doesn't care about LOOKUP_EMPTY at all.
> 
> The things could be further simplified by use of cleanup.h stuff, but
> let's not clutter the patch with that.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/open.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 3d64372ecc67..db8fe2b5463d 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -471,6 +471,7 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
>  	int res;
>  	unsigned int lookup_flags = LOOKUP_FOLLOW;
>  	const struct cred *old_cred = NULL;
> +	struct filename *name;
>  
>  	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
>  		return -EINVAL;
> @@ -480,8 +481,6 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
>  
>  	if (flags & AT_SYMLINK_NOFOLLOW)
>  		lookup_flags &= ~LOOKUP_FOLLOW;
> -	if (flags & AT_EMPTY_PATH)
> -		lookup_flags |= LOOKUP_EMPTY;
>  
>  	if (access_need_override_creds(flags)) {
>  		old_cred = access_override_creds();
> @@ -489,8 +488,9 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
>  			return -ENOMEM;
>  	}
>  
> +	name = getname_uflags(filename, flags);
>  retry:
> -	res = user_path_at(dfd, filename, lookup_flags, &path);
> +	res = filename_lookup(dfd, name, lookup_flags, &path, NULL);
>  	if (res)
>  		goto out;
>  
> @@ -530,6 +530,7 @@ static int do_faccessat(int dfd, const char __user *filename, int mode, int flag
>  		goto retry;
>  	}
>  out:
> +	putname(name);
>  	if (old_cred)
>  		put_cred(revert_creds(old_cred));
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

