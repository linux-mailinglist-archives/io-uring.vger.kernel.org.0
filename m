Return-Path: <io-uring+bounces-1276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C0D88F74F
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 06:35:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8E571C2412F
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 05:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D6440862;
	Thu, 28 Mar 2024 05:35:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A558485;
	Thu, 28 Mar 2024 05:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711604143; cv=none; b=vGXJuvsKnbvNwr07J8XK02VObc2KTa8CNk+boM+hC3nZUPIJbVKTxcmFUiA6HoDtwP0yjyGxDvKyC/W5E+EAYXfakiC+prC98FcGGKE2K2KproNBplSCjKF9p1ebUpy8ImkrLnl3seujZFbVwrUsJvaRzFAZMrTXJXkBixwMZBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711604143; c=relaxed/simple;
	bh=moB5DrOjmWx3r17RcxCTM9zF1NX/XnFiRO8wLD+oZMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCU2yIq2G5Y0MUezNVpwlTn9+5fp3Tw35ulXlidth5TskUv6lJ/fdxsTRx/WLuU2tcqp3OWjKRLezmUWLnPL12svw1wogw2Xn1a9/Y2Nu5reAZl3LXVgUOMcVbMhX0IN4WBa+rpUW7OtQw21x6dLNvvX2g8V9sqiBczLg+HQyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 665A168D17; Thu, 28 Mar 2024 06:35:35 +0100 (CET)
Date: Thu, 28 Mar 2024 06:35:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <20240328053533.GA15831@lst.de>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 27, 2024 at 05:45:09PM +0100, Christian Brauner wrote:
> There's a bunch of flags that are purely based on what the file
> operations support while also never being conditionally set or unset.
> IOW, they're not subject to change for individual file opens. Imho, such
> flags don't need to live in f_mode they might as well live in the fops
> structs itself.

Yes.  I actually have a half-finished patch doing the same lying around,
which I've not found time to rabse.

> (Fwiw, FMODE_NOACCOUNT and FMODE_BACKING could live in fops_flags as
>  well because they're also completely static but they aren't really
>  about file operations so they're better suited for FMODE_* imho.)

I'd still move them there.  I've also simply called fops_flags flags
so maybe it didn't bother me too much :)

> +/* File ops support async buffered reads */
> +#define FOP_BUF_RASYNC		BIT(0)
> +/* File ops support async nowait buffered writes */
> +#define FOP_BUF_WASYNC		BIT(1)

Can we spell out BUFFERED here when changing things?  BUF always confuses
me as it let's me thing of the buffer cache.

And can be please avoid this silly BIT() junk?  1u << N is shorter
and a lot more obvious than this random macro.

> +#define FOP_MMAP_SYNC		BIT(2)

Please throw in a comment for this one while you're at it.

> +/* File ops support non-exclusive O_DIRECT writes from multiple threads */
> +#define FOP_DIO_PARALLEL_WRITE	BIT(3)
> +
> +#define __fops_supported(f_op, flag) ((f_op)->fops_flags & (flag))
> +#define fops_buf_rasync(file) __fops_supported((file)->f_op, FOP_BUF_RASYNC)
> +#define fops_buf_wasync(file) __fops_supported((file)->f_op, FOP_BUF_WASYNC)
> +#define fops_mmap_sync(file) __fops_supported((file)->f_op, FOP_MMAP_SYNC)
> +#define fops_dio_parallel_write(file) __fops_supported((file)->f_op, FOP_DIO_PARALLEL_WRITE)

And please drop these helpers.  They just make grepping for the flags
a complete pain.


