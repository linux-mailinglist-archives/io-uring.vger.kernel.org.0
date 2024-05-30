Return-Path: <io-uring+bounces-2018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 294AA8D510E
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 19:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87D6D1F249E1
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3F846435;
	Thu, 30 May 2024 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oUUw/Ooo"
X-Original-To: io-uring@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E444225D7
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 17:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717090256; cv=none; b=SE6to9HL3q4CdAGPc+PLmQ0K/xUl52lCd71Tu5WBA7SNviVpqyEugAVQ6hDhMhr6hGl8l3OhhIx63QAPTQygfHkOtOnMVFUXoRlNpLXaoYcgKXnbq9Jl04KBsnsRU6wJjj3g3mUkbNdKSm8QyngPVeop5RhTvAwcbVc36faqIaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717090256; c=relaxed/simple;
	bh=3iuhRs7RtzHZ9/IxtZbUZoxfy3hEq7TsUY7P+NXCbcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVXqImUArVmdaghjZRjeODkJnuNWbWG49GDCRCpiFfYDHWkdp8yw//Ya20jMYTiBtnLChSxXPDTSu0n6ZXckKEY/SRoO+5Vbed80bY89aSo4URT4TlP0OyBhPR/zlKkPXuN27g7K382FNiuHUySGLv2zy2SGVpTpRgo2HL/RnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oUUw/Ooo; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: bernd.schubert@fastmail.fm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717090252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ecBfK0D4e0ZtUSrQeyfZauk9M9aepqKnh3roZbh5Nf8=;
	b=oUUw/OoovYnnLnrdEVwdHTMajTqLF2cQNCncP6NGiORTdI3lESWwM3dQR8Lztsry6etEFW
	90mbdosQXPjpkJAULqT7M8kVkqhDisKR2gxp+0OLkr+DyaFIrio8U6YWEGBba2dLtHPAE0
	34Hl7V1ZETx25lWx/8Nw641kX4+Uoqg=
X-Envelope-To: bschubert@ddn.com
X-Envelope-To: miklos@szeredi.hu
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: avagin@google.com
X-Envelope-To: io-uring@vger.kernel.org
X-Envelope-To: axboe@kernel.dk
X-Envelope-To: ming.lei@redhat.com
X-Envelope-To: asml.silence@gmail.com
X-Envelope-To: josef@toxicpanda.com
Date: Thu, 30 May 2024 13:30:48 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	Pavel Begunkov <asml.silence@gmail.com>, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <flphjnv5gyaco3v2o43xvttaxmfz5ktbrhf3tilq5kuffe65y3@w6sizlmk7eph>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <owccqrazlyfo2zcsprxr7bhpgjrh4km3xlc4ku2aqhqhlqhtyj@djlwwccmlwhw>
 <fe874c55-a26f-413f-9719-9cf59b1a3d28@fastmail.fm>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe874c55-a26f-413f-9719-9cf59b1a3d28@fastmail.fm>
X-Migadu-Flow: FLOW_OUT

On Thu, May 30, 2024 at 06:17:29PM +0200, Bernd Schubert wrote:
> 
> 
> On 5/30/24 18:10, Kent Overstreet wrote:
> > On Thu, May 30, 2024 at 06:02:21PM +0200, Bernd Schubert wrote:
> >> Hmm, initially I had thought about writing my own ring buffer, but then 
> >> io-uring got IORING_OP_URING_CMD, which seems to have exactly what we
> >> need? From interface point of view, io-uring seems easy to use here, 
> >> has everything we need and kind of the same thing is used for ublk - 
> >> what speaks against io-uring? And what other suggestion do you have?
> >>
> >> I guess the same concern would also apply to ublk_drv. 
> >>
> >> Well, decoupling from io-uring might help to get for zero-copy, as there
> >> doesn't seem to be an agreement with Mings approaches (sorry I'm only
> >> silently following for now).
> >>
> >> From our side, a customer has pointed out security concerns for io-uring. 
> >> My thinking so far was to implemented the required io-uring pieces into 
> >> an module and access it with ioctls... Which would also allow to
> >> backport it to RHEL8/RHEL9.
> > 
> > Well, I've been starting to sketch out a ringbuffer() syscall, which
> > would work on any (supported) file descriptor and give you a ringbuffer
> > for reading or writing (or call it twice for both).
> > 
> > That seems to be what fuse really wants, no? You're already using a file
> > descriptor and your own RPC format, you just want a faster
> > communications channel.
> 
> Fine with me, if you have something better/simpler with less security
> concerns - why not. We just need a community agreement on that.
> 
> Do you have something I could look at?

Like I said it's at the early sketch stage, I haven't written any code
yet. But I'm envisioning something very simple - just a syscall that
gives you a mapped buffer of a specified size with head and tail pointers.

But this has been kicking around for awhile, so if you're interested I
could probably have something for you to try out in the next few days.

