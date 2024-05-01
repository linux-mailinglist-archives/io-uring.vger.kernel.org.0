Return-Path: <io-uring+bounces-1696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFE78B8644
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 09:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 329A3B22258
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 07:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB80A4D135;
	Wed,  1 May 2024 07:45:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A44AEF0;
	Wed,  1 May 2024 07:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549553; cv=none; b=Z9SqnjeDvDdxxvoyC4v0Gl9xkH5e/pG/RLjNm8yzUwklNM0IZ7j8TKslQK6LoAJtSTgvRhmV2QveiL2J/XMo4ruqtHexl62ARdRnSrwEiKLOwlo6dtT9BdDBa1qWG/wws8bDiYcqkf9GOfb14VXRADWxK/GQrHa0tvuuozdzW0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549553; c=relaxed/simple;
	bh=0cqJx193OjqEaWVpBvGX2MAx65Um0oXXM2Tpcdxj3lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qeuWaVkOMXpK7B1QvZsMEYC8aoPkMOsiC7EjDlLbbGRf1bexJwmV2GB96DYcgKS0HC1sJAHmY6lU5qrG+HFCGz/NjJAOOD9uDAcbU4XMzFnoXnvDfuoFQPEqqBQGnfKAzW8VZlc2Kpl+XTcjTqGy+foZf46FLXCBCYhDwEQvVj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1D9F227A87; Wed,  1 May 2024 09:45:45 +0200 (CEST)
Date: Wed, 1 May 2024 09:45:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	axboe@kernel.dk, martin.petersen@oracle.com, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 01/10] block: set bip_vcnt correctly
Message-ID: <20240501074544.GA2325@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc@epcas5p3.samsung.com> <20240425183943.6319-2-joshi.k@samsung.com> <20240427070214.GA3873@lst.de> <Zi0I1Aa7mIJ9tOht@kbusch-mbp.mynextlight.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zi0I1Aa7mIJ9tOht@kbusch-mbp.mynextlight.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Apr 27, 2024 at 08:16:52AM -0600, Keith Busch wrote:
> > Please add a Fixes tag and submit it separately from the features.
> > 
> > I'm actually kinda surprised the direct user mapping of integrity data
> > survived so far without this.
> 
> The only existing use case for user metadata is REQ_OP_DRV_IN/OUT, which
> never splits, so these initial fixes only really matter after this
> series adds new usage for generic READ/WRITE.

Well, it matters to keep our contract up, even if we're not hitting it.

And apparently another user just came out of the woods in dm land..

