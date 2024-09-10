Return-Path: <io-uring+bounces-3099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84228972B63
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 10:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 471B62857E7
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 08:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25FF184555;
	Tue, 10 Sep 2024 08:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KmTzOBH8"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB9E18CC1E;
	Tue, 10 Sep 2024 08:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955269; cv=none; b=ZAVxAPfH169UbMqKP8jz7YRuTt8x4g4cJT2ehSIFsNbq5WOljXrbNUOabrtwbNJ7V/sRgM7fvx1yWg6kU4HnqEN1T3U4qE7ysEzYuMiff2qHoipY3QORab19ihCAoTU+LoerA0IfvohfrTGZFsDcKkiCsrNan3cNVqysvWqFYr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955269; c=relaxed/simple;
	bh=ZaC7aJqocASs7+bvk9YVYP7ZpEjbPiTAlY/qqqOZR7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IaLC8mJ7iAyCRp7UiKQFMvr6Sll+PgPOzAZ6KnA3xoT1M9L0CVZxkuHxLuoExbuJkjlnS7y0Lrbz2C9JEYELOWWBVDRp84+kE9yaRqTbVV//xY9Bd6g8emndYfnBgA7UxmjVes6EvYveVZLE0HZRMGs1np9JezAHw0/cUGXw464=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KmTzOBH8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bLKw5eqf3LrbTi1/fAvMlpTbb6TDAZkRKzCr/OXELyE=; b=KmTzOBH8cddFcrOxrOTMkf4E2t
	NqjHwyh5EDI/Lc+jE/M7YuzOId4o6zqvUL+FQyomixp0qx5MxgMIZ3S19ilmwfR3QJDC16VME3+g9
	I5krs5E0sXYCj+saU6ECveIh8cUe8BL71p3mgwYX1It7bHtTjHayNt9UrXJf13XK2ObSZ6BrD4BwM
	W4if8DpazDcgP4JKJkppl7OF/dmFqySRCjwu3Q+ZgFrhMhFXuQdDJh04l/wCHkRDLuPM7IlkW+J/6
	OLsR0QBAYKLncWxFViYiMqD8xECFyXAHRQJjn5OOQdW1GmsHAis6EVfIJEeQC4sMn8QqWRu+lSzy1
	8HLLQL5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snvoA-00000004hyy-2zMc;
	Tue, 10 Sep 2024 08:01:06 +0000
Date: Tue, 10 Sep 2024 01:01:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 5/8] block: implement async discard as io_uring cmd
Message-ID: <Zt_8wlXTyS2E7Xbe@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
 <7fc0a61ae29190a42e958eddfefd6d44cdf372ad.1725621577.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fc0a61ae29190a42e958eddfefd6d44cdf372ad.1725621577.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	sector_t sector = start >> SECTOR_SHIFT;
> +	sector_t nr_sects = len >> SECTOR_SHIFT;
> +	struct bio *prev = NULL, *bio;
> +	int err;
> +
> +	if (!bdev_max_discard_sectors(bdev))
> +		return -EOPNOTSUPP;
> +
> +	if (!(file_to_blk_mode(cmd->file) & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +	err = blk_validate_byte_range(bdev, start, len);
> +	if (err)
> +		return err;

Based on the above this function is misnamed, as it validates sector_t
range and not a byte range.

> +	if (nowait && nr_sects > bio_discard_limit(bdev, sector))
> +		return -EAGAIN;
> +
> +	err = filemap_invalidate_pages(bdev->bd_mapping, start,
> +					start + len - 1, nowait);
> +	if (err)
> +		return err;
> +
> +	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp))) {
> +		if (nowait)
> +			bio->bi_opf |= REQ_NOWAIT;
> +		prev = bio_chain_and_submit(prev, bio);
> +	}
> +	if (!prev)
> +		return -EAGAIN;

If a user changes the max_discard value between the check above and
the loop here this is racy.

> +sector_t bio_discard_limit(struct block_device *bdev, sector_t sector);

And to be honest, I'd really prefer to not have bio_discard_limit
exposed.  Certainly not outside a header private to block/.

> +
>  #endif /* __LINUX_BIO_H */
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 753971770733..7ea41ca97158 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -208,6 +208,8 @@ struct fsxattr {
>   * (see uapi/linux/blkzoned.h)
>   */
>  
> +#define BLOCK_URING_CMD_DISCARD			_IO(0x12,137)

Whitespace after the comma please.  Also why start at 137?  A comment
would generally be pretty useful as well.

Also can we have a include/uapi/linux/blkdev.h for this instead of
bloating fs.h that gets included just about everywhere?


