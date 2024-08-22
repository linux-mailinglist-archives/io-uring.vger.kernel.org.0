Return-Path: <io-uring+bounces-2890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E692395ADE2
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 08:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2329281499
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 06:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154E94963A;
	Thu, 22 Aug 2024 06:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e++10MiQ"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C5A8BF3;
	Thu, 22 Aug 2024 06:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724309208; cv=none; b=PGHKsA2Xoy4WBfXPtKGsbjD2eXTQG/oRlJxJizHTNS3o+EUjOP4ZTEtrp6pfk50MiwX59W32dBj8C6+bK4tf77ccBePz2JdJzr/BmktMmGp1OudLRJxutIfCZ9/twXrtci5laq2atIl/i+JIwZX3AfEkTyXjYL6Gokyz5yg3AwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724309208; c=relaxed/simple;
	bh=wiDlROL8KUxhBRnjDp2AjQs5YfJNh+2gYXtrvxaVUD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJnEU866JvAmje50jI0AqBvVMOdZUoCe/Qtw49AW7O0m/r5arwbEK1MMx/JdwNGFH3Ynyq90oekvXXUmQCMFjzGrxjBXtJ9woKZ4ugu7aiZT/WcHYQhx1pLVoGt0E4lVtfOwiSfCvCj0zjJMMl3DyQQ1qvzmVXeTxAwk/aNokmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e++10MiQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lYAyybBx9ag/sgO6l6j7CoDzfNN3dtp7xr87Twy9vgo=; b=e++10MiQQU8L/mwLY9/zR05cAI
	rj5vgR16euUPRPLFT4nDyaZPb2tKnxn6f7cJGJIVurOsGc/YNGZ7juDf5fcYgjOZy+ZsV8cUi39nY
	wQZraOTm5gchN84agQlBTP9NgsGVhgTY9cy0BK0oohTjzlesbcJSYAktvieQk7FbLzoY2mt27vSe2
	n074yDSXLJC0WknqjmCayiZhbGbudZis9DaOb5dMdXtxjEBWBi18eyDZ3c240Zp1cwczZty2ZCa+W
	ZbmyYp7tziRx2baAzFAfA7hcBXnizyqTzUFubp2wW85s1bBfUYxz+jRXbqAWiDzoM0btw5bammL8d
	Fcv2+ZWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh1ao-0000000Bg00-0efc;
	Thu, 22 Aug 2024 06:46:46 +0000
Date: Wed, 21 Aug 2024 23:46:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 5/7] block: implement async discard as io_uring cmd
Message-ID: <Zsbe1mIYMd9uf8cq@infradead.org>
References: <cover.1724297388.git.asml.silence@gmail.com>
 <e39a9aabe503bbd7f2b7454327d3e6a6620deccf.1724297388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e39a9aabe503bbd7f2b7454327d3e6a6620deccf.1724297388.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 04:35:55AM +0100, Pavel Begunkov wrote:
> io_uring allows to implement custom file specific operations via
> fops->uring_cmd callback. Use it to wire up asynchronous discard
> commands. Normally, first it tries to do a non-blocking issue, and if
> fails we'd retry from a blocking context by returning -EAGAIN to
> core io_uring.
> 
> Note, unlike ioctl(BLKDISCARD) with stronger guarantees against races,
> we only do a best effort attempt to invalidate page cache, and it can
> race with any writes and reads and leave page cache stale. It's the
> same kind of races we allow to direct writes.

Can you please write up a man page for this that clear documents the
expecvted semantics?

> +static void bio_cmd_end(struct bio *bio)

This is really weird function name.  blk_cmd_end_io or
blk_cmd_bio_end_io would be the usual choices.

> +	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
> +					    GFP_KERNEL))) {

GFP_KERNEL can often will block.  You'll probably want a GFP_NOWAIT
allocation here for the nowait case.

> +		if (nowait) {
> +			/*
> +			 * Don't allow multi-bio non-blocking submissions as
> +			 * subsequent bios may fail but we won't get direct
> +			 * feedback about that. Normally, the caller should
> +			 * retry from a blocking context.
> +			 */
> +			if (unlikely(nr_sects)) {
> +				bio_put(bio);
> +				return -EAGAIN;
> +			}
> +			bio->bi_opf |= REQ_NOWAIT;
> +		}

And this really looks weird.  It first allocates a bio, potentially
blocking, and then gives up?  I think you're much better off with
something like:

	if (nowait) {
		if (nr_sects > bio_discard_limit(bdev, sector))
			return -EAGAIN;
		bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
						    GFP_NOWAIT);
		if (!bio)
			return -EAGAIN
		bio->bi_opf |= REQ_NOWAIT;
		goto submit;
	}

	/* submission loop here */

> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 753971770733..0016e38ed33c 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -208,6 +208,8 @@ struct fsxattr {
>   * (see uapi/linux/blkzoned.h)
>   */
>  
> +#define BLOCK_URING_CMD_DISCARD			0

Is fs.h the reight place for this?

Curious:  how to we deal with conflicting uring cmds on different
device and how do we probe for them?  The NVMe uring_cmds
use the ioctl-style _IO* encoding which at least helps a bit with
that and which seem like a good idea.  Maybe someone needs to write
up a few lose rules on uring commands?


