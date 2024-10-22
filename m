Return-Path: <io-uring+bounces-3892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A809A9A2C
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 08:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1255C28642A
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 06:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A637E811EB;
	Tue, 22 Oct 2024 06:43:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BB3145B16;
	Tue, 22 Oct 2024 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729579395; cv=none; b=c0JLBzliPGoIjDjH8khJYqV7Ii+/3qXXjhhY19myLEGZmN99zvXWZPqqXXOjeUGqCXtNGESIVWOfcXAHQRctcpUj+RWbCznZM3wo1kLH8cw0pMUpsBwWNCeeBwE+aJHLe2S8+G88GT9t40M3kCV/vylSoDOYKaCCmcm2cqZvRjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729579395; c=relaxed/simple;
	bh=kta9YLLuoVBmX+evwPHt8LFx7mqj3Pk3hvsvL5PuFag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQNpf2xvokc5M+OlSoiAoKscvONWeNwIweyIkJ067rq5qzs35R+FLZ4y3qG5hjerjJwEr8uPBQCcIGxDc/k4t9tAqPsBHMJn92oMXZdqcFM9bnAGDEeMQHaJ3b2Um9dhMx5YCaul7JqpcxmesCgcsoG8c8KcljqdwSZ0BMT8cFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B52EE227AA8; Tue, 22 Oct 2024 08:43:09 +0200 (CEST)
Date: Tue, 22 Oct 2024 08:43:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 1/6] block, fs: restore kiocb based write hint
 processing
Message-ID: <20241022064309.GA11161@lst.de>
References: <20241017160937.2283225-1-kbusch@meta.com> <20241017160937.2283225-2-kbusch@meta.com> <20241018055032.GB20262@lst.de> <ZxZ3o_HzN8HN6QPK@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxZ3o_HzN8HN6QPK@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 21, 2024 at 09:47:47AM -0600, Keith Busch wrote:
> On Fri, Oct 18, 2024 at 07:50:32AM +0200, Christoph Hellwig wrote:
> > On Thu, Oct 17, 2024 at 09:09:32AM -0700, Keith Busch wrote:
> > >  {
> > >  	*kiocb = (struct kiocb) {
> > >  		.ki_filp = filp,
> > >  		.ki_flags = filp->f_iocb_flags,
> > >  		.ki_ioprio = get_current_ioprio(),
> > > +		.ki_write_hint = file_write_hint(filp),
> > 
> > And we'll need to distinguish between the per-inode and per file
> > hint.  I.e. don't blindly initialize ki_write_hint to the per-inode
> > one here, but make that conditional in the file operation.
> 
> Maybe someone wants to do direct-io with partions where each partition
> has a different default "hint" when not provided a per-io hint? I don't
> know of such a case, but it doesn't sound terrible. In any case, I feel
> if you're directing writes through these interfaces, you get to keep all
> the pieces: user space controls policy, kernel just provides the
> mechanisms to do it.

Eww.  You actually pointed out a real problem here: if a device
has multiple partitions the write streams as of this series are
shared by them, which breaks their use case as the applications or
file systems in different partitions will get other users of the
write stream randomly overlayed onto theirs.

So either the available streams need to be split into smaller pools
by partitions, or we just assigned them to the first partition to
make these scheme work for partitioned devices.

Either way mixing up the per-inode hint and the dynamic one remains
a bad idea.

