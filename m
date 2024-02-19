Return-Path: <io-uring+bounces-637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2672985AB9E
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 19:57:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF1061F22560
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 18:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FD5446A2;
	Mon, 19 Feb 2024 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VYGRxYfH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA3834545;
	Mon, 19 Feb 2024 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708369049; cv=none; b=F2RVb0otCh515nReQFVRrQlgY1Z0y57CXXF6ZJr8ymE27m4JOwqJQBXfs9C0efR/oorEswpJuOqblS/CNAZ1QdMwC4J4KWfoRY4usPhaG7VyBRf8LYFtiuLRMXF5v2qxFBVf8954tTj0tpSWNGFAygxp6NxBcix2dojlngwJPI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708369049; c=relaxed/simple;
	bh=hlzNv0HneAFcj8iXq6Qfn9/TqgvN+CXJ8vpN0bhvzuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nI307I8DUhRdk9swHm2JS3NQCntB+m3Un7NZCW8D/e0hZbxS4pPGvTDFoEYNd8rxvZZgpV7WyXAF1UtNxpkqx7J5ONmGEDBHbjGNHQJFjn5gL7vD+G0/s2X7lZjCmTUZjfoinZlEoN1Ftc+LwAp164ee+nnOHzItJ0auH43KrzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VYGRxYfH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D1EC433C7;
	Mon, 19 Feb 2024 18:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708369049;
	bh=hlzNv0HneAFcj8iXq6Qfn9/TqgvN+CXJ8vpN0bhvzuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VYGRxYfHz+G5gsqE/kZ4an8+k6ihso+suEPttoEPqHlHRsbjJ/rGY14ni7lhoobG7
	 x+RoZnTABT4BQwrVYlT9CDUxYlvONcW+6VGDuq6Rr76NAUgnuMMosQhFmbVcChmM3L
	 phR4ndzdjB31okSWC7FD7Qd/49kwDaGyasfOFFjkVslnlcmLOFy3HlMtn6gGJMtkmL
	 h4z5S2vA+7TQDbiY7i3IQZAYMeFkhAdA8aGt6RGmGurZtO7kovYuEKhtXLuNt8XWYV
	 w+Ocv832w1rwRR6AMOuIPW9Dz71gwFlL+G9dCYWCrYOGLqbkUqj//z7JztyDntVXE6
	 vQ70wA0mNgV2Q==
Date: Mon, 19 Feb 2024 11:57:25 -0700
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v4 02/11] block: Call blkdev_dio_unaligned() from
 blkdev_direct_IO()
Message-ID: <ZdOklTSG9tHuYtGi@kbusch-mbp>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219130109.341523-3-john.g.garry@oracle.com>

On Mon, Feb 19, 2024 at 01:01:00PM +0000, John Garry wrote:
> @@ -53,9 +53,6 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>  	struct bio bio;
>  	ssize_t ret;
>  
> -	if (blkdev_dio_unaligned(bdev, pos, iter))
> -		return -EINVAL;
> -
>  	if (nr_pages <= DIO_INLINE_BIO_VECS)
>  		vecs = inline_vecs;
>  	else {
> @@ -171,9 +168,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
>  	loff_t pos = iocb->ki_pos;
>  	int ret = 0;
>  
> -	if (blkdev_dio_unaligned(bdev, pos, iter))
> -		return -EINVAL;
> -
>  	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
>  		opf |= REQ_ALLOC_CACHE;
>  	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
> @@ -310,9 +304,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>  	loff_t pos = iocb->ki_pos;
>  	int ret = 0;
>  
> -	if (blkdev_dio_unaligned(bdev, pos, iter))
> -		return -EINVAL;
> -
>  	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
>  		opf |= REQ_ALLOC_CACHE;
>  	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
> @@ -365,11 +356,16 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>  
>  static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  {
> +	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
> +	loff_t pos = iocb->ki_pos;
>  	unsigned int nr_pages;

All three of the changed functions also want 'bdev' and 'pos', so maybe
pass on the savings to them? Unless you think the extended argument list
would harm readibilty, or perhaps the compiler optimizes the 2nd access
out anyway. Either way, this looks good to me.

Reviewed-by: Keith Busch <kbusch@kernel.org>

