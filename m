Return-Path: <io-uring+bounces-4610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AADD29C42B6
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 17:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8735FB229DD
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 16:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCB71A0BF2;
	Mon, 11 Nov 2024 16:34:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8161B19C569;
	Mon, 11 Nov 2024 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731342873; cv=none; b=W56lczzOzO+6IjNfPyOjgQdJG2Ho1Wqy3dMcIrFYuZRsIzKqp38djWz4CJFZ5OhFbtY8lBdpNaClLAVzI3330jJBt9irJpBDQu7l5mlVCfEwm5ii5nUBA+mLGJneRooPAergv4FsFvfL73hti8ST+VavxfhyTH0rYeK3jHiCiIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731342873; c=relaxed/simple;
	bh=KWPIFZJXA+An9Mjg45PmlhqbudT3WPMG04jLt2b/DsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kW5yiO5VfMNStG4ua8mK5R++U2MGaAUIj9zA1U5VryEx7H71oZvSchyEm/UP1+VJV6EtWl0h3kcpA7+wYvtOjkkzDj4LRXRHQkZ+s9BNe/Lbw6TN73HINnP1gXnC72aaF+ovU33VWYYDyK05KISyroIdu4lsKqMrZJ4aJHDmY+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D98C768D05; Mon, 11 Nov 2024 17:34:25 +0100 (CET)
Date: Mon, 11 Nov 2024 17:34:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, axboe@kernel.dk,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	javier.gonz@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
Message-ID: <20241111163425.GA17212@lst.de>
References: <20241108193629.3817619-1-kbusch@meta.com> <20241111102914.GA27870@lst.de> <ZzIwdW0-yn6uglDF@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzIwdW0-yn6uglDF@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 11, 2024 at 09:27:33AM -0700, Keith Busch wrote:
> Just purely for backward compatibility, I don't think you can have the
> nvme driver error out if a stream is too large. The fcntl lifetime hint
> never errored out before, which gets set unconditionally from the
> file_inode without considering the block device's max write stream.

True.  But block/fops.c should simply not the write hint in that
case (or even do a bit of folding if we care enough).

> >  - block/fops.c is the place to map the existing write hints into
> >    the write streams instead of the driver
> 
> I might be something here, but that part sure looks the same as what's
> in this series.

Your series simply mixes up the existing write (temperature) hint and
the write stream, including for file system use.  This version does
something very similar, but only for block devices.

> 
> >  - the stream granularity is added, because adding it to statx at a
> >    later time would be nasty.  Getting it in nvme is actually amazingly
> >    cumbersome so I gave up on that and just fed a dummy value for
> >    testing, though
> 
> Just regarding the documentation on the write_stream_granularity, you
> don't need to discard the entire RU in a single command. You can
> invalidate the RU simply by overwriting the LBAs without ever issuing
> any discard commands.

True.  Did I managed this was a quick hack job?

> If you really want to treat it this way, you need to ensure the first
> LBA written to an RU is always aligned to NPDA/NPDAL.

Those are just hints as well, but I agree you probably get much
better results if they do.

> If this is really what you require to move this forward, though, that's
> fine with me.

I could move it forward, but right now I'm more than over subsribed.
If someone actually pushing for this work could put more effort into it
it will surely be faster.


