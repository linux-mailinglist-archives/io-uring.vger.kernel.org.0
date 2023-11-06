Return-Path: <io-uring+bounces-35-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 386BA7E27C6
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:55:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E70DF28129F
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 14:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6141728DB6;
	Mon,  6 Nov 2023 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2k2tFvPu"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8087465
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 14:55:24 +0000 (UTC)
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAE5EA
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 06:55:23 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-7ac830e8b74so41027339f.1
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 06:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699282522; x=1699887322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iairs2nHbf4BFvIm6R4/DL1Lv/6t5zKTAWcYMmkRBmo=;
        b=2k2tFvPu8qRmpOnG+RiggRUTFNK/9Zy6UWXbrZjYt2n7CyZiFT2s1T4v+W7mdL1yM3
         VY7X7dmA7OMhpkacCdHBiHaHI07Cj411B+YdTMEajUBSk0YoNQc476nm8e3WVfAZDLcP
         ++Lv3l5+Bhv5FplzALUKJAE4SjpezHeyKOAUeJS8IHu/OFwwpTOJV8932MXyj1gdQW0e
         8fqGI0TQUtNosHvEpnoSK5YHN0vIqoCgtWSeroUZ4/lR9u96bvLa9sIntZgSoB65GaQ7
         kEd/pAfwhydldOle+MCFKIX78Nuy6zzbP+Y/tQp8mHhrYDxL1FpQXvXQQyUEdi8qGXZK
         zSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699282522; x=1699887322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iairs2nHbf4BFvIm6R4/DL1Lv/6t5zKTAWcYMmkRBmo=;
        b=O2zKvkT+HbTqbmRHJ3USkwG5ouS6EGR+LV5sFrPRwNJWk2EDkFZ2DgyLlInLEvV+pD
         btgwABFByEhMdVSsthi0h6bSXGA2tatJJdYsXjirbUyUDc5kNAQMulUHD4kYemjMgMr2
         LMzOozzMExlGHrzQv4JzdoX/HzaxlnafdaiSxdgS6AqYv7MruGpXvdEKgv+rLwYvnKgN
         PgWCbGbmKscdv0vyY25L58N4PbX6MalLc4WpvqQ848mCYr3ie0HbJZut/03E87PUKzxh
         ywQuwx8UzetBrGAJZ5UxvBGccWcCqwT8ucgrzzPdK7+V+vIaef3NXLWefr9wC4IJkRoD
         gXRg==
X-Gm-Message-State: AOJu0YzufOpGCw9NA8BQ4nuPJ3FHoG5bPZ/oN4uMjY/iifO11i9qFjoR
	TBugdrGLMKdNeefvm+Q+tQAE4g==
X-Google-Smtp-Source: AGHT+IEG4LkvzOFaOp62JcFT1CxHf8o8fb6KRC4bWob/4jtCewcHGdjRc90M/C/q507HMKpXurQncA==
X-Received: by 2002:a92:d08b:0:b0:359:39ac:a161 with SMTP id h11-20020a92d08b000000b0035939aca161mr15435444ilh.1.1699282522379;
        Mon, 06 Nov 2023 06:55:22 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id gs25-20020a0566382d9900b0042b2f0b77aasm2118414jab.95.2023.11.06.06.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 06:55:21 -0800 (PST)
Message-ID: <2a1bdb5a-1216-45b0-a78d-5542b36ccd17@kernel.dk>
Date: Mon, 6 Nov 2023 07:55:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] IO_URING: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com
References: <CGME20231106074844epcas5p252beb2aa7925de34aea33d5c64d1d72e@epcas5p2.samsung.com>
 <20231106074055.1248629-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231106074055.1248629-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/23 12:40 AM, Xiaobing Li wrote:
> Since the sq thread has a while(1) structure, during this process, there
> may be a lot of time that is not processing IO but does not exceed the
> timeout period, therefore, the sqpoll thread will keep running and will
> keep occupying the CPU. Obviously, the CPU is wasted at this time;Our
> goal is to count the part of the time that the sqpoll thread actually
> processes IO, so as to reflect the part of the CPU it uses to process
> IO, which can be used to help improve the actual utilization of the CPU
> in the future.
> 
> Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
> ---
>  io_uring/sqpoll.c | 8 ++++++++
>  io_uring/sqpoll.h | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index bd6c2c7959a5..27b01ad42678 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -224,6 +224,7 @@ static int io_sq_thread(void *data)
>  	struct io_ring_ctx *ctx;
>  	unsigned long timeout = 0;
>  	char buf[TASK_COMM_LEN];
> +	unsigned long long start, begin, end;
>  	DEFINE_WAIT(wait);

These can just be unsigned long, that's the size of jiffies on any
platform. Ditto for struct io_sq_data.

And while this looks fine, nothing is using this accounting. For this to
be an acceptable patch, surely the value needs to be used somehow or at
least you should be able to query it?

-- 
Jens Axboe


