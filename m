Return-Path: <io-uring+bounces-640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C64F85ABEA
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 20:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BFCD1C20F59
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 19:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CAC50272;
	Mon, 19 Feb 2024 19:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rDI2Tw7l"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DCC1BF3D;
	Mon, 19 Feb 2024 19:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708370478; cv=none; b=SBF0I3XXx/ucgvyIoBHQXPkIz+aL/h2rpfRYye/znGquht+KP7tOJP+n9sIfIZdCv5ge82naMRc8nK4O4SHoLQUfkYkP2axvbzGG08tBZ9QyLNbtRYK3GHdRzCDsljVKU3BaY3KpOOHWIl/Zek084+fXTmmOw3m/xPyyQBMY5tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708370478; c=relaxed/simple;
	bh=BU7vmtS91LW14umqdRks1US1wmoCN7BfyNRskJ+lpzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mc6sb+9HBgxmwuyl+D3F8kK0kW7JHCuVYq9kP6piFBor4padm1iphrSgCmg9epJn39UJRg4riEp68mo56byjdRtjz7C43fUxZoRFP9r7I/dME9A3YrQ6vlIiNLaXZTf/joYaCOhu6V7XTg7fqkX+b912k9VEK11b86JJOPXxmYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rDI2Tw7l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BB4C433F1;
	Mon, 19 Feb 2024 19:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708370478;
	bh=BU7vmtS91LW14umqdRks1US1wmoCN7BfyNRskJ+lpzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rDI2Tw7lYr17vYfRVT31/CFWOTvQvw8vu8Kd10WZDkZAfAUrzH8Df4KP6kxyUwmrK
	 rGFpMcWC60IsJ/xONKcoIBQHrAldlZdG91Eo5stQQ7g0kxVAFfd9FHlI499h6X/V9X
	 uV3aNuG/f+xnORzGFBi12Jq9+lalxrUM0mCfg2eSqcmNxdvWWWj0HLY4KndwAixZ5R
	 QrIt0Synm8G4YerLcrr4Ta1M2jUeYFvwJyqYGsqzjANrsTGlgG6z54InG3nSN7NzBy
	 lWYK1LwZxKgM45/cm2HfebVej40pz17i5AFt4n/v5CPx9+emInzhElr3yhPEDIr6p7
	 ynArQJ8jnkTMw==
Date: Mon, 19 Feb 2024 12:21:14 -0700
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, Alan Adamson <alan.adamson@oracle.com>
Subject: Re: [PATCH v4 10/11] nvme: Atomic write support
Message-ID: <ZdOqKr6Js_nlobh5@kbusch-mbp>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-11-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240219130109.341523-11-john.g.garry@oracle.com>

On Mon, Feb 19, 2024 at 01:01:08PM +0000, John Garry wrote:
> From: Alan Adamson <alan.adamson@oracle.com>
> 
> Add support to set block layer request_queue atomic write limits. The
> limits will be derived from either the namespace or controller atomic
> parameters.
> 
> NVMe atomic-related parameters are grouped into "normal" and "power-fail"
> (or PF) class of parameter. For atomic write support, only PF parameters
> are of interest. The "normal" parameters are concerned with racing reads
> and writes (which also applies to PF). See NVM Command Set Specification
> Revision 1.0d section 2.1.4 for reference.
> 
> Whether to use per namespace or controller atomic parameters is decided by
> NSFEAT bit 1 - see Figure 97: Identify - Identify Namespace Data Structure,
> #NVM Command Set.
> 
> NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
> are provided for a write which straddles this per-lba space boundary. The
> block layer merging policy is such that no merges may occur in which the
> resultant request would straddle such a boundary.
> 
> Unlike SCSI, NVMe specifies no granularity or alignment rules. In addition,
> again unlike SCSI, there is no dedicated atomic write command - a write
> which adheres to the atomic size limit and boundary is implicitly atomic.
> 
> If NSFEAT bit 1 is set, the following parameters are of interest:
> - NAWUPF (Namespace Atomic Write Unit Power Fail)
> - NABSPF (Namespace Atomic Boundary Size Power Fail)
> - NABO (Namespace Atomic Boundary Offset)
> 
> and we set request_queue limits as follows:
> - atomic_write_unit_max = rounddown_pow_of_two(NAWUPF)
> - atomic_write_max_bytes = NAWUPF
> - atomic_write_boundary = NABSPF
> 
> If in the unlikely scenario that NABO is non-zero, then atomic writes will
> not be supported at all as dealing with this adds extra complexity. This
> policy may change in future.
> 
> In all cases, atomic_write_unit_min is set to the logical block size.
> 
> If NSFEAT bit 1 is unset, the following parameter is of interest:
> - AWUPF (Atomic Write Unit Power Fail)
> 
> and we set request_queue limits as follows:
> - atomic_write_unit_max = rounddown_pow_of_two(AWUPF)
> - atomic_write_max_bytes = AWUPF
> - atomic_write_boundary = 0
> 
> The block layer requires that the atomic_write_boundary value is a
> power-of-2. However, it is really only required that atomic_write_boundary
> be a multiple of atomic_write_unit_max. As such, if NABSPF were not a
> power-of-2, atomic_write_unit_max could be reduced such that it was
> divisible into NABSPF. However, this complexity will not be yet supported.
> 
> A helper function, nvme_valid_atomic_write(), is also added for the
> submission path to verify that a request has been submitted to the driver
> will actually be executed atomically.

Maybe patch 11 should be folded into this one. No bigged, the series as
a whole looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

