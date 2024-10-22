Return-Path: <io-uring+bounces-3928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC2F9AB996
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 00:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D54A1C22759
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 22:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D191CDA0E;
	Tue, 22 Oct 2024 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcktxEXP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3F61CCEFA
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 22:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729636858; cv=none; b=rj7iuzSmz8wLHdsZQb0PFkAexzzTnfxKlkOe4IN8iyuKEmgZEXVs4XzLvdPXVsK6YHxwr3KVOL+8dSFRf1S4iev6yMjxs4/HXOdWUnAPcAG1nbREXLPKRoVMjcsw4lYU34NgPnk86gDU9dTlHbRywm6kgnfwLjWAmYIbO5Xfl3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729636858; c=relaxed/simple;
	bh=MGcb4ErwHCvEWqzze0rUjoEHaOUF0hEQbpt3ypRKs9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIhSHAhlvigCkAGT598yGdrjj3rMKWlrVIGrQxNXUeWJdIs+ME4e6VL0FBBVTEapaInrcViaD/QMoj5y+tSmBAUS8oPLLpZCVJcCPqbx8SU2XrtE1oOmxiFW28bRf0++DXjko+SYzOgsMNJ1alSiyfFaODTxTVGptjze1OwIJb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcktxEXP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95441C4CEC3;
	Tue, 22 Oct 2024 22:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729636857;
	bh=MGcb4ErwHCvEWqzze0rUjoEHaOUF0hEQbpt3ypRKs9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XcktxEXPHsepqNcf6tiSyyIytU6yv99pB22zF+9F4QrYDCuL4GE25qy7mU4k21FqT
	 mWXava/Vp66zqvI5I7tD+RC4nOHRT42hd0i/0QzXgJCOoeHuhlTsqrJWMSUEAz1+22
	 hPzp8ikr8IGI8aTKoN9rPpqU4UxqN85Vogtmo6kgC2qncbBnSkVXE81EY0cX76UliI
	 7g/lsbS97hYbucGrBQZTqNd3WW9mkSJex+kxzagLwYgqOI+n3CQK5EkqTAgNcYCKGL
	 J5NyfyXip+LI7BkU7ufYN2WVuJWgk952symRf4fEUdPUpX/bBP4kKwV3BEtN+ixBw2
	 aiXRyANsSJYmw==
Date: Tue, 22 Oct 2024 16:40:54 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] io_uring: change io_get_ext_arg() to uaccess begin +
 end
Message-ID: <Zxgp9uPGPJZijSoq@kbusch-mbp>
References: <20241022204708.1025470-1-axboe@kernel.dk>
 <20241022204708.1025470-3-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022204708.1025470-3-axboe@kernel.dk>

On Tue, Oct 22, 2024 at 02:39:03PM -0600, Jens Axboe wrote:
> In scenarios where a high frequency of wait events are seen, the copy
> of the struct io_uring_getevents_arg is quite noticeable in the
> profiles in terms of time spent. It can be seen as up to 3.5-4.5%.
> Rewrite the copy-in logic, saving about 0.5% of the time.

I'm surprised it's faster to retrieve field by field instead of a
straight copy. But you can't argue with the results!
 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 8952453ea807..612e7d66f845 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3239,6 +3239,7 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
>  static int io_get_ext_arg(unsigned flags, const void __user *argp,
>  			  struct ext_arg *ext_arg)
>  {
> +	const struct io_uring_getevents_arg __user *uarg = argp;
>  	struct io_uring_getevents_arg arg;
>  
>  	/*
> @@ -3256,8 +3257,13 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
>  	 */
>  	if (ext_arg->argsz != sizeof(arg))
>  		return -EINVAL;
> -	if (copy_from_user(&arg, argp, sizeof(arg)))
> +	if (!user_access_begin(uarg, sizeof(*uarg)))
>  		return -EFAULT;
> +	unsafe_get_user(arg.sigmask, &uarg->sigmask, uaccess_end);
> +	unsafe_get_user(arg.min_wait_usec, &uarg->min_wait_usec, uaccess_end);
> +	unsafe_get_user(arg.ts, &uarg->ts, uaccess_end);
> +	unsafe_get_user(arg.sigmask_sz, &uarg->sigmask_sz, uaccess_end);
> +	user_access_end();
>  	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
>  	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
>  	ext_arg->argsz = arg.sigmask_sz;
> @@ -3267,6 +3273,9 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
>  		ext_arg->ts_set = true;
>  	}
>  	return 0;
> +uaccess_end:
> +	user_access_end();
> +	return -EFAULT;
>  }

I was looking for the 'goto' for this label and discovered it's in the
macro. Neat.

Reviewed-by: Keith Busch <kbusch@kernel.org>

