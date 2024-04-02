Return-Path: <io-uring+bounces-1361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 310638950E0
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 12:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA94B286B5F
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 10:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39395FB98;
	Tue,  2 Apr 2024 10:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z8Adm5+W";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="loDp6aBU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D105F873;
	Tue,  2 Apr 2024 10:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712055086; cv=none; b=bp/Vot2ajrzVGB6CBoKvlQYWEsOTXyr0e4NMinpxaMoXmFCcpB91LnaSMCxhJFmqBxuMbGIylD8g83oQ6C7kk9wg7u1kDVEmcNuojUEi144DHBgVwYuXINyeFJcwB80oIW24h/CNQulZAm9giTp1vVrgMZWnAjiq7FO9XZN7sdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712055086; c=relaxed/simple;
	bh=8EPxofJKrmn27UvzvxakwQaPTnGb1vRz73yD/7QFR9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktWODaheBd+t9+HMvMel8uF7abj1k0tVDG6oN7CSThdGmXJJZ3Bde5STLujL33vFQEPy8hWnRNwF0Cmm6gUuBdCvLSkqCjEMmyUFJuPawuGZTDapueSemSBbVMAFv3C8BNUV77caBHA8HG7FK+2/YonZg4FFus1suqtkUxWqhyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z8Adm5+W; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=loDp6aBU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 31B78345AF;
	Tue,  2 Apr 2024 10:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712055082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qKZccLTJaJ/+J5R+DjrdtmF1ZnxPN3VrC9yKNF8h/lg=;
	b=z8Adm5+WK2xLi4rQIvo2Lq3i0jl0yldkD9AIRqMajZ6vB45WLq1yrqM/aUl/Y1/mbONXH/
	xmvLqRSHs4Qt8aHSFr0FCoDMCuejtZF4DnIFp7eI1RwoLptX7tLezFHZE95A5A5cCo9Q6P
	g3ciItSmrE/D+MTtGozR6fNj5ZHmaYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712055082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qKZccLTJaJ/+J5R+DjrdtmF1ZnxPN3VrC9yKNF8h/lg=;
	b=loDp6aBUkZy/BJSJlcNe4Wg7U4neBNC4mV7xD6CKuni4lyuPGZwDkxzHRSS/2zgtZSrujq
	nNXqLDtnyC9sRCBg==
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 274ED13357;
	Tue,  2 Apr 2024 10:51:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id kmeVCSrjC2YgHQAAn2gu4w
	(envelope-from <jack@suse.cz>); Tue, 02 Apr 2024 10:51:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C3740A0813; Tue,  2 Apr 2024 12:51:17 +0200 (CEST)
Date: Tue, 2 Apr 2024 12:51:17 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <20240402105117.bkbbqvzk7eqh23wa@quack3>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328-gewendet-spargel-aa60a030ef74@brauner>
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap2.dmz-prg2.suse.org:rdns,imap2.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

On Thu 28-03-24 13:27:24, Christian Brauner wrote:
> There's a bunch of flags that are purely based on what the file
> operations support while also never being conditionally set or unset.
> IOW, they're not subject to change for individual files. Imho, such
> flags don't need to live in f_mode they might as well live in the fops
> structs itself. And the fops struct already has that lonely
> mmap_supported_flags member. We might as well turn that into a generic
> fop_flags member and move a few flags from FMODE_* space into FOP_*
> space. That gets us four FMODE_* bits back and the ability for new
> static flags that are about file ops to not have to live in FMODE_*
> space but in their own FOP_* space. It's not the most beautiful thing
> ever but it gets the job done. Yes, there'll be an additional pointer
> chase but hopefully that won't matter for these flags.
> 
> I suspect there's a few more we can move into there and that we can also
> redirect a bunch of new flag suggestions that follow this pattern into
> the fop_flags field instead of f_mode.
> 
> (Fwiw, FMODE_NOACCOUNT and FMODE_BACKING could live in fop_flags as
>  well because they're also completely static but they aren't really
>  about file operations so they're better suited for FMODE_* imho.)
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bdev.c         |  2 +-
>  block/fops.c         |  1 +
>  drivers/dax/device.c |  2 +-
>  fs/btrfs/file.c      |  4 ++--
>  fs/ext4/file.c       |  6 +++---
>  fs/f2fs/file.c       |  3 ++-
>  fs/read_write.c      |  2 +-
>  fs/xfs/xfs_file.c    |  8 +++++---
>  include/linux/fs.h   | 22 ++++++++++++----------
>  io_uring/io_uring.c  |  2 +-
>  io_uring/rw.c        |  9 +++++----
>  mm/mmap.c            |  4 +++-
>  12 files changed, 37 insertions(+), 28 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index b8e32d933a63..dd26d37356aa 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -903,7 +903,7 @@ int bdev_open(struct block_device *bdev, blk_mode_t mode, void *holder,
>  		disk_unblock_events(disk);
>  
>  	bdev_file->f_flags |= O_LARGEFILE;
> -	bdev_file->f_mode |= FMODE_BUF_RASYNC | FMODE_CAN_ODIRECT;
> +	bdev_file->f_mode |= FMODE_CAN_ODIRECT;
>  	if (bdev_nowait(bdev))
>  		bdev_file->f_mode |= FMODE_NOWAIT;
>  	if (mode & BLK_OPEN_RESTRICT_WRITES)
> diff --git a/block/fops.c b/block/fops.c
> index 679d9b752fe8..af6c244314af 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -863,6 +863,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_read	= filemap_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
> +	.fop_flags	= FOP_BUFFER_RASYNC,
>  };
>  
>  static __init int blkdev_init(void)
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 93ebedc5ec8c..c24ef4d3cf31 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -377,7 +377,7 @@ static const struct file_operations dax_fops = {
>  	.release = dax_release,
>  	.get_unmapped_area = dax_get_unmapped_area,
>  	.mmap = dax_mmap,
> -	.mmap_supported_flags = MAP_SYNC,
> +	.fop_flags = FOP_MMAP_SYNC,
>  };
>  
>  static void dev_dax_cdev_del(void *cdev)
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f9d76072398d..1640c46f2153 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3719,8 +3719,7 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
>  {
>  	int ret;
>  
> -	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
> -		        FMODE_CAN_ODIRECT;
> +	filp->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
>  
>  	ret = fsverity_file_open(inode, filp);
>  	if (ret)
> @@ -3850,6 +3849,7 @@ const struct file_operations btrfs_file_operations = {
>  	.compat_ioctl	= btrfs_compat_ioctl,
>  #endif
>  	.remap_file_range = btrfs_remap_file_range,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC,
>  };
>  
>  int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end)
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 54d6ff22585c..28c51b0cc4db 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -885,8 +885,7 @@ static int ext4_file_open(struct inode *inode, struct file *filp)
>  			return ret;
>  	}
>  
> -	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC |
> -			FMODE_DIO_PARALLEL_WRITE;
> +	filp->f_mode |= FMODE_NOWAIT;
>  	return dquot_file_open(inode, filp);
>  }
>  
> @@ -938,7 +937,6 @@ const struct file_operations ext4_file_operations = {
>  	.compat_ioctl	= ext4_compat_ioctl,
>  #endif
>  	.mmap		= ext4_file_mmap,
> -	.mmap_supported_flags = MAP_SYNC,
>  	.open		= ext4_file_open,
>  	.release	= ext4_release_file,
>  	.fsync		= ext4_sync_file,
> @@ -946,6 +944,8 @@ const struct file_operations ext4_file_operations = {
>  	.splice_read	= ext4_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= ext4_fallocate,
> +	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
> +			  FOP_DIO_PARALLEL_WRITE,
>  };
>  
>  const struct inode_operations ext4_file_inode_operations = {
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 1761ad125f97..2b65e09822d4 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -569,7 +569,7 @@ static int f2fs_file_open(struct inode *inode, struct file *filp)
>  	if (err)
>  		return err;
>  
> -	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
> +	filp->f_mode |= FMODE_NOWAIT;
>  	filp->f_mode |= FMODE_CAN_ODIRECT;
>  
>  	return dquot_file_open(inode, filp);
> @@ -5045,4 +5045,5 @@ const struct file_operations f2fs_file_operations = {
>  	.splice_read	= f2fs_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fadvise	= f2fs_file_fadvise,
> +	.fop_flags	= FOP_BUFFER_RASYNC,
>  };
> diff --git a/fs/read_write.c b/fs/read_write.c
> index d4c036e82b6c..2115d1f40bd5 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1685,7 +1685,7 @@ int generic_write_checks_count(struct kiocb *iocb, loff_t *count)
>  
>  	if ((iocb->ki_flags & IOCB_NOWAIT) &&
>  	    !((iocb->ki_flags & IOCB_DIRECT) ||
> -	      (file->f_mode & FMODE_BUF_WASYNC)))
> +	      (file->f_op->fop_flags & FOP_BUFFER_WASYNC)))
>  		return -EINVAL;
>  
>  	return generic_write_check_limits(iocb->ki_filp, iocb->ki_pos, count);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 632653e00906..147439ad3581 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1230,8 +1230,7 @@ xfs_file_open(
>  {
>  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
>  		return -EIO;
> -	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
> -			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
> +	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
>  	return generic_file_open(inode, file);
>  }
>  
> @@ -1490,7 +1489,6 @@ const struct file_operations xfs_file_operations = {
>  	.compat_ioctl	= xfs_file_compat_ioctl,
>  #endif
>  	.mmap		= xfs_file_mmap,
> -	.mmap_supported_flags = MAP_SYNC,
>  	.open		= xfs_file_open,
>  	.release	= xfs_file_release,
>  	.fsync		= xfs_file_fsync,
> @@ -1498,6 +1496,8 @@ const struct file_operations xfs_file_operations = {
>  	.fallocate	= xfs_file_fallocate,
>  	.fadvise	= xfs_file_fadvise,
>  	.remap_file_range = xfs_file_remap_range,
> +	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC |
> +			  FOP_DIO_PARALLEL_WRITE,
>  };
>  
>  const struct file_operations xfs_dir_file_operations = {
> @@ -1510,4 +1510,6 @@ const struct file_operations xfs_dir_file_operations = {
>  	.compat_ioctl	= xfs_file_compat_ioctl,
>  #endif
>  	.fsync		= xfs_dir_fsync,
> +	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC |
> +			  FOP_DIO_PARALLEL_WRITE,
>  };
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8dfd53b52744..ece6e681ec77 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -165,9 +165,6 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  
>  #define	FMODE_NOREUSE		((__force fmode_t)0x800000)
>  
> -/* File supports non-exclusive O_DIRECT writes from multiple threads */
> -#define FMODE_DIO_PARALLEL_WRITE	((__force fmode_t)0x1000000)
> -
>  /* File is embedded in backing_file object */
>  #define FMODE_BACKING		((__force fmode_t)0x2000000)
>  
> @@ -183,12 +180,6 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  /* File does not contribute to nr_files count */
>  #define FMODE_NOACCOUNT		((__force fmode_t)0x20000000)
>  
> -/* File supports async buffered reads */
> -#define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
> -
> -/* File supports async nowait buffered writes */
> -#define FMODE_BUF_WASYNC	((__force fmode_t)0x80000000)
> -
>  /*
>   * Attribute flags.  These should be or-ed together to figure out what
>   * has been changed!
> @@ -2003,8 +1994,11 @@ struct iov_iter;
>  struct io_uring_cmd;
>  struct offset_ctx;
>  
> +typedef unsigned int __bitwise fop_flags_t;
> +
>  struct file_operations {
>  	struct module *owner;
> +	fop_flags_t fop_flags;
>  	loff_t (*llseek) (struct file *, loff_t, int);
>  	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
>  	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
> @@ -2017,7 +2011,6 @@ struct file_operations {
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>  	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
> -	unsigned long mmap_supported_flags;
>  	int (*open) (struct inode *, struct file *);
>  	int (*flush) (struct file *, fl_owner_t id);
>  	int (*release) (struct inode *, struct file *);
> @@ -2048,6 +2041,15 @@ struct file_operations {
>  				unsigned int poll_flags);
>  } __randomize_layout;
>  
> +/* Supports async buffered reads */
> +#define FOP_BUFFER_RASYNC	((__force fop_flags_t)(1 << 0))
> +/* Supports async buffered writes */
> +#define FOP_BUFFER_WASYNC	((__force fop_flags_t)(1 << 1))
> +/* Supports synchronous page faults for mappings */
> +#define FOP_MMAP_SYNC		((__force fop_flags_t)(1 << 2))
> +/* Supports non-exclusive O_DIRECT writes from multiple threads */
> +#define FOP_DIO_PARALLEL_WRITE	((__force fop_flags_t)(1 << 3))
> +
>  /* Wrap a directory iterator that needs exclusive inode access */
>  int wrap_directory_iterator(struct file *, struct dir_context *,
>  			    int (*) (struct file *, struct dir_context *));
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 5d4b448fdc50..d73c9ad2d2f8 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -471,7 +471,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>  
>  		/* don't serialize this request if the fs doesn't need it */
>  		if (should_hash && (req->file->f_flags & O_DIRECT) &&
> -		    (req->file->f_mode & FMODE_DIO_PARALLEL_WRITE))
> +		    (req->file->f_op->fop_flags & FOP_DIO_PARALLEL_WRITE))
>  			should_hash = false;
>  		if (should_hash || (ctx->flags & IORING_SETUP_IOPOLL))
>  			io_wq_hash_work(&req->work, file_inode(req->file));
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 0585ebcc9773..d9dfde1142a1 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -683,7 +683,8 @@ static bool io_rw_should_retry(struct io_kiocb *req)
>  	 * just use poll if we can, and don't attempt if the fs doesn't
>  	 * support callback based unlocks
>  	 */
> -	if (io_file_can_poll(req) || !(req->file->f_mode & FMODE_BUF_RASYNC))
> +	if (io_file_can_poll(req) ||
> +	    !(req->file->f_op->fop_flags & FOP_BUFFER_RASYNC))
>  		return false;
>  
>  	wait->wait.func = io_async_buf_func;
> @@ -1022,10 +1023,10 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  		if (unlikely(!io_file_supports_nowait(req)))
>  			goto copy_iov;
>  
> -		/* File path supports NOWAIT for non-direct_IO only for block devices. */
> +		/* Check if we can support NOWAIT. */
>  		if (!(kiocb->ki_flags & IOCB_DIRECT) &&
> -			!(kiocb->ki_filp->f_mode & FMODE_BUF_WASYNC) &&
> -			(req->flags & REQ_F_ISREG))
> +		    !(req->file->f_op->fop_flags & FOP_BUFFER_WASYNC) &&
> +		    (req->flags & REQ_F_ISREG))
>  			goto copy_iov;
>  
>  		kiocb->ki_flags |= IOCB_NOWAIT;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 6dbda99a47da..3490af70f259 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1294,7 +1294,9 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		if (!file_mmap_ok(file, inode, pgoff, len))
>  			return -EOVERFLOW;
>  
> -		flags_mask = LEGACY_MAP_MASK | file->f_op->mmap_supported_flags;
> +		flags_mask = LEGACY_MAP_MASK;
> +		if (file->f_op->fop_flags & FOP_MMAP_SYNC)
> +			flags_mask |= MAP_SYNC;
>  
>  		switch (flags & MAP_TYPE) {
>  		case MAP_SHARED:
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

