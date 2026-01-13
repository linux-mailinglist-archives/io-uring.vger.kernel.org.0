Return-Path: <io-uring+bounces-11607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 57FBCD1821D
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 11:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33F2F3049096
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 10:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01167349AF8;
	Tue, 13 Jan 2026 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dbGTUi6x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1953451B0
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 10:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768300981; cv=none; b=iy1eM9BrXJMDDZiMbdXofVMg5exfaOc7GfwcRw508ervw8Et5b2i2JF3r7a0i7DJhr3QRj8yftTy/s+Z9yrniE3jDtiMH+7y2klnvPBVLmy/DXJKJfLPVNf8N+rH6rERZJWh85AumzZytlPVXCZbNVom+LPlJfq2ZTTO2vHz58o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768300981; c=relaxed/simple;
	bh=h/iEAdqPaIY6WKNvkMpng0b6z40syJH+JgYaAQOu/Gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sodAjAgcW/5jNbju9koZ5VMr5YALNIoklABMZxsqPxYd7gV0OFSieQ4zf2ncal5YbFPSLRgIXk1cM4nJuq3oJIAtNTq9CmSGf734W4FxIsA3Uv/BRC/pt2UpTSm8cfeR2S0R++vFMwtA4ryYGjXOMnnil7gunC7/GnxwaYfwFkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dbGTUi6x; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so50360275e9.2
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 02:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768300978; x=1768905778; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LkhtI/R2xS3vmnHvCQqFwCBZTI8re8hBml5kcRz0zBY=;
        b=dbGTUi6xuFCFDtZvChjPqVXFIpJBzcboY/+8bIt8Mpg5BT5HXHdalGDlR1fHJCL1dF
         wdff2CYW56pIKesR4Csgy3hQtn99aNLr+w92OSyWKhyzmYCA7BTuo35KlGTKeAZgutZt
         qXtVmXGOSdZYbkZmC7HGOVJN8ovdNPpEdQPbLk8+OHZoXxWrq+rvgEn45clEh+thX3T8
         s0YXJChrVfPpnJ0GzFEuNa8G3f4SgakkPrTrv+7FgKytR+l+zr5RdgSdBW/vFaDVtNBl
         bfm7UB5ubRZECmu/fSdk5EkGS/ALXQNiBioDJaRvVRIfFmJEIsvC1g8NICR2plnfbOYH
         nCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768300978; x=1768905778;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LkhtI/R2xS3vmnHvCQqFwCBZTI8re8hBml5kcRz0zBY=;
        b=wUmE9wjG6F1FD3pTdPBNz1F4fbbNa5Eoi4wkzVSUdTHEFWj1M7Rf3RSJtMYojXcQtI
         R6lHojmjbgSB+62a8QaaAFbE/v8CvIp0CJj4FsLNYnObxC5eH4ASqa8Ri4YUhwAfIC62
         0aklDRqAwaTZvNUOaFEQLcKpXnR1QSfBUSpmmk9RBOkjBELUl2csSlc937n4EBCjIi1x
         zUhiR7PLxXI7X1lYfdAgc+gHQ6Oe0uP6RgyojH5//TER/BeaI/35w7gzWw4IjNRwwTX1
         lkj2D3b6J2mPB0UonTn7t36xVRyOqwPUXl2E9b7nxfIT8UAYvexK1Mk/vW7OijXL9YdS
         M2sA==
X-Forwarded-Encrypted: i=1; AJvYcCUhhdcNj77zXyTwVvaprl2rk/AVeZvTGUAsE0I9p3oZYOdAeCBDKDI7oMMY/8B/mz44IzDvfLKBUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYIsVTcndJaOTAuroEbETaQyKX10CQ7k/LdyZcPqJUOqK65L1g
	z/gJ9hdrd0svb4pG1qBwAMMHn16ijZia8g3K6ty9MFXgGlScn9yEQPDs
X-Gm-Gg: AY/fxX7j7BEAExOdj9KFAMWXykpw0k/cCy7Y7x9lx3FGz4/Ro73/PuJX77hGQF/s/nK
	Ypk6lcO71acFwmunuqVGWbpNGjSZAin0m4joralyQofXb0YOpv7EFZ/9brWcB55NHU3ThcZ5k3c
	sE1PL03/IUW90ewncZDoaBbomLlJXu1K8NT1KIfwQKHQw+9vs0EaNL1DIOqatuhX0ew7RYWc8kr
	Mht1jVlL/tMjjbWtW8FeUypLR4wAS2kgXoz3sXAw5UhaFen/0rVTcKxOHc0Sm1r6ldVUeh6FaOL
	xplFTotXHzMieGhiK+6W2M1FJa4QM1awD9XRF0QdXrxnRxMhctOEH7DTeMn+YKb5N91NfpmNDff
	UHg17Oe+ZsIzlOZeBZvKGaFPpiJphMk11hDGGxe0ium+H1TKBLtTTj+ohZ4BK+nrsxjoR+ujbEA
	2GxvKi9K665fmf58GXtYkKHzOPLhUKPQU5kIjRRGjSTXFCEAZC6IOvo9FYGBCTGpDR4q1x3sikS
	yD5qWMFd8TLrLw3+GHneF4axqhhVRxQj8Gg/q3C9r6kXj2BhXA8MZB34SAKIxsPuMBaWlInwg4g
X-Google-Smtp-Source: AGHT+IFkZdiJcndAA0MyUMm8x2SeND7c9WKpL4+wjJVZyc9wRUscpxmE8qJsJDcPKd4tkE4BoGQKUg==
X-Received: by 2002:a05:600c:3555:b0:47b:e2a9:2bd7 with SMTP id 5b1f17b1804b1-47d84b3b5dfmr248265925e9.19.1768300977891;
        Tue, 13 Jan 2026 02:42:57 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ed9ea45cesm13306085e9.1.2026.01.13.02.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 02:42:57 -0800 (PST)
Message-ID: <52b4ac3d-7634-4545-af11-e25b589db700@gmail.com>
Date: Tue, 13 Jan 2026 10:42:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 6/9] eth: bnxt: adjust the fill level of agg
 queues with larger buffers
To: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Alexander Duyck <alexanderduyck@fb.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, Shuah Khan
 <shuah@kernel.org>, Willem de Bruijn <willemb@google.com>,
 Ankit Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>,
 Alok Tiwari <alok.a.tiwari@oracle.com>, Ziwei Xiao <ziweixiao@google.com>,
 John Fraker <jfraker@google.com>,
 Praveen Kaligineedi <pkaligineedi@google.com>,
 Mohsin Bashir <mohsin.bashr@gmail.com>, Joe Damato <joe@dama.to>,
 Mina Almasry <almasrymina@google.com>,
 Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Kuniyuki Iwashima <kuniyu@google.com>,
 Samiullah Khawaja <skhawaja@google.com>, Ahmed Zaki <ahmed.zaki@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>, David Wei
 <dw@davidwei.uk>, Yue Haibing <yuehaibing@huawei.com>,
 Haiyue Wang <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>,
 Simon Horman <horms@kernel.org>, Vishwanath Seshagiri <vishs@fb.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, dtatulea@nvidia.com,
 io-uring@vger.kernel.org
References: <cover.1767819709.git.asml.silence@gmail.com>
 <8b6486d8a498875c4157f28171b5b0d26593c3d8.1767819709.git.asml.silence@gmail.com>
 <4db44c27-4654-46f9-be41-93bcf06302b2@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4db44c27-4654-46f9-be41-93bcf06302b2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 10:27, Paolo Abeni wrote:
> On 1/9/26 12:28 PM, Pavel Begunkov wrote:
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> The driver tries to provision more agg buffers than header buffers
>> since multiple agg segments can reuse the same header. The calculation
>> / heuristic tries to provide enough pages for 65k of data for each header
>> (or 4 frags per header if the result is too big). This calculation is
>> currently global to the adapter. If we increase the buffer sizes 8x
>> we don't want 8x the amount of memory sitting on the rings.
>> Luckily we don't have to fill the rings completely, adjust
>> the fill level dynamically in case particular queue has buffers
>> larger than the global size.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> [pavel: rebase on top of agg_size_fac, assert agg_size_fac]
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   drivers/net/ethernet/broadcom/bnxt/bnxt.c | 28 +++++++++++++++++++----
>>   1 file changed, 24 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> index 8f42885a7c86..137e348d2b9c 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> @@ -3816,16 +3816,34 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
>>   	}
>>   }
>>   
>> +static int bnxt_rx_agg_ring_fill_level(struct bnxt *bp,
>> +				       struct bnxt_rx_ring_info *rxr)
>> +{
>> +	/* User may have chosen larger than default rx_page_size,
>> +	 * we keep the ring sizes uniform and also want uniform amount
>> +	 * of bytes consumed per ring, so cap how much of the rings we fill.
>> +	 */
>> +	int fill_level = bp->rx_agg_ring_size;
>> +
>> +	if (rxr->rx_page_size > BNXT_RX_PAGE_SIZE)
>> +		fill_level /= rxr->rx_page_size / BNXT_RX_PAGE_SIZE;
> 
> According to the check in bnxt_alloc_rx_page_pool() it's theoretically
> possible for `rxr->rx_page_size / BNXT_RX_PAGE_SIZE` being zero. If so
> the above would crash.
> 
> Side note: this looks like something AI review could/should catch. The
> fact it didn't makes me think I'm missing something...

I doubt LLMs will be able to see it, but rx_page_size is no less
than BNXT_RX_PAGE_SIZE. It's either set from defaults, which is
exactly BNXT_RX_PAGE_SIZE, or given by the provider and then
checked in bnxt_validate_qcfg().

-- 
Pavel Begunkov


