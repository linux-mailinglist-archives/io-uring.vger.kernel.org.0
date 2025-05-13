Return-Path: <io-uring+bounces-7961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A772AB52DE
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 12:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 837BD16C795
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 10:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD0824166F;
	Tue, 13 May 2025 10:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jP/GhD8Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D9B23909F
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 10:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747132665; cv=none; b=eWNdwipqpkjWeaq3b+LLssV2KAxPFwwwMr0LEDKmdOffS0ZJ1QRRBJodNAdg5/6VybMmwI0AzakFwz7MlGlE+TqmWeV1OTZiwuxel/931kGMIYRjNHTWWwvqkPOkK/c1YAFgN4epZGThxO1sfrTTg5Q4v1bC5lizofiI1MU8XIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747132665; c=relaxed/simple;
	bh=4Xz/4aqjeHOOmyvFPwYCiI8tuTtNMHtO12B/qDudO34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFTg0nxIL3MBMtG+zFmj7P7iFvtSA1GvBu70T9tzQRhDHuQ/RZZuAyXui69I3t6cwXTrZB0UC24phQEQLIqldEKAh4UDYjF71F7LEhzIm6Nx/aZHvZeO4hZJxBS87EB/VqAa2DmF9g+sqGLRJRipv7kLOtjQ2pXSYRKf25RnOp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jP/GhD8Y; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747132664; x=1778668664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4Xz/4aqjeHOOmyvFPwYCiI8tuTtNMHtO12B/qDudO34=;
  b=jP/GhD8YVYcgSZvErEnl8uPHQ/d18wiT4pOb5od2z0K+WJmPefPV4TYG
   arRGNE2JfxqswKdwKTWUCx6iGtGCzmZJ6HMOQfyXTW7Tz6Pshjm3gZvk/
   JZyXgvPl640Hj7hvQjIwb/gqeBJiPZieUC/lCasK5nxU4W9YyHGnzv0Vp
   zJodcAGvNLQSUQ4/bE3h+KNi51F/mLN7J2Sb75rssIB9f4rmyJvKncZBp
   i70ChbgdgfN1Mx8XLaUHIXft+UENmy0bh8I8Jll/Op6l32Xz81fF7Oq4k
   8x7Lg+jIL9PP8XEM/SCx2N51rgs3VLbMwosJfGpXggS6ZpF6HvyTmImnv
   w==;
X-CSE-ConnectionGUID: xZIvxBmvSwGRqFybeJvt7w==
X-CSE-MsgGUID: 6yk8YWCpQHSf6QwV3DCp9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="51628971"
X-IronPort-AV: E=Sophos;i="6.15,285,1739865600"; 
   d="scan'208";a="51628971"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 03:37:43 -0700
X-CSE-ConnectionGUID: VbqbZMRtShiuJSoO3NTD2w==
X-CSE-MsgGUID: cWPPUvEQTOaKiGg/MT/rww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,285,1739865600"; 
   d="scan'208";a="137561319"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa006.fm.intel.com with ESMTP; 13 May 2025 03:37:42 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id D6318243; Tue, 13 May 2025 13:37:40 +0300 (EEST)
Date: Tue, 13 May 2025 13:37:40 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH v2 8/8] io_uring: drain based on allocates reqs
Message-ID: <aCMg9J25E_Um-kSg@black.fi.intel.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
 <46ece1e34320b046c06fee2498d6b4cd12a700f2.1746788718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ece1e34320b046c06fee2498d6b4cd12a700f2.1746788718.git.asml.silence@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, May 09, 2025 at 12:12:54PM +0100, Pavel Begunkov wrote:
> Don't rely on CQ sequence numbers for draining, as it has become messy
> and needs cq_extra adjustments. Instead, base it on the number of
> allocated requests and only allow flushing when all requests are in the
> drain list.
> 
> As a result, cq_extra is gone, no overhead for its accounting in aux cqe
> posting, less bloating as it was inlined before, and it's in general
> simpler than trying to track where we should bump it and where it should
> be put back like in cases of overflow. Also, it'll likely help with
> cleaning and unifying some of the CQ posting helpers.

This patch breaks the `make W=1` build. Please, always test your changes with
`make W=1`. See below the details.

...

>  static __cold void io_drain_req(struct io_kiocb *req)
>  	__must_hold(&ctx->uring_lock)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	bool drain = req->flags & IOSQE_IO_DRAIN;
>  	struct io_defer_entry *de;
> +	struct io_kiocb *tmp;

> +	int nr = 0;

Defined and assigned...

>  
>  	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
>  	if (!de) {
> @@ -1667,17 +1658,17 @@ static __cold void io_drain_req(struct io_kiocb *req)
>  		return;
>  	}
>  
> +	io_for_each_link(tmp, req)
> +		nr++;

...just incremented...

And that seems it. Does the above have any side-effects? Or is it just a dead
code (a.k.a. leftovers from the rebase/upcoming work)?

In any case, please make use of nr or drop it completely.

io_uring/io_uring.c:1649:6: error: variable 'nr' set but not used [-Werror,-Wunused-but-set-variable]
 1649 |         int nr = 0;
      |             ^
1 error generated.

>  	io_prep_async_link(req);
>  	trace_io_uring_defer(req);
>  	de->req = req;
> -	de->seq = io_get_sequence(req);
>  
> -	scoped_guard(spinlock, &ctx->completion_lock) {
> -		list_add_tail(&de->list, &ctx->defer_list);
> -		__io_queue_deferred(ctx);
> -		if (!drain && list_empty(&ctx->defer_list))
> -			ctx->drain_active = false;
> -	}
> +	ctx->nr_drained += io_linked_nr(req);
> +	list_add_tail(&de->list, &ctx->defer_list);
> +	io_queue_deferred(ctx);
> +	if (!drain && list_empty(&ctx->defer_list))
> +		ctx->drain_active = false;
>  }

-- 
With Best Regards,
Andy Shevchenko



