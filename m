Return-Path: <io-uring+bounces-4239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 832809B6D54
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:11:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E2CF1F21B7A
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 20:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB69B1D1732;
	Wed, 30 Oct 2024 20:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvcaSxIZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A94E1D1730;
	Wed, 30 Oct 2024 20:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730319108; cv=none; b=s8YrZEkDr1buayrU7WaKuR0b3Cr2X95mCzA2Xmw5Xhu2NiKKsUBcwd1aMq52qUYw13sFG57d7DgSkeWqPcfkEkgF4AeeFn3/eBefHNnR7Cgtj9/r8otzR6CwoUPJPt94R+okmLRzd0SZbW8FJ6erUJzE2l4eyYbZotn7gd/S668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730319108; c=relaxed/simple;
	bh=9xxRKEESrcbPlUbEacTObvDmHtRajxp0C89Y8pmgNZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gXdmQ4LTE7MUBaz9f85/hvvZ3UVYzPQEIu7OJQgHGmjn0m99vFBW5ZVydIhXg+MvZbyfWuDrbpGYjgj9Q5XrnbIYwe/CYr1tx+voHxBYdNETynApb2bRzNBCM0QpM1S8E9pixyUovhan0CGBp3pwSd7/QPigLMO7brO+vLGvI/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JvcaSxIZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F2DC4CECE;
	Wed, 30 Oct 2024 20:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730319107;
	bh=9xxRKEESrcbPlUbEacTObvDmHtRajxp0C89Y8pmgNZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JvcaSxIZWVXsT2nD1KY5BGzDrS2q3a9Z0Sd3N1iMi0mY0+bcuyd6HIT6OMgvEJJee
	 bndn73Xmm0OhipBMLGiuU6rGd1Mde68iMUX4i3Dk+3atz2WxSJu1EMgkTdX45IY6Iz
	 q505ptcEG0R3oezySaAgBU4SdJ6G6rhQiOXxQLwoaWHdFEenqlAJIYtgMbZ+E2MZXg
	 Nkfeufptp+NxmK6RqHE6I88y4rAcdqZoqzq3UE+HiZSni+4T5z4j2+oGZDpasgqW86
	 KYL7fO4P6J9Ftfr7WVjjtiWSWN5h99RehzQQRhYthWQE6f7b/PNESjM2laktTDEFq1
	 yLOVZGY6YmR7w==
Date: Wed, 30 Oct 2024 14:11:44 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCHv10 4/9] block: allow ability to limit partition write
 hints
Message-ID: <ZyKTACiLUsCEcJ-R@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-5-kbusch@meta.com>
 <a1ff3560-4072-4ecf-8501-e353b1c98bf0@acm.org>
 <20241030044658.GA32344@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030044658.GA32344@lst.de>

On Wed, Oct 30, 2024 at 05:46:58AM +0100, Christoph Hellwig wrote:
> On Tue, Oct 29, 2024 at 10:25:11AM -0700, Bart Van Assche wrote:
> >> +}
> >
> > bitmap_copy() is not atomic. Shouldn't the bitmap_copy() call be
> > serialized against the code that tests bits in bdev->write_hint_mask?
> 
> It needs something.  I actually pointed that out last round, but forgot
> about it again this time :)

I disagree. Whether we serialize it or not, writes in flight will either
think it can write or it won't. There's no point adding any overhead to
the IO path for this as you can't stop ending up with inflight writes
using the tag you're trying to turn off.

This is the same as the "ro" attribute. If you're changing it with
BLKROSET ioctl with writes in flight, some of those writes may get past
blkdev_write_iter's read-only check, others may not. No serialization
done there, and this pretty much the same thing.

