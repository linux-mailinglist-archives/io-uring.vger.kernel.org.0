Return-Path: <io-uring+bounces-3777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C59659A21BA
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 14:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CDDBB21DCD
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 12:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920CF1DC07D;
	Thu, 17 Oct 2024 12:01:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1351DC759;
	Thu, 17 Oct 2024 12:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729166470; cv=none; b=TkhV8AybkN5Yt8dVQxoF4Ia1fJBTd3ejpI21N1nwEd3dsPFiCaPzT0enBL4UJ621Qnd0/9u5dxMa/SeSNV6YJpTYX7MCcW1gLystJy+lRf399s32u+fWgfTUiIS4zNwUYSUSuf/59klTPTc03D+rKAl2bvvA4OHXrF6bR8pc6tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729166470; c=relaxed/simple;
	bh=J8HTvMHg8mgK1PZIxOh5fQoUl4lQS3tI/lEIX+KRpuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaV8ymg8ml96bLciEwJLRtT2ZPR+VcIqXYf9aMnfgzFV9Qlt5d5w4xH5jmlK4ilgPyYUSrstuLlVshyOXsGWDTs0nNUhngPWgDM3hYrEeVC7O3iGMM2/sg+nU+8TnK7zLJa8DKKtCycXKTg4s0ceUUm8Zl+vKJ1IImS27+Fcv7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 85593227A87; Thu, 17 Oct 2024 14:01:02 +0200 (CEST)
Date: Thu, 17 Oct 2024 14:01:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com
Subject: Re: [PATCH v4 06/11] block: add flags for integrity meta
Message-ID: <20241017120102.GA10883@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62@epcas5p1.samsung.com> <20241016112912.63542-7-anuj20.g@samsung.com> <20241017080015.GD25343@lst.de> <20241017104502.GA1885@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017104502.GA1885@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 04:15:02PM +0530, Anuj Gupta wrote:
> On Thu, Oct 17, 2024 at 10:00:15AM +0200, Christoph Hellwig wrote:
> > On Wed, Oct 16, 2024 at 04:59:07PM +0530, Anuj Gupta wrote:
> > > Add flags to describe checks for integrity meta buffer. These flags are
> > > specified by application as io_uring meta_flags, added in the next patch.
> > 
> > These are now blkdev uapis, but io_uring ones even if currently only
> > the block file operations implement them.  I do plan to support these
> > through file systems eventually.
> 
> Are these flags placed correctly here or you see that they should be
> moved somewhere else?

They are not as they aren't blkdev apis.  They are generic for io_uring,
or maybe even VFS-wide.


