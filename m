Return-Path: <io-uring+bounces-10562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0872DC56CD9
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 495F44E801D
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456243161A6;
	Thu, 13 Nov 2025 10:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WVtBWMug";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TYYXnRvo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WVtBWMug";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TYYXnRvo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ADB2E7658
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028963; cv=none; b=RfHkJ+gfDDgo9MpCAOFJfS8oppxWtSuiB84x9/m4+bi1dSRDHx8qwYuL5T8cCaO6fb2uQefgSyLMko2NXBBIBg/yLMN9AS9IzuEUD8zmexGpLE4Nr8+fsecIGKXse5ISXHlhRSpkQdRFpDdmPXzrpRhf6yOvVYCIxnHWixjKCtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028963; c=relaxed/simple;
	bh=Z3yScVCfEtSSJZo6vYGTjz6XESfL1V8iAJBoirYSajQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taotTiv9vuXjrs7uzPUL9KCIsJY5cLeAXnMbIfEXWlO5Z1uRzE/AtjadxZtMmTHRZUi584jbOWcFk5f390pieNbT2O1jouCqeN3uEjthGrhZAy7TQlqAaJnRrcGiXF6SQ8gU1KY55YVLkg7p9UCkJTXbpKrIm8o2c/YSaYIyL04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WVtBWMug; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TYYXnRvo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WVtBWMug; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TYYXnRvo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3616C1F388;
	Thu, 13 Nov 2025 10:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763028959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gA3y23KGPXIhR6UgbiAsghOlJgt6+hU2EzIDApijX9c=;
	b=WVtBWMugyY++qPG1xEAlSQB4VChLiJpkU3YqiNtJcPNpu0KttWp61Rfd7Nm0Jbw/orgClv
	E6k4HfLkKT8TF2Rwd6e9Cp6jdlb2rsziGU3jDAtUGYYIlIlJxGEtxHsl7UCCsgv2PA0UrF
	eePjvjq5f+WFqqc7ne/8oh/aPD+41CY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763028959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gA3y23KGPXIhR6UgbiAsghOlJgt6+hU2EzIDApijX9c=;
	b=TYYXnRvooONPbw5HqWqDX9ISpnrwgbIcdZk8bMul6Np1mi5oRz3Nxuu6nbHeGDkP7Aznz1
	VRR6qctPUjLSvWBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763028959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gA3y23KGPXIhR6UgbiAsghOlJgt6+hU2EzIDApijX9c=;
	b=WVtBWMugyY++qPG1xEAlSQB4VChLiJpkU3YqiNtJcPNpu0KttWp61Rfd7Nm0Jbw/orgClv
	E6k4HfLkKT8TF2Rwd6e9Cp6jdlb2rsziGU3jDAtUGYYIlIlJxGEtxHsl7UCCsgv2PA0UrF
	eePjvjq5f+WFqqc7ne/8oh/aPD+41CY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763028959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gA3y23KGPXIhR6UgbiAsghOlJgt6+hU2EzIDApijX9c=;
	b=TYYXnRvooONPbw5HqWqDX9ISpnrwgbIcdZk8bMul6Np1mi5oRz3Nxuu6nbHeGDkP7Aznz1
	VRR6qctPUjLSvWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29EFF3EA61;
	Thu, 13 Nov 2025 10:15:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1GQ8Ct+vFWnIIwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:15:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DEA8FA0976; Thu, 13 Nov 2025 11:15:54 +0100 (CET)
Date: Thu, 13 Nov 2025 11:15:54 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 04/13] do_utimes_path(): import pathname only once
Message-ID: <cyz62c6deuwpbr3qw4zdghqbyykzfvuwgqkazbh76oaolexan6@pdxsskeemg5c>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-5-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-5-viro@zeniv.linux.org.uk>
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

On Sun 09-11-25 06:37:36, Al Viro wrote:
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
>  fs/utimes.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/utimes.c b/fs/utimes.c
> index c7c7958e57b2..262a4ddeb9cc 100644
> --- a/fs/utimes.c
> +++ b/fs/utimes.c
> @@ -8,6 +8,7 @@
>  #include <linux/compat.h>
>  #include <asm/unistd.h>
>  #include <linux/filelock.h>
> +#include "internal.h"
>  
>  static bool nsec_valid(long nsec)
>  {
> @@ -82,27 +83,27 @@ static int do_utimes_path(int dfd, const char __user *filename,
>  {
>  	struct path path;
>  	int lookup_flags = 0, error;
> +	struct filename *name;
>  
>  	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
>  		return -EINVAL;
>  
>  	if (!(flags & AT_SYMLINK_NOFOLLOW))
>  		lookup_flags |= LOOKUP_FOLLOW;
> -	if (flags & AT_EMPTY_PATH)
> -		lookup_flags |= LOOKUP_EMPTY;
> +	name = getname_uflags(filename, flags);
>  
>  retry:
> -	error = user_path_at(dfd, filename, lookup_flags, &path);
> +	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
>  	if (error)
> -		return error;
> -
> +		goto out;
>  	error = vfs_utimes(&path, times);
>  	path_put(&path);
>  	if (retry_estale(error, lookup_flags)) {
>  		lookup_flags |= LOOKUP_REVAL;
>  		goto retry;
>  	}
> -
> +out:
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

