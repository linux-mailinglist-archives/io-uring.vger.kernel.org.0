Return-Path: <io-uring+bounces-10560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C620C56C6C
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4922F3A48E0
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B095C2E093C;
	Thu, 13 Nov 2025 10:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kuCophMS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZKHefnte";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kuCophMS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZKHefnte"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241BE35CBD6
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763028741; cv=none; b=klCM424g+SmDRTX0kUCtRwDLElZyhy1ltz7e819zIpspX73Ik9zlcJnN1mCs4f+MmEbo/49xE1wrDsn+K8435v2zVDk7nde4aIsujsJSXvTjiVztpNFn/6AuB3pfkZpAE+xo6OxKBLQMWPLYdsIpGgt/ZQRMso/OxbI7sbwvnv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763028741; c=relaxed/simple;
	bh=fbyr+xBTayfR3Jr8sWmgu5KbOGmwnaUZ/UAAHOURlIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFsm5/AbekusmYpcYkYCGUM5GQV+vjhyir3hHQLEjrLlQm+2XdaSd0svDo0MAR5B1A2BgJfBvBGUdh1rd89XgYHeagRRGqCltJ0etWnC7/YTxJek9resjZrx4YutNuEqg3QEwlQMqWZwm8GXppPuoY43eC46LYPgMb+TrOrW8nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kuCophMS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZKHefnte; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kuCophMS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZKHefnte; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 51DD221748;
	Thu, 13 Nov 2025 10:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763028738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11ZzfaLk+0WknhNZ5CBaiS1ZqYQ5YAy4IYBw4K81jcI=;
	b=kuCophMSiqUjjMhi9xF3eGBs2bW/PoeuWjGIrICgiMzdt0YxTLEudcyiXIKI2PHCIO2Kzu
	kXJIt1eMmqtEtqBOPf+X6CS+REaaZlS8EY8Xo4BPAM/0zYqmLZ/gvnKmwr0qWFXrSYRzpA
	IhTE+jktU5/h4k/PfD9QlJDNB1bhvBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763028738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11ZzfaLk+0WknhNZ5CBaiS1ZqYQ5YAy4IYBw4K81jcI=;
	b=ZKHefnte9do13G9ZK1uuPkNzbJx5i1J+D3pYzrwk1mmoY6w1u8KQNRYt2SkPOqwh829c7y
	+0n02sEH2I05vDDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763028738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11ZzfaLk+0WknhNZ5CBaiS1ZqYQ5YAy4IYBw4K81jcI=;
	b=kuCophMSiqUjjMhi9xF3eGBs2bW/PoeuWjGIrICgiMzdt0YxTLEudcyiXIKI2PHCIO2Kzu
	kXJIt1eMmqtEtqBOPf+X6CS+REaaZlS8EY8Xo4BPAM/0zYqmLZ/gvnKmwr0qWFXrSYRzpA
	IhTE+jktU5/h4k/PfD9QlJDNB1bhvBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763028738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11ZzfaLk+0WknhNZ5CBaiS1ZqYQ5YAy4IYBw4K81jcI=;
	b=ZKHefnte9do13G9ZK1uuPkNzbJx5i1J+D3pYzrwk1mmoY6w1u8KQNRYt2SkPOqwh829c7y
	+0n02sEH2I05vDDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48A683EA61;
	Thu, 13 Nov 2025 10:12:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5DW7EQKvFWmmHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 10:12:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0E51FA0976; Thu, 13 Nov 2025 11:12:10 +0100 (CET)
Date: Thu, 13 Nov 2025 11:12:10 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 02/13] do_fchmodat(): import pathname only once
Message-ID: <gayhzmnzspb3ahvaa2tjsmha6vgzevkzzdo3fouu7sgklqxpqv@b3q73n43w7vq>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-3-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109063745.2089578-3-viro@zeniv.linux.org.uk>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Sun 09-11-25 06:37:34, Al Viro wrote:
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
>  fs/open.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index db8fe2b5463d..e9a08a820e49 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -682,6 +682,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
>  		       unsigned int flags)
>  {
>  	struct path path;
> +	struct filename *name;
>  	int error;
>  	unsigned int lookup_flags;
>  
> @@ -689,11 +690,9 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
>  		return -EINVAL;
>  
>  	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
> -	if (flags & AT_EMPTY_PATH)
> -		lookup_flags |= LOOKUP_EMPTY;
> -
> +	name = getname_uflags(filename, flags);
>  retry:
> -	error = user_path_at(dfd, filename, lookup_flags, &path);
> +	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
>  	if (!error) {
>  		error = chmod_common(&path, mode);
>  		path_put(&path);
> @@ -702,6 +701,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
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

