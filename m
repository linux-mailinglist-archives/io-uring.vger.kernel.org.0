Return-Path: <io-uring+bounces-13419-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPpYNicLDGo5UQUAu9opvQ
	(envelope-from <io-uring+bounces-13419-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 09:03:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C4B578924
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 09:03:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D317305128D
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 06:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C34439C017;
	Tue, 19 May 2026 06:57:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB98E2F7F06;
	Tue, 19 May 2026 06:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173823; cv=none; b=bFrjlxhf2xOXIxgLvcKRoZ3gAjdVgPh0kig5ZSqCDsXG3E7LR1jdrxLNjuKTQuwKpLFRTtVhF8r0DgqwY00PfalZTGbqYeEp3o1344E+obRH9kceP+NAJNplbszFrWV1oCN+EXPo04rqlmEX46QoVii15Ioye27bdhOPi1LX4Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173823; c=relaxed/simple;
	bh=DrWqQzOlBT7PBXEQ74exqA8NUZJPGXS5sd2MPD5AnkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hKrEQG56hFfwbHiwzyMNPcGRr6V5ATm8vzv/VGgQXOap2/finuRwria42SolTUr1ah87I/PmjA4qFHYeMQF14pxtuUwKwlcX/SKUoW81mZBcLYvN0Np5MRfmfoN/h771YfEWlBDdt/okG0XuEHe9tEsg1d9f63n3hYcs6wu5+OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F393168AFE; Tue, 19 May 2026 08:56:53 +0200 (CEST)
Date: Tue, 19 May 2026 08:56:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 05/10] lib: add dmabuf token infrastructure
Message-ID: <20260519065653.GB8173@lst.de>
References: <cover.1777475843.git.asml.silence@gmail.com> <c61e6d928f86f4cb253ae350272e6039faefd3a6.1777475843.git.asml.silence@gmail.com> <20260513082431.GA6461@lst.de> <ebf41920-5852-428f-b98a-e0f44c8f3315@gmail.com> <20260518125326.GA5754@lst.de> <ea47051e-697f-4017-a514-be6ef7c110e9@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea47051e-697f-4017-a514-be6ef7c110e9@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13419-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 69C4B578924
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, May 18, 2026 at 03:23:53PM +0100, Pavel Begunkov wrote:
> To be fair, it's not that dma-buf specific. This lib/ code only
> does some resv locking, fence waiting and queuing fences,

But all the dma resv/fence stuff is pretty tied into the dma-buf
ecosystem.  I don't think it would really apply to something not
doing DMA at all.

> otherwise
> all the attaching is done by the driver behind callbacks. Switching
> it to some memfd could be pretty simple. But The main thing it'd
> need to share is iterator handling like forwarding in the block
> layer, and it should be fine as it's already passed as a completely
> opaque object with no knowledge about pages / dma / etc. for the
> middle layers.

But none of that really sits in the current lib/ code anyway?

>> lib/ is most certainly the wrong place for something that absolutely
>> is not library functionality but directly interacts with a few
>> subsystems.
>
> It only interacts with dma-buf, and even for dma-buf attachments
> are created by the driver. Block, nvme, io_uring are users, either
> using the helpers or implementing callbacks.
>
> Ok. Let's assume for the argument's sake it's not dma-buf
> specific, if not lib/, where would you put it? I was also
> assuming that dma-buf being under drivers/ is rather a relic
> of the past rather than the desired location, hmm?

drivers/dma-buf is a pretty natural place for it, I could not thing
where else you'd place dma-buffers.  I'm not sure how hmm has anything
to do with it.

>
>
> -- 
> Pavel Begunkov
---end quoted text---

