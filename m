Return-Path: <io-uring+bounces-2197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 639A7905D25
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 22:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60EA31C21BAD
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 20:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A4A584E07;
	Wed, 12 Jun 2024 20:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCENvW0G"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF7743144;
	Wed, 12 Jun 2024 20:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718225463; cv=none; b=bNrEs1BmdHu+Q3r6FFWwix9UtUDJtzvB7m89Fg4RVH8a7iUSkxWm7a0ZvNNJsSCiJYQqlo46l7mXJ+KJ6ySCPSiT2Xuxk21679vypK8g+ZowFcl0Yu/8fflwdLOj4dtCbalgcW6aQ58QMzfeO+nDetyu6juqi1KWOmsO41R7dhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718225463; c=relaxed/simple;
	bh=qec7j+ugewcloFLvMaArPIx31fouyUzkqT5sKaBT1O0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqeQfd04hki3oDmGEJ5xf3PW36Ony70VBWjIlzO7EipTgXd9W7Mqm1rPjQnXDJtGbAPPMsDIKstVBATAJ1ddazGS9XGanBn+A6d37zz7H9DqNW3uvS60J5Ggw+Ev0lPTJqWEXmOW2mZXathu3K4SJAYLsfVpS5G6qT3VIr5E9Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCENvW0G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25A2C116B1;
	Wed, 12 Jun 2024 20:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718225462;
	bh=qec7j+ugewcloFLvMaArPIx31fouyUzkqT5sKaBT1O0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UCENvW0G3cYGlTa6fqJarMiS5zDLyanxMgNjucmmKeIrMKC857trSKlpeTQdE9tAV
	 eglVW1Strq5Ihqysy1fAfi2+fyRosi8ElSkWfhZ5JvDquhRgjb6GZU+erYSkFVvHhw
	 RuMN9IHofeEEHh6YYWzcxfsOVEVAtKOMfw9/+u0QHdXuVNSOz5MEWRnTzzXFt3bk+t
	 QfRyr2697zE54bXmuGneWX9s4vnQp+qqJ4MstJlV++rLRKO4jyOdHGLJeKhQwQRYsf
	 1DqUCPnDwb22zl2dy+TTvWxAWKhQLZmqZddBjIAtm/0txsw5EwdZIroeeaBddAeRm9
	 RlIaLnGdQ2ueQ==
Date: Wed, 12 Jun 2024 13:51:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [PATCH v8 03/10] fs: Initial atomic write support
Message-ID: <20240612205102.GB2764780@frogsfrogsfrogs>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
 <20240610104329.3555488-4-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610104329.3555488-4-john.g.garry@oracle.com>

On Mon, Jun 10, 2024 at 10:43:22AM +0000, John Garry wrote:
> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> 
> An atomic write is a write issued with torn-write protection, meaning
> that for a power failure or any other hardware failure, all or none of the
> data from the write will be stored, but never a mix of old and new data.
> 
> Userspace may add flag RWF_ATOMIC to pwritev2() to indicate that the
> write is to be issued with torn-write prevention, according to special
> alignment and length rules.
> 
> For any syscall interface utilizing struct iocb, add IOCB_ATOMIC for
> iocb->ki_flags field to indicate the same.
> 
> A call to statx will give the relevant atomic write info for a file:
> - atomic_write_unit_min
> - atomic_write_unit_max
> - atomic_write_segments_max
> 
> Both min and max values must be a power-of-2.
> 
> Applications can avail of atomic write feature by ensuring that the total
> length of a write is a power-of-2 in size and also sized between
> atomic_write_unit_min and atomic_write_unit_max, inclusive. Applications
> must ensure that the write is at a naturally-aligned offset in the file
> wrt the total write length. The value in atomic_write_segments_max
> indicates the upper limit for IOV_ITER iovcnt.
> 
> Add file mode flag FMODE_CAN_ATOMIC_WRITE, so files which do not have the
> flag set will have RWF_ATOMIC rejected and not just ignored.
> 
> Add a type argument to kiocb_set_rw_flags() to allows reads which have
> RWF_ATOMIC set to be rejected.
> 
> Helper function generic_atomic_write_valid() can be used by FSes to verify
> compliant writes. There we check for iov_iter type is for ubuf, which
> implies iovcnt==1 for pwritev2(), which is an initial restriction for
> atomic_write_segments_max. Initially the only user will be bdev file
> operations write handler. We will rely on the block BIO submission path to
> ensure write sizes are compliant for the bdev, so we don't need to check
> atomic writes sizes yet.
> 
> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
> jpg: merge into single patch and much rewrite
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Seems fine to me, though clearly others have had much stronger opinions
in the past so:
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/aio.c                |  8 ++++----
>  fs/btrfs/ioctl.c        |  2 +-
>  fs/read_write.c         | 18 +++++++++++++++++-
>  include/linux/fs.h      | 17 +++++++++++++++--
>  include/uapi/linux/fs.h |  5 ++++-
>  io_uring/rw.c           |  9 ++++-----
>  6 files changed, 45 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 57c9f7c077e6..93ef59d358b3 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1516,7 +1516,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res)
>  	iocb_put(iocb);
>  }
>  
> -static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
> +static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int rw_type)
>  {
>  	int ret;
>  
> @@ -1542,7 +1542,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
>  	} else
>  		req->ki_ioprio = get_current_ioprio();
>  
> -	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
> +	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags, rw_type);
>  	if (unlikely(ret))
>  		return ret;
>  
> @@ -1594,7 +1594,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
>  	struct file *file;
>  	int ret;
>  
> -	ret = aio_prep_rw(req, iocb);
> +	ret = aio_prep_rw(req, iocb, READ);
>  	if (ret)
>  		return ret;
>  	file = req->ki_filp;
> @@ -1621,7 +1621,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
>  	struct file *file;
>  	int ret;
>  
> -	ret = aio_prep_rw(req, iocb);
> +	ret = aio_prep_rw(req, iocb, WRITE);
>  	if (ret)
>  		return ret;
>  	file = req->ki_filp;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index efd5d6e9589e..6ad524b894fc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4627,7 +4627,7 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
>  		goto out_iov;
>  
>  	init_sync_kiocb(&kiocb, file);
> -	ret = kiocb_set_rw_flags(&kiocb, 0);
> +	ret = kiocb_set_rw_flags(&kiocb, 0, WRITE);
>  	if (ret)
>  		goto out_iov;
>  	kiocb.ki_pos = pos;
> diff --git a/fs/read_write.c b/fs/read_write.c
> index ef6339391351..285b0f5a9a9c 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -730,7 +730,7 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
>  	ssize_t ret;
>  
>  	init_sync_kiocb(&kiocb, filp);
> -	ret = kiocb_set_rw_flags(&kiocb, flags);
> +	ret = kiocb_set_rw_flags(&kiocb, flags, type);
>  	if (ret)
>  		return ret;
>  	kiocb.ki_pos = (ppos ? *ppos : 0);
> @@ -1736,3 +1736,19 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
>  
>  	return 0;
>  }
> +
> +bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos)
> +{
> +	size_t len = iov_iter_count(iter);
> +
> +	if (!iter_is_ubuf(iter))
> +		return false;
> +
> +	if (!is_power_of_2(len))
> +		return false;
> +
> +	if (!IS_ALIGNED(pos, len))
> +		return false;
> +
> +	return true;
> +}
> \ No newline at end of file
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0283cf366c2a..e049414bef7d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -125,8 +125,10 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  #define FMODE_EXEC		((__force fmode_t)(1 << 5))
>  /* File writes are restricted (block device specific) */
>  #define FMODE_WRITE_RESTRICTED	((__force fmode_t)(1 << 6))
> +/* File supports atomic writes */
> +#define FMODE_CAN_ATOMIC_WRITE	((__force fmode_t)(1 << 7))
>  
> -/* FMODE_* bits 7 to 8 */
> +/* FMODE_* bit 8 */
>  
>  /* 32bit hashes as llseek() offset (for directories) */
>  #define FMODE_32BITHASH         ((__force fmode_t)(1 << 9))
> @@ -317,6 +319,7 @@ struct readahead_control;
>  #define IOCB_SYNC		(__force int) RWF_SYNC
>  #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
>  #define IOCB_APPEND		(__force int) RWF_APPEND
> +#define IOCB_ATOMIC		(__force int) RWF_ATOMIC
>  
>  /* non-RWF related bits - start at 16 */
>  #define IOCB_EVENTFD		(1 << 16)
> @@ -351,6 +354,7 @@ struct readahead_control;
>  	{ IOCB_SYNC,		"SYNC" }, \
>  	{ IOCB_NOWAIT,		"NOWAIT" }, \
>  	{ IOCB_APPEND,		"APPEND" }, \
> +	{ IOCB_ATOMIC,		"ATOMIC"}, \
>  	{ IOCB_EVENTFD,		"EVENTFD"}, \
>  	{ IOCB_DIRECT,		"DIRECT" }, \
>  	{ IOCB_WRITE,		"WRITE" }, \
> @@ -3403,7 +3407,8 @@ static inline int iocb_flags(struct file *file)
>  	return res;
>  }
>  
> -static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
> +static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
> +				     int rw_type)
>  {
>  	int kiocb_flags = 0;
>  
> @@ -3422,6 +3427,12 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
>  			return -EOPNOTSUPP;
>  		kiocb_flags |= IOCB_NOIO;
>  	}
> +	if (flags & RWF_ATOMIC) {
> +		if (rw_type != WRITE)
> +			return -EOPNOTSUPP;
> +		if (!(ki->ki_filp->f_mode & FMODE_CAN_ATOMIC_WRITE))
> +			return -EOPNOTSUPP;
> +	}
>  	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
>  	if (flags & RWF_SYNC)
>  		kiocb_flags |= IOCB_DSYNC;
> @@ -3613,4 +3624,6 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
>  extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
>  			   int advice);
>  
> +bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos);
> +
>  #endif /* _LINUX_FS_H */
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 45e4e64fd664..191a7e88a8ab 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -329,9 +329,12 @@ typedef int __bitwise __kernel_rwf_t;
>  /* per-IO negation of O_APPEND */
>  #define RWF_NOAPPEND	((__force __kernel_rwf_t)0x00000020)
>  
> +/* Atomic Write */
> +#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
> +
>  /* mask of flags supported by the kernel */
>  #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
> -			 RWF_APPEND | RWF_NOAPPEND)
> +			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC)
>  
>  /* Pagemap ioctl */
>  #define PAGEMAP_SCAN	_IOWR('f', 16, struct pm_scan_arg)
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 1a2128459cb4..c004d21e2f12 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -772,7 +772,7 @@ static bool need_complete_io(struct io_kiocb *req)
>  		S_ISBLK(file_inode(req->file)->i_mode);
>  }
>  
> -static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
> +static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
>  {
>  	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
>  	struct kiocb *kiocb = &rw->kiocb;
> @@ -787,7 +787,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>  		req->flags |= io_file_get_flags(file);
>  
>  	kiocb->ki_flags = file->f_iocb_flags;
> -	ret = kiocb_set_rw_flags(kiocb, rw->flags);
> +	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
>  	if (unlikely(ret))
>  		return ret;
>  	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
> @@ -832,8 +832,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>  		if (unlikely(ret < 0))
>  			return ret;
>  	}
> -
> -	ret = io_rw_init_file(req, FMODE_READ);
> +	ret = io_rw_init_file(req, FMODE_READ, READ);
>  	if (unlikely(ret))
>  		return ret;
>  	req->cqe.res = iov_iter_count(&io->iter);
> @@ -1013,7 +1012,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  	ssize_t ret, ret2;
>  	loff_t *ppos;
>  
> -	ret = io_rw_init_file(req, FMODE_WRITE);
> +	ret = io_rw_init_file(req, FMODE_WRITE, WRITE);
>  	if (unlikely(ret))
>  		return ret;
>  	req->cqe.res = iov_iter_count(&io->iter);
> -- 
> 2.31.1
> 
> 

