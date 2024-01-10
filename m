Return-Path: <io-uring+bounces-382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F2C82A04D
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 19:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39E55B246A9
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 18:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1F5C4D582;
	Wed, 10 Jan 2024 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bV8ey8aW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83224D580
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 18:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08468C433F1;
	Wed, 10 Jan 2024 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704911552;
	bh=CVObbuRWPv/3Rqf3e2d5EeuwnFgZ1cPPEHIJtwk5WHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bV8ey8aW+LEeg2dXzvpheDrQLbTOvUD8ty1/22qOnfq9vfrmopK5F5M3Tua+GwytC
	 lMdpudm5rAMPm762ju30WnSLmn7Kkf/4fuV9tfJkihCZptfXp4VKI4jnIrFARr2GvB
	 FOwReZI5NNzXa3jsB4zU2j3tEZVRVsAMaRx8Bhx4GtVcANGBqJ4FkxQpt9TP/RqysS
	 4Se4fBxT8Yg1uD8BG7JwjvWUIsyIO9//uLNavPpTCHMmzL6z+Mu7mFt3XuZnk+VEgd
	 dU7LahTABbC4K+oa5gATsfMW2sIqBTMKaUPwyuZtG8KCKbk5wAeguGtc7vEq6FNllu
	 izFeTRqktHjbw==
Date: Wed, 10 Jan 2024 11:32:29 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rw: cleanup io_rw_done()
Message-ID: <ZZ7ivQcfP4rgtbS0@kbusch-mbp>
References: <8182cb84-0fca-43b8-b36f-0287e20184cd@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8182cb84-0fca-43b8-b36f-0287e20184cd@kernel.dk>

On Wed, Jan 10, 2024 at 10:09:19AM -0700, Jens Axboe wrote:
> +static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
> +{
> +	if (ret == -EIOCBQUEUED) {
> +		return;
> +	} else if (ret >= 0) {
> +end_io:
> +		INDIRECT_CALL_2(kiocb->ki_complete, io_complete_rw_iopoll,
> +				io_complete_rw, kiocb, ret);
> +	} else {
> +		switch (ret) {
> +		case -ERESTARTSYS:
> +		case -ERESTARTNOINTR:
> +		case -ERESTARTNOHAND:
> +		case -ERESTART_RESTARTBLOCK:
> +			/*
> +			 * We can't just restart the syscall, since previously
> +			 * submitted sqes may already be in progress. Just fail
> +			 * this IO with EINTR.
> +			 */
> +			ret = -EINTR;
> +			WARN_ON_ONCE(1);
> +			break;
> +		}
> +		goto end_io;
> +	}
> +}

Are you just trying to get the most common two conditions at the top? A
little rearringing and you can remove the 'goto'. Maybe just my opinion,
but I find using goto for flow control harder to read if there's a
structured alternative.

static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
{
	if (ret == -EIOCBQUEUED)
		return;

	if (unlikely(ret < 0)) {
		switch (ret) {
		case -ERESTARTSYS:
		case -ERESTARTNOINTR:
		case -ERESTARTNOHAND:
		case -ERESTART_RESTARTBLOCK:
			/*
			 * We can't just restart the syscall, since previously
			 * submitted sqes may already be in progress. Just fail
			 * this IO with EINTR.
			 */
			ret = -EINTR;
			WARN_ON_ONCE(1);
			break;
		}
	}

	INDIRECT_CALL_2(kiocb->ki_complete, io_complete_rw_iopoll,
			io_complete_rw, kiocb, ret);
}

