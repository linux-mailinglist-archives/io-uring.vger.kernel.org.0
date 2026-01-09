Return-Path: <io-uring+bounces-11558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9DB5D07479
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 06:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 929B23019B4E
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 05:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0B128E579;
	Fri,  9 Jan 2026 05:59:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7B728980E;
	Fri,  9 Jan 2026 05:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767938339; cv=none; b=dZKx/7eJ9VXkwWCCZIg/4aK541iPG+UWTUXCouf7ylZJM5/IAOFHaGtQxm1P85RqejbaxXcByw4RyNPFS0pymSkEqwFctId3mTHYxYtEmZ2PvT5c0Y4c3GVrNpMwjM8MCSiMKXDWU3Yo/xma+ptNjgrlxBuWuhtM6go7QeZ5rgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767938339; c=relaxed/simple;
	bh=4hdPP5MhlGBAu6qQNs0gC655H5dyFIDLruCW9JRtAtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMyzzXThkinwq2zCzEp8ryx1p2CcEhLox1NYg/q47rDtuL7rv62qB5/gXJaTv+p4vf4ttnhgJJwXMQ8njgTVTm7aXY5kYzT5cp6wBTPnYecJ6kw3F4r2C/F3a/IMvZCtpIcpbNo7PQsRl65LwpeUEAKTNlzf8ntjtj8kppEEjY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ADFF367373; Fri,  9 Jan 2026 06:58:52 +0100 (CET)
Date: Fri, 9 Jan 2026 06:58:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
Message-ID: <20260109055852.GA5063@lst.de>
References: <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com> <20251204110709.GA22971@lst.de> <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com> <20251204131025.GA26860@lst.de> <aVnFnzRYWC_Y5zHg@fedora> <754b4cc9-20ab-4d87-85bf-eb56be058856@amd.com> <20260107160151.GA21887@lst.de> <aV8UJvkt7VGzHjxS@fedora> <20260108101703.GA24709@lst.de> <aWBjsa2RZ_uaO9Ns@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWBjsa2RZ_uaO9Ns@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 09, 2026 at 10:10:57AM +0800, Ming Lei wrote:
> On Thu, Jan 08, 2026 at 11:17:03AM +0100, Christoph Hellwig wrote:
> > On Thu, Jan 08, 2026 at 10:19:18AM +0800, Ming Lei wrote:
> > > > The feature is in no way nvme specific.  nvme is just the initial
> > > > underlying driver.  It makes total sense to support this for any high
> > > > performance block device, and to pass it through file systems.
> > > 
> > > But why does FS care the dma buffer attachment? Since high performance
> > > host controller is exactly the dma buffer attachment point.
> > 
> > I can't parse what you're trying to say here.
> 
> dma buffer attachment is simply none of FS's business.

The file systems should indeed never do a dma buffer attachment itself,
but that's not the point.

> > But even when not stacking, the registration still needs to go
> > through the file system even for a single device, never mind multiple
> > controlled by the file system.
> 
> dma_buf can have multiple importers, so why does it have to go through FS for
> single device only?
>
> If the registered buffer is attached to single device before going
> through FS, it can not support stacking block device, and it can't or not
> easily to use for multiple block device, no matter if they are behind same
> host controller or multiple.

Because the file system, or the file_operations instance to be more
specific, is the only entity that known what block device(s) or other DMA
capable device(s) like (R)NIC a file maps to.

