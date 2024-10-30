Return-Path: <io-uring+bounces-4225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA389B6AF5
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:24:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4E271F21E40
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368D11BD9F4;
	Wed, 30 Oct 2024 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8U1HDtU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D651BD9D1;
	Wed, 30 Oct 2024 17:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730309008; cv=none; b=pkD+TaGXJgfMbalM/dgJw9l9luvgIv9VQoZjANYxFS5vPHPj3t4C6ty2/yHak6DcY+RHN/HoU8m+xeDOnwcbSaYMtkAsJraeioxf4mfR4P5nI8x/CB4qXEqPCDFN1Opu10+cuAFAVlz6EZGW4SBRb3vE88DBTLb+3LBwgxb240I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730309008; c=relaxed/simple;
	bh=6IqeD9OR8grEFIquAlG+eKQrDyJFCloHUWc1o9RKuUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOsP0TTgsRaGU+HNSm5VbeN5pr6qCuNSZUdXgHk8i6EleIQ4k2SnekL8sNqFGAwUBCaiGr92wH59I1dc99OlYIq8CFCDPA7B9oSEfJtLCq5iF1x00GkObPFPRirY2YBXmjPHWfm5gDKwL5LjwoB+UM3k7xZJQWiObsdDXZ5LfZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8U1HDtU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A931AC4CECE;
	Wed, 30 Oct 2024 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730309005;
	bh=6IqeD9OR8grEFIquAlG+eKQrDyJFCloHUWc1o9RKuUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c8U1HDtUMehii0vbt7n5UMBQ7tiCAXpqPof9Ag1fL4SSGBjdfJSTa8XVyZgOGPSfY
	 iEGhqZYO6CvAMk5G0h+p+fujQ67rChs5InFn5Q66g1yUcAdwc7oaHqHMCtx0OwtmS2
	 hpIXJxfb1wDtJ2mGPcZ6RdsogLsJr2UvP4KG8vvzbkYS5i18RW1VysWRywVnMJ2ipW
	 Xgj4zFUbb/K6aJOQeY5xkotMciWJO+Tzr1xjE1cC6J4COwk73lWqDekE5YWbT3K8hr
	 EiUWD43kgEeTJrE6ihcrgPgKApivC0DytrXs5AHhe0gFKbe2drRlDQTo5t4Q+0ZBfh
	 WHiU4fXH82brw==
Date: Wed, 30 Oct 2024 11:23:22 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyJriq2jZ4ZG-UAC@kbusch-mbp.dhcp.thefacebook.com>
References: <ZyEBhOoDHKJs4EEY@kbusch-mbp>
 <20241029155330.GA27856@lst.de>
 <ZyEL4FOBMr4H8DGM@kbusch-mbp>
 <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com>
 <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
 <20241030155052.GA4984@lst.de>
 <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
 <20241030165708.GA11009@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241030165708.GA11009@lst.de>

On Wed, Oct 30, 2024 at 05:57:08PM +0100, Christoph Hellwig wrote:
> > On Wed, Oct 30, 2024 at 04:50:52PM +0100, Christoph Hellwig wrote:
> 
> > It sets temperature hints for different SST levels, which already
> > happens today. The last data point made some minor changes with
> > level-to-hint mapping.
> 
> Do you have a pointer to the changes?

The change moves levels 2 and 3 to "MEDIUM" (along with 0 and 1 already
there), 4 to "LONG", and >= 5 remain "EXTREME".

WAL continues to be "SHORT", as before.
 
> > Without FDP:
> > 
> > WAF:        2.72
> > IOPS:       1465
> > READ LAT:   2681us
> > UPDATE LAT: 3115us
> > 
> > With FDP (rocksdb unmodified):
> > 
> > WAF:        2.26
> > IOPS:       1473
> > READ LAT:   2415us
> > UPDATE LAT: 2807us
> > 
> > With FDP (with some minor rocksdb changes):
> > 
> > WAF:        1.67
> > IOPS:       1547
> > READ LAT:   1978us
> > UPDATE LAT: 2267us
> 
> Compared to the Numbers Hans presented at Plumbers for the Zoned XFS code,
> which should work just fine with FDP IFF we exposed real write streams,
> which roughly double read nad wirte IOPS and reduce the WAF to almost
> 1 this doesn't look too spectacular to be honest, but it sure it something.
> 
> I just wish we could get the real infraѕtructure instead of some band
> aid, which makes it really hard to expose the real thing because now
> it's been taken up and directly wired to a UAPI.
> one

This doesn't have to be the end placement streams development. I
fundamentally disagree that this locks anyone in to anything.

