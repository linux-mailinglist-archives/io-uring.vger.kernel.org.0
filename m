Return-Path: <io-uring+bounces-6769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C459AA4526B
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 02:53:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8200170F5E
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 01:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9779417B506;
	Wed, 26 Feb 2025 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfLN6SX1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68723EBE;
	Wed, 26 Feb 2025 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740534815; cv=none; b=YyfJa2urJkoFUiUlO5YgZmvtHtxiNxxdjO/621W5hmfqCtjMNcvAtaYcR5bIPwRW/IfKom9ZRr+4kmTpjww0SL4zcBU0P/iPtS6dtHFEnqVygIKXHPrhS7gGvz4nLv4ivWV1vDkovqn5cr1D4twzcUK2w1p37x5zwKse4onvV6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740534815; c=relaxed/simple;
	bh=+elC5n9UxXmY/+kaH9dHoOOaj/CKZ/DiW/WDKX925ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ad+R3fS5Mtxu6EyJWCAovUBbL0kReiKhXmSBKZwVLJBdOI5rFvspv3cwcJAxgfxbHFZ2RYvh+TEBeLYjNrjoetDw6sdX2zGFWwGyC30x8ZmlhPii/c76JTWaSwIM96Fr0DYWE43cxGqcGMDLkxewg5ryTeszQG/jM3XsmKIZCr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfLN6SX1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D542EC4CEDD;
	Wed, 26 Feb 2025 01:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740534814;
	bh=+elC5n9UxXmY/+kaH9dHoOOaj/CKZ/DiW/WDKX925ik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dfLN6SX1aOao00bo86A0SdA7cWCvObHxJ9mBeVNjOC1X8+gj+SljqRNMlxWhSdtzV
	 lyOJr4ErnCA0HVv2qgjoGbxMzFvO36+NRXeZ5l6CbFdUCnOTp6cZCXqfcGW0r+B672
	 tB1fnHIZjJrxz50c9BqbFkfKNIUXnN2qFKZoUgAp+Tv5OM3woiIbT8pdj3ox7YRPOI
	 maPbUFZ6/XOstGrUBR007HP7Pa4GMoGQXasBhfJ1JlUSxWk0V+SLHEQwtNgrDzp8ru
	 uSxCw2l1mHvYmUbVeUispvsmZhmkNwEmTjTztJIPat4E2XTMffYeVhNRlcpYHZHXAn
	 TAni0dBYFZ3SA==
Date: Tue, 25 Feb 2025 17:53:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH 1/1] iomap: propagate nowait to block layer
Message-ID: <20250226015334.GF6265@frogsfrogsfrogs>
References: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>

On Wed, Feb 26, 2025 at 01:33:58AM +0000, Pavel Begunkov wrote:
> There are reports of high io_uring submission latency for ext4 and xfs,
> which is due to iomap not propagating nowait flag to the block layer
> resulting in waiting for IO during tag allocation.
> 
> Cc: stable@vger.kernel.org
> Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
> Reported-by: wu lei <uwydoc@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/iomap/direct-io.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index b521eb15759e..25c5e87dbd94 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -81,6 +81,9 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
>  		WRITE_ONCE(iocb->private, bio);
>  	}
>  
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		bio->bi_opf |= REQ_NOWAIT;

Shouldn't this go in iomap_dio_bio_opflags?

--D

> +
>  	if (dio->dops && dio->dops->submit_io)
>  		dio->dops->submit_io(iter, bio, pos);
>  	else
> -- 
> 2.48.1
> 

