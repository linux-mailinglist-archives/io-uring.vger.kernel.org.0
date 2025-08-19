Return-Path: <io-uring+bounces-9059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E32EB2C5CB
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 15:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A13431BA1727
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 13:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEE630C365;
	Tue, 19 Aug 2025 13:34:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58367305049;
	Tue, 19 Aug 2025 13:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755610494; cv=none; b=OM49tTvSjEEkdU3Ssc/iDCA7dsXVzAw8Rn3zfLAfnZlxmcjevXgsTHdwqqWdszqjZgwyBr00rlaxSFzbWfVzqtPOlwaJeXQDu0mVunjnBSdmkUk49ElGl/f8EaLnUwfkkpS+EqhVPIvq5DRsGhawRslSv1DetibMFWenuLiHerA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755610494; c=relaxed/simple;
	bh=OXvJDQRaCwawJzmJTJjCyfLVOfXK/kHnUGhG4J6vNak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jym/iwxbnm+7mvxCUDO00xMP6lpkz4xE+ieGrAHUzfejxKqcJlPfNYGxyQCJgYz95OT4YOHQvhnAQ+zx3Get8fsz98Rr0a3cBRZk4/bVk+eZ87MLPq3MN+bQn5Ci5LaKCns9oC4SJQc87TN+T3d6gRJl1thHov7Jj3WkV1AzXDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA92C227A88; Tue, 19 Aug 2025 15:34:47 +0200 (CEST)
Date: Tue, 19 Aug 2025 15:34:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add a FMODE_ flag to indicate
 IOCB_HAS_METADATA availability
Message-ID: <20250819133447.GA16775@lst.de>
References: <20250819082517.2038819-1-hch@lst.de> <20250819082517.2038819-2-hch@lst.de> <20250819-erwirbt-freischaffend-e3d3c1e8967a@brauner> <20250819092219.GA6234@lst.de> <20250819-verrichten-bagger-d139351bb033@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819-verrichten-bagger-d139351bb033@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 19, 2025 at 12:14:26PM +0200, Christian Brauner wrote:
> On Tue, Aug 19, 2025 at 11:22:19AM +0200, Christoph Hellwig wrote:
> > On Tue, Aug 19, 2025 at 11:14:41AM +0200, Christian Brauner wrote:
> > > It kind of feels like that f_iocb_flags should be changed so that
> > > subsystems like block can just raise some internal flags directly
> > > instead of grabbing a f_mode flag everytime they need to make some
> > > IOCB_* flag conditional on the file. That would mean changing the
> > > unconditional assigment to file->f_iocb_flags to a |= to not mask flags
> > > raised by the kernel itself.
> > 
> > This isn't about block.  I will be setting this for a file system
> > operation as well and use the same io_uring code for that.  That's
> > how I ran into the issue.
> 
> Yes, I get that. That's not what this is about. If IOCB_* flags keep
> getting added that then need an additional opt-out via an FMODE_* flag
> it's very annoying because you keep taking FMODE_* bits.

Agreed.

> The thing is
> that it should be possible to keep that information completely contained
> to f_iocb_flags without polluting f_mode.

I don't really understand how that would work.  The basic problem is that
we add optional features/flags to read and write, and we need a way to
check that they are supported and reject them without each time having
to update all instances.  For that VFS-level code needs some way to do
a per-instance check of available features.

