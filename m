Return-Path: <io-uring+bounces-9053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E32B2BCCC
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 11:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 009073A7E46
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 09:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E5D31A05B;
	Tue, 19 Aug 2025 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1CUo8fw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC16931A055;
	Tue, 19 Aug 2025 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594886; cv=none; b=dTVLCQJKzQLNPgQxGQY0Lesx4rKB/RHErfLxrXe9dmdu7+iNDt9EJwBl9IKZqzQ3W+7IRsVRlX2vrKNATykhZHM6lBuhWOvKOu+OOS3idrs5qorP1st4pQYDvkiDXL5ZWYF0QqwWDv4+GQQF6Gi9owVtCOqnRsPhi/ms127z3YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594886; c=relaxed/simple;
	bh=U96y3c9GsAsao2IeDLEh5rMxv6kdYoSjqBQs11MTxDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3X4o99+bhDfv/p87MTGum7Kk9GiDIHPN0ysDBodJR+BYiYk+9flAqvz0Sw7tkOty1N6e/sjU0TwrUXMz39/fgCt5kMF5Tqys9VIlz9vz2gLqUWJMUjmsHixsg71jODYMP0b5HkU6HJ6ORyvRr9WNrmty8GOZjS+y6Pvq2V3IEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1CUo8fw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8A0C4CEF1;
	Tue, 19 Aug 2025 09:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755594886;
	bh=U96y3c9GsAsao2IeDLEh5rMxv6kdYoSjqBQs11MTxDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W1CUo8fwgaozCqrrbMEEBa+OhPNz9S3zsDzWV7hwOnhF/3wi6itHUNRhctOCotwkz
	 8fk2KhUtC7dHpJ3Kya8WPa5Y3X3pqswa6r5Tef4bIYfosJzmh/APCzvJR6eUjFDlBe
	 Io7W25ThKC2vaLyQVcM5QiI5yVHJ0bPGdQoXxC7WAlT+Ef+Ej8UVHQPjVzP8g18o0D
	 OweE8sfxtCW3iT8skoZi8PDW2MBbGOHIuf16c8ywIOA3Lt44y/jOEqbXUsZ2c0BKL2
	 PqFJ8yje2Rm0SVwPRGdsL+rIlq4P3eng0fG3ipz+7OWKxCNimX6Fd17aADzif9Qo25
	 hGpXJm9DueS1A==
Date: Tue, 19 Aug 2025 11:14:41 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add a FMODE_ flag to indicate IOCB_HAS_METADATA
 availability
Message-ID: <20250819-erwirbt-freischaffend-e3d3c1e8967a@brauner>
References: <20250819082517.2038819-1-hch@lst.de>
 <20250819082517.2038819-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250819082517.2038819-2-hch@lst.de>

On Tue, Aug 19, 2025 at 10:25:00AM +0200, Christoph Hellwig wrote:
> Currently the kernel will happily route io_uring requests with metadata
> to file operations that don't support it.  Add a FMODE_ flag to guard
> that.
> 
> Fixes: 4de2ce04c862 ("fs: introduce IOCB_HAS_METADATA for metadata")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

It kind of feels like that f_iocb_flags should be changed so that
subsystems like block can just raise some internal flags directly
instead of grabbing a f_mode flag everytime they need to make some
IOCB_* flag conditional on the file. That would mean changing the
unconditional assigment to file->f_iocb_flags to a |= to not mask flags
raised by the kernel itself.

Then you can just push the burden of stuff like IOCB_HAS_* vs
IOCB_SUPPORTS/CAN_* to f_iocb_flags instead of the FMODE_* space.

>  block/fops.c       | 3 +++
>  include/linux/fs.h | 3 ++-
>  io_uring/rw.c      | 3 +++
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 82451ac8ff25..08e7c21bd9f1 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -7,6 +7,7 @@
>  #include <linux/init.h>
>  #include <linux/mm.h>
>  #include <linux/blkdev.h>
> +#include <linux/blk-integrity.h>
>  #include <linux/buffer_head.h>
>  #include <linux/mpage.h>
>  #include <linux/uio.h>
> @@ -687,6 +688,8 @@ static int blkdev_open(struct inode *inode, struct file *filp)
>  
>  	if (bdev_can_atomic_write(bdev))
>  		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
> +	if (blk_get_integrity(bdev->bd_disk))
> +		filp->f_mode |= FMODE_HAS_METADATA;
>  
>  	ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
>  	if (ret)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d7ab4f96d705..601d036a6c78 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -149,7 +149,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  /* Expect random access pattern */
>  #define FMODE_RANDOM		((__force fmode_t)(1 << 12))
>  
> -/* FMODE_* bit 13 */
> +/* Supports IOCB_HAS_METADATA */
> +#define FMODE_HAS_METADATA	((__force fmode_t)(1 << 13))
>  
>  /* File is opened with O_PATH; almost nothing can be done with it */
>  #define FMODE_PATH		((__force fmode_t)(1 << 14))
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 52a5b950b2e5..af5a54b5db12 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -886,6 +886,9 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
>  	if (req->flags & REQ_F_HAS_METADATA) {
>  		struct io_async_rw *io = req->async_data;
>  
> +		if (!(file->f_mode & FMODE_HAS_METADATA))
> +			return -EINVAL;
> +
>  		/*
>  		 * We have a union of meta fields with wpq used for buffered-io
>  		 * in io_async_rw, so fail it here.
> -- 
> 2.47.2
> 

