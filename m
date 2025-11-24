Return-Path: <io-uring+bounces-10761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 929C3C80ABB
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5D548344728
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5381304976;
	Mon, 24 Nov 2025 13:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qkeNiljP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nCaUcsL4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qkeNiljP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nCaUcsL4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81458303C9A
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 13:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763989837; cv=none; b=FA9Jt7pqqamZggMlllleUfEuj4vD0HcWQTWVXgPTHyfaoxXj3grpv71BU83ZbK+sa7vcnXISBsTdTiZ2UM/hVdXye0nG2E+L88fAY1awXBpvc2jJBW/3G6LvWyhXd0xIcYWGTP1g8ZX73kaCONEhwUEJcB9Gl1J6U+2dKqHyRf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763989837; c=relaxed/simple;
	bh=tfFCVgEp2a4mHjp2ZTRDPe9my3M1faGhzJ+yLdtGX+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDO2uC2P9HD+DiaeXzRSaQfqpzD2MsQnCFWhJpHDUOzMGCaC6Fyy1HsRloF//udOvg4FLcMkMkaBgX8Dc1O+qqGiJdm5TbL7kApn6py1DrZPPLVc1NeFrNb/lii5UdsgGOIFwd1romISF3JaQt3gxZeG7Sc9krpiYcJiTR5/zJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qkeNiljP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nCaUcsL4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qkeNiljP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nCaUcsL4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A1C6E5BED0;
	Mon, 24 Nov 2025 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763989833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9jDV8KGRUw6lUVv2vjHXgGxcuigsjgB3zkzS2kSogY=;
	b=qkeNiljPRctzzY6ar9Vl5AlTW2RVj/E6HUjC/5bLNJgu3jDIzKbpNVTSS/KKBo4pa0pGXU
	FdWOt66eMwwwIu/mRnEPEupFSkDIMVoKe0w/CAZk0nMJs7abDuFJlutqR2XoImkFmVzaDR
	vMiM7E4Uf2m6qumPf5Is3WcXWJ1adQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763989833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9jDV8KGRUw6lUVv2vjHXgGxcuigsjgB3zkzS2kSogY=;
	b=nCaUcsL4efjbxwPziMlivvNYYKBM0iU/pW4SdJfaRLoui3uhTC2rp6wWuydtDAUVLYky0J
	XuVTasIJtww2V4Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763989833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9jDV8KGRUw6lUVv2vjHXgGxcuigsjgB3zkzS2kSogY=;
	b=qkeNiljPRctzzY6ar9Vl5AlTW2RVj/E6HUjC/5bLNJgu3jDIzKbpNVTSS/KKBo4pa0pGXU
	FdWOt66eMwwwIu/mRnEPEupFSkDIMVoKe0w/CAZk0nMJs7abDuFJlutqR2XoImkFmVzaDR
	vMiM7E4Uf2m6qumPf5Is3WcXWJ1adQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763989833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r9jDV8KGRUw6lUVv2vjHXgGxcuigsjgB3zkzS2kSogY=;
	b=nCaUcsL4efjbxwPziMlivvNYYKBM0iU/pW4SdJfaRLoui3uhTC2rp6wWuydtDAUVLYky0J
	XuVTasIJtww2V4Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93C213EA61;
	Mon, 24 Nov 2025 13:10:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kf4hJElZJGmzQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 24 Nov 2025 13:10:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 52B53A0A04; Mon, 24 Nov 2025 14:10:29 +0100 (CET)
Date: Mon, 24 Nov 2025 14:10:29 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	io-uring@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 07/14] fs: return a negative error from
 generic_update_time
Message-ID: <6epbyvds7hmypmk6qfsmnvevbnt2msdbudknnn3ryx6szl5lwn@a2ydspgd2cd6>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114062642.1524837-8-hch@lst.de>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Fri 14-11-25 07:26:10, Christoph Hellwig wrote:
> Now that no caller looks at the updated flags, switch generic_update_time
> to the same calling convention as the ->update_time method and return 0
> or a negative errno.
> 
> This prepares for adding non-blocking timestamp updates that could return
> -EAGAIN.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/gfs2/inode.c    | 3 +--
>  fs/inode.c         | 6 +++---
>  fs/ubifs/file.c    | 6 ++----
>  fs/xfs/xfs_iops.c  | 6 ++----
>  include/linux/fs.h | 2 +-
>  5 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index 8a7ed80d9f2d..601c14a3ac77 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -2242,8 +2242,7 @@ static int gfs2_update_time(struct inode *inode, int flags)
>  		if (error)
>  			return error;
>  	}
> -	generic_update_time(inode, flags);
> -	return 0;
> +	return generic_update_time(inode, flags);
>  }
>  
>  static const struct inode_operations gfs2_file_iops = {
> diff --git a/fs/inode.c b/fs/inode.c
> index d3edcc5baec9..74e672dd90aa 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2091,7 +2091,7 @@ EXPORT_SYMBOL(inode_update_timestamps);
>   * or S_VERSION need to be updated we attempt to update all three of them. S_ATIME
>   * updates can be handled done independently of the rest.
>   *
> - * Returns a S_* mask indicating which fields were updated.
> + * Returns a negative error value on error, else 0.
>   */
>  int generic_update_time(struct inode *inode, int flags)
>  {
> @@ -2103,7 +2103,7 @@ int generic_update_time(struct inode *inode, int flags)
>  	if (updated & S_VERSION)
>  		dirty_flags |= I_DIRTY_SYNC;
>  	__mark_inode_dirty(inode, dirty_flags);
> -	return updated;
> +	return 0;
>  }
>  EXPORT_SYMBOL(generic_update_time);
>  
> @@ -2335,7 +2335,7 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
>  	if (inode->i_op->update_time)
>  		ret = inode->i_op->update_time(inode, sync_mode);
>  	else
> -		generic_update_time(inode, sync_mode);
> +		ret = generic_update_time(inode, sync_mode);
>  	mnt_put_write_access_file(file);
>  	return ret;
>  }
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index ca41ce8208c4..3e119cb93ea9 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -1379,10 +1379,8 @@ int ubifs_update_time(struct inode *inode, int flags)
>  			.dirtied_ino_d = ALIGN(ui->data_len, 8) };
>  	int err, release;
>  
> -	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT)) {
> -		generic_update_time(inode, flags);
> -		return 0;
> -	}
> +	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
> +		return generic_update_time(inode, flags);
>  
>  	err = ubifs_budget_space(c, &req);
>  	if (err)
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index caff0125faea..0ace5f790006 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1197,10 +1197,8 @@ xfs_vn_update_time(
>  
>  	if (inode->i_sb->s_flags & SB_LAZYTIME) {
>  		if (!((flags & S_VERSION) &&
> -		      inode_maybe_inc_iversion(inode, false))) {
> -			generic_update_time(inode, flags);
> -			return 0;
> -		}
> +		      inode_maybe_inc_iversion(inode, false)))
> +			return generic_update_time(inode, flags);
>  
>  		/* Capture the iversion update that just occurred */
>  		log_flags |= XFS_ILOG_CORE;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a09cebdb4881..c1077ae7c6b2 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2823,7 +2823,7 @@ extern int current_umask(void);
>  extern void ihold(struct inode * inode);
>  extern void iput(struct inode *);
>  int inode_update_timestamps(struct inode *inode, int flags);
> -int generic_update_time(struct inode *, int);
> +int generic_update_time(struct inode *inode, int flags);
>  
>  /* /sys/fs */
>  extern struct kobject *fs_kobj;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

