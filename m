Return-Path: <io-uring+bounces-714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9FC9862AAA
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 15:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D48AB20E5C
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 14:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0AD1125C1;
	Sun, 25 Feb 2024 14:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wwii20G7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245E0134A6;
	Sun, 25 Feb 2024 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708870816; cv=none; b=d0SzZxIWmPytVPI3dqZi5ITSSyVN4otHkF11vb1+Ov67cwjFFV902AZgiSJ0fsb+0GpQ/wogiY/kO1RXchjVsXf7X6wGNn2dvKS0RFuMdlyPC21cKFT6+jnsHgs3TKc9hdyh2H615vcMP2JzH2ZvYNgxBK+yU0Wb9J8z3vJHOFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708870816; c=relaxed/simple;
	bh=SVrYJdflN3YpptlopCMkC3cRmo84eXHVu7J/dp0JY0U=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=t39Bt4vmr2ZxLSXrpghijIkJRghG0xxQmqAlctWOWQC6LiQ7qxKF63QFkfmvV1LBIgnDc7L/fPi6pHVvUJepIAKCjfzeec+4ZFD1aBKpD4L4TwRFJdZGN9h5UTcVLjijCezgLQL70ydaLQEeM3SNZ8lHVnMGy04RnPBJXbka1fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wwii20G7; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dc0e5b223eso18005965ad.1;
        Sun, 25 Feb 2024 06:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708870814; x=1709475614; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dYKBi+Kx0kph0B/S8oQqjrPvt1FVU1da3rN7thqVsdg=;
        b=Wwii20G7q7BsTHlpCMgtKrSxc0vRE6vT/0ltXPfNsO/d/ekyisRuMu6F9Qa5Dkuv++
         dnZuLHUjZtb9OQt9muD6hH4zPH3qMocdEikRGCgI2awJzj5Pkj82EYrAMk+e7v/RulYV
         xyDEJD9LTMpdPYByDzQazZ4+qsvsnrZhOWamO9gM0mTb/Cnbm1V/nf5CaUBx408J6kUL
         WwNyWEE6YMhnDZSCZYH3/LzQ52+1GkdH7iAzLunx83edm8qgvXdD4vLBXx78rSIc6IQX
         iqzijEOMyb/OSvH2PrjCWagCGLf2vr/9dMg1jjvvIgAkvAN+Ar/gGpAgj9CpryNznUU0
         LWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708870814; x=1709475614;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dYKBi+Kx0kph0B/S8oQqjrPvt1FVU1da3rN7thqVsdg=;
        b=bTVpone86Nj2FlFrGTNRWA8rwh/NLQsh7JYN0s4xqfiKoIlDkrR0keK0rUR7Q0IGd4
         6/yANebeByKlGIz948hQoPGfW+23P2kbHVSvVbfRJEF6YxpVjM8/gnNjnC9iqz5Vad+L
         sdvu/bJgrKv4T796btpP/2OtD+twfG/H6+xFLZIbqEHQr9iNYn2ArZ4cgXV4lCyAQA4g
         IWRriA1JJYIAa3d5TETT2l6DCCYNxH5CQwtKbMEQuX/ShZILJyALz4egVDFcabj6sDva
         6jZu9VvF/P9pEZwLR/Scvcqrs4qsheq52Q2j0ojocCoOV+ozLndufxWcyua2nWEBmpxC
         v89w==
X-Forwarded-Encrypted: i=1; AJvYcCXmvFPLZBdOsCA7XrvxhKk66trh9UYx6dMF5gxzXn4ucWZpAZ095CGqeGY11rTTyCBUXoM4FYBGQpBoih9aQtv7D91TerG2fNmUD3jTtU+TvjIWido6R86PDKHDCEn41xOa8LS70ejK3AiUOI25m7NvfO4AegHOd4E50Lzj5wEAP9xihN60Ph3IL73tJSeP7lY7NLLXSSsCDfYhem3JktpaJERq2UI1EYnaLeuUsw/mKIgmtdr7UCu2d7fDxpbw
X-Gm-Message-State: AOJu0YzDVYWNEH+wabco7w8+Fo/A9ztDcwMSfLwBZBYAOx0/sEiurpX2
	DyD0jkd7C811Dva9kOVSjt6LQ+ny52z0K5QcVfJneyoIjAUVDiXsmn2CQEIN
X-Google-Smtp-Source: AGHT+IEXYxsOr0QSU3u6gD+WhXD9eZzTG9jlMHzB6YlRK1F6+maANbBs6nKGmmS0D2Yf2XVZrvmbdA==
X-Received: by 2002:a17:902:6506:b0:1dc:8fb0:2b9e with SMTP id b6-20020a170902650600b001dc8fb02b9emr1407177plk.34.1708870814349;
        Sun, 25 Feb 2024 06:20:14 -0800 (PST)
Received: from dw-tp ([171.76.80.106])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902a38600b001d7252fef6bsm2357872pla.299.2024.02.25.06.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 06:20:13 -0800 (PST)
Date: Sun, 25 Feb 2024 19:50:06 +0530
Message-Id: <87frxg1v8p.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com, Prasad Singamsetty <prasad.singamsetty@oracle.com>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 06/11] block: Add atomic write support for statx
In-Reply-To: <20240219130109.341523-7-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

John Garry <john.g.garry@oracle.com> writes:

> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>
> Extend statx system call to return additional info for atomic write support
> support if the specified file is a block device.
>
> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  block/bdev.c           | 37 +++++++++++++++++++++++++++----------
>  fs/stat.c              | 13 ++++++-------
>  include/linux/blkdev.h |  5 +++--
>  3 files changed, 36 insertions(+), 19 deletions(-)
>
> diff --git a/block/bdev.c b/block/bdev.c
> index e9f1b12bd75c..0dada9902bd4 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -1116,24 +1116,41 @@ void sync_bdevs(bool wait)
>  	iput(old_inode);
>  }
>  
> +#define BDEV_STATX_SUPPORTED_MASK (STATX_DIOALIGN | STATX_WRITE_ATOMIC)
> +
>  /*
> - * Handle STATX_DIOALIGN for block devices.
> - *
> - * Note that the inode passed to this is the inode of a block device node file,
> - * not the block device's internal inode.  Therefore it is *not* valid to use
> - * I_BDEV() here; the block device has to be looked up by i_rdev instead.
> + * Handle STATX_{DIOALIGN, WRITE_ATOMIC} for block devices.
>   */
> -void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
> +void bdev_statx(struct dentry *dentry, struct kstat *stat, u32 request_mask)

why change this to dentry? Why not keep it as inode itself?

-ritesh

>  {
>  	struct block_device *bdev;
>  
> -	bdev = blkdev_get_no_open(inode->i_rdev);
> +	if (!(request_mask & BDEV_STATX_SUPPORTED_MASK))
> +		return;
> +
> +	/*
> +	 * Note that d_backing_inode() returns the inode of a block device node
> +	 * file, not the block device's internal inode.  Therefore it is *not*
> +	 * valid to use I_BDEV() here; the block device has to be looked up by
> +	 * i_rdev instead.
> +	 */
> +	bdev = blkdev_get_no_open(d_backing_inode(dentry)->i_rdev);
>  	if (!bdev)
>  		return;
>  
> -	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
> -	stat->dio_offset_align = bdev_logical_block_size(bdev);
> -	stat->result_mask |= STATX_DIOALIGN;
> +	if (request_mask & STATX_DIOALIGN) {
> +		stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
> +		stat->dio_offset_align = bdev_logical_block_size(bdev);
> +		stat->result_mask |= STATX_DIOALIGN;
> +	}
> +
> +	if (request_mask & STATX_WRITE_ATOMIC && bdev_can_atomic_write(bdev)) {
> +		struct request_queue *bd_queue = bdev->bd_queue;
> +
> +		generic_fill_statx_atomic_writes(stat,
> +			queue_atomic_write_unit_min_bytes(bd_queue),
> +			queue_atomic_write_unit_max_bytes(bd_queue));
> +	}
>  
>  	blkdev_put_no_open(bdev);
>  }
> diff --git a/fs/stat.c b/fs/stat.c
> index 522787a4ab6a..bd0618477702 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -290,13 +290,12 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
>  		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
>  	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
>  
> -	/* Handle STATX_DIOALIGN for block devices. */
> -	if (request_mask & STATX_DIOALIGN) {
> -		struct inode *inode = d_backing_inode(path.dentry);
> -
> -		if (S_ISBLK(inode->i_mode))
> -			bdev_statx_dioalign(inode, stat);
> -	}
> +	/* If this is a block device inode, override the filesystem
> +	 * attributes with the block device specific parameters
> +	 * that need to be obtained from the bdev backing inode
> +	 */
> +	if (S_ISBLK(d_backing_inode(path.dentry)->i_mode))
> +		bdev_statx(path.dentry, stat, request_mask);
>  
>  	path_put(&path);
>  	if (retry_estale(error, lookup_flags)) {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 40ed56ef4937..4f04456f1250 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1541,7 +1541,7 @@ int sync_blockdev(struct block_device *bdev);
>  int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
>  int sync_blockdev_nowait(struct block_device *bdev);
>  void sync_bdevs(bool wait);
> -void bdev_statx_dioalign(struct inode *inode, struct kstat *stat);
> +void bdev_statx(struct dentry *dentry, struct kstat *stat, u32 request_mask);
>  void printk_all_partitions(void);
>  int __init early_lookup_bdev(const char *pathname, dev_t *dev);
>  #else
> @@ -1559,7 +1559,8 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
>  static inline void sync_bdevs(bool wait)
>  {
>  }
> -static inline void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
> +static inline void bdev_statx(struct dentry *dentry, struct kstat *stat,
> +				u32 request_mask)
>  {
>  }
>  static inline void printk_all_partitions(void)
> -- 
> 2.31.1

