Return-Path: <io-uring+bounces-4082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37B8B9B35CE
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 17:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7B58B211F4
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8671CF2A6;
	Mon, 28 Oct 2024 16:08:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C2B15C13A;
	Mon, 28 Oct 2024 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730131695; cv=none; b=D1GQazZ50Yz/4uTCJrTyEpj1YwCED/wIjXrNtmDTFmwIlYAOfxRYScfjctiPUSLlSKJ93olkgbSSxGK9XUsPb4czbbAaqmjtrm0xkqSajrH9bH4ksnnxhdkkVxm7PUtWhg/a7fs7QQn/K5iDMGQUDbdFS1cTUjjcbeVwDkireC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730131695; c=relaxed/simple;
	bh=cD+tVOPgBP2aUOkOS5fVCdYhB3T4AyVqCU57n9MzTM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bH+2ivsLj3EQvh+FCxIzZ7U8/mrRpt/A/L737KS5l4qLhPHIY8EViDfyvpcXJ/wpc9Ud4akohe7qDPN6Z/FBCpf4Z/U+lQGhgCxW5/QvE3O3gMgH6eaVEXkrAlz3MFKsh2lliVRGaoHTpiohqQZ47qFMYr5FpINSnE841HXKM6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7922068BEB; Mon, 28 Oct 2024 17:08:08 +0100 (CET)
Date: Mon, 28 Oct 2024 17:08:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv9 4/7] block, fs: add write hint to kiocb
Message-ID: <20241028160808.GA28077@lst.de>
References: <20241025213645.3464331-1-kbusch@meta.com> <20241025213645.3464331-5-kbusch@meta.com> <20241028115932.GE8517@lst.de> <Zx-hzSwkkUMeuA5C@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zx-hzSwkkUMeuA5C@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 28, 2024 at 08:38:05AM -0600, Keith Busch wrote:
> > > +	if (bdev_is_partition(bdev) &&
> > > +	    !test_bit(hint - 1, bdev->write_hint_mask))
> > > +		return file_inode(iocb->ki_filp)->i_write_hint;
> > 
> > I would have expected an error when using an invalid stream identifier.
> 
> It's a hint. fcntl doesn't error if you give an unusable hint, so
> neither should this. You get sane default behavior.

Well, why does it have to be a hint?

If I have a data placement aware application I really want to know
into how many buckets I can sort and adjust my algorithm for it.
And I'd rather have an error checked interface to pass that down
as far as I can.

Same for my file system use case.  I guess you have a use case where
a hint would be enough, at least with good enough knowledge of the
underlying implementation.  But would there be an actual downside
in not having a hint?  Because historically speaking everything we've
done as a not error checked vaguely defined hint has not been all
the useful, but it in hardware or software interfaces.

