Return-Path: <io-uring+bounces-5318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD389E956E
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6971D18867D5
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 13:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF3E22B59F;
	Mon,  9 Dec 2024 12:55:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2063228C87;
	Mon,  9 Dec 2024 12:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748917; cv=none; b=I461Jklf94/5OzsZZWAYnAPmVx++xt/devtcKvV80aZvlz8+vs1tUHJ/Y4tMLHxUAVupSa1RHwdMuAO0MOUIxzAeiYAKzKP+CMxi/5YJiZTA/XvkcgOmr8G5l2JdZQZ0VbGf60TPp00Is173iSg4n9DXAoVWS0O5Ctcitz1sC0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748917; c=relaxed/simple;
	bh=ISQMp13i+XML2yrJqJzeydPpwbwjqrUhzZ9FHyUhw2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eX2pREtbE4sDf1evZZ+7pFznKwpOgPp56SBEARzZ6sI7xI1T3As6uPbuGCTLOEm2rWvLV90+2j9DiDuQRQH7JqK/TdOHWcdLx4IrkUyt6BqkB9dkAPex/zzk7casrZCLuafHAdfoLxqWwW9IkJVHJCoe1GIWrmITbcFmah4MGOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD09C68D09; Mon,  9 Dec 2024 13:55:11 +0100 (CET)
Date: Mon, 9 Dec 2024 13:55:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv12 00/12] block write streams with nvme fdp
Message-ID: <20241209125511.GB14316@lst.de>
References: <20241206221801.790690-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206221801.790690-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

I just compared this to a crude rebase of what I last sent out, and
AFAICS the differences are:

 1) basically all new io_uring handling due to the integrity stuff that
   went in
 2) fixes for the NVMe FDP log page parsing
 3) drop the support for the remapping of per-partition streams
 
conceptually this all looks fine to me.  I'll throw in a few nitpicks
on the nvme bits, and I'd need to get up to speed a bit more on the
io_uring bits before commenting useful.

One thing that came I was pondering for a new version is if statx
really is the right vehicle for this as it is a very common fast-path
information.  If we had a separate streaminfo ioctl or fcntl it might
be easier to leave a bit spare space for extensibility.  I can try to
prototype that or we can leave it as-is because everyone is tired of
the series.


