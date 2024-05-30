Return-Path: <io-uring+bounces-2009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A742E8D4F33
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:37:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47AA71F218CF
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBCD182D2F;
	Thu, 30 May 2024 15:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gnA7vGMC"
X-Original-To: io-uring@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD32187558
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717083417; cv=none; b=Enq0TMc7e4CioXjXNmRxr+c3CUKkAZSi49JDyL2dOTFuT+ecBaQsTLWuuBlt3vbWXHVe83zbheVQFIufQr1XIH0OXpVP2xp8yewHZDfpTl6XfFM9HijGDN5ULbh2R46AS59W58yJmffEcTxdxLArgCNzCGXLiWPVJtSqBvnSpJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717083417; c=relaxed/simple;
	bh=PgEEPPJ7huqT12B4Wb+pYeIFMau0oMceIwl7H9dzBV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fboUhDFBCKBXFCu6zgYrRuyiSHnJWy+JVJPvyLPOcZ78wFjxpM7zaAYM4rMiQZCblqKlplSiWNwR2OIQZvym+3NZnh4PXK6oVyj73R1UdMI0+msD9X9NLJs8VAbh/+ZLhNaSti3JsjGhYT962AU1DBY/no4cWC7oJ6mwA+YpJ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gnA7vGMC; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: bschubert@ddn.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717083413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EijsAgXsRWXx6XFjbJyE2P7goIY3BBH3zxCViy1wr3s=;
	b=gnA7vGMCGLRmT+wucoFpM8VRIuReG3m23CGR3ks1TFPZtF3WilXg9Z7G6mWkxPSUehXMOW
	BTytO8YVTyv3IPflt86WDFozlZZFsvZQZ+s/XUJBZyXIjwqElfZk6C9mO4ojb5ym5ug2Jk
	rnUsvmW3BUnV8Qx6HcApWWZvhdB2QT4=
X-Envelope-To: miklos@szeredi.hu
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: bernd.schubert@fastmail.fm
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: avagin@google.com
X-Envelope-To: io-uring@vger.kernel.org
Date: Thu, 30 May 2024 11:36:49 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, bernd.schubert@fastmail.fm, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Message-ID: <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 29, 2024 at 08:00:35PM +0200, Bernd Schubert wrote:
> From: Bernd Schubert <bschubert@ddn.com>
> 
> This adds support for uring communication between kernel and
> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
> appraoch was taken from ublk.  The patches are in RFC state,
> some major changes are still to be expected.
> 
> Motivation for these patches is all to increase fuse performance.
> In fuse-over-io-uring requests avoid core switching (application
> on core X, processing of fuse server on random core Y) and use
> shared memory between kernel and userspace to transfer data.
> Similar approaches have been taken by ZUFS and FUSE2, though
> not over io-uring, but through ioctl IOs

What specifically is it about io-uring that's helpful here? Besides the
ringbuffer?

So the original mess was that because we didn't have a generic
ringbuffer, we had aio, tracing, and god knows what else all
implementing their own special purpose ringbuffers (all with weird
quirks of debatable or no usefulness).

It seems to me that what fuse (and a lot of other things want) is just a
clean simple easy to use generic ringbuffer for sending what-have-you
back and forth between the kernel and userspace - in this case RPCs from
the kernel to userspace.

But instead, the solution seems to be just toss everything into a new
giant subsystem?

