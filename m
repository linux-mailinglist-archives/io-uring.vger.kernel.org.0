Return-Path: <io-uring+bounces-4590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B7C9C3897
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 07:48:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5968C1C21CAD
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 06:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2536313A258;
	Mon, 11 Nov 2024 06:48:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBE017F7;
	Mon, 11 Nov 2024 06:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731307727; cv=none; b=Hgnjtkp1+pWkMXi5M0N0yQG/vD1jmgw5dsE/KPeTqnbNV4K6sjJ8d13Y0bvRfF+u72LgxKrg1guW05j7ypDFjblb8LrHA4zYwweGoE1lZ+e+BKgEi+UQc6F4yu+DSEcr5hNEXQdHPSe9kiWri0t7RGL0EX/OttPE0MHdCSFAbxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731307727; c=relaxed/simple;
	bh=aXtd0QCRphRYeWp0UQGTZfRJTgzgJckEzQ4C4m8R9QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obTl2TcR3Xp1cMVxpe2bNfGUZdLH64miQyuBxvwOtHwJXsOOEp3MvpQASJwuggZCS4PiMgvPLZKFEvhJnRS07OKDEkPlNW9qhzEhrsB8VPl7bzyjCzSlYTdj2GwJ18q9L3VYtMrcM9g7jd7OUIVtVj2lijrlEcONCHbSmbBlElg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8F32468C7B; Mon, 11 Nov 2024 07:48:41 +0100 (CET)
Date: Mon, 11 Nov 2024 07:48:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241111064841.GA24107@lst.de>
References: <20241029151922.459139-1-kbusch@meta.com> <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp> <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy4zgwYKB1f6McTH@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 08, 2024 at 08:51:31AM -0700, Keith Busch wrote:
> You're getting fragmentation anyway, which is why you had to implement
> gc.

A general purpose file system always has fragmentation of some kind,
even it manages to avoid those for certain workloads with cooperative
applications.

If there was magic pixies dust to ensure freespace never fragments file
system development would be solved problem :)

> You're just shifting who gets to deal with it from the controller to
> the host. The host is further from the media, so you're starting from a
> disadvantage.

And the controller is further from the application and misses a lot of
information like say the file structure, so it inherently is at a
disadvantage.

> The host gc implementation would have to be quite a bit
> better to justify the link and memory usage necessary for the copies

That assumes you still have to device GC.  If you do align to the
zone/erase (super)block/reclaim unit boundaries you don't.

> This xfs implementation also has logic to recover from a power fail. The
> device already does that if you use the LBA abstraction instead of
> tracking sequential write pointers and free blocks.

Every file system has logic to recover from a power fail.  I'm not sure
what kind of discussion you're trying to kick off here.

> I think you are underestimating the duplication of efforts going on
> here.

I'm still not sure what discussion you're trying to to start here.
There is very little work in here, and it is work required to support
SMR drives.  It turns out for a fair amount of workloads it actually
works really well on SSDs as well beating everything else we've tried.

