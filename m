Return-Path: <io-uring+bounces-1649-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6F18B3B44
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 17:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9597B1F217D3
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 15:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09C714D6FA;
	Fri, 26 Apr 2024 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIep1t4u"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887F814D6E5;
	Fri, 26 Apr 2024 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714144904; cv=none; b=EIj3ly3DmEgtlDQSQJRuoqGp0AnODktWZYWys+Pia36UquNoAXLV5Y3vTkxsUCZ4iKKHyGCCsn3Kj9UxBVmSYjzFwk8ZXU0Luv1ganFURTxXd/3LuZPm5uehMlpBSAlchrGkzF57d3BdYZ9TihIN9xakcOQgZoush+PYUrCn26c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714144904; c=relaxed/simple;
	bh=xPK28Iox1vdryqRd/xtRp+PiKJObrHW3XTZr3b861Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbyUZ3c2VCFafuPpEc4BmM9RIzevxG3LBJPNJSsqO7bKEOypRik6rNcDidBourr2gUeIXhAf+9GjV/f3yhXnfBz7BlXiELda6KLjKJ4nq5iFy3iLcaEys+LG99izSzKdEzfpDi3XBxW0hMy/K+42cpDVDvAKVsNcoXkheWIwVyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIep1t4u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E2DC113CD;
	Fri, 26 Apr 2024 15:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714144904;
	bh=xPK28Iox1vdryqRd/xtRp+PiKJObrHW3XTZr3b861Yc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WIep1t4uVRkLM3U/+qJKwPwYMz6vBbHFexic/usbb6GBGMhrkyhUJgI64pY5KQdp4
	 Wl23tcLgMMBYY6dW4FXrNEdwYpjAdfxmAbbhE3ARedOiEjTT9LGyL4ZBOeBmOmX7is
	 gtKhr27omT1mnCXobOrXiHLRNo5Skg6FhofdvbngpC2NciWYBhnJJZQwQcmOYUyubk
	 lh8yPc8ffDTgZSFkPzmz2CiMnvNxng9ZbY/FrO+HC5xPE7sJBIFjIRenB8/i70zZQd
	 H4M1SGdWuNqUH1loHQpKIru4p2yt8F7V2Le21FC/7XhfK+HnclLpxnmHxIsMb+C1va
	 W1VAOLo96APyw==
Date: Fri, 26 Apr 2024 09:21:40 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, hch@lst.de,
	brauner@kernel.org, asml.silence@gmail.com, dw@davidwei.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 09/10] block: add support to send meta buffer
Message-ID: <ZivGhB0rGwBb8Eic@kbusch-mbp.dhcp.thefacebook.com>
References: <20240425183943.6319-1-joshi.k@samsung.com>
 <CGME20240425184708epcas5p4f1d95cd8d285614f712868d205a23115@epcas5p4.samsung.com>
 <20240425183943.6319-10-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425183943.6319-10-joshi.k@samsung.com>

On Fri, Apr 26, 2024 at 12:09:42AM +0530, Kanchan Joshi wrote:
> diff --git a/block/fops.c b/block/fops.c
> index 679d9b752fe8..e488fa66dd60 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -353,6 +353,15 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>  		task_io_account_write(bio->bi_iter.bi_size);
>  	}
>  
> +	if (unlikely(iocb->ki_flags & IOCB_USE_META)) {
> +		ret = bio_integrity_map_iter(bio, iocb->private);
> +		WRITE_ONCE(iocb->private, NULL);
> +		if (unlikely(ret)) {
> +			bio_put(bio);
> +			return ret;
> +		}
> +	}

Should this also be done for __blkdev_direct_IO and
__blkdev_direct_IO_simple?

