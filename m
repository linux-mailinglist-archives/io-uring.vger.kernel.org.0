Return-Path: <io-uring+bounces-10955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C065CA363F
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 12:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F9C13024894
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 11:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4692E543B;
	Thu,  4 Dec 2025 11:07:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF4828727C;
	Thu,  4 Dec 2025 11:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764846438; cv=none; b=RRXwhuNCdaR/WtNd5QFHxKTNssFx2zUpXP4tyKv1ZuVipmjAvFCVKbIyUbnrphnkDh39SBCe475Ln3sbwdYQ9RkZG3NzphO5TF5/DnUa73htNP/CmoBn20LM0F3YovCLFR5e5u+1VEMpmXaDiR6qJG5lJiDS3SaYKRQexlqjsNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764846438; c=relaxed/simple;
	bh=6shrHfAvqdQGVzX5Dr3TDGVa/VUGLyV6TlblNAISCTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kr65mJJkKoHQeQpQnRNIBJgumpMztbmKOjMObc7kla7U487+8BvtmfOwJ/UV3DTA3Ttryt6ITGqeCVY80o/rFbXL8vTv2IVaz0soOsbHYpnBds5Oo7hVk65myqRiMZS4Gebnty6AaH3QcpT5QozfgUWLtcUx0JJ/2+7NJOO0l1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A036F68B05; Thu,  4 Dec 2025 12:07:09 +0100 (CET)
Date: Thu, 4 Dec 2025 12:07:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, Vishal Verma <vishal1.verma@intel.com>,
	tushar.gohad@intel.com, Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
Message-ID: <20251204110709.GA22971@lst.de>
References: <cover.1763725387.git.asml.silence@gmail.com> <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com> <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 04, 2025 at 11:46:45AM +0100, Christian König wrote:
> On 11/23/25 23:51, Pavel Begunkov wrote:
> > Add a file callback that maps a dmabuf for the given file and returns
> > an opaque token of type struct dma_token representing the mapping.
> 
> I'm really scratching my head what you mean with that?
> 
> And why the heck would we need to pass a DMA-buf to a struct file?

I find the naming pretty confusing a well.  But what this does is to
tell the file system/driver that it should expect a future
read_iter/write_iter operation that takes data from / puts data into
the dmabuf passed to this operation.


