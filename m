Return-Path: <io-uring+bounces-11440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B66CFEDB3
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 17:26:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72FCE314A0BA
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 16:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7314318B90;
	Wed,  7 Jan 2026 16:02:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BEF3A89A9;
	Wed,  7 Jan 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801733; cv=none; b=OjKt9juAptk26FHkRiSRms+WxepZS0jwMjhlupoMvkk+67xpAJyc2a5rX3g/0gjc/3gmj/QMNA209dkxnG//VBVBw8vz4vZ5/+FiDoAGJ5Xth6YYnQlnPgykRv02CM+qbkwjn/ueXUuWC49NNzIjlq/RdTKTcypqEOeBzaJKfTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801733; c=relaxed/simple;
	bh=x0JIweeKnhzsIrSSoe0lNzCEnwjXJ48x2cBRuxek93Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PlooZrRo0w8LsIFTxvDB/PNrBHefiQxPW6YKpXVAxe7AeLxDTtdlzv4KJW/B5deTkHl9eRUYNahQozhV5jviFa6U+wnBkNbkc2wMtCrGNSeZO+jPk15+rMFklaAsuRZxLOfVe315sDxv2ArMCjECI1Xq+GqxlgbWxJH5zoNBwEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9186227A87; Wed,  7 Jan 2026 17:01:51 +0100 (CET)
Date: Wed, 7 Jan 2026 17:01:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20260107160151.GA21887@lst.de>
References: <cover.1763725387.git.asml.silence@gmail.com> <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com> <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com> <20251204110709.GA22971@lst.de> <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com> <20251204131025.GA26860@lst.de> <aVnFnzRYWC_Y5zHg@fedora> <754b4cc9-20ab-4d87-85bf-eb56be058856@amd.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <754b4cc9-20ab-4d87-85bf-eb56be058856@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 07, 2026 at 04:56:05PM +0100, Christian König wrote:
> > But I am wondering why not make it as one subsystem interface, such as nvme
> > ioctl, then the whole implementation can be simplified a lot. It is reasonable
> > because subsystem is exactly the side for consuming/importing the dma-buf.
> 
> Yeah that it might be better if it's more nvme specific came to me as well.

The feature is in no way nvme specific.  nvme is just the initial
underlying driver.  It makes total sense to support this for any high
performance block device, and to pass it through file systems.


