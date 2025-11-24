Return-Path: <io-uring+bounces-10764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B300C80BC7
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 231A2347561
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A9E70808;
	Mon, 24 Nov 2025 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ap9z4K9h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SBeLE8V5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ap9z4K9h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SBeLE8V5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596EE1E1A3B
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 13:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763990589; cv=none; b=anHc0JYMgL6+QpBToZIm8HarGrMtCgIhH4N4X7LVEI2MsFoLaPv4rg3ht9ATSStOv9XgR4r63dpA4ynk+d4TvXAT7tRvyOjjxOCauffJBBgq4tFzwhASI0sIdKHwr0FPGvEyr6gQITMd0O+b7dmbGXHiZJu3JcsNVYL0U/4Vhs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763990589; c=relaxed/simple;
	bh=Sc9MzAF1n5roisa1aL5pVyfDtNapVOc6kZrxZsOtKDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZQxtmxfE41bQTxCqvLs18MJjPFBDB9TblxY06cqWE0xxFT1FbKR42dShAx5maqPd6X09NobrImppZX89/tfoKNGKpkx/oF5l2Dq+xiLk5mdWNctocznVPyYF+S8Z5ZKml5WgL41CW2q5OyA07YL5Ytkf3rf5ymogSDniiDUWcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ap9z4K9h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SBeLE8V5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ap9z4K9h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SBeLE8V5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 44DA122439;
	Mon, 24 Nov 2025 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763990584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FPNZIZGEngYR7OWv1Yo0iyX474sGJnGUprBV/QxqdPE=;
	b=ap9z4K9hzosFq0AwJa+fOE2AS3tDIUXpoKhxLaJuQNbFAhf1GuHf4i90s05tM1v+p1hT/1
	TFZPBO+rkFoyIrNXpugfwsfZkcQjPFH8/59AB6a5vw9UHpWWDJjh3RqxUwRy4rcClTaSWb
	ejjNnhti15Vz94OomuuhECLZsLp3ES0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763990584;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FPNZIZGEngYR7OWv1Yo0iyX474sGJnGUprBV/QxqdPE=;
	b=SBeLE8V5C8vimCF6tacHZDiXrpV+wgqP3Xoj2dmoCAMSLwKqmQqfzPMiZDRYQYcLLhPfQC
	H2zGWBLQDfPoLwCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ap9z4K9h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SBeLE8V5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763990584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FPNZIZGEngYR7OWv1Yo0iyX474sGJnGUprBV/QxqdPE=;
	b=ap9z4K9hzosFq0AwJa+fOE2AS3tDIUXpoKhxLaJuQNbFAhf1GuHf4i90s05tM1v+p1hT/1
	TFZPBO+rkFoyIrNXpugfwsfZkcQjPFH8/59AB6a5vw9UHpWWDJjh3RqxUwRy4rcClTaSWb
	ejjNnhti15Vz94OomuuhECLZsLp3ES0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763990584;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FPNZIZGEngYR7OWv1Yo0iyX474sGJnGUprBV/QxqdPE=;
	b=SBeLE8V5C8vimCF6tacHZDiXrpV+wgqP3Xoj2dmoCAMSLwKqmQqfzPMiZDRYQYcLLhPfQC
	H2zGWBLQDfPoLwCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38F783EA64;
	Mon, 24 Nov 2025 13:23:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vuvmDThcJGkaUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 13:23:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D1748A0A04; Mon, 24 Nov 2025 14:22:59 +0100 (CET)
Date: Mon, 24 Nov 2025 14:22:59 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	io-uring@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 09/14] fs: factor out a mark_inode_dirty_time helper
Message-ID: <fbym7i2zelbatxbhy5eeffwpa3ni7bstjddbf7ran7djzthwjo@kfxj3wrxeuou>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-10-hch@lst.de>
X-Rspamd-Queue-Id: 44DA122439
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,lst.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Fri 14-11-25 07:26:12, Christoph Hellwig wrote:
> Factor out the inode dirtying vs lazytime logic from generic_update_time
> into a new helper so that it can be reused in file system methods.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/fs-writeback.c  | 15 +++++++++++++++
>  fs/inode.c         | 14 +++-----------
>  include/linux/fs.h |  3 ++-
>  3 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..930697f39153 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2671,6 +2671,21 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  }
>  EXPORT_SYMBOL(__mark_inode_dirty);
>  
> +void mark_inode_dirty_time(struct inode *inode, unsigned int flags)

What I find a bit concerning here is that mark_inode_dirty_time() takes a
different kind of flags than __mark_inode_dirty() so it's relatively easy
to confuse. Proper typing of 'flags' would be nice here but it's a bit
cumbersome to do in C so I'm not sure if it's worth it for this relatively
limited use. So I guess feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> +{
> +	if (inode->i_sb->s_flags & SB_LAZYTIME) {
> +		int dirty_flags = 0;
> +
> +		if (flags & (S_ATIME | S_MTIME | S_CTIME))
> +			dirty_flags = I_DIRTY_TIME;
> +		if (flags & S_VERSION)
> +			dirty_flags |= I_DIRTY_SYNC;
> +		__mark_inode_dirty(inode, dirty_flags);
> +	} else {
> +		mark_inode_dirty_sync(inode);
> +	}
> +}
> +
>  /*
>   * The @s_sync_lock is used to serialise concurrent sync operations
>   * to avoid lock contention problems with concurrent wait_sb_inodes() calls.
> diff --git a/fs/inode.c b/fs/inode.c
> index 57c458ee548d..559ce5c07188 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2095,17 +2095,9 @@ EXPORT_SYMBOL(inode_update_timestamps);
>   */
>  int generic_update_time(struct inode *inode, int flags)
>  {
> -	int updated = inode_update_timestamps(inode, flags);
> -	int dirty_flags = 0;
> -
> -	if (!updated)
> -		return 0;
> -
> -	if (updated & (S_ATIME|S_MTIME|S_CTIME))
> -		dirty_flags = inode->i_sb->s_flags & SB_LAZYTIME ? I_DIRTY_TIME : I_DIRTY_SYNC;
> -	if (updated & S_VERSION)
> -		dirty_flags |= I_DIRTY_SYNC;
> -	__mark_inode_dirty(inode, dirty_flags);
> +	flags = inode_update_timestamps(inode, flags);
> +	if (flags)
> +		mark_inode_dirty_time(inode, flags);
>  	return 0;
>  }
>  EXPORT_SYMBOL(generic_update_time);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c1077ae7c6b2..5c762d80b8a8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2608,7 +2608,8 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
>  	};
>  }
>  
> -extern void __mark_inode_dirty(struct inode *, int);
> +void mark_inode_dirty_time(struct inode *inode, unsigned int flags);
> +void __mark_inode_dirty(struct inode *inode, int flags);
>  static inline void mark_inode_dirty(struct inode *inode)
>  {
>  	__mark_inode_dirty(inode, I_DIRTY);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

