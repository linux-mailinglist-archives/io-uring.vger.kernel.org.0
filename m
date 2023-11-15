Return-Path: <io-uring+bounces-92-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE487EC3EE
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 14:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAB1428121C
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 13:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC951A737;
	Wed, 15 Nov 2023 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="na5iWha1"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFF81A5BA
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 13:42:21 +0000 (UTC)
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1085FA
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 05:42:19 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-7ba0fb0ef88so394069241.1
        for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 05:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700055739; x=1700660539; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uqnZjakniWhn8buWjxqZAVtXyr/uRYGYn4oOldoEIrQ=;
        b=na5iWha1XCEr7kexNk/j3xXY6GDcgH/e/tt/9SLke5R8ZVrfXWnaBFtiM4WRKPAvuq
         yk3i8Dj3zfjr60bFl+eHFfrZzQf0DZDutYxSqaT01lftr4gBtap5UkoFvr9NoF/wHbLL
         T5OCrJktA24NN/BD6dnOVyVYGdy/K0lFLWYTTlSXKB2BmBj+Xmgj7b1W8tzHW3kN0Fof
         25Q6PHsaPDaAhxaApEqluJ8teydJDKMQl46g5YXtcXuw6aIrc/t2X9BdjsdA6l6jrZiH
         g4FXyGfwr0kdrhsCm6pSClxFiXEdVEo/Rrf+c8Wl7a3tv39NPcaWhIGAel2fu+OuudJ6
         ykXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700055739; x=1700660539;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uqnZjakniWhn8buWjxqZAVtXyr/uRYGYn4oOldoEIrQ=;
        b=dzXtcSx4eaZbt2kQUm9yu0/ahYMPmLuSId2uBBm4mi+EbSyWNQ/VkEnukKr9sE7Idx
         tU9Gqg/kNWazZZo8nZUUJr3oEkMNJlI5aQyvrgjmLaHs7JFuJXcbSddSqcxNhg2jRhbh
         sLYLd1AIh+U8ICsMVYDHk7EDi774BpBk/WxpPgcPu1RbV+bylSGeHuTe6MRYG18k5Vnr
         kGovGCP4DpfTtsxZCXsZMKQMAsAPgSaCv/+Jvj9kXTWFa4NZUq2vsZ/u+sZHZJn/oVGX
         3teI1p+m5eNp3hlsvbbIQ8ZQanoLW3y1vr6zFwRC7oD/ngi7V/Sr1/7MXu7Ka9pxfUDV
         ZY9Q==
X-Gm-Message-State: AOJu0YzLEgAjOPB0Ewi8liRf32iT3QBlhg6NetH1TOjfG9BvOm+xg3kY
	M0EugGbEPAHKGsuigPbZIaij3w==
X-Google-Smtp-Source: AGHT+IGN14qtNd76A0R+qFqvGDrt+ehcCXBDbvD7GaHym10oc/TSc/YslIYRBVgP4RqTmKICrlbJcQ==
X-Received: by 2002:a05:6102:829:b0:45d:980e:3ed3 with SMTP id k9-20020a056102082900b0045d980e3ed3mr5176585vsb.2.1700055738290;
        Wed, 15 Nov 2023 05:42:18 -0800 (PST)
Received: from ?IPV6:2600:380:9175:75f:e6af:c913:71c3:9f81? ([2600:380:9175:75f:e6af:c913:71c3:9f81])
        by smtp.gmail.com with ESMTPSA id d6-20020ad450a6000000b00675497e5bf3sm553581qvq.30.2023.11.15.05.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 05:42:17 -0800 (PST)
Message-ID: <433e9977-a85c-4d5a-aed2-a6f82fcc6bf4@kernel.dk>
Date: Wed, 15 Nov 2023 06:42:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, kun.dou@samsung.com,
 peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com,
 wenwen.chen@samsung.com, ruyi.zhang@samsung.com
References: <ffbbe596-c6a9-42ed-9156-e6d5c21eca9b@kernel.dk>
 <CGME20231115061813epcas5p2bb6bebb451c6e2c65a5e9ec9ffac5f46@epcas5p2.samsung.com>
 <20231115061027.20214-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231115061027.20214-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/14/23 11:10 PM, Xiaobing Li wrote:
> On 11/15/23 2:36 AM, Jens Axboe wrote:
>> 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>> 		struct io_sq_data *sq = ctx->sq_data;
>>
>> -		if (mutex_trylock(&sq->lock)) {
>> -			if (sq->thread) {
>> -				sq_pid = task_pid_nr(sq->thread);
>> -				sq_cpu = task_cpu(sq->thread);
>> -			}
>> -			mutex_unlock(&sq->lock);
>> -		}
>> +		sq_pid = sq->task_pid;
>> +		sq_cpu = sq->sq_cpu;
>> 	}
> 
> There are two problems:
> 1.The output of SqThread is inaccurate. What is actually recorded is
> the PID of the parent process.

Doh yes, we need to reset this at the start of the thread, post
assigning task_comm. I'll send out a v4 today.

> 2. Sometimes it can output, sometimes it outputs -1.
> 
> The test results are as follows:
> Every 0.5s: cat /proc/9572/fdinfo/6 | grep Sq
> SqMask: 0x3
> SqHead: 6765744
> SqTail: 6765744
> CachedSqHead:   6765744
> SqThread:       -1
> SqThreadCpu:    -1
> SqBusy: 0%
> -------------------------------------------
> Every 0.5s: cat /proc/9572/fdinfo/6 | grep Sq
> SqMask: 0x3
> SqHead: 7348727
> SqTail: 7348728
> CachedSqHead:   7348728
> SqThread:       9571
> SqThreadCpu:    174
> SqBusy: 95%

Right, this is due to the uring_lock. We got rid of the main regression,
which was the new trylock for the sqd->lock, but the old one remains. We
can fix this as well for sqpoll info, but it's not a regression from
past releases, it's always been like that.

Pavel and I discussed it yesterday, and the easy solution is to make
io_sq_data be under RCU protection. But that requires this patch first,
so we don't have to fiddle with the sqpoll task itself. I can try and
hack up the patch if you want to test it, it'd be on top of this one and
for the next kernel release rather than 6.7.

-- 
Jens Axboe


