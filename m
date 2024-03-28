Return-Path: <io-uring+bounces-1277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B8F88F754
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 06:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 011C0B220DA
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 05:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521E745957;
	Thu, 28 Mar 2024 05:36:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B1E40874;
	Thu, 28 Mar 2024 05:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711604197; cv=none; b=ZOt0M+EmfOkjSZt9/uKMmoCQhVDpHBkE9KqSSvL65aa8p7AM3IH+hW72dPDpQB+MIZk0Lp6DSIOzffeTS0SSpgsAy6UiYd9bK4RvoGNQ3g0Og5LmNDZeZqk2BK0yQDMaCZxKswhYvJEEL9suRiWkalOoLHsSBWFtGnLdbUjwuqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711604197; c=relaxed/simple;
	bh=LAD8ntMJ2GpYWtCqzlij+YHsaBZSjRYVWqI5ajKrWHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3UNCa0uyrwlB8SM1HplzQ7Rx11/sHGRyFX2JJq0PXBN+lxEazTMVXnam4YgID8GdI4Mn0BZr4tggKQug0c5FshtvrR1EQ3NzQVpwZk/ZiThO2KF3tzj2+AVLfHRIkjbXpabgpgein8EhitxUKwEmaXNc46k5Wmb/IE12msS4wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EB8168B05; Thu, 28 Mar 2024 06:36:32 +0100 (CET)
Date: Thu, 28 Mar 2024 06:36:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <20240328053631.GB15831@lst.de>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner> <ZgTFTu8byn0fg9Ld@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgTFTu8byn0fg9Ld@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 12:18:06PM +1100, Dave Chinner wrote:
> >  		if (!(kiocb->ki_flags & IOCB_DIRECT) &&
> > -			!(kiocb->ki_filp->f_mode & FMODE_BUF_WASYNC) &&
> > +			!fops_buf_wasync(kiocb->ki_filp) &&
> >  			(req->flags & REQ_F_ISREG))
> >  			goto copy_iov;
> 
> You should probably also fix that comment - WASYNC is set when the
> filesystem supports NOWAIT for buffered writes.

The existing indentation is also horribly wrong here, might be owrth
fixing if we touch it anyway..

