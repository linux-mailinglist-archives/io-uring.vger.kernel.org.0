Return-Path: <io-uring+bounces-1668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 615C68B5764
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 14:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92A701C21737
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 12:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8615338D;
	Mon, 29 Apr 2024 12:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5JqlPe0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9452152F9A;
	Mon, 29 Apr 2024 12:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714392258; cv=none; b=WxGKPF5yxvTg/m4Tn1y7pdArVQ+0UjY8/d1K9jmT7KStstb/ol4lDs7soTg7LDOKTSgrZVgilXX6NlEqTXCH6chKn8QSY4W4AQSRAtOoPdUxxP+btFLrztBTYlZLtFnxy40U+GIsewExZfwstVGkobLC8Jq7rAOkoOma1eKDgKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714392258; c=relaxed/simple;
	bh=pq0lWaHsNtRjZLrmFVCuV7gCG3CV9wh1ghXCs79Y358=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdjZE75yh2f0QIeCjllBr27pgABueDsblTAnjFLzW2aZCS7tqBFNL2vuaXos/3pYsPDrSyNUAPF9O9r2aueRadm+YVU7otvBigyY6s6EEUUHjq1sHKwa+TZ4FGACKS2hQI0g8z943AEN/MFRAeuSRx1LTwuk4MHJ+3Eqjs85ZPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5JqlPe0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5476C113CD;
	Mon, 29 Apr 2024 12:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714392258;
	bh=pq0lWaHsNtRjZLrmFVCuV7gCG3CV9wh1ghXCs79Y358=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c5JqlPe0hBfjXVVONCFuWNbafEdLcnJJ/BHAGEYlyTei08tqypytDGESojmRHUZeQ
	 T1di+VQmX+gAC7drHWz8Oehh8U1hYlnrJFH/nT793f1JKrsdB7JyxF7ms4cZRnZdEe
	 wHMm7fM0Gnf7VQ/+Q6pOQqN+NO1/XbTnYY1lWRd0MF9AqxjFIxexUilMX/IuzTEU++
	 AaoEZIoxE0oRO6JXBtiHrZyPO/wsqgJeM1lZoaQ0SWR0uMOmRb/WIv5iBicDiIx+fN
	 ExkL2u6FeipIU6tPDfIqtx+OFLxgy/boO078TCNJoyCkuGdybMchMaqZk5BjqEJlJS
	 1zQt7IdBKMi+A==
Date: Mon, 29 Apr 2024 13:04:12 +0100
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	martin.petersen@oracle.com, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 02/10] block: copy bip_max_vcnt vecs instead of bip_vcnt
 during clone
Message-ID: <Zi-MvOZ_bYVuiuBb@kbusch-mbp.mynextlight.net>
References: <20240425183943.6319-1-joshi.k@samsung.com>
 <CGME20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7@epcas5p2.samsung.com>
 <20240425183943.6319-3-joshi.k@samsung.com>
 <20240427070331.GB3873@lst.de>
 <73cc82c3-fbf6-ea3e-94ec-3bdce55af541@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73cc82c3-fbf6-ea3e-94ec-3bdce55af541@samsung.com>

On Mon, Apr 29, 2024 at 04:58:37PM +0530, Kanchan Joshi wrote:
> On 4/27/2024 12:33 PM, Christoph Hellwig wrote:
> >> If bio_integrity_copy_user is used to process the meta buffer, bip_max_vcnt
> >> is one greater than bip_vcnt. In this case bip_max_vcnt vecs needs to be
> >> copied to cloned bip.
> > Can you explain this a bit more?  The clone should only allocate what
> > is actually used, so this leaves be a bit confused.
> > 
> 
> Will expand the commit description.
> 
> Usually the meta buffer is pinned and used directly (say N bio vecs).
> In case kernel has to make a copy (in bio_integrity_copy_user), it 
> factors these N vecs in, and one extra for the bounce buffer.
> So for read IO, bip_max_vcnt is N+1, while bip_vcnt is N.
> 
> The clone bio also needs to be aware of all N+1 vecs, so that we can 
> copy the data from the bounce buffer to pinned user pages correctly 
> during read-completion.

An earlier version added a field in the bip to point to the original
bvec from the user address. That extra field wouldn't be used in the far
majority of cases, so moving the user bvec to the end of the existing
bip_vec is a spatial optimization. The code may look a little more
confusing that way, but I think it's better than making the bip bigger.

