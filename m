Return-Path: <io-uring+bounces-10561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C3FC56CA9
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 079334EBED2
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD92F2E11AA;
	Thu, 13 Nov 2025 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m1tbmn5n";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="W109emQf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m1tbmn5n";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="W109emQf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409382E7622
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028830; cv=none; b=ZUBzzWXIyxDhv4aYQIE6yVOkOGyBxpaZSkGZhL4lwHuBBjZDzt4nl1ylgf1w2NgNZ7iqYS93+LjxMy5VdOXRvzuoEVgQWutDw1y/xTjDNozNbZJsRA/oo0C1aSHTJhkUaaL5uMNDVGxLSDlWKAMuVRFsqve7b9EeBoVcWQGQNjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028830; c=relaxed/simple;
	bh=NSFQhQ8qI5TnBhTC3t78B9jHJbYwQi3P06DBPZIaaCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1C/QJwHS5THP6XEewUX1QIW0DTTJQoybBEeu0USwz6aOeG8lx3godARrpmYr9uE4w4H2l78jWsCTr0b+2yIhIp9RktUQWMB4akHsKk+OqVnrmckjsAc566CT9+V+T4e1nsRl5LLGv2zuXgFC7JUjazR1ub0lCkSIqVxcxHoltM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m1tbmn5n; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=W109emQf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m1tbmn5n; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=W109emQf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7D9011F388;
	Thu, 13 Nov 2025 10:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763028827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oEf9HMnlLOit5zphbeQ1qT0IFbPGT4gsvcLMLEJeJqU=;
	b=m1tbmn5nr/R3ekXkxibemsL43AyQ+tq1dZ56o3xXYvqXJXDA/A0cwnb+niS1vz0A9qJiU6
	jojV0OoFwmc4lHmTS04pnO8L54cqDJYMGVcDlb4NIBc9DvfuUtqnAP61jfBcChUZQrL6hH
	iU8rDFSUJYq6+rZlAPLL0P0KhHAADRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763028827;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oEf9HMnlLOit5zphbeQ1qT0IFbPGT4gsvcLMLEJeJqU=;
	b=W109emQft6VmeAMtOCkpDEOr6WakYYvr86sHKH/THXKoZ4Yyh7J9QSGYtd3NkrpPqZqIxc
	X5q04Ez/wKcNupBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763028827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oEf9HMnlLOit5zphbeQ1qT0IFbPGT4gsvcLMLEJeJqU=;
	b=m1tbmn5nr/R3ekXkxibemsL43AyQ+tq1dZ56o3xXYvqXJXDA/A0cwnb+niS1vz0A9qJiU6
	jojV0OoFwmc4lHmTS04pnO8L54cqDJYMGVcDlb4NIBc9DvfuUtqnAP61jfBcChUZQrL6hH
	iU8rDFSUJYq6+rZlAPLL0P0KhHAADRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763028827;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oEf9HMnlLOit5zphbeQ1qT0IFbPGT4gsvcLMLEJeJqU=;
	b=W109emQft6VmeAMtOCkpDEOr6WakYYvr86sHKH/THXKoZ4Yyh7J9QSGYtd3NkrpPqZqIxc
	X5q04Ez/wKcNupBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E28A3EA61;
	Thu, 13 Nov 2025 10:13:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rXDeGluvFWmJIQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:13:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EAC6EA0976; Thu, 13 Nov 2025 11:13:38 +0100 (CET)
Date: Thu, 13 Nov 2025 11:13:38 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 03/13] do_fchownat(): import pathname only once
Message-ID: <hauhv55cip6ropnmpqqhnlfkfza5c6ykzcrps7tfkrr35cm5ax@aixe6b5ze2xp>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-4-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-4-viro@zeniv.linux.org.uk>
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Sun 09-11-25 06:37:35, Al Viro wrote:
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
>  fs/open.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index e9a08a820e49..e5110f5e80c7 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -804,17 +804,17 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
>  		int flag)
>  {
>  	struct path path;
> -	int error = -EINVAL;
> +	int error;
>  	int lookup_flags;
> +	struct filename *name;
>  
>  	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
> -		goto out;
> +		return -EINVAL;
>  
>  	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
> -	if (flag & AT_EMPTY_PATH)
> -		lookup_flags |= LOOKUP_EMPTY;
> +	name = getname_uflags(filename, flag);
>  retry:
> -	error = user_path_at(dfd, filename, lookup_flags, &path);
> +	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
>  	if (error)
>  		goto out;
>  	error = mnt_want_write(path.mnt);
> @@ -829,6 +829,7 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
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

