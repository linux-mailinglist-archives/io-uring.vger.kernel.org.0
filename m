Return-Path: <io-uring+bounces-11016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF80CB780D
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 02:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 007E3300AC43
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 01:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8015326FDA8;
	Fri, 12 Dec 2025 01:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pv7E8nan"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F3423D2B4
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 01:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765501567; cv=none; b=e3WGRNUk5aMj6w8wrbxJ33o/A1FfgyaHrDAlXLCkTjDZdvMBcv1zJuss08RvL7OQvrZHa3BrfzF5mDTzrG/tzGQX6LurhlDM/e+q/rj3zqrameHyftlpoto4dzdxoWlvh/lqsiQxq4RNpe1mYcq5p8l0hpDRqD/hcc22zQxMfLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765501567; c=relaxed/simple;
	bh=K1VuPgyejhpo8R8GttFalwF9L+ZZzTbzYl21HGIer1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uHJGwnoudkd8OFnRWe8QjbYqBLurIrkeqhmFYq/WoJO1z9/rF7wBNxzI2soaLwl49njTohE+DzHtMX5Yd5s9SxBnslgVev2lPaYV+xHsHDgkTeaIKDdDCNmIwvNuC2aHuE6DQ80l4ugRGgrCX0FH135LgdQmRkQEqXogS7eeSrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pv7E8nan; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7f651586be1so90305b3a.1
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 17:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765501565; x=1766106365; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IIn/LcD13PrglPwKrjbzANKOSQPEYp8vSoODGBl4RDw=;
        b=Pv7E8nan7uRJVNO6eOuSZY2fcLHuM8eyEv1r+jY+mNoTmV+Ewf/m3WWs9DJIgHEZRP
         +K8yZ+rgoh7CMSV4MTrYsgwKcPuFIo4XmE5R6iPXuZUL9/53v30Bz2eDkTn4SdDTtvot
         M2WP12QLgC+UFs/h4VNMhthuJPunyFPDqvpHiaUuMdtUcz8kIvlTcAGB6DKCY30EbKS5
         wnGa/7aGMB9HURe34bi1NOd+ShGFPjCsVnWwyboL5Oas7rMjb64rWJi7745HVVqJiCEq
         XMn1Ms5slyhDtvRoHiYno4QYA97m8gDY4i/LzIKQp/tdx2Tp8i5Rk8ga8igJZ3hir4m6
         w1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765501565; x=1766106365;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IIn/LcD13PrglPwKrjbzANKOSQPEYp8vSoODGBl4RDw=;
        b=QW1wEV7q7lRTJiRMAT8qxrX6KZvssGsYL7I1565nMwOBj/z7Z+cXc5haK0p83NvSFz
         CxIUHyPtSQh4bR/Ac0WwcdaWj9kdOgDSJupJ+lBHvUBaTCNlOLDQqmsi8fGxMl0POF32
         T2Pm2lYtjPqfJDoY8W2QvC7SmayWIsEL5/Jdp1uoAIA47SKJBrcQVJROqo3E8g9yy/yN
         Sa7CN4660oknYVTnBpgJxtuDiJDguNtxlMjvMOXa6qeQYn6gSPxyKkMhYbx1IQI1k7Xh
         3Wtkb4acoaoItp32heXKdQ46fHdHkxScEyomIDPC4JUHh++CbCOuNGmgpTMkVDEQcWSO
         86BA==
X-Forwarded-Encrypted: i=1; AJvYcCX98qsarMkEQ1r5+jLTQbs807kMaymKmvcHunOiPIXXEsfvyMjmJORL0plAeZg27RtN6qIm5LYVqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPjmvg/uWJXIiwehn5ErAiDshBuMv7WZvtiI0KqEt/ng190uQp
	X54ywgsNCIKAKfMuorDbokmG6tOl/uynOhbCu3+CNwIhUixCkOdqfjDh
X-Gm-Gg: AY/fxX6IDPFSE+KaFxMh4ctm/Z1Y18h6afB+77MPlocIdlZ2U0XfXf5LDjAndhIZzwF
	V7cH5mOBKlvvOEGoav6ezuv3Ew4g0F99iaeXYfdVQltQKQ+3eFsTvsq/iWa5CiIDEDRt44p1qvV
	lFHDcdavj6pLOz0veofcmQz8Ki+ihdoh83xEVioUmg4bzDc8We2NNUa+5eOzYnjU8fv73t2DqsU
	+7oJMv4j7DLIBLAaplDuzFJxLycOlPgQxzAqoIozIltYN9feZXYcRBSpFm8i6W5YbJl2dpQolHw
	D1X+UV/K16jS5y6qdYBbGXSFGeRLTzejIsOeWzoBDCSemFBRCDjfdsd05Epc6GFZXgGt1w5tvfv
	IkzYezmAL/9CHyqDgAEzZ69MSWMUjRDbUxrdJK18wpXf1e2L2xITVUco0gwq4tDWEk0LhbqqoNX
	qkvmwLLzfvZFUN6DtNYrKv7YytyCEx19ZAslfsOdrUh3ZcGkCR4x99qt3C/xEUlBndJxfhyZZXS
	bJ/el6FxUAg3D3C5zuxVv3FQXq2M2nyagVsY5nL8lQzgRmYsFvZ54ZcfZ736w==
X-Google-Smtp-Source: AGHT+IEhxHfa3EvqLnd161U/iUsmuB/KO5aMfBcewaILSnv9w+0OotqTV/mO8Q9y2e3SELVXDNPiCw==
X-Received: by 2002:a05:6a00:8c12:b0:7e8:3fcb:bc4a with SMTP id d2e1a72fcca58-7f669c8a4efmr414424b3a.31.1765501565293;
        Thu, 11 Dec 2025 17:06:05 -0800 (PST)
Received: from [10.200.8.97] (fs98a57d9c.tkyc007.ap.nuro.jp. [152.165.125.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5093a56sm3565645b3a.47.2025.12.11.17.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 17:06:04 -0800 (PST)
Message-ID: <6edcb112-dabc-41ff-8e47-8b331de12f5c@gmail.com>
Date: Fri, 12 Dec 2025 01:06:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 02/11] iov_iter: introduce iter type for pre-registered
 dma
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <f57269489c4d6f670ab1f9de4d0764030d8d080c.1763725387.git.asml.silence@gmail.com>
 <aTFlx1Rb-zS5vxlq@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aTFlx1Rb-zS5vxlq@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 10:43, Christoph Hellwig wrote:
> On Sun, Nov 23, 2025 at 10:51:22PM +0000, Pavel Begunkov wrote:
>> diff --git a/include/linux/uio.h b/include/linux/uio.h
>> index 5b127043a151..1b22594ca35b 100644
>> --- a/include/linux/uio.h
>> +++ b/include/linux/uio.h
>> @@ -29,6 +29,7 @@ enum iter_type {
>>   	ITER_FOLIOQ,
>>   	ITER_XARRAY,
>>   	ITER_DISCARD,
>> +	ITER_DMA_TOKEN,
> 
> Please use DMABUF/dmabuf naming everywhere, this is about dmabufs and
> not dma in general.

I guess I can do that (in all places) since it got that much fat
around dmabuf, but for me it was always about passing dma
addresses. Dmabuf was a way to pass buffers, even though
mandatory for uapi.

-- 
Pavel Begunkov


