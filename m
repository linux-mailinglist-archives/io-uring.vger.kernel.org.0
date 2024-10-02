Return-Path: <io-uring+bounces-3384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5729398E27B
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 20:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 208A528344E
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 18:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315202139A4;
	Wed,  2 Oct 2024 18:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2+HXCbK6"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3151D0F58;
	Wed,  2 Oct 2024 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727893798; cv=none; b=YlK2tBycHOhCcvFD9KmTs0qaEZcQ4PSMeasnSNGNu3C4qk1IlRdjRP2V/c8jTkc/2KJMAWkgFpiylGCBevDLzqjOuZsjXtuygJBKdf9EgEUDgWQa0ppPmu/vLNESArqUHTVExq4dYEDtZzZMhgn6TCG+bD2Oxy9OoBNrFKexcMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727893798; c=relaxed/simple;
	bh=Z28y+tpcPpMVId5gAiIuBlMyT/Kux7RGYjReD8gSWds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qDdqVBRbku6doCDhwlNdTNP4lj+/YaJfvN8+pVorMFFmErVV6tv76rIbSs4cXyYhFFP7QFDX63BWcuM/Jxj1HTU70w80JXK0b74nFPX4dB7H7LCo5J/mRQcNhJ5W6eGZ9Ewsg58DjSXW+4zLbXXFR9aXRkjbQz0nptmk2eAnBEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2+HXCbK6; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJjyr00kTzlgMWB;
	Wed,  2 Oct 2024 18:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727893788; x=1730485789; bh=rFxspoJzSpoidu30KdZ/3Lut
	pEs5eoSpyKA4GWnHU/c=; b=2+HXCbK6SmuieqTkaM6qtUc4K+iKcGDiWWfIUizJ
	qeDK0l4j6vf7prZMWMfP9kYMN2aIimluNOu+uUOnbUDlu3QWes6ZaFJNNqo6IVFr
	1vNgCcRCPvD8KUbJ4rkKqd9mf8L9NVKfjM8MGjCfp6WN/CrLaHPziAyxB/MdnA12
	K0/AYnRp/u9Cxf4iE0i52F7EgoiOTnT/Txceo9XtDuFIC4iDfseJ/SFMmqvripyS
	yFD/YTy6aMKsmFUvyi21OD2H43fr5lNP1XUqxKF0fBXpm451dOyxPXRSA6vBbdaI
	Gn+ys5xCORibg0VCvGEOHTyZ1XzOp8+N8beaw7tzBN/NyA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fb7lQuE366pl; Wed,  2 Oct 2024 18:29:48 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJjyf4PxZzlgMW9;
	Wed,  2 Oct 2024 18:29:46 +0000 (UTC)
Message-ID: <80eb6cb1-c1e6-42fd-8941-ffe081041a18@acm.org>
Date: Wed, 2 Oct 2024 11:29:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] io_uring: enable per-io hinting capability
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, hare@suse.de, sagi@grimberg.me, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
 asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>
References: <20240930181305.17286-1-joshi.k@samsung.com>
 <CGME20240930182103epcas5p4c9e91ca3cdf20e900b1425ae45fef81d@epcas5p4.samsung.com>
 <20240930181305.17286-4-joshi.k@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240930181305.17286-4-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 11:13 AM, Kanchan Joshi wrote:
> diff --git a/include/linux/rw_hint.h b/include/linux/rw_hint.h
> index 309ca72f2dfb..f4373a71ffed 100644
> --- a/include/linux/rw_hint.h
> +++ b/include/linux/rw_hint.h
> @@ -21,4 +21,28 @@ enum rw_hint {
>   static_assert(sizeof(enum rw_hint) == 1);
>   #endif
>   
> +#define	WRITE_LIFE_INVALID	(RWH_WRITE_LIFE_EXTREME + 1)
> +
> +static inline bool rw_hint_valid(u64 hint)
> +{
> +	BUILD_BUG_ON(WRITE_LIFE_NOT_SET != RWH_WRITE_LIFE_NOT_SET);
> +	BUILD_BUG_ON(WRITE_LIFE_NONE != RWH_WRITE_LIFE_NONE);
> +	BUILD_BUG_ON(WRITE_LIFE_SHORT != RWH_WRITE_LIFE_SHORT);
> +	BUILD_BUG_ON(WRITE_LIFE_MEDIUM != RWH_WRITE_LIFE_MEDIUM);
> +	BUILD_BUG_ON(WRITE_LIFE_LONG != RWH_WRITE_LIFE_LONG);
> +	BUILD_BUG_ON(WRITE_LIFE_EXTREME != RWH_WRITE_LIFE_EXTREME);
> +
> +	switch (hint) {
> +	case RWH_WRITE_LIFE_NOT_SET:
> +	case RWH_WRITE_LIFE_NONE:
> +	case RWH_WRITE_LIFE_SHORT:
> +	case RWH_WRITE_LIFE_MEDIUM:
> +	case RWH_WRITE_LIFE_LONG:
> +	case RWH_WRITE_LIFE_EXTREME:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}

Moving a function that is not in the hot path from a .c file to a .h
file is wrong. This increases the kernel size, slows down compilation
and makes implementation details visible to callers that should not have
access to these implementation details.

Bart.

