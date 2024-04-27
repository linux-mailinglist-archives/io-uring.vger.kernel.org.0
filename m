Return-Path: <io-uring+bounces-1659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9553F8B44C1
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 09:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53D111F22A4B
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 07:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA08376EC;
	Sat, 27 Apr 2024 07:19:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F504085C;
	Sat, 27 Apr 2024 07:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714202349; cv=none; b=YnkCCNH65IfmovePFoR0I4lha7XGUGZ54136HP3vOMn4qE2slvhKujDLJVZNMv44ax2TM6EQmMh7bZEkyXt354Jtp2+G3gSLVmPQZmpEJkh1PPJn6gblbTu+bxAZVtrZj3hLPS6qZBS2IwvA77CU7X1YpsddOgCG67vCRnPlD2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714202349; c=relaxed/simple;
	bh=JzA9tDsRL6kwYGuH7IR+rnBRxGESQX3Ax2eG72Wu8DQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvdoj+rEwn20gBhkeEJuMtl7Y1g+74GD5XMom69WjhNufk7EjOtIsj58PLXD4lnWzLU1UEXpAIa2E7B1j8fEPtWTRTrbPO5w0xR/T0x0O0TwRnQEIHzmmWnGzjTP0NLhkunY4p64OkNxyFH0MhVTRe5MHGxBkylRktSBs0aXpYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 44AAF68AFE; Sat, 27 Apr 2024 09:19:04 +0200 (CEST)
Date: Sat, 27 Apr 2024 09:19:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org, asml.silence@gmail.com,
	dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 06/10] block: modify bio_integrity_map_user argument
Message-ID: <20240427071903.GF3873@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184702epcas5p1ccb0df41b07845bc252d69007558e3fa@epcas5p1.samsung.com> <20240425183943.6319-7-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425183943.6319-7-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 26, 2024 at 12:09:39AM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> This patch refactors bio_integrity_map_user to accept iov_iter as
> argument. This is a prep patch.

Please put the fact that you pass the iov_iter into the subject, and
use the main commit message to explain why.


