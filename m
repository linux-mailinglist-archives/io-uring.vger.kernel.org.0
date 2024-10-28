Return-Path: <io-uring+bounces-4061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E44A9B2F4E
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 12:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 609ED1C21194
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 11:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865C81D5CE0;
	Mon, 28 Oct 2024 11:52:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C7B1D3648;
	Mon, 28 Oct 2024 11:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730116338; cv=none; b=Qgw+U1INrtR0InZHyiQxiKOrnvOde/OU7l/7SBG6Hb9ZlOI9zVBJ6uRs1JtUsFR4zjYYUTQshnqzj/g2Oa0S7SiR/UDsAd8YD2Hj0tBnXohQ+MBXfDBYDpA3Bo3UvgxYzqjwAnVN3F4ckrJs1gZrvNaNkHX8OZQVA/X56OwwLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730116338; c=relaxed/simple;
	bh=xHJshYMEAAqFpk4DGVr2vhdJrMNlZN33YJioTMXoX5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yx47fKrlVrcEg8RxFeeIm1GTlOZH8jTACJLNFPW/1lOUotyWk+ElyoEwM4aXEh3lEaryRDfFl8XrSprRef1Ow1zAOA0yNS7v7dUOy9svV10cka1s3AHFze6rizmF0HQ3O12qTvJhHYAnAJr1fQOSVVeN3EYWipvEUL7SwZxZpdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D7A58227AAC; Mon, 28 Oct 2024 12:52:12 +0100 (CET)
Date: Mon, 28 Oct 2024 12:52:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
	javier.gonz@samsung.com, bvanassche@acm.org,
	Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv9 2/7] block: introduce max_write_hints queue limit
Message-ID: <20241028115211.GC8517@lst.de>
References: <20241025213645.3464331-1-kbusch@meta.com> <20241025213645.3464331-3-kbusch@meta.com> <20241028115132.GB8517@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028115132.GB8517@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 28, 2024 at 12:51:32PM +0100, Christoph Hellwig wrote:
> As pointed out by Bart last time, you can't simply give the write hints
> to all block device.  Assume we'd want to wire up the write stream based
> separate to f2fs (which btw would be a good demonstration), and you'd
> have two different f2fs file systems on separate partitions that'd
> now start sharing the write streams if they simply started from stream
> 1.  Same for our pending XFS data placement work.

And I'm an idiot and should have looked at the next patch patch first.
Sorry for that.

