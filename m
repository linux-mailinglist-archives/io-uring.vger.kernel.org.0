Return-Path: <io-uring+bounces-3850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC4A9A6D8C
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEA5028114D
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B678B7FBC2;
	Mon, 21 Oct 2024 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0U1Wzxu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1E746447;
	Mon, 21 Oct 2024 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729523000; cv=none; b=Pvv/24V3vlUlQRAoeSeK5LQX5o1VOUzH9Lw5iTB3RWaqs23aQzcXqMFFUvBjH8sgNMb2Q3h2VK4qpQfq3w/kmpRxRduj6rpr8gQbgLp5T5cC4acWdYKH7lqS5b+w1AJlYc+BnUhDksguPcX++XNZ60oGje97ALEtUcHGCOM/3Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729523000; c=relaxed/simple;
	bh=uMevaMHFfOwTKWvSaEBMTX9OYA7bYlx5LsL/xcy9+ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGkgqdiGOLMFE7BzpnypDjqPIzRNWiN22ucJuzVVv/y8ORAF0OadXXhYzshsT4a2kDZjSj6FCoeL2odfY7jXl4EePKrkf6fDECJ3l3ThGmYRpXoCjbPlDiTSDeEQZDznHfNnogxaVSSJXatIiKk5zCT4qfKfxIVYSBLHs54GBF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0U1Wzxu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCD8C4CEC3;
	Mon, 21 Oct 2024 15:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729523000;
	bh=uMevaMHFfOwTKWvSaEBMTX9OYA7bYlx5LsL/xcy9+ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g0U1WzxuKdiRGmZu42rxm6Fq364mLH68aZor8wFJPKif5QSKycTCEHddIrqTi+fRK
	 uy8k4Th82SLFmNH93knciXQgLuaiCogF2qsn+UIS7FBIJ/IrBtRlWlfzTs1bk+wdtY
	 pThOMz1lv6W+nnHIu9ScwLM+0p4T7EKkn3B5TvK4vLK9ySULTNY9bIo/EqTr+4S8Kr
	 hjl/K/ZSkb4wQ0FeeR/leluSEd+7iXLxttrJ5fT8JKwiXFsb221G+vtgEy/T4WINMf
	 hw/Yba9C8Du6UVhX02Qp1PJQHN68In+bw4XcaEqVTEYO77RD98rDPiQUpgjE+BUKF2
	 JPuvjFCVjzUvg==
Date: Mon, 21 Oct 2024 09:03:17 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCHv8 2/6] block: use generic u16 for write hints
Message-ID: <ZxZtNR5fGlbwD7T9@kbusch-mbp>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-3-kbusch@meta.com>
 <d09efed0-c1d2-4c7b-a893-0c7367d1a420@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d09efed0-c1d2-4c7b-a893-0c7367d1a420@acm.org>

On Fri, Oct 18, 2024 at 09:12:20AM -0700, Bart Van Assche wrote:
> On 10/17/24 9:09 AM, Keith Busch wrote:
> > @@ -156,7 +155,7 @@ struct request {
> >   	struct blk_crypto_keyslot *crypt_keyslot;
> >   #endif
> > -	enum rw_hint write_hint;
> > +	unsigned short write_hint;
> 
> Why 'u16' for ki_write_hint and 'unsigned short' for write_hint? Isn't
> that inconsistent?

It's consistent with the local convetion of the existing structs. Some
use unsiged short, others use u16. It looks weird to mix the types
within the same struct.

