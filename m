Return-Path: <io-uring+bounces-4628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B24469C5FDB
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 19:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A3EEB23E42
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 16:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1092076AB;
	Tue, 12 Nov 2024 16:51:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FC7207212;
	Tue, 12 Nov 2024 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731430262; cv=none; b=OtLxsnAAkWpEEmiLHU5hkpuFfnn6D+x3+VHMKkiLEhIaBiavFoA9QlZhhuoRjpUSZLuxlY3e8ZvpeEKPBlg/4WsQ62NpSdWkU91afvzbRZ8nIWgbHTiizcHJX6DxGokO/hBOGl0aeljoz75hiyUDsaqfD6sz0ouB7UG9oonu+c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731430262; c=relaxed/simple;
	bh=EBUiZlEK6HZ+A1x2vpCE2pv8RGYfBE2Zi/lkPtedqeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+pYSolxSFKgbrt/nVd2kzsRRSH9IV3GXwmNwpJnvR50mg+6JFEYzrkE+SZWwSTZTkZrIHsLPxMqKkd9KjcdK09vmnNol5ioNYPsmyZSNQ+XwXqrHHTyTXJj2VfeQRZVCXWaA+K9kbvMZBR0vr+MKkM7CxO199PyWYmSw1xu53A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7689768D0A; Tue, 12 Nov 2024 17:50:54 +0100 (CET)
Date: Tue, 12 Nov 2024 17:50:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, martin.petersen@oracle.com, asml.silence@gmail.com,
	javier.gonz@samsung.com
Subject: Re: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
Message-ID: <20241112165054.GA19355@lst.de>
References: <20241108193629.3817619-1-kbusch@meta.com> <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com> <20241111102914.GA27870@lst.de> <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com> <20241112133439.GA4164@lst.de> <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 12, 2024 at 07:25:45AM -0700, Keith Busch wrote:
> > I feel like banging my head against the wall.  No, passing through write
> > streams is simply not acceptable without the file system being in
> > control.  I've said and explained this in detail about a dozend times
> > and the file system actually needing to do data separation for it's own
> > purpose doesn't go away by ignoring it.
> 
> But that's just an ideological decision that doesn't jive with how
> people use these.

Sorry, but no it is not.  The file system is the entity that owns the
block device, and it is the layer that manages the block device.
Bypassing it is an layering violation that creates a lot of problems
and solves none at all.

> The applications know how they use their data better
> than the filesystem,

That is a very bold assumption, and a clear indication that you are
actually approaching this with a rather idiological hat.  If your
specific application actually thinks it knows the storage better than
the file system that you are using you probably should not be using
that file system.  Use a raw block device or even better passthrough
or spdk if you really know what you are doing (or at least thing so).

Otherwise you need to agree that the file system is the final arbiter
of the underlying device resource.  Hint: if you have an application
that knows that it is doing (there actually are a few of those) it's
usually not hard to actually work with file system people to create
abstractions that don't poke holes into layering but still give the
applications what you want.  There's also the third option of doing
something like what Damien did with zonefs and actually create an
abstraction for what what your are doing.

> so putting the filesystem in the way to force
> streams look like zones is just a unnecessary layer of indirection
> getting in the way.

Can you please stop this BS?  Even if a file system doesn't treat
write streams like zones keeps LBA space and physical allocation units
entirely separate (for which I see no good reason, but others might
disagree) you still need the file system in control of the hardware
resources.


