Return-Path: <io-uring+bounces-11429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6468CCFC2BC
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 07:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7284130021E4
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 06:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF87813959D;
	Wed,  7 Jan 2026 06:18:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E93C2F;
	Wed,  7 Jan 2026 06:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766739; cv=none; b=BsrlUWmd6eVRmElOFuL1X45Ro0J8PyPJ9EZvBQFXwzVsKaCbfWuyWh6VILXi84JICVC7hDfgPXvuRMQQzsuL3SjBa2z16WmeyqJ9oP8WmW/LPlbPmxIQWF2tLW8oRoRSlnHMgk+AsowyaXfhQNxCZidDFbfFvntsL9j+977ZqGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766739; c=relaxed/simple;
	bh=K2HV4jj+W4Ahhy1KrtksAp7WwoV9zGOT+igW03S/DyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxGxsiPBJKneSdhsF8HywTnT73GW8zREvw8qc0Jej2qd6/0pM0v+52UmnvRIRC2KH+xN9x9T71Kpzd46OYMwjM1tlkRLJgZ5mzpt2nMuJF4OG8xNv4SkaO7dd30jGWS1JQccRiCsmdoJNtavQ1Hicum0k/woKAuUHIt6eSXbnFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3B3B6227A87; Wed,  7 Jan 2026 07:18:52 +0100 (CET)
Date: Wed, 7 Jan 2026 07:18:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
Message-ID: <20260107061851.GA15324@lst.de>
References: <cover.1763725387.git.asml.silence@gmail.com> <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com> <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com> <20251204110709.GA22971@lst.de> <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com> <20251204131025.GA26860@lst.de> <aVnFnzRYWC_Y5zHg@fedora> <a96e327d-3fef-4d08-87e9-c65866223967@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a96e327d-3fef-4d08-87e9-c65866223967@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 06, 2026 at 07:51:12PM +0000, Pavel Begunkov wrote:
>> But I am wondering why not make it as one subsystem interface, such as nvme
>> ioctl, then the whole implementation can be simplified a lot. It is reasonable
>> because subsystem is exactly the side for consuming/importing the dma-buf.
>
> It's not an nvme specific interface, and so a file op was much more
> convenient.

It is the much better abstraction.  Also the nvme subsystems is not
an actor, and registering things to the subsystems does not work.
The nvme controller is the entity that does the dma mapping, and this
interface works very well for that.


