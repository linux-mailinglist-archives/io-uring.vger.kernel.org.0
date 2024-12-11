Return-Path: <io-uring+bounces-5429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 162BA9EC568
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 08:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 383F918897F1
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 07:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F7D1BEF75;
	Wed, 11 Dec 2024 07:13:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E721C2443;
	Wed, 11 Dec 2024 07:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733901238; cv=none; b=bfMEpHB2s9kPiscpC2DRqSa8CUh2Qr+VP/rDB9n987IicpAH4EAZXgMGEfCzXhpjCoUDTHvPmtQmBIlcS01OVG9l78BAfKBf9SUpvaUh1px5iVYE3WauJlu2QM2TQ9pX18uhJ6LRcM1NIh72Gk4zv9RYi/c66CkX8LIPuisJOAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733901238; c=relaxed/simple;
	bh=1sOlw5z6UsMyq7zN233vhG/ASxdlBvjI1f0NzdMTRqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLRE+LGiXzMwOMGtYoGLShzPpI1+MstRWYmhpHiaQgMvq0oOb4ZsIgImW0ZOQqJxzpDStKFP+I7VZnC7juh77TO48D8qrN/DBF8jsBqwtrjoO9bd4UCcoOOllsseXcfgotgBUoqvTzIRIorrWdme/1q5Y8jkroPlDGC/Ln/ZCAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1410E68D12; Wed, 11 Dec 2024 08:13:51 +0100 (CET)
Date: Wed, 11 Dec 2024 08:13:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv13 00/11] block write streams with nvme fdp
Message-ID: <20241211071350.GA14002@lst.de>
References: <20241210194722.1905732-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210194722.1905732-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 10, 2024 at 11:47:11AM -0800, Keith Busch wrote:
> Changes from v12:

The changes looks good to me.  I'll ty to send out an API for querying
the paramters in the next so that we don't merge the granularity as dead
code, but I'll need a bit more time to also write proper tests and
stuff.  For that it probably makes sense to expose these streams using
null_blk so that we can actually have a block test.  If someone feels
like speeding things up I'd also be happy for someone else to take
that work.


