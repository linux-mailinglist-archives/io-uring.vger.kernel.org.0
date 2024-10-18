Return-Path: <io-uring+bounces-3802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 085C69A348A
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 07:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A171A1F22EE7
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 05:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541891547C3;
	Fri, 18 Oct 2024 05:50:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F1F17332B;
	Fri, 18 Oct 2024 05:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729230639; cv=none; b=FsewoomZmdZE5q7zp4eOFjZlrsLV8WVnJ+L/qe9m/9Fa6Ialy6PRT3y8QTRUUB08zVT682dMAjBAeS50zB25EcKV5jzLyBH4sfcz+jviXL0rmrOvpwxbu8fFMLFKgoL7di/yUr8j7usC4Vz/M1JutICrrhmjNWjthBJYgEGgrFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729230639; c=relaxed/simple;
	bh=I+x3WdY21fpgtwTWvWt1043faKH4xvIpryhm2qjgQIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pxwwythNQGEpMuUK2X4puP+U4AmDinDvt4H8lrRPF+hOjJ0eO0C4chFA5S4uYHUgvT8D0qaKoWh00ziZoVq36YcyPpMTOyZW4nHMbUQwrW4QWhNtKMIcpQOWJf0G5k9BjyJsgEiLOQZCGS10cfC2xSm0BUTjgqICkIkiD/UK+ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 19F25227AAF; Fri, 18 Oct 2024 07:50:33 +0200 (CEST)
Date: Fri, 18 Oct 2024 07:50:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
	Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 1/6] block, fs: restore kiocb based write hint
 processing
Message-ID: <20241018055032.GB20262@lst.de>
References: <20241017160937.2283225-1-kbusch@meta.com> <20241017160937.2283225-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017160937.2283225-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 09:09:32AM -0700, Keith Busch wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> struct kiocb has a 2 bytes hole that developed post commit 41d36a9f3e53
> ("fs: remove kiocb.ki_hint"). But write hint returned with commit
> 449813515d3e ("block, fs: Restore the per-bio/request data lifetime
> fields").
> 
> This patch uses the leftover space in kiocb to carve 2 byte field
> ki_write_hint. Restore the code that operates on kiocb to use
> ki_write_hint instead of inode hint value.
> 
> This does not change any behavior, but needed to enable per-io hints.

In this version it doesn't really restore anything, but adds a new
write hinting capability.   Similarly to the bio patch we'll probably
need to make clear what is in there instead of having it completely
untyped (the exact same appraoch as for the bio should work).

> index bbd05f1a21453..73629e26becbe 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -409,7 +409,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
>  		bio->bi_end_io = dio_bio_end_io;
>  	if (dio->is_pinned)
>  		bio_set_flag(bio, BIO_PAGE_PINNED);
> -	bio->bi_write_hint = file_inode(dio->iocb->ki_filp)->i_write_hint;
> +	bio->bi_write_hint = dio->iocb->ki_write_hint;
>  
>  	sdio->bio = bio;
>  	sdio->logical_offset_in_bio = sdio->cur_page_fs_offset;
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index f637aa0706a31..fff43f121ee65 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -397,7 +397,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
>  					  GFP_KERNEL);
>  		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
> -		bio->bi_write_hint = inode->i_write_hint;
> +		bio->bi_write_hint = dio->iocb->ki_write_hint;

File system (helper) code should not directly apply this limit,
but the file system needs to set it.

> +static inline enum rw_hint file_write_hint(struct file *filp)
> +{
> +	return file_inode(filp)->i_write_hint;
> +}
> +
>  static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
>  {
>  	*kiocb = (struct kiocb) {
>  		.ki_filp = filp,
>  		.ki_flags = filp->f_iocb_flags,
>  		.ki_ioprio = get_current_ioprio(),
> +		.ki_write_hint = file_write_hint(filp),

And we'll need to distinguish between the per-inode and per file
hint.  I.e. don't blindly initialize ki_write_hint to the per-inode
one here, but make that conditional in the file operation.


