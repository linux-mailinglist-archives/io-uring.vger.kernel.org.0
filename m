Return-Path: <io-uring+bounces-94-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2A87EC418
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 14:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12FBA1C2074A
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 13:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8DF18646;
	Wed, 15 Nov 2023 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="d44Y42Ns"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF359179A6
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 13:51:20 +0000 (UTC)
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ECBAC
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 05:51:19 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-77bccdea0ffso11228285a.0
        for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 05:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700056279; x=1700661079; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WYEMkbRs5f6FQHbQGdDrqvN21x+DPqoXcf4uI4/Hi3A=;
        b=d44Y42Ns+Ep6JW+TMjbKPDHJzX64ECRGhZT/t7+ac39ONy8ewOlVQzwnPS8d0E/FY3
         as1YrZULZnR8c+11UAz6010jByqAPEPnFBNUh1VXxDXesJ64HhD/DbAviF4j4DB8UDJI
         pFRsO9I7hwJzsnArHK6/J8WnkjIYx5GjmxAANz7q0jyozQLIU33AZVZxdjwlp+xK6Paw
         OYeWJcLOjiBoCHirnF7EG5ATlLT/w627a7v51CQiLX4NgvEl4J05OaBet8Wk5C/GoABH
         WvCuPXdz2P358JR10TVhTEu4ZvqK+KCaNy0TJgvcOhZLSrrZB85Zxoccc0sbAlIJquKK
         C/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700056279; x=1700661079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WYEMkbRs5f6FQHbQGdDrqvN21x+DPqoXcf4uI4/Hi3A=;
        b=c51ZT12RVaweJZUFH0Z0H7dEspSOMhtCM/aQ5P0uYTSUnvth2zWOZUESbpfMOhuEfo
         s+dvLeiQc8USnOVrnjvYWo8MvPsOhQPNGSInMnOpe7ju2yboU3IAUpmF6Wi/UsLeXker
         6h9fFb4C+VcwGP+tBPTNvtCDZ3cqeB29gJdqqo2DqyDU0dRRLOpDCGUAOLUb1arB+OPL
         bDoFA90fHlM3tQ3ujYkDrqKh1czFOThHAJYBXp0tC+bYStyaZnJkk4yDCb6pwLg0Q+vf
         gAGLdgYXVZIlGGZ9fbhItvYtPrwZu2aJa7965sfUnCtkGYT196ikMcFSGCIFCxetkYLf
         CwAw==
X-Gm-Message-State: AOJu0YxKp6oy2QbU8tXd6Jq0j/XMouHW5KkhonA/NzSVrc+n2uBmojBH
	IrgGJ2Wl8aShFPwuQSjI4L1kOw==
X-Google-Smtp-Source: AGHT+IGaj1Qpq+RNmSVt5V0/DdAN36kVvgi9dfEsGco2RNPoc4Fw6kPcMdc1FeDZbo3ALaKmjZSsgQ==
X-Received: by 2002:a05:620a:1a0f:b0:767:e04f:48c8 with SMTP id bk15-20020a05620a1a0f00b00767e04f48c8mr5993087qkb.7.1700056279043;
        Wed, 15 Nov 2023 05:51:19 -0800 (PST)
Received: from ?IPV6:2600:380:9175:75f:e6af:c913:71c3:9f81? ([2600:380:9175:75f:e6af:c913:71c3:9f81])
        by smtp.gmail.com with ESMTPSA id b22-20020a05620a127600b0076c8fd39407sm3470731qkl.113.2023.11.15.05.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 05:51:18 -0800 (PST)
Message-ID: <b4a58cf5-3bc6-4279-8a33-d7209a60164f@kernel.dk>
Date: Wed, 15 Nov 2023 06:51:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
 cliang01.li@samsung.com, xue01.he@samsung.com
References: <CGME20231115122627epcas5p37263cadafd5af20043fbb74e57fe5a4c@epcas5p3.samsung.com>
 <20231115121839.12556-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231115121839.12556-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/23 5:18 AM, Xiaobing Li wrote:
> v3:
> 1.Since the sq thread has a while(1) structure, during this process,
>   there may be a lot of time that is not processing IO but does not
> exceed the timeout period, therefore, the sqpoll thread will keep
> running and will keep occupying the CPU. Obviously, the CPU is wasted at
> this time;Our goal is to count the part of the time that the sqpoll
> thread actually processes IO, so as to reflect the part of the CPU it
> uses to process IO, which can be used to help improve the actual
> utilization of the CPU in the future.
> 
> 2."work_time" in the code represents the sum of the jiffies count of the
>   sq thread actually processing IO, that is, how many milliseconds it
> actually takes to process IO. "total_time" represents the total time
> that the sq thread has elapsed from the beginning of the loop to the
> current time point, that is, how many milliseconds it has spent in
> total.
> The output "SqBusy" represents the percentage of time utilization that
> the sq thread actually uses to process IO.
> 
> 3.The task_pid value in the io_sq_data structure should be assigned
>   after the sq thread is created, otherwise the pid of its parent
> process will be recorded.
> 
> 4.After many tests, we do not need to obtain ctx->uring_lock in advance
>   when obtaining ctx->sq_data. We can avoid null pointer references by
> judging that ctx is not null.

This is mixed in with my patch, please just base it on top of the v4
I'll send out now rather than integrate it. And then you'd need that rcu
free patch as well on top of that, then your changes as a separate
patch.

-- 
Jens Axboe


