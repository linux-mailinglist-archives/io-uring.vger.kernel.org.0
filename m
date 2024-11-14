Return-Path: <io-uring+bounces-4677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4CD9C81E3
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 05:16:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F061CB22619
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 04:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5E642052;
	Thu, 14 Nov 2024 04:16:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE1013D53E;
	Thu, 14 Nov 2024 04:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731557770; cv=none; b=Co+wHj9c2mcsWYNG8vT7m+zzZ2hpDLs2vZsTaBHW7rur7ZgHKn6HeLVz9ZpoQkwl7XwZyd5Je7eugklQWv4V4qRcGwU/6pzh+xjrb3ml+VgJOYcUrJuNc8RMKKS02vDI2RPhrV5FUAkwBbxtdAL2TNP4x/APfR8xLgwDkeD0gJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731557770; c=relaxed/simple;
	bh=qXbJLp+yZAzg8AJsxlwMlfISBXHRjhQwwo5oOaZIgMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VU9Nu79pRA7XOogAQCXjPNzRYCjhRXFmj3uVc70bjaHI2zY+h4JMlMZh7AH7VA66GjmPmCFKGoVpSyJc7Ub9hMUZS/l75yguvvaeNteNbB1LXqhzb3q2fzobxU51Hyy/1qbUee4jV5VZzcRM3SCTBMh5b9VvLKHitdQbgJ/XrcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0540268D0A; Thu, 14 Nov 2024 05:16:04 +0100 (CET)
Date: Thu, 14 Nov 2024 05:16:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: don't reorder requests passed to ->queue_rqs
Message-ID: <20241114041603.GA8971@lst.de>
References: <20241113152050.157179-1-hch@lst.de> <eb2faaba-c261-48de-8316-c8e34fdb516c@nvidia.com> <2f7fa13a-71d9-4a8d-b8f4-5f657fdaab60@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f7fa13a-71d9-4a8d-b8f4-5f657fdaab60@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 13, 2024 at 01:51:48PM -0700, Jens Axboe wrote:
> Thanks for testing, but you can't verify any kind of perf change with
> that kind of setup. I'll be willing to bet that it'll be 1-2% drop at
> higher rates, which is substantial. But the reordering is a problem, not
> just for zoned devices, which is why I chose to merge this.

So I did not see any variation, but I also don't have access to a really
beefy setup right now.  If there is a degradation it probably is that
touching rq_next for each request actually has an effect if the list is
big enough and they aren't cache hot any more.  I can cook up a patch
that goes back to the scheme currently used upstream in nvme and virtio
that just cuts of the list at a hctx change instead of moving the
requests one by one now that the block layer doesn't mess up the order.


