Return-Path: <io-uring+bounces-4249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E949B6FDC
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 23:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 164961C20E00
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 22:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C781925AE;
	Wed, 30 Oct 2024 22:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOLGBIAc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B089B1BD9EA;
	Wed, 30 Oct 2024 22:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730327580; cv=none; b=QbioGjStXfMw2Le+7LPa5YtHCfhU8rNdvj6PhWHQCpbxWXRc/MLkd5H+lat5EZmluwglJZ1dLOOINvPnDHhYyIEgu/gRymMvdAZ6jJjE3r9r530pXVOLftv2YpZtu0zBp0FD3/K9xLtzxxtBqzNczl6s6qDht/LnOWiJJ1Vja1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730327580; c=relaxed/simple;
	bh=pG2dV6wbFJ9/N3Eo79eG7sTCZARua6TPwKbzaZm5T8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djjvXDPZUa9jc1MQ/hCfjx9mn5mfoacgiGgMZEYoU+pVwOztOimZwBEMJLZPJPYza5OEnRHm1NUDEFjveiEeR6Mfh+LZnDk18YtOE4i57ySfomEPCalP6rrUuaGsyrwZ/+VeUmI68bKvMCDOdZY9tnAp8bCDnHBeqxNb/2tgWv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOLGBIAc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E300C4CECE;
	Wed, 30 Oct 2024 22:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730327580;
	bh=pG2dV6wbFJ9/N3Eo79eG7sTCZARua6TPwKbzaZm5T8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TOLGBIAcEYrCYSFurialDE1/dDbk0s5VsobxcNkWosTwMWsHUtEwV2Dp6K1Bt2xB/
	 Fr9YO4uhhAZ+bYoWwuhY2pbaLrRSeZCZGIRh48gST8/NSWTSOpVy4vmedCkJGiHmok
	 evunMKCuBVIHpmHm+FOgsiNNdCqGZnbXnl58AgDLjkC3DkO9NldpetChGi52nPYqxm
	 O6ZwqatzbxIPcJW8GOiZeuM9otwid4W0Il7PCsaI1J094cFyXVVLrj2x3Yi1K/uHqf
	 pK8aowBq29IKzesQio0R+lZ1Rty5SsD0ych9kGkC73wmjtsa6CtFfbObGwNhCGncFE
	 CMtEjbWx7DpbA==
Date: Wed, 30 Oct 2024 16:32:57 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com, bvanassche@acm.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
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
> On Wed, Oct 30, 2024 at 10:42:59AM -0600, Keith Busch wrote:
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

Hold up... I absolutely appreciate the work Hans is and has done. But
are you talking about this talk?

https://lpc.events/event/18/contributions/1822/attachments/1464/3105/Zoned%20XFS%20LPC%20Zoned%20MC%202024%20V1.pdf

That is very much apples-to-oranges. The B+ isn't on the same device
being evaluated for WAF, where this has all that mixed in. I think the
results are pretty good, all things considered.
 
> I just wish we could get the real infraѕtructure instead of some band
> aid, which makes it really hard to expose the real thing because now
> it's been taken up and directly wired to a UAPI.
> one

I don't know what make of this. I think we're talking past each other.

