Return-Path: <io-uring+bounces-10958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1414CCA3BA1
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 14:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A997C300FB3D
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 13:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396AC33891F;
	Thu,  4 Dec 2025 13:10:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3D62F068A;
	Thu,  4 Dec 2025 13:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764853833; cv=none; b=InKsTruC/Fy2e9cycdeufmbiWXvsg3mnCrMRomeu5qkiRwdGqrZ59O1s9lZoIpnjHjoE/Z/dxAkzydVGqprQYtGnqfiQIsrtLtA3yg7hbJGmUFoTxjQlxXGsMYkogOBAnSPVBvVuHokd1X+jxczSoemv78az2WiC7qUFy3QyKGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764853833; c=relaxed/simple;
	bh=3PFNtXJzJmTnsBX4Iry24FL0le+T0k6756nV5CJFj+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYzNYQleTt1GpxTJSxU3WdBzA2v6XatnBO9EF11U0ETgvcfbpiJ14fggzM2iBTK/VXDfbubtGOmXFnqTuL3ZgznzD9py2gIpyGjE335hEx4nDIEF3jQm3ie+2jfLrrIwcCblrgXy7JTwFWF8jotLmKX9iKzi7L+ah1sgSb1Xz4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0DDAC68D0D; Thu,  4 Dec 2025 14:10:26 +0100 (CET)
Date: Thu, 4 Dec 2025 14:10:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>, Pavel Begunkov <asml.silence@gmail.com>,
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
Message-ID: <20251204131025.GA26860@lst.de>
References: <cover.1763725387.git.asml.silence@gmail.com> <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com> <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com> <20251204110709.GA22971@lst.de> <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 04, 2025 at 12:09:46PM +0100, Christian König wrote:
> > I find the naming pretty confusing a well.  But what this does is to
> > tell the file system/driver that it should expect a future
> > read_iter/write_iter operation that takes data from / puts data into
> > the dmabuf passed to this operation.
> 
> That explanation makes much more sense.
> 
> The remaining question is why does the underlying file system / driver
> needs to know that it will get addresses from a DMA-buf?

This eventually ends up calling dma_buf_dynamic_attach and provides
a way to find the dma_buf_attachment later in the I/O path.


