Return-Path: <io-uring+bounces-2275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF76790F065
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 16:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90F8F1F2166B
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 14:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398ED17556;
	Wed, 19 Jun 2024 14:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cg6ZTY21"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8176F11723
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718807227; cv=none; b=bMr426cLzGgkn8aFH29jnXdaZhBgHB2LzPvALLeUs+wfFXitRp1W+0zpLOzkFkk4lnvzBJNceh3pBgwhBmTLPxTwSPaMX4wJVyuwp1o16CdakfcVeTq03BJgaChyE2joZsLKeKNsW15VO6D/IEIYmBnffla71tV2YNMDqoR1Vy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718807227; c=relaxed/simple;
	bh=57MALYy6vMqThTTD+A8/rBjdsqXK8NdtzaYdW06VBW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VI+0XI7FN5W+svCMOmj3iASNqC0KR17y3ltg5STvMn4CV0+2nXW4piBMaYfJ1hvHG+6uK4hif+1pHZIKuO4ZIHAkhcbFIizqajNASXgAPGCFZNUEt62JftB1YpikD+6olGr9qejbkrrFXnv7kuIdgNTw+r5vc68a3HVP5iqSBNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cg6ZTY21; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a6fb696d2d8so73919666b.1
        for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 07:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718807224; x=1719412024; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=86f/DndQH0AwAYjbT0nSqVKrhbooi9MhW2WdKfXLDh8=;
        b=Cg6ZTY213n6FMM983FzmfQo2Cyovf1z4fnH3FstHiSzeO9kfwNBKNgteQr0Nhehs1a
         qvw6xd3oo0JRDvTaHum5HUZEDNZgaZMCRjm380wshAp7lNDMcquUoM2bs1uYH1RrUMBA
         ufObJiI/hAHjyreIsn12K++GDTXdEFZ5HiRbX5FzVBAhbU+vXae6sPXSET1eCEWZkJjs
         YH1t87Xf7tI1yVB93Sd88Qq7ZmBr8aCHjS+K7ZYEZ46c4HSW8ITNyT4gs+3P6E9xT9tg
         1clCKfzJRgu1M2jDeGe0gASiPqHVeCA5H+9k5mEzs+TFy+KEnUaZXl8NQN8oZbUOjgn5
         4uxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718807224; x=1719412024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=86f/DndQH0AwAYjbT0nSqVKrhbooi9MhW2WdKfXLDh8=;
        b=p1qTpGeRT9vF3cc73CDpML46AbVCc1VRQbNXM8WvJxiCzbVBqNFlod+/7w929bkhQW
         IqgKFS8rPJ6grAh932oCIh0F34sJ4oGjEBHTQPwX04rJqrrf/Qink4JxE3YxDhlL8DAB
         PnAe5Hweg+xbkxFMhPAzbBIIq9DDGivq44N7HHU0ByGQg7+/Gnc02e34VHahmYPnIU8T
         TXs2wF9dZCwcsQVMJ1nLkab+U6/VHy7J/FgLxUMxutm63ypmdGz/F2z+vrO4xLuQvieL
         tQj3jWfA+J5APn2blYvyDd/VNxurqz1248gZ62sQcYfoFKj0of+qjTYIDq831b2Igev4
         7GGg==
X-Gm-Message-State: AOJu0YxUADKOYzEMopwG110qc0/uyuH7PTvAJQHZCB3nI+KRk5LCkpIR
	LgqSFwoOUguccdXmVqHwTtC+BBRShVCuGpvM5+VoE5Ygk67UIH2gNtbsMw==
X-Google-Smtp-Source: AGHT+IEONFbPwdpvg0qeHgTrDhXqNySd++XpDhtMmlqPeJ5astKyHSWC0CAHOS5lXix4YwKT3fdCjg==
X-Received: by 2002:a17:906:b0cd:b0:a6f:6ec0:5558 with SMTP id a640c23a62f3a-a6fab6187aemr177124466b.21.1718807223568;
        Wed, 19 Jun 2024 07:27:03 -0700 (PDT)
Received: from [192.168.42.75] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3585sm668709366b.117.2024.06.19.07.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 07:27:03 -0700 (PDT)
Message-ID: <b51fe1ca-5a3f-46e1-a33e-a3c91ce9ad6c@gmail.com>
Date: Wed, 19 Jun 2024 15:27:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: fix incorrect assignment of iter->nr_segs
 in io_import_fixed
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <CGME20240619063825epcas5p26224fc244b0ff14899731dea6d5a674b@epcas5p2.samsung.com>
 <20240619063819.2445-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240619063819.2445-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/24 07:38, Chenliang Li wrote:
> In io_import_fixed when advancing the iter within the first bvec, the
> iter->nr_segs is set to bvec->bv_len. nr_segs should be the number of
> bvecs, plus we don't need to adjust it here, so just remove it.

Good catch, quite old. It's our luck that bvec iteration
honours the length and doesn't step outside of the first entry.

> Fixes: b000ae0ec2d7 ("io_uring/rsrc: optimise single entry advance")
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>   io_uring/rsrc.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 60c00144471a..a860516bf448 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1049,7 +1049,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>   			 * branch doesn't expect non PAGE_SIZE'd chunks.
>   			 */
>   			iter->bvec = bvec;
> -			iter->nr_segs = bvec->bv_len;

iter->nr_segs = 1, please


>   			iter->count -= offset;
>   			iter->iov_offset = offset;
>   		} else {
> 
> base-commit: 3b87184f7eff27fef7d7ee18b65f173152e1bb81

-- 
Pavel Begunkov

