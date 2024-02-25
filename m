Return-Path: <io-uring+bounces-715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F68862ACC
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 15:46:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19F2DB20EF4
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 14:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F00612B71;
	Sun, 25 Feb 2024 14:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AW1Zn5Vm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A959612E6A;
	Sun, 25 Feb 2024 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708872386; cv=none; b=DGtdgtriKtg5npAzL/aUYG0499U0VCWlrXkz2QFBLLqjz11oHZKjHfkgmU4YdIqL7Tq+Rr8N10FVVbnmRX+E3vqGNzRKIRMmCYyelV+u6yZI46q/4gE0vN1D7qQXxPjMu0tni4uA7xxfQLoCoRbGk3cqWyHZI0p+uEtSEBCFz2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708872386; c=relaxed/simple;
	bh=cJxeZ9XcAyAWI/FNWJkHGSlKd1lbYW4aDtPK/n0YZ7E=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=DpKkA8IrvQd5/VKHvx8QABWq+Y514Pvkhc8WTe7KB3bw7afxuZn8MCgkJkJ6QTDifyzUVBoY0Ng8zFvQW2+yNm00ZgPw7F7VslF4RxkpzAqOw4kcrohUzjGaW04S+dW59rK+gYnP7Cp8LX4jMB8OD/LTxXWs8gB/uuZIbwB4Q/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AW1Zn5Vm; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6e125818649so959907a34.1;
        Sun, 25 Feb 2024 06:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708872384; x=1709477184; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JpmlBduLOtP9Y7HibP2DDg1Ww/fxHjaBUbZW8bb6d/A=;
        b=AW1Zn5VmQkfCq0cJRFVK/ELslGUJtAfKmvQOBK5n7WHRR+a8b/7QYR7++jLAEdCjzZ
         C5EWKncnQO8/XnyF8AmwcxVw47Yp8DgMZxOWPb2GA5tvpUSy7dfeW/mv+fY6FSQ9VXv2
         7ubgCh+NVZkYAk+VQj0q8NeWjZFf59VJg2DMSLQ5RlsxRy2InTDudd8+tnO8QU4+3Z9L
         7oGTHEAqelz/qxKACLJuFllFQZ039n+thADhdCtK20InQCvQEA9HhHGbvKx+5iSrXBpJ
         N4S1B2uaaxtzxF7kdtgjEmG3iqGoFXsUc6+40oHzm2JyEQlq5OB5kqPfNXFNGDwC0S2R
         ycQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708872384; x=1709477184;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JpmlBduLOtP9Y7HibP2DDg1Ww/fxHjaBUbZW8bb6d/A=;
        b=nVvZTENd8X0QXzA1SbAP8sG+lfcFKWGETkEOO9A6R/rQ53i4gd63v3fuoNVb2Q6Qmn
         09xzoAfwMtLDdr0Rci78k7UVTog9xuACMLR3a6hJZX8H11voh/dJeEiskMWy9Y8u5J+P
         oDoC+XK67xTa2nNhRP7UF9uKTGYhXLXuSQdFrHHrXSmqrR3ARcJM4ed+yVFw4gNrXN42
         IgJroMrSrONDKA31vXF4GpoRmT2dYjXFyHaHe0uRMKQ/v4DC3la7bT7PLr3RNEgvAN9S
         zoFtnNH9r66pY5r9wMRSEc8Ug2P6jyVpTO4eaTH46RXKUzO27yxUNoNQPBl87SZVGodz
         UERA==
X-Forwarded-Encrypted: i=1; AJvYcCVupIqXIoAzUuB32m8dlgAUTk/HKs0D01XcTK3TIrm0cKWR+Y8dRM+0DfZA8MUZ7Hhv6IaBjdplK/eUgtsCUKLBzJElP8bUnuymH3QLeQ0PPENlRJ0FL8cpojoCrdMPDthzqyXbL/6PcZnKJXyy/qEGJMMBj+dnPOCvHTeVySLY4+rF76ilCZRNvzf8tCfW5/jzA6zAAl0w75YgSRGkRsdTE6iqQKOenGlSSRWrOg3dikKCxVtCmnxlcH67fh/d
X-Gm-Message-State: AOJu0YzKqICN2WK6QD0yamBIntqYUvZVSLIv81ToLIP7BOCMnTl0ZAL6
	3YIrui6XvNf4E5ENq1RhuFSDi+ZHxi0NitG73NCRx6LuloEc6xST
X-Google-Smtp-Source: AGHT+IHH2tg/cZwys6nguaiuLttBdJz9HIEFZ+uxlzW8VtX1+VRUmvRpyYwrqwFLixwGrsBZ7zvQBA==
X-Received: by 2002:a05:6358:7e81:b0:179:272e:54c6 with SMTP id o1-20020a0563587e8100b00179272e54c6mr5299313rwn.25.1708872383543;
        Sun, 25 Feb 2024 06:46:23 -0800 (PST)
Received: from dw-tp ([171.76.80.106])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a0010c800b006e4762b5f3bsm2476163pfu.172.2024.02.25.06.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 06:46:22 -0800 (PST)
Date: Sun, 25 Feb 2024 20:16:15 +0530
Message-Id: <87cysk1u14.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 07/11] block: Add fops atomic write support
In-Reply-To: <20240219130109.341523-8-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

John Garry <john.g.garry@oracle.com> writes:

> Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.
>
> It must be ensured that the atomic write adheres to its rules, like
> naturally aligned offset, so call blkdev_dio_invalid() ->
> blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
> blkdev_dio_invalid()] for this purpose.
>
> In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
> produce a single BIO, so error in this case.

BIO_MAX_VECS is 256. So around 1MB limit with 4k pagesize. 
Any mention of why this limit for now? Is it due to code complexity that
we only support a single bio? 
As I see it, you have still enabled req merging in block layer for
atomic requests. So it can essentially submit bio chains to the device
driver? So why not support this case for user to submit a req. larger
than 1 MB? 

>
> Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
> and the associated file flag is for O_DIRECT.
>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  block/fops.c | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/block/fops.c b/block/fops.c
> index 28382b4d097a..563189c2fc5a 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -34,13 +34,27 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
>  	return opf;
>  }
>  
> -static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
> -			      struct iov_iter *iter)
> +static bool blkdev_atomic_write_valid(struct block_device *bdev, loff_t pos,
> +				      struct iov_iter *iter)
>  {
> +	struct request_queue *q = bdev_get_queue(bdev);
> +	unsigned int min_bytes = queue_atomic_write_unit_min_bytes(q);
> +	unsigned int max_bytes = queue_atomic_write_unit_max_bytes(q);
> +
> +	return atomic_write_valid(pos, iter, min_bytes, max_bytes);

generic_atomic_write_valid() would be better for this function. However,
I have any commented about this in some previous

> +}
> +
> +static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
> +				struct iov_iter *iter, bool atomic_write)

bool "is_atomic" or "is_atomic_write" perhaps? 
we anyway know that we only support atomic writes and RWF_ATOMIC
operation is made -EOPNOTSUPP for reads in kiocb_set_rw_flags().
So we may as well make it "is_atomic" for bools.

> +{
> +	if (atomic_write && !blkdev_atomic_write_valid(bdev, pos, iter))
> +		return true;
> +
>  	return pos & (bdev_logical_block_size(bdev) - 1) ||
>  		!bdev_iter_is_aligned(bdev, iter);
>  }
>  
> +
>  #define DIO_INLINE_BIO_VECS 4
>  
>  static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
> @@ -71,6 +85,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>  	}
>  	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
>  	bio.bi_ioprio = iocb->ki_ioprio;
> +	if (iocb->ki_flags & IOCB_ATOMIC)
> +		bio.bi_opf |= REQ_ATOMIC;
>  
>  	ret = bio_iov_iter_get_pages(&bio, iter);
>  	if (unlikely(ret))
> @@ -341,6 +357,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>  		task_io_account_write(bio->bi_iter.bi_size);
>  	}
>  
> +	if (iocb->ki_flags & IOCB_ATOMIC)
> +		bio->bi_opf |= REQ_ATOMIC;
> +
>  	if (iocb->ki_flags & IOCB_NOWAIT)
>  		bio->bi_opf |= REQ_NOWAIT;
>  
> @@ -357,13 +376,14 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>  static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  {
>  	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
> +	bool atomic_write = iocb->ki_flags & IOCB_ATOMIC;

ditto, bool is_atomic perhaps?

>  	loff_t pos = iocb->ki_pos;
>  	unsigned int nr_pages;
>  
>  	if (!iov_iter_count(iter))
>  		return 0;
>  
> -	if (blkdev_dio_unaligned(bdev, pos, iter))
> +	if (blkdev_dio_invalid(bdev, pos, iter, atomic_write))
>  		return -EINVAL;
>  
>  	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
> @@ -371,6 +391,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  		if (is_sync_kiocb(iocb))
>  			return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
>  		return __blkdev_direct_IO_async(iocb, iter, nr_pages);
> +	} else if (atomic_write) {
> +		return -EINVAL;
>  	}
>  	return __blkdev_direct_IO(iocb, iter, bio_max_segs(nr_pages));
>  }
> @@ -616,6 +638,9 @@ static int blkdev_open(struct inode *inode, struct file *filp)
>  	if (bdev_nowait(handle->bdev))
>  		filp->f_mode |= FMODE_NOWAIT;
>  
> +	if (bdev_can_atomic_write(handle->bdev) && filp->f_flags & O_DIRECT)
> +		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
> +
>  	filp->f_mapping = handle->bdev->bd_inode->i_mapping;
>  	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
>  	filp->private_data = handle;
> -- 
> 2.31.1

