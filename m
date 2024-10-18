Return-Path: <io-uring+bounces-3820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B85E9A4396
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C932B1C2384A
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 16:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA502038A8;
	Fri, 18 Oct 2024 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VzlrEF+s"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FFA2038AF;
	Fri, 18 Oct 2024 16:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268333; cv=none; b=B5PXGCxh+RL8te7kJM9Kf6aiJMVGLvk90qckv0KGgXNEM4QsAcpojtd4eFfFkZEtq/JV4X31ueiTJ0tj8tgUclhQ0Fxf0F3g2cKLxm/un25RBaTqCZt3mn3db4EIkQTsAHY1dBqx5jQu2dtygSZPM2vyh/HBEq1FVMoYTV1PYAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268333; c=relaxed/simple;
	bh=F323mCe8qSN2xMQlVszmsWxzyYuqUmdLoA1r7h9WV3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lDHyyw1wZi7kQxZWubs7wFDUCxniDOt/Nb663nnBMg2VtuPp/LKueZHYd5Kt+pWEmgA4xkl5DTnQcgMdgDXIzKckkCjiJtv0i3kcjtTjrsGiCHixVko46JXZa++nqNeOaV8MKHLG/NhgdADWK831O+HGlyHmpN0ekQ0o+sDPsg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VzlrEF+s; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XVVJB6FQMz6ClSq5;
	Fri, 18 Oct 2024 16:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729268319; x=1731860320; bh=UZOvWd9Qdr/ICcHkPTjBkXNp
	ReqYfNANXbD13j3yPbA=; b=VzlrEF+sa5/JCGuO0NnR/jFuALhH083kv+ExB8vk
	5YNp7M0ui1R2CJHzoDdhkiwyPJioERh7UIggGaYtodtkPsePh42DqJ8bXKa6QHXJ
	bPAKMy7Yb++Sjr4kgfPzq7g8mHdasUPcjNa8cTpPn9SQMsLla68j6NIN9vzDDTQ/
	iW9EO1yXUQ5F+YPnWDpx2p5MPmR1G7m8mnMq5iBEdkRx2o+QZCfoU4sdzbXACY42
	YwXNDesRJocfgmOMvI3FXCbJyxhoic7n6n7HLclz4pORGJE+/l7m30wzJz8szNpL
	2cBBs6Df6+FvNo/mhvljvqsiwF5Lb/CkbWFIMoKhySHXRw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id izSwHc7fHMsE; Fri, 18 Oct 2024 16:18:39 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XVVHx1z0Zz6ClV8W;
	Fri, 18 Oct 2024 16:18:36 +0000 (UTC)
Message-ID: <57798ab7-fc67-4606-900e-d221e028bd8f@acm.org>
Date: Fri, 18 Oct 2024 09:18:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 3/6] block: introduce max_write_hints queue limit
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-4-kbusch@meta.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241017160937.2283225-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 9:09 AM, Keith Busch wrote:
> Drivers with hardware that support write hints need a way to export how
> many are available so applications can generically query this.

Something is missing from this patch, namely a change for the SCSI disk
(sd) driver that sets max_write_hints to sdkp->permanent_stream_count.

> +What:		/sys/block/<disk>/queue/max_write_hints
> +Date:		October 2024
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RO] Maximum number of write hints supported, 0 if not
> +		supported. If supported, valid values are 1 through
> +		max_write_hints, inclusive.

That's a bit short. I think it would help to add a reference to the
aspects of the standards related to this attribute: permanent streams
for SCSI and FDP for NVMe.

> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index a446654ddee5e..921fb4d334fa4 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -43,6 +43,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>   	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
>   
>   	/* Inherit limits from component devices */
> +	lim->max_write_hints = USHRT_MAX;
>   	lim->max_segments = USHRT_MAX;
>   	lim->max_discard_segments = USHRT_MAX;
>   	lim->max_hw_sectors = UINT_MAX;
> @@ -544,6 +545,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>   	t->max_segment_size = min_not_zero(t->max_segment_size,
>   					   b->max_segment_size);
>   
> +	t->max_write_hints = min(t->max_write_hints, b->max_write_hints);
> +
>   	alignment = queue_limit_alignment_offset(b, start);
>   

I prefer that lim->max_write_hints is initialized to zero in
blk_set_stacking_limits() and that blk_stack_limits() uses
min_not_zero().

Thanks,

Bart.

