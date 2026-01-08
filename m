Return-Path: <io-uring+bounces-11514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B09D02230
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 11:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3F3730E1166
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 10:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44FC93A0B2E;
	Thu,  8 Jan 2026 10:17:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA1139E6E3;
	Thu,  8 Jan 2026 10:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767867439; cv=none; b=EjFYsVWgmLzeH6KmJN9Htjr3vwnSCRkMa3KW0OCanSNIWWRGn6PfrEsZy1OiohfWqjwRJSW5Om8xzNxQFyj+GFSZz7mibuswPxilW0doCM6NjUYmn+VGZrRMrWT3Ycef0v9J6TUh4Tcjh62msZHnxMEFyIHnBpsTkvHrHvShxRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767867439; c=relaxed/simple;
	bh=ODGdH7RlSR+dio8YcadH4b5hAYSaRoEE5ObchUQmYbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ry+Vcbfw2VmEjeU6qx0baHYoHbB0bsqLuK82kJQvZgDpIprwZUjuhl3zwcLlpZfVwPW6jWrUBwDJhLP7oEtC7yCRPreJjHQDCNFDuiceK72FEF7muE0XAncTIZGZoWLj/DexOU0GcJJIs2/OsKcQUSA4/p79DXhTSv7XVx+et2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E3BE3227A87; Thu,  8 Jan 2026 11:17:03 +0100 (CET)
Date: Thu, 8 Jan 2026 11:17:03 +0100
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
Message-ID: <20260108101703.GA24709@lst.de>
References: <cover.1763725387.git.asml.silence@gmail.com> <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com> <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com> <20251204110709.GA22971@lst.de> <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com> <20251204131025.GA26860@lst.de> <aVnFnzRYWC_Y5zHg@fedora> <754b4cc9-20ab-4d87-85bf-eb56be058856@amd.com> <20260107160151.GA21887@lst.de> <aV8UJvkt7VGzHjxS@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV8UJvkt7VGzHjxS@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 08, 2026 at 10:19:18AM +0800, Ming Lei wrote:
> > The feature is in no way nvme specific.  nvme is just the initial
> > underlying driver.  It makes total sense to support this for any high
> > performance block device, and to pass it through file systems.
> 
> But why does FS care the dma buffer attachment? Since high performance
> host controller is exactly the dma buffer attachment point.

I can't parse what you're trying to say here.

> If the callback is added in `struct file_operations` for wiring dma buffer
> and the importer(host contrller), you will see it is hard to let it cross device
> mapper/raid or other stackable block devices.

Why?

But even when not stacking, the registration still needs to go
through the file system even for a single device, never mind multiple
controlled by the file system.


