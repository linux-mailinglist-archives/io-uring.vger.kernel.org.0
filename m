Return-Path: <io-uring+bounces-3763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0F59A1CB4
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 10:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CD0F1C27250
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 08:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78FB71D2200;
	Thu, 17 Oct 2024 08:11:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B633C1D0F62;
	Thu, 17 Oct 2024 08:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729152670; cv=none; b=GGN30FzqQo11qmOQ/l6MPOxXlR6XkFiBANq+CDoxogEEA+6hP0waG+e+FlyIR/LFevM7/uVF3CVVxGmC2z3UxgQRJqCLT/xyWyQ4ac3mFcz0UszCSOm/+6cFGET4zpRkNd6/UmLOkbExcv2SEOJeKD3gdF3D1cC2fhs3IorvJTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729152670; c=relaxed/simple;
	bh=9Z5ccorxULOSFbGAOqPe73zoNufx9ZLmuCh22bs7ZdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlQSbX9tJFHJ5DQP12PB278HLX+u/zQIcioYzIp9Sraq5hD2Dv3aZ19T+d6i7Ym96/r9Z+/jiL492gegBbLxRgrarZw+felQ8+jUegUgsSz+iaLCzA2XygonXW/42/oxWFP8mxag4UBpR+X4gont4fEw4/p7jXP2AsTWPf+Cnew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 28397227A87; Thu, 17 Oct 2024 10:10:58 +0200 (CEST)
Date: Thu, 17 Oct 2024 10:10:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 07/11] io_uring/rw: add support to send meta along
 with read/write
Message-ID: <20241017081057.GA27241@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4@epcas5p4.samsung.com> <20241016112912.63542-8-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-8-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

s/meta/metadata/ in the subject.

> +	const struct io_uring_meta *md = (struct io_uring_meta *)sqe->big_sqe_cmd;

Overly long line.

> +	if (!meta_type)
> +		return 0;
> +	if (!(meta_type & META_TYPE_INTEGRITY))
> +		return -EINVAL;

What is the meta_type for?  To distintinguish PI from non-PI metadata?
Why doesn't this support non-PI metadata?  Also PI or TO_PI might be
a better name than the rather generic integrity.  (but I'll defer to
Martin if he has any good arguments for naming here).

>  static bool need_complete_io(struct io_kiocb *req)
>  {
> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> +
> +	/* Exclude meta IO as we don't support partial completion for that */
>  	return req->flags & REQ_F_ISREG ||
> -		S_ISBLK(file_inode(req->file)->i_mode);
> +		S_ISBLK(file_inode(req->file)->i_mode) ||
> +		!(rw->kiocb.ki_flags & IOCB_HAS_METADATA);
>  }

What partial ocmpletions aren't supported?  Note that this would
trigger easily as right now metadata is only added for block devices
anyway.

> +	if (unlikely(kiocb->ki_flags & IOCB_HAS_METADATA)) {

For a workload using metadata this is everything but unlikely.  Is
there a specific reason you're trying to override the existing
branch predictor here (although on at least x86_64 gcc these kinds
of unlikely calls tend to be no-ops anyway).

> +		struct io_async_rw *io = req->async_data;
> +
> +		if (!(req->file->f_flags & O_DIRECT))
> +			return -EOPNOTSUPP;

I guess you are forcing this here rather in the file oerations instance
because the union of the field in struct io_async_rw.  Please add comment
about that.

> +	/* wpq is for buffered io, while meta fields are used with direct io*/

missing whitespace before the closing of the comment.

