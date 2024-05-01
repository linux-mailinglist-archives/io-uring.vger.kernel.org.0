Return-Path: <io-uring+bounces-1699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 450558B86B6
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 10:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EECDA1F23EFE
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 08:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254144CE1F;
	Wed,  1 May 2024 08:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPCdRwAC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE4528DC7;
	Wed,  1 May 2024 08:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714550628; cv=none; b=uJIsLcod4M0eEaC3kUx6EbdP3W73PlEX5Bq2N8ycM7nbCmQLcu9zlEai/CjbCvFN1FE2gItDPE/a8N4nAL+IN3hbkd/co1ksq/HkCExrcynNpoxsbrtp6Rl5DmUPnUy7y9GOaPDqnydH7Vs/WJqvbEEkAdUor6h9nZew8/te+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714550628; c=relaxed/simple;
	bh=nro5vjHEyShkXn1U9q4AMDjdNsY60v/Rv0pskhrbT9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/kts6xg5lCgqBiKcYmij1q7rVkfB7sI7R/55S9I8x4oUdd3uRHboAQYGpegUOzw4HAXlqd/c968mpqtuW7+DT0qYPTn0Fz5g9CnTs1LapLDuW2HE8pMwbmMT95fIvcGGkG00ZJTY7eEaOfAyIQQsA7wt7r29464bR70P2xF/hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPCdRwAC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018DAC113CC;
	Wed,  1 May 2024 08:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714550627;
	bh=nro5vjHEyShkXn1U9q4AMDjdNsY60v/Rv0pskhrbT9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZPCdRwACNPQChTwHaH0PpotCCMc4n0IIL1cLvDzUsxvC2zFhp8B5DA2qVE/iFx+4t
	 ujjdrPeM8b9Eh4ZdFuMQ0pwIXGN1SlrBkirnF+ZQKRViFUFOoivnNyHq5VoiGAYhja
	 FP/Nr/T0G9249mVeyM8snhZhKyN66NpEJWsbP4EelXBHCNTl7AeRf5PT405qQk+1FC
	 peFvQZboAolXrFAFOclD2DiMabri5eJ0yIUDvMD+RxnHjXpOHUyQV3uwAJyMQpx445
	 v+tRQPvtmIGUWRhVwm32EKM06VBQp3gsUp/TdPYu5eV2tPLJtC3Tk/rLuk2RLwKR7g
	 MpJPuCR1M9cSg==
Date: Wed, 1 May 2024 09:03:42 +0100
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 01/10] block: set bip_vcnt correctly
Message-ID: <ZjH3XtjNx9I_6OoR@kbusch-mbp.dhcp.thefacebook.com>
References: <20240425183943.6319-1-joshi.k@samsung.com>
 <CGME20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc@epcas5p3.samsung.com>
 <20240425183943.6319-2-joshi.k@samsung.com>
 <20240427070214.GA3873@lst.de>
 <Zi0I1Aa7mIJ9tOht@kbusch-mbp.mynextlight.net>
 <20240501074544.GA2325@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501074544.GA2325@lst.de>

On Wed, May 01, 2024 at 09:45:44AM +0200, Christoph Hellwig wrote:
> On Sat, Apr 27, 2024 at 08:16:52AM -0600, Keith Busch wrote:
> > > Please add a Fixes tag and submit it separately from the features.
> > > 
> > > I'm actually kinda surprised the direct user mapping of integrity data
> > > survived so far without this.
> > 
> > The only existing use case for user metadata is REQ_OP_DRV_IN/OUT, which
> > never splits, so these initial fixes only really matter after this
> > series adds new usage for generic READ/WRITE.
> 
> Well, it matters to keep our contract up, even if we're not hitting it.
> 
> And apparently another user just came out of the woods in dm land..

But the bug report from dm has nothing to do with user mapped metadata.
That bug existed before that was added, so yeah, patch 5 from this
series (or something like it) should be applied on its own.

