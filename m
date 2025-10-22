Return-Path: <io-uring+bounces-10112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C5CBFCD24
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7FBA64FC3E2
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 15:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2556534C9B1;
	Wed, 22 Oct 2025 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYv69xx5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B49034A790;
	Wed, 22 Oct 2025 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761146280; cv=none; b=bLGL8+ZUBOJYzeEOl7RUJ6KEhO1ahqpylqYVfCAL0k43US2rSChspNwMLmv8V0EZ1umwFrt5u5VfmlOwsj6BoEHxAGrPp8xLi2sd6gy2s+2sHMZwzLA1XVwC1xXxR6o9YD6vSSARB65+ti53DwgfwaCL8g0i44CAAtoa/prKgC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761146280; c=relaxed/simple;
	bh=VWEl2mDGynZ5482NGPUVDpxu6n+wfhCJrNqdIFewJeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DnNo3fP8W4eyugkc/e9psDio4W7uE8Vp9Of891EJuMprt4jOnP2zV1MSQoDVTRFwfyaHI5cR3VHwqWxDSjB6dgjsdBLCgElNbZkPiDvKDLOX94BPFyBt01V5J+Q4sizUqMgW8PpelI0kYmhbGFBtU56VAQVmQwnYewCRu6YPXdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYv69xx5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E91C4CEE7;
	Wed, 22 Oct 2025 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761146279;
	bh=VWEl2mDGynZ5482NGPUVDpxu6n+wfhCJrNqdIFewJeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DYv69xx5iWCnopo8ATU9S5JpW+asFEbBFXiV4ppDPRTLMBKYNu8ktpGJkKfI+gOby
	 mJECpiXtdSsIumNRsKV+2Zrn8gZ8GqwIaEU143w+RCGal0VyRfcW0noBK/BK5Ma4Fr
	 ntyS3IOFIEZtYwoHLN1i3XNL7x6kBRpnqVQi7r3M=
Date: Wed, 22 Oct 2025 17:17:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mallikarjun Thammanavar <mallikarjunst09@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	"kernelci . org bot" <bot@kernelci.org>
Subject: Re: [PATCH] io_uring: initialize vairable "sqe" to silence build
 warning
Message-ID: <2025102217-manicure-debtor-4d0f@gregkh>
References: <20251022150716.2157854-1-mallikarjunst09@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022150716.2157854-1-mallikarjunst09@gmail.com>

On Wed, Oct 22, 2025 at 05:07:16PM +0200, Mallikarjun Thammanavar wrote:
> clang-17 compiler throws build error when [-Werror,-Wuninitialized] are enabled
> error: variable 'sqe' is uninitialized when used here [-Werror,-Wuninitialized]
> 
> Initialize struct io_uring_sqe *sqe = NULL; to have clean build
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Link: https://lore.kernel.org/regressions/176110914348.5309.724397608932251368@15dd6324cc71/
> 
> Signed-off-by: Mallikarjun Thammanavar <mallikarjunst09@gmail.com>
> ---
>  io_uring/fdinfo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index d5aa64203de5..e5792b794f8b 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -89,7 +89,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
>  	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
>  	while (sq_head < sq_tail) {
> -		struct io_uring_sqe *sqe;
> +		struct io_uring_sqe *sqe = NULL;

If you do that, then other tools will report a NULL dereference, right?

Please fix the tools, don't paper over stuff like this.

thanks,

greg k-h

