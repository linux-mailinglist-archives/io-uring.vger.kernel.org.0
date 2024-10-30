Return-Path: <io-uring+bounces-4242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F19A19B6DC7
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:37:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F9D81C2194D
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 20:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760941E130F;
	Wed, 30 Oct 2024 20:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKhDA2yg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BFC1DE3BD;
	Wed, 30 Oct 2024 20:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730320643; cv=none; b=I2F5rXaEPfdG6OHeHk3nsf46RSWtR6six1siTfRJIQiJjV50AkNZ9JJzOttZLaTnExLDG6GCoQJ2EMg0jvR1yruGfsIGpU5nwr0OGrcVIPe4IYE1C6ta7wmSoSb0dnNcJQ36XV4wMrLmAvOjQBjYfEH9UwtQCuTJJIclMYnpwY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730320643; c=relaxed/simple;
	bh=PrJ+6LIqFra5zqIEIDGYKJDXKAfwJPRoggLObenh7h4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p0+HyHJBtmJE2x/6Zjc8Rh496pxLPtENA2K80HlwdrUW0cp2AKiwePdrXwXxXpBat6XyFC/eb+b2A3wxYw89k+pL3jqpj1V45dKgYlELThNG1m0yMkUQ84FOtDSbxQYl8RxkRK7ff2WPPbVtj6HhhAEliK7C026/nW6NOOVV260=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKhDA2yg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB76C4CECE;
	Wed, 30 Oct 2024 20:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730320642;
	bh=PrJ+6LIqFra5zqIEIDGYKJDXKAfwJPRoggLObenh7h4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KKhDA2ygEUVS6ERioFoB4scqZ9gcxJJRhuLv+hCDw3RnLJ4nTzPW2pOtwsOwRB2RM
	 I2GEtJEavoIE0hlbtXrzHBo/bs8lOkaWKr9VCNs9L3VS3dCTkxFJhKZ+TTWXVpwTAw
	 H+Ja8fOIYdTnFipRPT8JbOOtXYMMrO2BdnhqCLT4RNIKIWGagSJabin8jFUsgVRTv1
	 n7Rjcet4rMiD7dLL1myojyToyhviipQONn1XERVa2wHp43t3CE/REUGMMKtn42wo5F
	 rCJxZRV3AcWguygA8JA2nMKwTuoFEcE6kE/rywpkGIqq59eCECeZYGXtYN2iFR/yr3
	 YlNAtHnspw7aQ==
Date: Wed, 30 Oct 2024 14:37:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCHv10 4/9] block: allow ability to limit partition write
 hints
Message-ID: <ZyKY_xdxcM2aSMow@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-5-kbusch@meta.com>
 <a1ff3560-4072-4ecf-8501-e353b1c98bf0@acm.org>
 <20241030044658.GA32344@lst.de>
 <ZyKTACiLUsCEcJ-R@kbusch-mbp.dhcp.thefacebook.com>
 <7f63ba9b-856b-4ca5-b864-de1b8f87d658@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f63ba9b-856b-4ca5-b864-de1b8f87d658@acm.org>

On Wed, Oct 30, 2024 at 01:26:38PM -0700, Bart Van Assche wrote:
> On 10/30/24 1:11 PM, Keith Busch wrote:
> > On Wed, Oct 30, 2024 at 05:46:58AM +0100, Christoph Hellwig wrote:
> > > On Tue, Oct 29, 2024 at 10:25:11AM -0700, Bart Van Assche wrote:
> > > > > +}
> > > > 
> > > > bitmap_copy() is not atomic. Shouldn't the bitmap_copy() call be
> > > > serialized against the code that tests bits in bdev->write_hint_mask?
> > > 
> > > It needs something.  I actually pointed that out last round, but forgot
> > > about it again this time :)
> > 
> > I disagree. Whether we serialize it or not, writes in flight will either
> > think it can write or it won't. There's no point adding any overhead to
> > the IO path for this as you can't stop ending up with inflight writes
> > using the tag you're trying to turn off.
> 
> Shouldn't the request queue be frozen while this write_hint_mask bitmap
> is modified, just like the request queue is frozen while queue limits
> are updated? This change wouldn't add any additional overhead to the I/O
> path.

The partitions don't have a queue. If we need to freeze, then changing
one partition's available hints harms IO to other partitions.

Also, block direct IO creates the bio before it freezes. Freezing would
only get writes using the hint you're trying to disable queue up after
all the checks have been done, so you still can't stop making inflight
writes with freeze.

But if by "not atomic", if you're just saying we need a barrier on the
bitmap_copy, like smp_mb__after_atomic(), then yeah, I see that's
probably appropriate here.

