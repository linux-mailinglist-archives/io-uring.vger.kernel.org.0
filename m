Return-Path: <io-uring+bounces-6849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D27A48BF3
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 23:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 647DC188F14C
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 22:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DDF2288F4;
	Thu, 27 Feb 2025 22:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjKMkScl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6703C1AA1E4;
	Thu, 27 Feb 2025 22:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740696354; cv=none; b=r9QgV2PXNBnjBp+TZI+Hmc2Beo9lqWXds90M03szK16oLaSVQL1KZvi7kuGwTR/OjDIfTVOMG40ZFrJGovYYUxOKgBAsJQheUllq5NHy+2EZk06Izck/yHbrmZe9Q2bh4MLUR5LRuvdKwJ03QPV3CyX7Mw/IwvOS6um4fCxIqPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740696354; c=relaxed/simple;
	bh=+p5E0lo3u03fgQR50E6wq/mHsi3IrLUxGn3iMOUgeNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6jr7ebBw2ntWM7C37TeyB5WxyGvNO4mnH05gGR/uxsRDHn1STHQt2sEC2vcFv6yM3KcPsMrqOuwpFmg7vx2A9wpLkBwkUWFtds+15xUay5kV9yFsCnVEzN4/2t24Y9GRWvCexYWCMtX3KtHxPGuoSJbFNK9wTGP6GSZe11hxRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjKMkScl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A63C4CEE4;
	Thu, 27 Feb 2025 22:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740696353;
	bh=+p5E0lo3u03fgQR50E6wq/mHsi3IrLUxGn3iMOUgeNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hjKMkSclpnSw6gXgh1+crh+wk4ZiQ992nr25s882P3SWo5BDxvTBsfDaZ23ehm93r
	 dkbBlmZMFq9NdRKv5+HQ1HswNxKQOGvLMkq+u0UWdu+1gEJOWKrZS2bzitBJ5ObqV6
	 7ogD4sBJoXhQqI2J/O2TQTc2yq5CbRyllbz8RCMEVN6j+dQ3x+27203304lFawbRKO
	 5boclL4BMfc1swiyeA+hfOz9F0WZkeOcvHlXPDcClhcCH1NSJFdCXCa8vCvxKDvwnJ
	 z4cXgJyQvYz2sSUAy1pOkwrh7HJmRISHsmkPtaATaGbCCZt/6bgtAWAN0a37ku6bv3
	 kzhNNIqV0UhdA==
Date: Thu, 27 Feb 2025 15:45:51 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCHv7 2/6] io_uring: add support for kernel registered bvecs
Message-ID: <Z8DrH7sBSS752Z3o@kbusch-mbp>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-3-kbusch@meta.com>
 <844f45ac-e36e-4784-9f8d-528b022dff9c@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <844f45ac-e36e-4784-9f8d-528b022dff9c@gmail.com>

On Thu, Feb 27, 2025 at 03:54:31PM +0000, Pavel Begunkov wrote:
> On 2/26/25 18:20, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Provide an interface for the kernel to leverage the existing
> > pre-registered buffers that io_uring provides. User space can reference
> > these later to achieve zero-copy IO.
> > 
> > User space must register an empty fixed buffer table with io_uring in
> > order for the kernel to make use of it.
> 
> Can you also fail rw.c:loop_rw_iter()? Something like:
> 
> loop_rw_iter() {
> 	if ((req->flags & REQ_F_BUF_NODE) &&
> 	    req->buf_node->buf->release)
> 		return -EFAULT;
> }

For posterity: the suggestion is because this function uses the
file_operations' .read/.write callbacks, which expect __user pointers.

Playing devil's advocate here, I don't see how user space might know
ahead of time if the file they opened implements the supported _iter
versions. I think only esoteric and legacy interfaces still use it, so
maybe we don't care.

