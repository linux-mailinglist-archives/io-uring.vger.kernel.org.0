Return-Path: <io-uring+bounces-11527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7878CD04889
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 17:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3812F316A223
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 15:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72768349AEE;
	Thu,  8 Jan 2026 15:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h4fRbLSI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Aw34SwKC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h4fRbLSI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Aw34SwKC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FD633E369
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767885667; cv=none; b=jlcToPu9as+hpFwCGsOtvh5JHLBS51nRpg4B5OVt6XwVsWNoObeVsZGqh4LG6+1EL34AmqZCP+QHleAHigRSm8UrPVdJi2KlQNeyvokwD9kerjKNqtVmOki63j0UihvzcLqu+g+Z9G0j5HpTsfKF/pZCVib/yahRXBH5+Wtxf8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767885667; c=relaxed/simple;
	bh=XxsdSOgQc2IDXM1vH0ztAYCPVlCSFiCCszvGUR5Tv5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6DqnHxkxc35lr0evbxO04OAGLi4CfFbdNJ+W2MpDbDzVLbUEDZx4CmGr+5pGlMyjJfhvG+xFCSs7knYPTWk4uZVqR6Fbh/UvM7bhYCXSGpPfmLIchCBWP7MVSMzlo07amlXR3CEWPrVvXNkPJuIIiBvr1dfpXRCHuMVKxkSQSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h4fRbLSI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Aw34SwKC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h4fRbLSI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Aw34SwKC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DDA35C894;
	Thu,  8 Jan 2026 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767885656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ylC4BbezKOg/v6QxlNAtFKvCjQu+BeDsLwqfteTncQ=;
	b=h4fRbLSIa+zeAxIJg0j4RtnfxuCECyKVjH1r8BsSsGlTPLAZcmunCK18kpBOtre0PosVxP
	/fSxXclLH9vbXYS7FIdh6hHnFdl8FoRsVCBxYKXePVSQIri3ELmGQkuVgALNM4wjWeX1mb
	Vrlbikm2qE2NTD3CE8OXksbCKBbOHkM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767885656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ylC4BbezKOg/v6QxlNAtFKvCjQu+BeDsLwqfteTncQ=;
	b=Aw34SwKCjNNKEPN/hAE4wLh+m6UPKOmbjNhQcx7eztpH7KJOG8yQKADctP5UA+hEfRNWhe
	2dcfJnYfZkB0gkBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h4fRbLSI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Aw34SwKC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767885656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ylC4BbezKOg/v6QxlNAtFKvCjQu+BeDsLwqfteTncQ=;
	b=h4fRbLSIa+zeAxIJg0j4RtnfxuCECyKVjH1r8BsSsGlTPLAZcmunCK18kpBOtre0PosVxP
	/fSxXclLH9vbXYS7FIdh6hHnFdl8FoRsVCBxYKXePVSQIri3ELmGQkuVgALNM4wjWeX1mb
	Vrlbikm2qE2NTD3CE8OXksbCKBbOHkM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767885656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ylC4BbezKOg/v6QxlNAtFKvCjQu+BeDsLwqfteTncQ=;
	b=Aw34SwKCjNNKEPN/hAE4wLh+m6UPKOmbjNhQcx7eztpH7KJOG8yQKADctP5UA+hEfRNWhe
	2dcfJnYfZkB0gkBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D3973EA63;
	Thu,  8 Jan 2026 15:20:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eWK8FljLX2mUdwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 15:20:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 19BF6A09CF; Thu,  8 Jan 2026 16:20:56 +0100 (CET)
Date: Thu, 8 Jan 2026 16:20:56 +0100
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
Subject: Re: [PATCH 05/11] fs: refactor ->update_time handling
Message-ID: <ljaucvi236sejlfeswafnjhc4twoje6zayghjhktnywjdxcepr@jzfkqffnngxq>
References: <20260108141934.2052404-1-hch@lst.de>
 <20260108141934.2052404-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108141934.2052404-6-hch@lst.de>
X-Spam-Score: -4.01
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[23];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,lst.de:email];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6DDA35C894
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Thu 08-01-26 15:19:05, Christoph Hellwig wrote:
> Pass the type of update (atime vs c/mtime plus version) as an enum
> instead of a set of flags that caused all kinds of confusion.
> Because inode_update_timestamps now can't return a modified version
> of those flags, return the I_DIRTY_* flags needed to persist the
> update, which is what the main caller in generic_update_time wants
> anyway, and which is suitable for the other callers that only want
> to know if an update happened.
> 
> The whole update_time path keeps the flags argument, which will be used
> to support non-blocking updates soon even if it is unused, and (the
> slightly renamed) inode_update_time also gains the possibility to return
> a negative errno to support this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/filesystems/locking.rst |   3 +-
>  Documentation/filesystems/vfs.rst     |   3 +-
>  fs/bad_inode.c                        |   3 +-
>  fs/btrfs/inode.c                      |  11 ++-
>  fs/fat/fat.h                          |   3 +-
>  fs/fat/misc.c                         |  26 ++---
>  fs/gfs2/inode.c                       |   5 +-
>  fs/inode.c                            | 134 ++++++++++++++------------
>  fs/nfs/inode.c                        |  10 +-
>  fs/orangefs/inode.c                   |  28 +++---
>  fs/orangefs/orangefs-kernel.h         |   3 +-
>  fs/overlayfs/inode.c                  |   5 +-
>  fs/overlayfs/overlayfs.h              |   3 +-
>  fs/ubifs/file.c                       |  21 ++--
>  fs/ubifs/ubifs.h                      |   3 +-
>  fs/xfs/xfs_iops.c                     |  22 ++---
>  include/linux/fs.h                    |  28 ++++--
>  17 files changed, 157 insertions(+), 154 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 77704fde9845..37a4a7fa8094 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -80,7 +80,8 @@ prototypes::
>  	int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
> -	void (*update_time)(struct inode *, struct timespec *, int);
> +	void (*update_time)(struct inode *inode, enum fs_update_time type,
> +			    int flags);
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  				struct file *, unsigned open_flag,
>  				umode_t create_mode);
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 670ba66b60e4..51aa9db64784 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -485,7 +485,8 @@ As of kernel 2.6.22, the following members are defined:
>  		int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
>  		int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
>  		ssize_t (*listxattr) (struct dentry *, char *, size_t);
> -		void (*update_time)(struct inode *, struct timespec *, int);
> +		void (*update_time)(struct inode *inode, enum fs_update_time type,
> +				    int flags);
>  		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
>  				   unsigned open_flag, umode_t create_mode);
>  		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
> diff --git a/fs/bad_inode.c b/fs/bad_inode.c
> index 0ef9bcb744dd..acf8613f5e36 100644
> --- a/fs/bad_inode.c
> +++ b/fs/bad_inode.c
> @@ -133,7 +133,8 @@ static int bad_inode_fiemap(struct inode *inode,
>  	return -EIO;
>  }
>  
> -static int bad_inode_update_time(struct inode *inode, int flags)
> +static int bad_inode_update_time(struct inode *inode, enum fs_update_time type,
> +				 unsigned int flags)
>  {
>  	return -EIO;
>  }
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 599c03a1c573..23fc38de9be5 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6354,16 +6354,19 @@ static int btrfs_dirty_inode(struct btrfs_inode *inode)
>   * We need our own ->update_time so that we can return error on ENOSPC for
>   * updating the inode in the case of file write and mmap writes.
>   */
> -static int btrfs_update_time(struct inode *inode, int flags)
> +static int btrfs_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	bool dirty;
> +	int dirty;
>  
>  	if (btrfs_root_readonly(root))
>  		return -EROFS;
>  
> -	dirty = inode_update_timestamps(inode, flags);
> -	return dirty ? btrfs_dirty_inode(BTRFS_I(inode)) : 0;
> +	dirty = inode_update_time(inode, type, flags);
> +	if (dirty <= 0)
> +		return dirty;
> +	return btrfs_dirty_inode(BTRFS_I(inode));
>  }
>  
>  /*
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 767b566b1cab..0d269dba897b 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -472,7 +472,8 @@ extern struct timespec64 fat_truncate_atime(const struct msdos_sb_info *sbi,
>  #define FAT_UPDATE_CMTIME	(1u << 1)
>  void fat_truncate_time(struct inode *inode, struct timespec64 *now,
>  		unsigned int flags);
> -extern int fat_update_time(struct inode *inode, int flags);
> +int fat_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
>  extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
>  
>  int fat_cache_init(void);
> diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> index 78c620e9b3fd..b154a5162764 100644
> --- a/fs/fat/misc.c
> +++ b/fs/fat/misc.c
> @@ -332,28 +332,14 @@ void fat_truncate_time(struct inode *inode, struct timespec64 *now,
>  }
>  EXPORT_SYMBOL_GPL(fat_truncate_time);
>  
> -int fat_update_time(struct inode *inode, int flags)
> +int fat_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	unsigned int fat_flags = 0;
> -	int dirty_flags = 0;
> -
> -	if (inode->i_ino == MSDOS_ROOT_INO)
> -		return 0;
> -
> -	if (flags & S_ATIME)
> -		fat_flags |= FAT_UPDATE_ATIME;
> -	if (flags & (S_CTIME | S_MTIME))
> -		fat_flags |= FAT_UPDATE_CMTIME;
> -
> -	if (fat_flags) {
> -		fat_truncate_time(inode, NULL, flags);
> -		if (inode->i_sb->s_flags & SB_LAZYTIME)
> -			dirty_flags |= I_DIRTY_TIME;
> -		else
> -			dirty_flags |= I_DIRTY_SYNC;
> +	if (inode->i_ino != MSDOS_ROOT_INO) {
> +		fat_truncate_time(inode, NULL, type == FS_UPD_ATIME ?
> +				FAT_UPDATE_ATIME : FAT_UPDATE_CMTIME);
> +		__mark_inode_dirty(inode, inode_time_dirty_flag(inode));
>  	}
> -
> -	__mark_inode_dirty(inode, dirty_flags);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(fat_update_time);
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index e08eb419347c..4ef39ff6889d 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -2242,7 +2242,8 @@ loff_t gfs2_seek_hole(struct file *file, loff_t offset)
>  	return vfs_setpos(file, ret, inode->i_sb->s_maxbytes);
>  }
>  
> -static int gfs2_update_time(struct inode *inode, int flags)
> +static int gfs2_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
>  	struct gfs2_inode *ip = GFS2_I(inode);
>  	struct gfs2_glock *gl = ip->i_gl;
> @@ -2257,7 +2258,7 @@ static int gfs2_update_time(struct inode *inode, int flags)
>  		if (error)
>  			return error;
>  	}
> -	return generic_update_time(inode, flags);
> +	return generic_update_time(inode, type, flags);
>  }
>  
>  static const struct inode_operations gfs2_file_iops = {
> diff --git a/fs/inode.c b/fs/inode.c
> index 7eb28dd45a5a..a0dd11a05473 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2081,78 +2081,84 @@ static bool relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>  	return false;
>  }
>  
> +static int inode_update_atime(struct inode *inode)
> +{
> +	struct timespec64 atime = inode_get_atime(inode);
> +	struct timespec64 now = current_time(inode);
> +
> +	if (timespec64_equal(&now, &atime))
> +		return 0;
> +
> +	inode_set_atime_to_ts(inode, now);
> +	return inode_time_dirty_flag(inode);
> +}
> +
> +static int inode_update_cmtime(struct inode *inode)
> +{
> +	struct timespec64 ctime = inode_get_ctime(inode);
> +	struct timespec64 mtime = inode_get_mtime(inode);
> +	struct timespec64 now = inode_set_ctime_current(inode);
> +	unsigned int dirty = 0;
> +	bool mtime_changed;
> +
> +	mtime_changed = !timespec64_equal(&now, &mtime);
> +	if (mtime_changed || !timespec64_equal(&now, &ctime))
> +		dirty = inode_time_dirty_flag(inode);
> +	if (mtime_changed)
> +		inode_set_mtime_to_ts(inode, now);
> +
> +	if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, !!dirty))
> +		dirty |= I_DIRTY_SYNC;
> +
> +	return dirty;
> +}
> +
>  /**
> - * inode_update_timestamps - update the timestamps on the inode
> + * inode_update_time - update either atime or c/mtime and i_version on the inode
>   * @inode: inode to be updated
> - * @flags: S_* flags that needed to be updated
> + * @type: timestamp to be updated
> + * @flags: flags for the update
>   *
> - * The update_time function is called when an inode's timestamps need to be
> - * updated for a read or write operation. This function handles updating the
> - * actual timestamps. It's up to the caller to ensure that the inode is marked
> - * dirty appropriately.
> + * Update either atime or c/mtime and version in a inode if needed for a file
> + * access or modification.  It is up to the caller to mark the inode dirty
> + * appropriately.
>   *
> - * In the case where any of S_MTIME, S_CTIME, or S_VERSION need to be updated,
> - * attempt to update all three of them. S_ATIME updates can be handled
> - * independently of the rest.
> - *
> - * Returns a set of S_* flags indicating which values changed.
> + * Returns the positive I_DIRTY_* flags for __mark_inode_dirty() if the inode
> + * needs to be marked dirty, 0 if it did not, or a negative errno if an error
> + * happened.
>   */
> -int inode_update_timestamps(struct inode *inode, int flags)
> +int inode_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	int updated = 0;
> -	struct timespec64 now;
> -
> -	if (flags & (S_MTIME|S_CTIME|S_VERSION)) {
> -		struct timespec64 ctime = inode_get_ctime(inode);
> -		struct timespec64 mtime = inode_get_mtime(inode);
> -
> -		now = inode_set_ctime_current(inode);
> -		if (!timespec64_equal(&now, &ctime))
> -			updated |= S_CTIME;
> -		if (!timespec64_equal(&now, &mtime)) {
> -			inode_set_mtime_to_ts(inode, now);
> -			updated |= S_MTIME;
> -		}
> -		if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, updated))
> -			updated |= S_VERSION;
> -	} else {
> -		now = current_time(inode);
> -	}
> -
> -	if (flags & S_ATIME) {
> -		struct timespec64 atime = inode_get_atime(inode);
> -
> -		if (!timespec64_equal(&now, &atime)) {
> -			inode_set_atime_to_ts(inode, now);
> -			updated |= S_ATIME;
> -		}
> +	switch (type) {
> +	case FS_UPD_ATIME:
> +		return inode_update_atime(inode);
> +	case FS_UPD_CMTIME:
> +		return inode_update_cmtime(inode);
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EIO;
>  	}
> -	return updated;
>  }
> -EXPORT_SYMBOL(inode_update_timestamps);
> +EXPORT_SYMBOL(inode_update_time);
>  
>  /**
>   * generic_update_time - update the timestamps on the inode
>   * @inode: inode to be updated
> - * @flags: S_* flags that needed to be updated
> - *
> - * The update_time function is called when an inode's timestamps need to be
> - * updated for a read or write operation. In the case where any of S_MTIME, S_CTIME,
> - * or S_VERSION need to be updated we attempt to update all three of them. S_ATIME
> - * updates can be handled done independently of the rest.
> + * @type: timestamp to be updated
> + * @flags: flags for the update
>   *
>   * Returns a negative error value on error, else 0.
>   */
> -int generic_update_time(struct inode *inode, int flags)
> +int generic_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	int updated = inode_update_timestamps(inode, flags);
> -	int dirty_flags = 0;
> +	int dirty;
>  
> -	if (updated & (S_ATIME|S_MTIME|S_CTIME))
> -		dirty_flags = inode->i_sb->s_flags & SB_LAZYTIME ? I_DIRTY_TIME : I_DIRTY_SYNC;
> -	if (updated & S_VERSION)
> -		dirty_flags |= I_DIRTY_SYNC;
> -	__mark_inode_dirty(inode, dirty_flags);
> +	dirty = inode_update_time(inode, type, flags);
> +	if (dirty <= 0)
> +		return dirty;
> +	__mark_inode_dirty(inode, dirty);
>  	return 0;
>  }
>  EXPORT_SYMBOL(generic_update_time);
> @@ -2225,9 +2231,9 @@ void touch_atime(const struct path *path)
>  	 * of the fs read only, e.g. subvolumes in Btrfs.
>  	 */
>  	if (inode->i_op->update_time)
> -		inode->i_op->update_time(inode, S_ATIME);
> +		inode->i_op->update_time(inode, FS_UPD_ATIME, 0);
>  	else
> -		generic_update_time(inode, S_ATIME);
> +		generic_update_time(inode, FS_UPD_ATIME, 0);
>  	mnt_put_write_access(mnt);
>  skip_update:
>  	sb_end_write(inode->i_sb);
> @@ -2354,7 +2360,7 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
>  {
>  	struct inode *inode = file_inode(file);
>  	struct timespec64 now, ts;
> -	int sync_mode = 0;
> +	bool need_update = false;
>  	int ret = 0;
>  
>  	/* First try to exhaust all avenues to not sync */
> @@ -2367,14 +2373,14 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
>  
>  	ts = inode_get_mtime(inode);
>  	if (!timespec64_equal(&ts, &now))
> -		sync_mode |= S_MTIME;
> +		need_update = true;
>  	ts = inode_get_ctime(inode);
>  	if (!timespec64_equal(&ts, &now))
> -		sync_mode |= S_CTIME;
> +		need_update = true;
>  	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
> -		sync_mode |= S_VERSION;
> +		need_update = true;
>  
> -	if (!sync_mode)
> +	if (!need_update)
>  		return 0;
>  
>  	if (flags & IOCB_NOWAIT)
> @@ -2383,9 +2389,9 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
>  	if (mnt_get_write_access_file(file))
>  		return 0;
>  	if (inode->i_op->update_time)
> -		ret = inode->i_op->update_time(inode, sync_mode);
> +		ret = inode->i_op->update_time(inode, FS_UPD_CMTIME, 0);
>  	else
> -		ret = generic_update_time(inode, sync_mode);
> +		ret = generic_update_time(inode, FS_UPD_CMTIME, 0);
>  	mnt_put_write_access_file(file);
>  	return ret;
>  }
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 3be8ba7b98c5..cd6d7c6e1237 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -649,15 +649,15 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
>  		struct timespec64 ctime = inode_get_ctime(inode);
>  		struct timespec64 mtime = inode_get_mtime(inode);
>  		struct timespec64 now;
> -		int updated = 0;
> +		bool updated = false;
>  
>  		now = inode_set_ctime_current(inode);
>  		if (!timespec64_equal(&now, &ctime))
> -			updated |= S_CTIME;
> +			updated = true;
>  
>  		inode_set_mtime_to_ts(inode, attr->ia_mtime);
>  		if (!timespec64_equal(&now, &mtime))
> -			updated |= S_MTIME;
> +			updated = true;
>  
>  		inode_maybe_inc_iversion(inode, updated);
>  		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
> @@ -671,13 +671,13 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
>  
>  static void nfs_update_atime(struct inode *inode)
>  {
> -	inode_update_timestamps(inode, S_ATIME);
> +	inode_update_time(inode, FS_UPD_ATIME, 0);
>  	NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_ATIME;
>  }
>  
>  static void nfs_update_mtime(struct inode *inode)
>  {
> -	inode_update_timestamps(inode, S_MTIME | S_CTIME);
> +	inode_update_time(inode, FS_UPD_CMTIME, 0);
>  	NFS_I(inode)->cache_validity &=
>  		~(NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME);
>  }
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index d7275990ffa4..eab16afb5b8a 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -872,22 +872,24 @@ int orangefs_permission(struct mnt_idmap *idmap,
>  	return generic_permission(&nop_mnt_idmap, inode, mask);
>  }
>  
> -int orangefs_update_time(struct inode *inode, int flags)
> +int orangefs_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	struct iattr iattr;
> +	struct iattr iattr = { };
> +	int dirty;
>  
> -	gossip_debug(GOSSIP_INODE_DEBUG, "orangefs_update_time: %pU\n",
> -	    get_khandle_from_ino(inode));
> -
> -	flags = inode_update_timestamps(inode, flags);
> +	switch (type) {
> +	case FS_UPD_ATIME:
> +		iattr.ia_valid = ATTR_ATIME;
> +		break;
> +	case FS_UPD_CMTIME:
> +		iattr.ia_valid = ATTR_CTIME | ATTR_MTIME;
> +		break;
> +	}
>  
> -	memset(&iattr, 0, sizeof iattr);
> -        if (flags & S_ATIME)
> -		iattr.ia_valid |= ATTR_ATIME;
> -	if (flags & S_CTIME)
> -		iattr.ia_valid |= ATTR_CTIME;
> -	if (flags & S_MTIME)
> -		iattr.ia_valid |= ATTR_MTIME;
> +	dirty = inode_update_time(inode, type, flags);
> +	if (dirty <= 0)
> +		return dirty;
>  	return __orangefs_setattr(inode, &iattr);
>  }
>  
> diff --git a/fs/orangefs/orangefs-kernel.h b/fs/orangefs/orangefs-kernel.h
> index 29c6da43e396..1451fc2c1917 100644
> --- a/fs/orangefs/orangefs-kernel.h
> +++ b/fs/orangefs/orangefs-kernel.h
> @@ -360,7 +360,8 @@ int orangefs_getattr(struct mnt_idmap *idmap, const struct path *path,
>  int orangefs_permission(struct mnt_idmap *idmap,
>  			struct inode *inode, int mask);
>  
> -int orangefs_update_time(struct inode *, int);
> +int orangefs_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
>  
>  /*
>   * defined in xattr.c
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index bdbf86b56a9b..c0ce3519e4af 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -555,9 +555,10 @@ int ovl_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>  }
>  #endif
>  
> -int ovl_update_time(struct inode *inode, int flags)
> +int ovl_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
> -	if (flags & S_ATIME) {
> +	if (type == FS_UPD_ATIME) {
>  		struct ovl_fs *ofs = OVL_FS(inode->i_sb);
>  		struct path upperpath = {
>  			.mnt = ovl_upper_mnt(ofs),
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index f9ac9bdde830..315882a360ce 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -820,7 +820,8 @@ static inline struct posix_acl *ovl_get_acl_path(const struct path *path,
>  }
>  #endif
>  
> -int ovl_update_time(struct inode *inode, int flags);
> +int ovl_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
>  bool ovl_is_private_xattr(struct super_block *sb, const char *name);
>  
>  struct ovl_inode_params {
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index ec1bb9f43acc..0cc44ad142de 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -1361,17 +1361,8 @@ static inline int mctime_update_needed(const struct inode *inode,
>  	return 0;
>  }
>  
> -/**
> - * ubifs_update_time - update time of inode.
> - * @inode: inode to update
> - * @flags: time updating control flag determines updating
> - *	    which time fields of @inode
> - *
> - * This function updates time of the inode.
> - *
> - * Returns: %0 for success or a negative error code otherwise.
> - */
> -int ubifs_update_time(struct inode *inode, int flags)
> +int ubifs_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags)
>  {
>  	struct ubifs_inode *ui = ubifs_inode(inode);
>  	struct ubifs_info *c = inode->i_sb->s_fs_info;
> @@ -1379,15 +1370,19 @@ int ubifs_update_time(struct inode *inode, int flags)
>  			.dirtied_ino_d = ALIGN(ui->data_len, 8) };
>  	int err, release;
>  
> +	/* ubifs sets S_NOCMTIME on all inodes, this should not happen. */
> +	if (WARN_ON_ONCE(type != FS_UPD_ATIME))
> +		return -EIO;
> +
>  	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
> -		return generic_update_time(inode, flags);
> +		return generic_update_time(inode, type, flags);
>  
>  	err = ubifs_budget_space(c, &req);
>  	if (err)
>  		return err;
>  
>  	mutex_lock(&ui->ui_mutex);
> -	inode_update_timestamps(inode, flags);
> +	inode_update_time(inode, type, flags);
>  	release = ui->dirty;
>  	__mark_inode_dirty(inode, I_DIRTY_SYNC);
>  	mutex_unlock(&ui->ui_mutex);
> diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
> index 118392aa9f2a..b62a154c7bd4 100644
> --- a/fs/ubifs/ubifs.h
> +++ b/fs/ubifs/ubifs.h
> @@ -2018,7 +2018,8 @@ int ubifs_calc_dark(const struct ubifs_info *c, int spc);
>  int ubifs_fsync(struct file *file, loff_t start, loff_t end, int datasync);
>  int ubifs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr);
> -int ubifs_update_time(struct inode *inode, int flags);
> +int ubifs_update_time(struct inode *inode, enum fs_update_time type,
> +		      unsigned int flags);
>  
>  /* dir.c */
>  struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 9dedb54e3cb0..d9eae1af14a8 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1184,21 +1184,21 @@ xfs_vn_setattr(
>  STATIC int
>  xfs_vn_update_time(
>  	struct inode		*inode,
> -	int			flags)
> +	enum fs_update_time	type,
> +	unsigned int		flags)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			log_flags = XFS_ILOG_TIMESTAMP;
>  	struct xfs_trans	*tp;
>  	int			error;
> -	struct timespec64	now;
>  
>  	trace_xfs_update_time(ip);
>  
>  	if (inode->i_sb->s_flags & SB_LAZYTIME) {
> -		if (!((flags & S_VERSION) &&
> -		      inode_maybe_inc_iversion(inode, false)))
> -			return generic_update_time(inode, flags);
> +		if (type == FS_UPD_ATIME ||
> +		    !inode_maybe_inc_iversion(inode, false))
> +			return generic_update_time(inode, type, flags);
>  
>  		/* Capture the iversion update that just occurred */
>  		log_flags |= XFS_ILOG_CORE;
> @@ -1209,16 +1209,10 @@ xfs_vn_update_time(
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (flags & (S_CTIME|S_MTIME))
> -		now = inode_set_ctime_current(inode);
> +	if (type == FS_UPD_ATIME)
> +		inode_set_atime_to_ts(inode, current_time(inode));
>  	else
> -		now = current_time(inode);
> -
> -	if (flags & S_MTIME)
> -		inode_set_mtime_to_ts(inode, now);
> -	if (flags & S_ATIME)
> -		inode_set_atime_to_ts(inode, now);
> -
> +		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, log_flags);
>  	return xfs_trans_commit(tp);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index fccb0a38cb74..35b3e6c6b084 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1717,6 +1717,13 @@ static inline struct timespec64 inode_set_ctime(struct inode *inode,
>  
>  struct timespec64 simple_inode_init_ts(struct inode *inode);
>  
> +static inline int inode_time_dirty_flag(struct inode *inode)
> +{
> +	if (inode->i_sb->s_flags & SB_LAZYTIME)
> +		return I_DIRTY_TIME;
> +	return I_DIRTY_SYNC;
> +}
> +
>  /*
>   * Snapshotting support.
>   */
> @@ -1983,6 +1990,11 @@ int wrap_directory_iterator(struct file *, struct dir_context *,
>  	static int shared_##x(struct file *file , struct dir_context *ctx) \
>  	{ return wrap_directory_iterator(file, ctx, x); }
>  
> +enum fs_update_time {
> +	FS_UPD_ATIME,
> +	FS_UPD_CMTIME,
> +};
> +
>  struct inode_operations {
>  	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
>  	const char * (*get_link) (struct dentry *, struct inode *, struct delayed_call *);
> @@ -2010,7 +2022,8 @@ struct inode_operations {
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
>  		      u64 len);
> -	int (*update_time)(struct inode *, int);
> +	int (*update_time)(struct inode *inode, enum fs_update_time type,
> +			   unsigned int flags);
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  			   struct file *, unsigned open_flag,
>  			   umode_t create_mode);
> @@ -2237,13 +2250,6 @@ static inline void inode_dec_link_count(struct inode *inode)
>  	mark_inode_dirty(inode);
>  }
>  
> -enum file_time_flags {
> -	S_ATIME = 1,
> -	S_MTIME = 2,
> -	S_CTIME = 4,
> -	S_VERSION = 8,
> -};
> -
>  extern bool atime_needs_update(const struct path *, struct inode *);
>  extern void touch_atime(const struct path *);
>  
> @@ -2398,8 +2404,10 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
>  extern void ihold(struct inode * inode);
>  extern void iput(struct inode *);
>  void iput_not_last(struct inode *);
> -int inode_update_timestamps(struct inode *inode, int flags);
> -int generic_update_time(struct inode *inode, int flags);
> +int inode_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
> +int generic_update_time(struct inode *inode, enum fs_update_time type,
> +		unsigned int flags);
>  
>  /* /sys/fs */
>  extern struct kobject *fs_kobj;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

