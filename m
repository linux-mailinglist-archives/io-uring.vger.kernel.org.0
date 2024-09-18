Return-Path: <io-uring+bounces-3224-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E3BBC97B7E5
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 08:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C923B262C1
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 06:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBBF16132A;
	Wed, 18 Sep 2024 06:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W+Hg6mF/"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0D0339A0;
	Wed, 18 Sep 2024 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726640567; cv=none; b=T2uqAY189HX97I7F4E4BG0Zm4WtyvIr28YWcX0sRAIG/Gyu1zAOl8cC5iAqjrqA8WSXbvQvd0qSRc8MxwGOZBEKNqjl8qnThsXmhppzRLeqy8TeHoE9D9frcYBWTXHzCSS/Sm4TJcSCr1V//sdcSTVjS3/xkgbJoDb5Hgc7Bz7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726640567; c=relaxed/simple;
	bh=2Nf2xXXqOPusb/SiXKCGS0TviajEiQ1Gtw/T5EX2xWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZhGOk0xLUF4QkOx3KN7H/D+pnBuqL1MEycjf2f9IEunp70TSzpC3xVUDrKvbFLAB3M/sqnHOSd0xw/K/rZhmc/iioXSlv10aUI+f6a9slI8lcv/MclpWUS3ni0sw52Njzi3xee4sbBj0HamzTvK5QoWyEvDgre+WOOAtNWnFNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W+Hg6mF/; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726640566; x=1758176566;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Nf2xXXqOPusb/SiXKCGS0TviajEiQ1Gtw/T5EX2xWg=;
  b=W+Hg6mF/OI0H8sOOCIV2vSZwY/xqzEH3JYGa1omgxHietabF0O2pzMYZ
   4nm57YSdik4Xk+ITe+KJ0+S9pBs82DRVQsUKTRyEHLSep1j4lSJxdi1l0
   6gEQ1c0wZPtf8hg+a1j544nTj6b0CY3ysBFNaaziXL9tcOY54EQ33o5sq
   DHvDi0Y/cKdwylv5uVgn3YXNoEuLyiMeumVaLtLMCiBfJJeOEYTlr8H49
   o2D53UKDWVxtXDWw3uDOml8eCXm8CqapHzFy6RRBudhFfcEiDwHqpjObL
   7XpSrelSNri2ZyKZS41JXZqXFsFlIk0Is01D/5FIF2MEzGO8VINmX/jd2
   Q==;
X-CSE-ConnectionGUID: js8VqP5pRIuIlSgrdn2OrQ==
X-CSE-MsgGUID: Qr3n4ErGR3i8Oz8bmF0Xkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11198"; a="25653554"
X-IronPort-AV: E=Sophos;i="6.10,235,1719903600"; 
   d="scan'208";a="25653554"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2024 23:22:38 -0700
X-CSE-ConnectionGUID: vHY8YzuzRwC1U/FFOy8dKw==
X-CSE-MsgGUID: BOsk7cVsQvCYWiTNiQ/SWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,235,1719903600"; 
   d="scan'208";a="69444540"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.161.23])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2024 23:22:35 -0700
Date: Wed, 18 Sep 2024 14:21:25 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Felix Moessbauer <felix.moessbauer@siemens.com>, asml.silence@gmail.com,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	cgroups@vger.kernel.org, dqminh@cloudflare.com, longman@redhat.com,
	adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com,
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	pengfei.xu@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH 1/1] io_uring/sqpoll: do not allow pinning outside of
 cpuset
Message-ID: <ZupxZeILxuKqFsRq@ly-workstation>
References: <20240909150036.55921-1-felix.moessbauer@siemens.com>
 <ZupPb3OH3tnM2ARj@ly-workstation>
 <5237b4c0-973f-44cc-a6ee-08302871fd19@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5237b4c0-973f-44cc-a6ee-08302871fd19@kernel.dk>

Thanks for reply. I will include lkp into search database before sending
out fuzzing findings.

Regards,
Yi Lai

On Wed, Sep 18, 2024 at 12:16:41AM -0600, Jens Axboe wrote:
> On 9/17/24 9:56 PM, Lai, Yi wrote:
> > Hi Felix Moessbauer,
> > 
> > Greetings!
> > 
> > I used Syzkaller and found that there is KASAN: use-after-free Read in io_sq_offload_create in Linux-next tree - next-20240916.
> > 
> > After bisection and the first bad commit is:
> > "
> > f011c9cf04c0 io_uring/sqpoll: do not allow pinning outside of cpuset
> > "
> 
> This is known and fixed:
> 
> https://git.kernel.dk/cgit/linux/commit/?h=for-6.12/io_uring&id=a09c17240bdf2e9fa6d0591afa9448b59785f7d4
> 
> -- 
> Jens Axboe

