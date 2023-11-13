Return-Path: <io-uring+bounces-83-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 083EF7EA15B
	for <lists+io-uring@lfdr.de>; Mon, 13 Nov 2023 17:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F9E5280DF7
	for <lists+io-uring@lfdr.de>; Mon, 13 Nov 2023 16:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39F52134A;
	Mon, 13 Nov 2023 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kbGQ8jXq"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2121119
	for <io-uring@vger.kernel.org>; Mon, 13 Nov 2023 16:38:23 +0000 (UTC)
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A324D69
	for <io-uring@vger.kernel.org>; Mon, 13 Nov 2023 08:38:22 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1e9e4636ce6so602808fac.0
        for <io-uring@vger.kernel.org>; Mon, 13 Nov 2023 08:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699893501; x=1700498301; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2zeHTCEwkJWMtUTahIH4QC2kkGN1U6NwIG//5rchOt8=;
        b=kbGQ8jXqhaDzhUYskWopFc7duqIwZKmx7qY+CxunqVvb8ysz6aJvtB2xk+5BDhYeOG
         kaYLKF0ULdjiDEwZwsPq3PVstVIaHvET3f39E4NgLEEc4R6p9VSW5ph2b+PhiS9TqDLw
         fYpuU4tXCoKRaTs+bYCDtJnxgBhXzMyqnxHfaNbUx/83vcOSVeLQlV/Lt5bej1EmTFDH
         eLj6zG1Kj6HFP16EHmxMb6gj4nDWhiK+3sCU5BFKtCB+pCF7Mjw3Od1FpL0uo3fIz1sL
         cyscRa4C6AAO9wNQcKsiOgJQ0ptf1TzH65C2iZ8qDIB/lOM37l+5qAtxtbaEPQi/uJHS
         MYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699893501; x=1700498301;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2zeHTCEwkJWMtUTahIH4QC2kkGN1U6NwIG//5rchOt8=;
        b=o7iyXvYvSvhkgqyUYXgwSn9jhrFqEgXuzix00hjy5nY7yDdU0pHpWE56Op7A0W2Rvz
         uoFDWtTDwe1qy0qeZxtn8ABeCg8cq8Tzc6wNolfqIekB+zz3cecW6HJUXFsCssm2mVX9
         wQLFlm1gWIUJ3BQuOWYzfSj/Xu28tYxhx0I82NTdrXAHokZrwwr2Pfl7RROi/N+NS9f/
         f1zRIMf+SPwaG4Nx7/hXEoOmr80V2Hej05Bg8F6n4D/lmCgBg2MrecCBDFd+ldpLEqcx
         vp4hSWlspyxPMOPD7iRiy/hSJT1FceAwyC88bvEVdDUv1jEgrZV/GqhGpynQJEqorUrS
         jTjA==
X-Gm-Message-State: AOJu0YxhKmsY9wHqaQdO+MfsYCYd6x2Fc2sYk7sKIzLdkjl5JacOenBr
	whHp1eoBRSjKtza8Rg45QJZZ+g==
X-Google-Smtp-Source: AGHT+IE36sQjOPU+pSjqqYtv8a+WCA+IwmYMnfjSfw7wGxRsEjnOuaJR0ZLShmybuhzhLjMsSYwiGg==
X-Received: by 2002:a05:6870:7e0e:b0:1e9:e8fd:bb77 with SMTP id wx14-20020a0568707e0e00b001e9e8fdbb77mr8799627oab.0.1699893501349;
        Mon, 13 Nov 2023 08:38:21 -0800 (PST)
Received: from [172.20.4.17] ([12.191.197.195])
        by smtp.gmail.com with ESMTPSA id t19-20020ac865d3000000b0041ce9ebaad2sm2054046qto.43.2023.11.13.08.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 08:38:20 -0800 (PST)
Message-ID: <93c6f293-7aa5-4e12-b238-f369d53ab28e@kernel.dk>
Date: Mon, 13 Nov 2023 09:38:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com
References: <60464608-a9b7-4cf8-bd6d-c982210c6f83@kernel.dk>
 <CGME20231113031827epcas5p2e6e858292a3cd4b9e03b4615d972b22d@epcas5p2.samsung.com>
 <20231113031040.1391334-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231113031040.1391334-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/23 8:10 PM, Xiaobing Li wrote:
> After careful consideration and testing, I don't think getting the
> uring_lock is possible here, for the following reasons:
> Due to lock competition, ctx->uring_lock and sq->lock are usually not
> available here. The best proof is that the values of SqThread and
> SqThreadCpu always output -1. In this case, it is impossible to obtain
> the required work_time and total_time values.
> In fact, it should be feasible to obtain work_time and total_time by
> judging that ctx->sq_data is not NULL, because if the sq thread exits,
> the action of reading data will also stop, and the possibility of a null
> pointer reference is very low.

We have that problem right now, in the current tree. And agree it's not
the best. sq_data should be fine under the (ctx) lock, it's just the
thread that may go away. Maybe we just cache the cpu/pid of it when we
create it, seems better than needing to query it. And for the other
stats, should be fine in ctx->sq_data.

-- 
Jens Axboe


