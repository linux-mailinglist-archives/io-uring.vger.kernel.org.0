Return-Path: <io-uring+bounces-4083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A01859B362F
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 17:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFDD61C24FEF
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10011DE883;
	Mon, 28 Oct 2024 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W0dqk1Ds"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9FD1DE892;
	Mon, 28 Oct 2024 16:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730132001; cv=none; b=sbHuNzk3ceBgxx9BTzU7ZqnOxDMSukHqrRD/1Q0/6kTOusAVyj7hxCZc/rGEpmjVsZr6Ypz1C9gsHxW4KQ9d6ntjTQ0OIx1uAEOoROLOhyg1lTxphYSehcTzwiN//9k3NT9wgEcfMZ0D9VeMNtQJRIVqaZCyxSw0u9SHPrpeEU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730132001; c=relaxed/simple;
	bh=Rj7dAa97W4f4nsy3wpoOstotuVQdhoO58XJVBGQXGgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F5aCJCK71sIpIC686awDWVUvTDomklHdkx1D2n4obbZ/49EqLJ0qXa+zdyynG3qOPPEYhsLyL6YAw/2m4HTH9kBMAVT19GXB7adUFbk47y6AviWwb1KuhHsk4l5qufB4BRNLGzvHk/YtwSpnQs+K2OaeOZsoPndbvEJCZ58W0dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W0dqk1Ds; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xcdj53kxVzlgVnY;
	Mon, 28 Oct 2024 16:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730131990; x=1732723991; bh=aVIfM6ADLRrW2ddhkhRN1Ajj
	S03IN19K19H+CtsbWaU=; b=W0dqk1DsslaMtQqRUmYfCegGOqGHrqnDrBsmojNg
	gIK38JxDgmg9hSczFGVpBQ+VMchq05YeATWBuU/ttAFAxocaqf0NvdPrfjsP+jvB
	sNphj7PLtS9+uCjWq9gDoR6/HZ52a+D9FFe3Eerfk44lAlErzTVCIjRUrmK1bSih
	Iy3M1dfEs4ejypA41t9GfZYJ3tE13m83o+JpgpPAiFl5PB9ZpmcwBzfBuWGqKIJp
	SCnmsX/A3fuIqK+HW/thaWRFwjddUyjB+06oy94SByPou5AkmgfOOreyiyADV7tP
	t9jRAePD4uGb1SHVlYx5E6tnUZYSAHi0/DirZru94rycow==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EpRxxZ74yApD; Mon, 28 Oct 2024 16:13:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xcdj06BCKzlgMVd;
	Mon, 28 Oct 2024 16:13:08 +0000 (UTC)
Message-ID: <e83cfc72-029f-4ab1-b8e4-56732585e9fd@acm.org>
Date: Mon, 28 Oct 2024 09:13:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv9 7/7] scsi: set permanent stream count in block limits
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241025213645.3464331-1-kbusch@meta.com>
 <20241025213645.3464331-8-kbusch@meta.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241025213645.3464331-8-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/24 2:36 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The block limits exports the number of write hints, so set this limit if
> the device reports support for the lifetime hints. Not only does this
> inform the user of which hints are possible, it also allows scsi devices
> supporting the feature to utilize the full range through raw block
> device direct-io.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/scsi/sd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ca4bc0ac76adc..235dd6e5b6688 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3768,6 +3768,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   		sd_config_protection(sdkp, &lim);
>   	}
>   
> +	lim.max_write_hints = sdkp->permanent_stream_count;
> +
>   	/*
>   	 * We now have all cache related info, determine how we deal
>   	 * with flush requests.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

