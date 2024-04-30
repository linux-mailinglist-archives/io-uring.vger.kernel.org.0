Return-Path: <io-uring+bounces-1680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 131868B6CC4
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 10:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD22D283DD5
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 08:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3F67D3F4;
	Tue, 30 Apr 2024 08:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYiA8rgX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F587BB01;
	Tue, 30 Apr 2024 08:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714465543; cv=none; b=WuyTeJ2eduFCx8gMPLofZrtmEumoR4If5IaDER0vCQm5eQX7gmkrlZWIwnIZLqJAbjmMKu6pdDBD3WJ/wTFKVZTf7YaAI8FPEt6a7q4a8eQ6G4bxCTklWBWPwvurnjXLtcK/JrihhLcIlglSx1iMZg/GuZ58cCIcS0KJ/+W87kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714465543; c=relaxed/simple;
	bh=Y/sjR08e/Huau+7cIoWgrNdMy6qgZ4syIBJ/vQzG5CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsQY0wXM8/YjjpFTbz6ES011M+v44R2KaE/sQ0ksXYtON+yyXcoErTV8PMFRTB17PJF2jYemjpQRgHoJIqmTSAbVvDuMFbkAj3PjRMr6ehZzlXT7L1j2C/Uet6g0BaMEO4S4vA/MDfPQ2whujK+Sxq76SBNajgrfPjFXGlVwvKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYiA8rgX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA702C2BBFC;
	Tue, 30 Apr 2024 08:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714465543;
	bh=Y/sjR08e/Huau+7cIoWgrNdMy6qgZ4syIBJ/vQzG5CY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GYiA8rgXJV4+2zkPPV1eNSN3QK38TuQYFcU9knAy/f8HyMk4rJ0M1YdowO02l1100
	 5TBiga/Xu+GojvGaEsBpTQbC8XdB2EwikYuU+0dzJsmI4jWyVUxk4ygys+aItzPycs
	 ChUkPBT+jc67axR8ECZIlECW9DlPG1938IptIzufZ/v55B/C35YdNHxVzH3X0ACcDx
	 0L7ds01EEW8jrwTgaGBEN2fiEQyJ0OEhEcH0yOuXbVaGOglsyDqvN4OIERglD8eYLC
	 wlbxamAddIQ+5tRwnrDmrbx+H2EAo2PDyvWnadEhRtNrg1NtYIAWVPvESDh6gNPFrG
	 E1MMzPCbva6+g==
Date: Tue, 30 Apr 2024 09:25:38 +0100
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 02/10] block: copy bip_max_vcnt vecs instead of bip_vcnt
 during clone
Message-ID: <ZjCrAkM8oOgLhg8_@kbusch-mbp.dhcp.thefacebook.com>
References: <20240425183943.6319-1-joshi.k@samsung.com>
 <CGME20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7@epcas5p2.samsung.com>
 <20240425183943.6319-3-joshi.k@samsung.com>
 <20240427070331.GB3873@lst.de>
 <73cc82c3-fbf6-ea3e-94ec-3bdce55af541@samsung.com>
 <Zi-MvOZ_bYVuiuBb@kbusch-mbp.mynextlight.net>
 <20240429170728.GA31337@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429170728.GA31337@lst.de>

On Mon, Apr 29, 2024 at 07:07:29PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 29, 2024 at 01:04:12PM +0100, Keith Busch wrote:
> > An earlier version added a field in the bip to point to the original
> > bvec from the user address. That extra field wouldn't be used in the far
> > majority of cases, so moving the user bvec to the end of the existing
> > bip_vec is a spatial optimization. The code may look a little more
> > confusing that way, but I think it's better than making the bip bigger.
> 
> I think we need to do something like that - just hiding the bounce
> buffer is not really maintainable once we get multiple levels of stacking
> and other creative bio cloning.

Not sure I follow that. From patches 2-4 here, I think that pretty much
covers it. It's just missing a good code comment, but the implementation
side looks complete for any amount of stacking and splitting.

