Return-Path: <io-uring+bounces-6323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE94CA2D683
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 15:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB47A3A82CF
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 14:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3901AF0BC;
	Sat,  8 Feb 2025 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="epRwQqd6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF2C1DDE9;
	Sat,  8 Feb 2025 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739023242; cv=none; b=gI35Q6W1jNGhYFN3iw11/NZuA7adSz17JsK3p9qc8iEmLhTDWKh+xrWPgAYJWEDtHKVnpk1Tn2alPEuar3gipVuJ/Fm3gD0QxyYKZAzXtEtmScAXVkK5ibV4p8RQfenO7OlY/h350pDqPj/OG6ZHGrbqny3vWd0wNQcfNCHKcFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739023242; c=relaxed/simple;
	bh=6SOJrVkaoPv/LIQ0lX9Pyci6rowXmS+AhmEBv8Lkrm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bBQZUEtZtOcE7myN36jHwGFh+QlrVXbrhuE4rS99ykbSlygWs6RZrpfQTrk8+vka+lG7Sk1du+1e0vEJ9I0zJT5Kef8WyASBmTDIfn8WPJWNbswxIxcFbu2ln+TrMkIKyqyHD83xCvE7EiU9EReYxZsM0bTDp/DeSdw4EkW78s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=epRwQqd6; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso513468766b.3;
        Sat, 08 Feb 2025 06:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739023239; x=1739628039; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fGAcqckTNKKDS6462vJ976x93X2f89+XGq5zOwYTOnM=;
        b=epRwQqd6Kg0SB30WNlpF4fGHqM3bJEDOHJcq++wbRgmH8HAiCtFqtMEQRZhZf/Hfiq
         z/izxThZ2PaHRcmBR1osvM3lEtJ3vgXnXYxV+cZEQ42kGhjK9TN6sRNn2cNfmaxRmTdD
         852XkS+LBtyMwfUkE5TZ/Dkjooofra7rK96xfXHWXlwhVK1A4+a+Bqz8GOMXW9XsyEE4
         OJ9ZdrBSOoRkrKj7iPNaeYvcDGhwjFxEbr674Yt5EgXMxtMN+JVgzUdKjTOk9mdfXii2
         vEO5b+EdOpDgppn4wutjPj/sGDyBNxNIjqzcx3IUcKtBhYTFdZiW0Lyplqkv166OGpaf
         ZHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739023239; x=1739628039;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fGAcqckTNKKDS6462vJ976x93X2f89+XGq5zOwYTOnM=;
        b=LJTrfA7EyIeCdxvuDg4eqAg1PZHrQWDc3uM1yFzR5ZXOgLgW8DoC3hhKmsRcwDx9t4
         7/mxIOIiEEvBTOR3xTrlY9Ati7rzdM2ux5xUSiiV55rBrHOCy4Lb/z3DQjYl2jO03Ugy
         HZls6Wzs/A6yJOX1Z094wrszB3IsDLVTkerWktKDGQBib3395g34CHXN3hwE8eHV+9iu
         Ki0taMZv2JrSNIsRU2Tj6VLRz+XQu5BDhSQt4lDyw9CxhS/8sQr7j+CYYphXC6Qd2vky
         yUZy2qogNN/IAEqe2OBCHXkP50v5naIPi2xXTGbSe2DrKWkj6FWaMbHgTguhGp9R7CuM
         hJKA==
X-Forwarded-Encrypted: i=1; AJvYcCV2CkR/aUV7ORf91uFkGXhdn/4m0ZOqb9G0Hi4FJcO2CAsVFXyhMjpcrC++OJfIQauqfwseXib8RqOLlcg=@vger.kernel.org, AJvYcCVm0MHn5YS8mH5XelTUW4fX8ZfR/ZRR1uA3HeNgFTjbkvG9MXOIV9yfUS5epUCOXSQdKyAI+lzRAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt79MM5KHGrJeOpWDxlNHlCjwGeLk7JNJF9bCA4efeg8rXKcCe
	IDTBkoK0YVy2950LJJQzAjl3kPv//hxczh+Q2KUfDT4k6PnCJyR0
X-Gm-Gg: ASbGncuRQq5nJ00srXVjIbRi3l7oDrdZ7r7fqr1zSWm+lMlbNk7F0d3osGuTi1bR+BZ
	+RjraPwKFcpVnuAxjOkBxITcxhdCJ/jQCrY5t6p+RULlU4JB51I7CFtkStNG0OkNaJ2bKwe/6bG
	vvnwy5IGCCrdeMIjqUZg2IStDB29a1Us5ZQf4zPYAij0VRWxhxIJQ2eyosmtDw6rAPqHU6DdskO
	WDzggZYF+JzvYI82KaTUOtQkQO21rXjNNO0JT0zcWaYgY2OkV2yNTDVN9br4fo6tb7Vq/iVXoA7
	XDNIPf46udEMDiRnmAq8/7eUBA==
X-Google-Smtp-Source: AGHT+IEpez2orbXRYz2WjK75M4+g/bPcwTODSDFgGlrF6eLh9N+yuQ1pEeui8GK/nKnT+dwNpJNF+g==
X-Received: by 2002:a17:906:8417:b0:ab7:9285:301e with SMTP id a640c23a62f3a-ab792853034mr420631466b.5.1739023238291;
        Sat, 08 Feb 2025 06:00:38 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.220])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de58404347sm1876495a12.9.2025.02.08.06.00.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2025 06:00:36 -0800 (PST)
Message-ID: <d05ab6d4-8b8b-46c7-9597-f04885c6acda@gmail.com>
Date: Sat, 8 Feb 2025 14:00:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-7-kbusch@meta.com>
 <a6845bcf-8881-4b92-acc0-0aab8d98cba9@gmail.com>
 <Z6Yn1GOPlMfpZqsf@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z6Yn1GOPlMfpZqsf@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 15:33, Keith Busch wrote:
...
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index 864c2eabf8efd..5434b0d992d62 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -117,23 +117,39 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>>>    				unpin_user_page(imu->bvec[i].bv_page);
>>>    		if (imu->acct_pages)
>>>    			io_unaccount_mem(ctx, imu->acct_pages);
>>> -		kvfree(imu);
>>> +		if (struct_size(imu, bvec, imu->nr_bvecs) >
>>> +				ctx->buf_table.imu_cache.elem_size ||
>>
>> It could be quite a large allocation, let's not cache it if
>> it hasn't came from the cache for now. We can always improve
>> on top.
> 
> Eh? This already skips inserting into the cache if it wasn't allocated
> out of the cache.

Ah yes, you're right, I overlooked it.

> 
> I picked an arbitrary size, 512b, as the threshold for caching. If you
> need more bvecs than fit in that, it falls back to a kvmalloc/kvfree.
> The allocation overhead is pretty insignificant when you're transferring
> large payloads like that, and 14 vectors was chosen as the tipping point
> because it fits in a nice round number.
>   
>> And can we invert how it's calculated? See below. You'll have
>> fewer calculations in the fast path, and I don't really like
>> users looking at ->elem_size when it's not necessary.
>>
>>
>> #define IO_CACHED_BVEC_SEGS	N
> 
> Yah, that's fine.

-- 
Pavel Begunkov


