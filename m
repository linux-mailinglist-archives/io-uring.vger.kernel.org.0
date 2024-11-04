Return-Path: <io-uring+bounces-4385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 618A49BA9A5
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 01:01:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 870C61C20D6A
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A1233EA;
	Mon,  4 Nov 2024 00:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OoTy6BC2"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EFB800
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 00:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730678510; cv=none; b=Rd8Ov4nKRSvEfL2yKpvU1ZTVdALFUEoHf8sL09CQ24mfQyDgYDtc3pLfiQ2pG9BL8HAa26/Zhv9px4Wxdev9ATcWh073EBQO44Rq4ZUv2W7/P3lGI5JV4Dul6QtufXokCJ35hVslDoR4ztB+McUzHmcdwFSOVO9q4/25LUr4BlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730678510; c=relaxed/simple;
	bh=RRz1+00MAXLzX1gU18oVEaY7/WURDYuNT7M++7l9xX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5GWuhTLkjWz4n4jKHm7UE20rtJmWVDOEgn3GepFtMFwOdab9QG7k4aCX25AqGVM7IcFTULoeUanE+5zUDdXEmjElFtV9B7UaCKvnXx7SkWc4rWMuWY36Wff+Fh40PBy+hs7xWXdXeTVq/TfLpCLl1Jm34FU0X79r/3sqZZh2vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OoTy6BC2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2816EC4CECD;
	Mon,  4 Nov 2024 00:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730678510;
	bh=RRz1+00MAXLzX1gU18oVEaY7/WURDYuNT7M++7l9xX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OoTy6BC2sm2Ygr7BKzz1DlE8Y04hD9eH/7QDZ9Uhst1dEqdZIRzW/gWKvXCvsD/eK
	 0iyxVNgqgZ1fs1Jypt+vbHSw/mPpneQJBFRtShRi72AKYz+1FG6zzBSqSnwd2Bg0pM
	 D5lW8e83HWCR63pXqsS+9XZ19XQMiK2ztWrplDekGfj6GHVb+znNBrTWmYBwnz842L
	 0zXhD/pP7Wh5HFZtpwl/bpH0VkQyrKJFtuQEMjWRjEDP/R9XnlzMIviBVw1JaD1jeG
	 FvqoSG2EJYoOQ85avfvobKniXs6t/ikzBQNNWRBYgm3QA/FvWRNJMWIk15Ax8jaFWb
	 k86CD4m/nDz1A==
Date: Sun, 3 Nov 2024 17:01:48 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Marshall <andrew@johnandrewmarshall.com>,
	io-uring@vger.kernel.org
Subject: Re: PROBLEM: io_uring hang causing uninterruptible sleep state on
 6.6.59
Message-ID: <ZygO7O1Pm5lYbNkP@kbusch-mbp>
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
 <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>

On Sun, Nov 03, 2024 at 04:53:27PM -0700, Jens Axboe wrote:
> On 11/3/24 4:47 PM, Andrew Marshall wrote:
> > I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely
> > problematic commit simply by browsing git log. As indicated above;
> > reverting that atop 6.6.59 results in success. Since it is passing on
> > 6.11.6, I suspect there is some missing backport to 6.6.x, or some
> > other semantic merge conflict. Unfortunately I do not have a compact,
> > minimal reproducer, but can provide my large one (it is testing a
> > larger build process in a VM) if needed?there are some additional
> > details in the above-linked downstream bug report, though. I hope that
> > having identified the problematic commit is enough for someone with
> > more context to go off of. Happy to provide more information if
> > needed.
> 
> Don't worry about not having a reproducer, having the backport commit
> pin pointed will do just fine. I'll take a look at this.

I think stable is missing:

  6b231248e97fc3 ("io_uring: consolidate overflow flushing")

