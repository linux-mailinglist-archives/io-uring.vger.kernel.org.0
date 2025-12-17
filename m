Return-Path: <io-uring+bounces-11146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C0F8CC7983
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 13:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 69143300AB07
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 12:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848D029B764;
	Wed, 17 Dec 2025 12:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q66cb5Lr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mvv88HZj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="A9sXhjHy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lFVMxk77"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA0B32570E
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 12:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765974236; cv=none; b=hIHNaDjBuT9MO67nQ2akqG/tNDp7cyiu/PPznY79zZ4XrafjFdKRSSDwUxNlC90a5GDMbFdI0UcrN2RV9GSD4Re2VB7ZSMrhkgGOueLtuKa6klfyIMyxh6zi7KquKNiRnanctrzS6PHIaDpSxBR4yABwki6b8fphZN7cXCgHnRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765974236; c=relaxed/simple;
	bh=6+NHnw9iJyLKGMs0iTEF9pIQd9u6Gerh+nYPcNRAirE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2dPt76mbHHT8Tof/3Qsb7M5i6M4ylSbi3v4SzjX3Fmi1kMCKcKFQFrODjHpHdpLG0yZAk1//PYqXPMGD1pIiHiKHS2t5vOqqQZcpRejq6Bb9HMBkm7wkNA3FNMwfZ1g+WCoGbanb+rw9k0Ew4LDHtov7nbOkUeuY7wnrirL6AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q66cb5Lr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Mvv88HZj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=A9sXhjHy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lFVMxk77; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E01B35BCF6;
	Wed, 17 Dec 2025 12:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765974232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+KXbxG00KylL9Jx4UXbfEWiE2yGrlSZ5Ct4ZfTRaRr0=;
	b=q66cb5Lr/+mGepj7IKoPjBLkpB6KaOtn7SEz7dvm45cGZNY3VfoOz7AbZQobQUg5C0O0WO
	4pfQyP7U5rb2KoJxNTBkbkDOxINiegMFDIqbg54iO4hdbuolqcwHtu++RkkVlzc97wEytJ
	UbeYZyPD4mMX7C7p3Cwi8mMk5VCC9Lc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765974232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+KXbxG00KylL9Jx4UXbfEWiE2yGrlSZ5Ct4ZfTRaRr0=;
	b=Mvv88HZjFE2s5uBPp/B+pktpF11rBOPtuu6/K2EapyNO8Ewy8MDZjEY5H/QOWIpWL7TwRn
	tuFZjLz5b5jL2SAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765974231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+KXbxG00KylL9Jx4UXbfEWiE2yGrlSZ5Ct4ZfTRaRr0=;
	b=A9sXhjHy+rYYrLaLfZ6gkG5/YGksPNEJqgye+HKCh3fSt5S/pnu9snpaoxaUJr8tgIrq55
	4WyuZrcMUamQZiKN4jgFymAVUJVH7jJ6k44Sjz6nAA6WI5gEQ7ZBBdglHO7J2o9lw9QZwJ
	GkBFmW14IKONB4m34e51tgYRlAnb4Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765974231;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+KXbxG00KylL9Jx4UXbfEWiE2yGrlSZ5Ct4ZfTRaRr0=;
	b=lFVMxk77ZSL+qZ99xkNGBGiWTKPc3h2DLxR/fwTvkg99QcGsfpeBLPlu41ew/YKvJF4n15
	r9d97yvAy0RakXDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6FCA3EA63;
	Wed, 17 Dec 2025 12:23:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BcaKMNegQml4FAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Dec 2025 12:23:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4155CA0927; Wed, 17 Dec 2025 13:23:43 +0100 (CET)
Date: Wed, 17 Dec 2025 13:23:43 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, io-uring@vger.kernel.org, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 05/10] fs: allow error returns from
 inode_update_timestamps
Message-ID: <j47ue7pzvtbg76hs5z7wov2ftjh2nnr4xxsslliiqjks5cmpwf@vz275nqw2bqb>
References: <20251217061015.923954-1-hch@lst.de>
 <20251217061015.923954-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217061015.923954-6-hch@lst.de>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
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
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Wed 17-12-25 07:09:38, Christoph Hellwig wrote:
> Change flags to a by reference argument so that it can be updated so that
> the return value can be used for error returns.  This will be used to
> implement non-blocking timestamp updates.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/inode.c    |  8 +++++---
>  fs/inode.c          | 24 ++++++++++++++++--------
>  fs/nfs/inode.c      |  4 ++--
>  fs/orangefs/inode.c |  5 ++++-
>  fs/ubifs/file.c     |  2 +-
>  include/linux/fs.h  |  2 +-
>  6 files changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 317db7d10a21..3ca8d294770e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6349,13 +6349,15 @@ static int btrfs_dirty_inode(struct btrfs_inode *inode)
>  static int btrfs_update_time(struct inode *inode, int flags)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	bool dirty;
> +	int error;
>  
>  	if (btrfs_root_readonly(root))
>  		return -EROFS;
>  
> -	dirty = inode_update_timestamps(inode, flags);
> -	return dirty ? btrfs_dirty_inode(BTRFS_I(inode)) : 0;
> +	error = inode_update_timestamps(inode, &flags);
> +	if (error || !flags)
> +		return error;
> +	return btrfs_dirty_inode(BTRFS_I(inode));
>  }
>  
>  /*
> diff --git a/fs/inode.c b/fs/inode.c
> index 17ecb7bb5067..2c0d69f7fd01 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2095,14 +2095,18 @@ static bool relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>   * attempt to update all three of them. S_ATIME updates can be handled
>   * independently of the rest.
>   *
> - * Returns a set of S_* flags indicating which values changed.
> + * Updates @flags to contain the S_* flags which actually need changing.  This
> + * can drop flags from the input when they don't need an update, or can add
> + * S_VERSION when the version needs to be bumped.
> + *
> + * Returns 0 or a negative errno.
>   */
> -int inode_update_timestamps(struct inode *inode, int flags)
> +int inode_update_timestamps(struct inode *inode, int *flags)
>  {
>  	int updated = 0;
>  	struct timespec64 now;
>  
> -	if (flags & (S_MTIME|S_CTIME|S_VERSION)) {
> +	if (*flags & (S_MTIME | S_CTIME | S_VERSION)) {
>  		struct timespec64 ctime = inode_get_ctime(inode);
>  		struct timespec64 mtime = inode_get_mtime(inode);
>  
> @@ -2119,7 +2123,7 @@ int inode_update_timestamps(struct inode *inode, int flags)
>  		now = current_time(inode);
>  	}
>  
> -	if (flags & S_ATIME) {
> +	if (*flags & S_ATIME) {
>  		struct timespec64 atime = inode_get_atime(inode);
>  
>  		if (!timespec64_equal(&now, &atime)) {
> @@ -2127,7 +2131,9 @@ int inode_update_timestamps(struct inode *inode, int flags)
>  			updated |= S_ATIME;
>  		}
>  	}
> -	return updated;
> +
> +	*flags = updated;
> +	return 0;
>  }
>  EXPORT_SYMBOL(inode_update_timestamps);
>  
> @@ -2145,10 +2151,12 @@ EXPORT_SYMBOL(inode_update_timestamps);
>   */
>  int generic_update_time(struct inode *inode, int flags)
>  {
> -	flags = inode_update_timestamps(inode, flags);
> -	if (flags)
> +	int error;
> +
> +	error = inode_update_timestamps(inode, &flags);
> +	if (!error && flags)
>  		mark_inode_dirty_time(inode, flags);
> -	return 0;
> +	return error;
>  }
>  EXPORT_SYMBOL(generic_update_time);
>  
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 84049f3cd340..221816524c66 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -671,8 +671,8 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
>  
>  static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
>  {
> -	enum file_time_flags time_flags = 0;
>  	unsigned int cache_flags = 0;
> +	int time_flags = 0;
>  
>  	if (ia_valid & ATTR_MTIME) {
>  		time_flags |= S_MTIME | S_CTIME;
> @@ -682,7 +682,7 @@ static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
>  		time_flags |= S_ATIME;
>  		cache_flags |= NFS_INO_INVALID_ATIME;
>  	}
> -	inode_update_timestamps(inode, time_flags);
> +	inode_update_timestamps(inode, &time_flags);
>  	NFS_I(inode)->cache_validity &= ~cache_flags;
>  }
>  
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index d7275990ffa4..3b58f31bd54f 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -875,11 +875,14 @@ int orangefs_permission(struct mnt_idmap *idmap,
>  int orangefs_update_time(struct inode *inode, int flags)
>  {
>  	struct iattr iattr;
> +	int error;
>  
>  	gossip_debug(GOSSIP_INODE_DEBUG, "orangefs_update_time: %pU\n",
>  	    get_khandle_from_ino(inode));
>  
> -	flags = inode_update_timestamps(inode, flags);
> +	error = inode_update_timestamps(inode, &flags);
> +	if (error || !flags)
> +		return error;
>  
>  	memset(&iattr, 0, sizeof iattr);
>          if (flags & S_ATIME)
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index ec1bb9f43acc..71540644a931 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -1387,7 +1387,7 @@ int ubifs_update_time(struct inode *inode, int flags)
>  		return err;
>  
>  	mutex_lock(&ui->ui_mutex);
> -	inode_update_timestamps(inode, flags);
> +	inode_update_timestamps(inode, &flags);
>  	release = ui->dirty;
>  	__mark_inode_dirty(inode, I_DIRTY_SYNC);
>  	mutex_unlock(&ui->ui_mutex);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 66d3d18cf4e3..75d5f38b08c9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2399,7 +2399,7 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
>  extern void ihold(struct inode * inode);
>  extern void iput(struct inode *);
>  void iput_not_last(struct inode *);
> -int inode_update_timestamps(struct inode *inode, int flags);
> +int inode_update_timestamps(struct inode *inode, int *flags);
>  int generic_update_time(struct inode *inode, int flags);
>  
>  /* /sys/fs */
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

