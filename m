Return-Path: <io-uring+bounces-11419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B160CF8313
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 13:00:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7EFA5304C0E9
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 11:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC65A3271EB;
	Tue,  6 Jan 2026 11:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ApR0x8fp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0WcTgiko";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ApR0x8fp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0WcTgiko"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381053168F7
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767700740; cv=none; b=E6jGVe2KC/c6lsUtbIT00F615HdSZFeLxU0V/0uvWPWgW9IV81sCrNqI4QYGW6uKXsvsrMWsglMX7IUlJmTVY/GWudJY4aeIgmJy+Z5n9S9W0Qyg63yxfkUQvtsJS5b4qTKxxg6tcORbDWRpzVqri8mB0BhXWvMeLU1zoA3Q8iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767700740; c=relaxed/simple;
	bh=DE3h7XPHKXKAtMrHjg9/u5oezu8yeFLJFoRL8sB7/2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qMqX2zdY/MSohfCMTj/uT3SjUxBnByv4yYqfGvL1z5i2hN5xBiD6R3zOGmYH6neav2qlv6Ihg37pTlrZ6+7Dnvf0oK0zVzDZIBZrC9Ss9lhEedhWtqobdzZy3RXGN5zJ41B5lyj44EPEsDo+i5Xua1CkKWh5h/aFh1dfsghVpQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ApR0x8fp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0WcTgiko; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ApR0x8fp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0WcTgiko; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C4005BCC3;
	Tue,  6 Jan 2026 11:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ObRgs3d+g8PveAEGr4BxnLJWbvM8QtjCZ0j19IkX9A=;
	b=ApR0x8fpWk4JE2WuMUwrbWrF5F+bOpeM9gn0Lq62/Wj/4SxZeeXoNdFA/sWRRGKHz1OC8n
	CV6y9fRm2czfPMGWASwCYwVd5NfTi/rzUC38vdiVwO5GsR4VP4sP/M2ArpbIvu19OEyJM+
	zdgJJGI8GTBXwzOicofRX9aQXZn8QSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ObRgs3d+g8PveAEGr4BxnLJWbvM8QtjCZ0j19IkX9A=;
	b=0WcTgikoiNw+yJEt8j+Xz4ALXZeXDmh3Fda7sdWR3afv6MYizQLg0cZfR9dXSGroO7aP2C
	WFw+7D+wNUq6rJDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ObRgs3d+g8PveAEGr4BxnLJWbvM8QtjCZ0j19IkX9A=;
	b=ApR0x8fpWk4JE2WuMUwrbWrF5F+bOpeM9gn0Lq62/Wj/4SxZeeXoNdFA/sWRRGKHz1OC8n
	CV6y9fRm2czfPMGWASwCYwVd5NfTi/rzUC38vdiVwO5GsR4VP4sP/M2ArpbIvu19OEyJM+
	zdgJJGI8GTBXwzOicofRX9aQXZn8QSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ObRgs3d+g8PveAEGr4BxnLJWbvM8QtjCZ0j19IkX9A=;
	b=0WcTgikoiNw+yJEt8j+Xz4ALXZeXDmh3Fda7sdWR3afv6MYizQLg0cZfR9dXSGroO7aP2C
	WFw+7D+wNUq6rJDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3CDEF3EA63;
	Tue,  6 Jan 2026 11:58:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jzWMDgD5XGmibQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 06 Jan 2026 11:58:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EE62FA08E3; Tue,  6 Jan 2026 12:58:47 +0100 (CET)
Date: Tue, 6 Jan 2026 12:58:47 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, io-uring@vger.kernel.org, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 08/11] fs: add support for non-blocking timestamp updates
Message-ID: <jdntrcr644ukmht5wq2xbbh6vmolawdahxahm22vuaihtvpa43@ixt3uehbbdiq>
References: <20260106075008.1610195-1-hch@lst.de>
 <20260106075008.1610195-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106075008.1610195-9-hch@lst.de>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.991];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.cz:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.80

On Tue 06-01-26 08:50:02, Christoph Hellwig wrote:
> Currently file_update_time_flags unconditionally returns -EAGAIN if any
> timestamp needs to be updated and IOCB_NOWAIT is passed.  This makes
> non-blocking direct writes impossible on file systems with granular
> enough timestamps.
> 
> Pass IOCB_NOWAIT to ->update_time and return -EAGAIN if it could block.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much nicer now! Thanks for the refactoring. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/inode.c     |  2 ++
>  fs/gfs2/inode.c      |  3 +++
>  fs/inode.c           | 45 +++++++++++++++++++++++++++++++++-----------
>  fs/orangefs/inode.c  |  3 +++
>  fs/overlayfs/inode.c |  2 ++
>  fs/ubifs/file.c      |  3 +++
>  fs/xfs/xfs_iops.c    |  3 +++
>  7 files changed, 50 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 23fc38de9be5..241727459c0a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6362,6 +6362,8 @@ static int btrfs_update_time(struct inode *inode, enum fs_update_time type,
>  
>  	if (btrfs_root_readonly(root))
>  		return -EROFS;
> +	if (flags & IOCB_NOWAIT)
> +		return -EAGAIN;
>  
>  	dirty = inode_update_time(inode, type, flags);
>  	if (dirty <= 0)
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index 4ef39ff6889d..c02ebf0ca625 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -2250,6 +2250,9 @@ static int gfs2_update_time(struct inode *inode, enum fs_update_time type,
>  	struct gfs2_holder *gh;
>  	int error;
>  
> +	if (flags & IOCB_NOWAIT)
> +		return -EAGAIN;
> +
>  	gh = gfs2_glock_is_locked_by_me(gl);
>  	if (gh && gl->gl_state != LM_ST_EXCLUSIVE) {
>  		gfs2_glock_dq(gh);
> diff --git a/fs/inode.c b/fs/inode.c
> index c08682524a8d..01e4f6b9b46e 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2090,7 +2090,7 @@ static int inode_update_atime(struct inode *inode)
>  	return inode_time_dirty_flag(inode);
>  }
>  
> -static int inode_update_cmtime(struct inode *inode)
> +static int inode_update_cmtime(struct inode *inode, unsigned int flags)
>  {
>  	struct timespec64 now = inode_set_ctime_current(inode);
>  	struct timespec64 ctime = inode_get_ctime(inode);
> @@ -2101,12 +2101,27 @@ static int inode_update_cmtime(struct inode *inode)
>  	mtime_changed = !timespec64_equal(&now, &mtime);
>  	if (mtime_changed || !timespec64_equal(&now, &ctime))
>  		dirty = inode_time_dirty_flag(inode);
> -	if (mtime_changed)
> -		inode_set_mtime_to_ts(inode, now);
>  
> -	if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, !!dirty))
> -		dirty |= I_DIRTY_SYNC;
> +	/*
> +	 * Pure timestamp updates can be recorded in the inode without blocking
> +	 * by not dirtying the inode.  But when the file system requires
> +	 * i_version updates, the update of i_version can still block.
> +	 * Error out if we'd actually have to update i_version or don't support
> +	 * lazytime.
> +	 */
> +	if (IS_I_VERSION(inode)) {
> +		if (flags & IOCB_NOWAIT) {
> +			if (!(inode->i_sb->s_flags & SB_LAZYTIME) ||
> +			    inode_iversion_need_inc(inode))
> +				return -EAGAIN;
> +		} else {
> +			if (inode_maybe_inc_iversion(inode, !!dirty))
> +				dirty |= I_DIRTY_SYNC;
> +		}
> +	}
>  
> +	if (mtime_changed)
> +		inode_set_mtime_to_ts(inode, now);
>  	return dirty;
>  }
>  
> @@ -2131,7 +2146,7 @@ int inode_update_time(struct inode *inode, enum fs_update_time type,
>  	case FS_UPD_ATIME:
>  		return inode_update_atime(inode);
>  	case FS_UPD_CMTIME:
> -		return inode_update_cmtime(inode);
> +		return inode_update_cmtime(inode, flags);
>  	default:
>  		WARN_ON_ONCE(1);
>  		return -EIO;
> @@ -2152,6 +2167,16 @@ int generic_update_time(struct inode *inode, enum fs_update_time type,
>  {
>  	int dirty;
>  
> +	/*
> +	 * ->dirty_inode is what could make generic timestamp updates block.
> +	 * Don't support non-blocking timestamp updates here if it is set.
> +	 * File systems that implement ->dirty_inode but want to support
> +	 * non-blocking timestamp updates should call inode_update_time
> +	 * directly.
> +	 */
> +	if ((flags & IOCB_NOWAIT) && inode->i_sb->s_op->dirty_inode)
> +		return -EAGAIN;
> +
>  	dirty = inode_update_time(inode, type, flags);
>  	if (dirty <= 0)
>  		return dirty;
> @@ -2380,15 +2405,13 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
>  	if (!need_update)
>  		return 0;
>  
> -	if (flags & IOCB_NOWAIT)
> -		return -EAGAIN;
> -
> +	flags &= IOCB_NOWAIT;
>  	if (mnt_get_write_access_file(file))
>  		return 0;
>  	if (inode->i_op->update_time)
> -		ret = inode->i_op->update_time(inode, FS_UPD_CMTIME, 0);
> +		ret = inode->i_op->update_time(inode, FS_UPD_CMTIME, flags);
>  	else
> -		ret = generic_update_time(inode, FS_UPD_CMTIME, 0);
> +		ret = generic_update_time(inode, FS_UPD_CMTIME, flags);
>  	mnt_put_write_access_file(file);
>  	return ret;
>  }
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index eab16afb5b8a..f420f48fc069 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -878,6 +878,9 @@ int orangefs_update_time(struct inode *inode, enum fs_update_time type,
>  	struct iattr iattr = { };
>  	int dirty;
>  
> +	if (flags & IOCB_NOWAIT)
> +		return -EAGAIN;
> +
>  	switch (type) {
>  	case FS_UPD_ATIME:
>  		iattr.ia_valid = ATTR_ATIME;
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index c0ce3519e4af..00c69707bda9 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -566,6 +566,8 @@ int ovl_update_time(struct inode *inode, enum fs_update_time type,
>  		};
>  
>  		if (upperpath.dentry) {
> +			if (flags & IOCB_NOWAIT)
> +				return -EAGAIN;
>  			touch_atime(&upperpath);
>  			inode_set_atime_to_ts(inode,
>  					      inode_get_atime(d_inode(upperpath.dentry)));
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index 0cc44ad142de..3dc3ca1cd803 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -1377,6 +1377,9 @@ int ubifs_update_time(struct inode *inode, enum fs_update_time type,
>  	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
>  		return generic_update_time(inode, type, flags);
>  
> +	if (flags & IOCB_NOWAIT)
> +		return -EAGAIN;
> +
>  	err = ubifs_budget_space(c, &req);
>  	if (err)
>  		return err;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index d9eae1af14a8..aef5b05c1b76 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1195,6 +1195,9 @@ xfs_vn_update_time(
>  
>  	trace_xfs_update_time(ip);
>  
> +	if (flags & IOCB_NOWAIT)
> +		return -EAGAIN;
> +
>  	if (inode->i_sb->s_flags & SB_LAZYTIME) {
>  		if (type == FS_UPD_ATIME ||
>  		    !inode_maybe_inc_iversion(inode, false))
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

