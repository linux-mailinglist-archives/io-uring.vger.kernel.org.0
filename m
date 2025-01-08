Return-Path: <io-uring+bounces-5753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E8FA06265
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 17:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23FC2188A833
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 16:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67B3200136;
	Wed,  8 Jan 2025 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AqNBHQdt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7B81CD0C;
	Wed,  8 Jan 2025 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736354586; cv=none; b=ri635RTL08FWYHD8iilGDKI3nBhCovsTa8j/68BOvEamR36FoDJK64oP42xeBoqtKB5HUqtKFUzpK5EZhCsZvQ6jTr8aEKyXtrrISTn7E25SUKv8Pb4j6uh9fuB/jDuW+hJM1nbS4dE4Wk9o8Q70EcPleYLOQpUtliGQZY2qQ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736354586; c=relaxed/simple;
	bh=N+kJ81CMex083zpPGo+O5ftfEhho2/aGU5bdhBS+nN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTjvFlyqTXVcyc/Yjw0kNOH3iBjisIBVryFLviwfTlwEuXkzjifWZ2NsAFGw6h0SVtxfais+HYjiAKdh3+PBxMv2gRDpYp4h+lTSm3ggINn7BVvJGAMX7YcZFeLaXdsyakZCc3YaOaUaBhs0PNZVsLxbX9xa57dcI8QbSgrcWvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AqNBHQdt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-215770613dbso190563885ad.2;
        Wed, 08 Jan 2025 08:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736354584; x=1736959384; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KsZNIAk9DNqE051h8U57SLnibB35Wy01ARZsMURnivY=;
        b=AqNBHQdtfsQVhKVXadR0bHapGgnoZzbs51oH0Ax4/243GJZDUpQvVRObdvmNvPw4+5
         fvRWSrLVv4hgoUI1qI2dvypyGOP7b4tAMtr7Wg6wHD2U6v1y9yVwS/r+KfsDEl5von8A
         IIiyjbhSzp7Pacetqs7bTRPP32BL8NgJe4E0AKlqDr527rlX4RDl6dOOmBnLXYJd/OlL
         a4iKUvbXIc6kS5XkFljtHsfoij8pmAi674YUroVzkgJ38NS6Hu6yDo6DiHT9xxe8YarJ
         wnrB9CKotLKssfbRWPlzjr7DSETPrhlELQRenaYWvxvofJV8xBPY3oC9CgHBIsDp2F95
         WpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736354584; x=1736959384;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KsZNIAk9DNqE051h8U57SLnibB35Wy01ARZsMURnivY=;
        b=EOl3N061ApZL9X347GI4Cfp4VkqhG5uGxFz4+VeWPCwdno5HuoDuWxXik/BjqnfoY3
         1Y9y9mgKxcgbAFTP503CE/hk6ujcDNYoXdyKR753ORCPQcCDBUrQPAGtbW8pKBINpJDT
         MYNLLRQLCBtelCYDNcNwbpz/H9jqRn0WmjdfSif41hAbNAJ8y52r6JahdHoWzPa/s0js
         Ju/WXmXjLLXgMP0K9/bYAAw+3U1d70kDAFBmHBgVho5A5Md1yxHbjd2u3DfxNvcScTjF
         3Kn8P/fH8PT6zjzlCqUDLRrjqce16wR3/a6w4ZyFLpf5X2XKLgBmKXN6f5ALY84da0JY
         q1SA==
X-Forwarded-Encrypted: i=1; AJvYcCV1iHAH+mhwvHHViSEnUekXJDFm9hgipAT4dpbar4heLALjanaNGqLZH/oizEtYGTmhA0a2YzeOTQ==@vger.kernel.org, AJvYcCVy8MofUNrOBxYqnQWRhyb+MOdROvcGTFplOHLl/B5Uh8c1UbjLeMfbTA+JE58Edyy2wUTEIdxxR6tY07Pj@vger.kernel.org
X-Gm-Message-State: AOJu0YwgIB7xYiInP3avJBcN2z1Gh9NfbkMAwx8OLPseAvAhESDuhh7Z
	sVs5YzwR9v9p3qdNorkBAW0Y4GyUf0ZuJKDrDtkDcaFE8AS1H7l1
X-Gm-Gg: ASbGncuNjPpCh1ZhyKuX5OmHVekQ5hce2qtyFZJXvCogdfs2JCB767+zGz/l6LNba5D
	VEIgPLQbvq2yOBu3bF8ksXvRlsDi3Oo9jVb8mnF8zyNJbKJldOc1+DnUJUIxsXSmyIv12xc5DoC
	1uxiCpBJCPpbzWUcFmmgliJVzyIcPWshPlo9MeQ8uCAl0uc5g+K3riMK4dUckvKSMrCH/DX6+rG
	Te2WRTNcfj2O9HTJ3qdqRZ5+G5FSJbWamhDjoiblzGj1g9m61859IIOwQPyQ+RqzsOV0BRrEUoz
	8sBaBZ0TADG1kc2WQRbmFWMSvMtXnQ0TNnY=
X-Google-Smtp-Source: AGHT+IEmnmjFic6KSSSmMY4tBQW4v+WKkkb+xVNo1LmvLy1jELpzXG6iDrRM5+i7DbsVFZZhDYQKzg==
X-Received: by 2002:a05:6a20:244d:b0:1e0:d89e:f5bc with SMTP id adf61e73a8af0-1e88d104c17mr6106282637.11.1736354583728;
        Wed, 08 Jan 2025 08:43:03 -0800 (PST)
Received: from ?IPV6:2001:ee0:4f0f:f760:e1d1:39fc:5691:9b51? ([2001:ee0:4f0f:f760:e1d1:39fc:5691:9b51])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8360fbsm35494661b3a.75.2025.01.08.08.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 08:43:03 -0800 (PST)
Message-ID: <2b5dd8cc-c9d0-4524-b2c0-e99f760a2e36@gmail.com>
Date: Wed, 8 Jan 2025 23:42:59 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/sqpoll: annotate data race for access in debug
 check
To: lizetao <lizetao1@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com"
 <syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250108151052.7944-1-minhquangbui99@gmail.com>
 <71f1cec18e94459995dfb4bed9a79939@huawei.com>
Content-Language: en-US
From: Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <71f1cec18e94459995dfb4bed9a79939@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/8/25 23:24, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Bui Quang Minh <minhquangbui99@gmail.com>
>> Sent: Wednesday, January 8, 2025 11:11 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: Bui Quang Minh <minhquangbui99@gmail.com>; Jens Axboe
>> <axboe@kernel.dk>; Pavel Begunkov <asml.silence@gmail.com>; io-
>> uring@vger.kernel.org;
>> syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com
>> Subject: [PATCH] io_uring/sqpoll: annotate data race for access in debug check
>>
>> sqd->thread must only be access while holding sqd->lock. In
>> io_sq_thread_stop, the sqd->thread access to wake up the sq thread is placed
>> while holding sqd->lock, but the access in debug check is not. As this access if
>> for debug check only, we can safely ignore the data race here. So we annotate
>> this access with data_race to silence KCSAN.
>>
>> Reported-by: syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com
>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>> ---
>>   io_uring/sqpoll.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c index
>> 9e5bd79fd2b5..2088c56dbaa0 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -57,7 +57,7 @@ void io_sq_thread_park(struct io_sq_data *sqd)
>>
>>   void io_sq_thread_stop(struct io_sq_data *sqd)  {
>> -	WARN_ON_ONCE(sqd->thread == current);
>> +	WARN_ON_ONCE(data_race(sqd->thread) == current);
>>   	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd-
>>> state));
>>
>>   	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>> --
>> 2.43.0
>>
> 
> The modification of this patch itself is fine, but there are two other things I need to confirm.
> 1、Does the io_uring_cancel_generic() require the same modification?

I think yes, there is another syzbot's bug report on data race on the 
io_uring_cancel_generic I'm currently looking at. Here is the link: 
https://syzkaller.appspot.com/bug?extid=3c750be01dab672c513d

> 2、It is not holding sqd->lock in io_req_normal_work_add(), is it safe?

This is a valid point, I think we should add lock here too. I will try 
to write a proof-of-concept to validate this.

Thanks,
Quang Minh.


