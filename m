Return-Path: <io-uring+bounces-4151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C399B5530
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 22:40:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F5A11C2127E
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 21:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3224B1E1A2D;
	Tue, 29 Oct 2024 21:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/gHBEen"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A301422AB;
	Tue, 29 Oct 2024 21:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730238029; cv=none; b=gGaI9TmcEKfW1I3QERlUEJPeS8TvPpt0v8snqq4kMF1QZkTL7fzAFXSkMVWNjtOJWGe8yb1doBxd5YG8dARo8KvmT1T1xCZd9uAOEVxmYQTzWjCzuanIt5IMQytnKeIyVJ1lQLM/x6vS76vj6PW87l3ID/BLq46dpZlQ3bwbw8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730238029; c=relaxed/simple;
	bh=+3gV/TRiOy547qz3zyixAW8zZPoNLgJ5Otj8t4gRJ3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKp0PUZ3ZOfnPP0yU2oq7cr03DNP2xpcsb/BxoQIW711sCqbBoLH6GEkVoAnAgh9A4syW1L3nRtL1lcKyTnsHQbVIavZXWK/w7Dhy7GOJDbmz9b0pGvrq5I6vjp4LSms08d1ApgtCVUbV6xMZNPe9hciNcJ4K3jsNi1F8Gsuimw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/gHBEen; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676B5C4CECD;
	Tue, 29 Oct 2024 21:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730238028;
	bh=+3gV/TRiOy547qz3zyixAW8zZPoNLgJ5Otj8t4gRJ3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S/gHBEenVC/id72EsFPtkZzyV1cxpAK9MzhTDh9Nm3A3BKF0ixlkdVSPX5dUa23Az
	 ZKaYRgIfUXGaH0TAYjqLoNadPQZxENmNP31SFoTzXU3sY9ONDBm8m4vdHfFKPY1mlL
	 83DNhoPShisdywWVlyZaHO11JAUkfio5rxLl+8TqEGujPEvLJw7CtzS7+bl61/xvVn
	 7GP1y8BgNMSrsPGfui3cmo2bAR+Vdv4pdl/LL2X9B8wOtWWq/t+/PabG69+FUwtyKm
	 wApywUCsvmp6HsW+TWtzSYL1FnGsm6bnYYvZbjqmMldU++MdDrtn5KrptdqX1y2e9H
	 MtRk2DcEX8Ezg==
Date: Tue, 29 Oct 2024 15:40:25 -0600
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v5 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Message-ID: <ZyFWSdeqZ_RdSQm-@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029162402.21400-1-anuj20.g@samsung.com>
 <CGME20241029163228epcas5p1cd9d1df3d8000250d58092ba82faa870@epcas5p1.samsung.com>
 <20241029162402.21400-8-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029162402.21400-8-anuj20.g@samsung.com>

On Tue, Oct 29, 2024 at 09:53:59PM +0530, Anuj Gupta wrote:
> This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
> indicate how the hardware should check the integrity payload.
> BIP_CHECK_GUARD/REFTAG are conversion of existing semantics, while
> BIP_CHECK_APPTAG is a new flag. The driver can now just rely on block
> layer flags, and doesn't need to know the integrity source. Submitter
> of PI decides which tags to check. This would also give us a unified
> interface for user and kernel generated integrity.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

