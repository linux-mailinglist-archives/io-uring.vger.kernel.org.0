Return-Path: <io-uring+bounces-425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 093A4831FCB
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 20:34:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BBBA1C238DB
	for <lists+io-uring@lfdr.de>; Thu, 18 Jan 2024 19:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980C42E405;
	Thu, 18 Jan 2024 19:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s7DUPnSj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F27A2E403
	for <io-uring@vger.kernel.org>; Thu, 18 Jan 2024 19:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705606468; cv=none; b=GWeudUzc895JPTYvFYzwtt/qrrOyIZPRlcwEmBqY5l9Wc8NuUJ8mKxJxN25Gn1QosUBOvHaNG6MjYdtaV67WTkIR1Zt45VuAvm6SAd3i8ZTboEODLub1WNryZC+a32JJ59bLV1PbcHzqjYVaDVy4M3t85238g3fPkvosDmo2XPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705606468; c=relaxed/simple;
	bh=b5FwYCmuMfyWIbHYKlxaJmyq3KKcGbifob/gUmbvP/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tmdL0m9eXU0k1BZf8GdRN1MmOLjHXpVGzp1k1hVSsqGjpjP3bmOFrH56pr6yofe4A7rvTYZqNqUt0t2c79XpyJ+ib2iQ3Nbyuk55sgHhWiHePqsaxNvEEAnsb/zUK4dWNo8LICqDIhZCEnKfyJyb6ekywvecBawZ4Zua5pQs84A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s7DUPnSj; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7bee01886baso9039f.1
        for <io-uring@vger.kernel.org>; Thu, 18 Jan 2024 11:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705606466; x=1706211266; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CnrFrxp56NFMNrnCrVwG/+HU/kQ2wnZfA81brF/kE/g=;
        b=s7DUPnSjvzH8ztOmxWoTjRejRWH9+BLgAludHyKS+97LON4U40nxUONP/pfx/wYy2P
         Rf+14QZqqPvqg43SHB2jI4P9dz5cF8KTlrh3RQ8b78LTAJTeWLszqQULhUt8JvAs6MKL
         YKr0niNx0+p1lb7qWg74pb2FK3mO2RR1Vk+F4r5Je9enlKjLtO+DRYjbDFaEkumQJnJP
         /p3Nx0N/00DniiqeWJVhORCDpLpzKcTewCUDcIe0RHZeq7mNwsJFMY5NTxKmy9Id/iIH
         ETPFbnt3OsOToA2Ny8xx+tT0m2l8YulQl+Fhi3yPoIwLaYd5gP2+TkH6bmZUK4Fyhxou
         Jwug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705606466; x=1706211266;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CnrFrxp56NFMNrnCrVwG/+HU/kQ2wnZfA81brF/kE/g=;
        b=lExiTTKhDia+IaSBEJEIUlJzoZ28NuguJtxz8EKPr8DoKoHO0h1i/w8K/onnBjG75n
         bW+DCj22ao93ADsKGp+t+RZWjjBOQOf4sgAFHA2FccAQwQrbUdas57ASb9TlwJiNuNV6
         PwKKGhjK9wL5qUBtRDUEZW42sx5tjMIckMMiTREgGmAIyJmG6tc0VDWtDOgVPnus+t+Y
         cyN7udkNoSm/hJm7sAr2cz4hJx/9Gfrok8FvHGVGFoDz1Fi4HdDrWAoIs5IewfgdF/GV
         LVfbD0c2EiMfrRngbvQyYbxJMni49hLBgyAV27t7RLvk3EMGGCOyXl5JLNyQ8HrJCeFY
         1Htg==
X-Gm-Message-State: AOJu0Yx4ml8kk1UzdWMUJMD3a6ZFec+MwheRVbfpzqcShcIVMkmkcKtQ
	syUIIM5E6hVDuyesMOPl2W45Fe4WXnybSJ11Z7WC6xUmPoRou3YVmWKS9zNz71g=
X-Google-Smtp-Source: AGHT+IGjnDssC0Sb4H6/cdD4B1H0ME2lB4ZEcABBsnEX+OR63qzpBD3GVy93LXTChdbdT8mVElQe0g==
X-Received: by 2002:a6b:5a0d:0:b0:7bf:35d5:bd21 with SMTP id o13-20020a6b5a0d000000b007bf35d5bd21mr388653iob.1.1705606466230;
        Thu, 18 Jan 2024 11:34:26 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j24-20020a02a698000000b0046ebbcf956bsm358743jam.53.2024.01.18.11.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 11:34:25 -0800 (PST)
Message-ID: <8e104175-7388-4930-b6a2-405fb9143a2d@kernel.dk>
Date: Thu, 18 Jan 2024 12:34:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] io_uring: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To: Xiaobing Li <xiaobing.li@samsung.com>, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
 cliang01.li@samsung.com, xue01.he@samsung.com
References: <CGME20240118073844epcas5p2f346bc8ef02a2f48eef0020a6ad5165d@epcas5p2.samsung.com>
 <20240118073032.15015-1-xiaobing.li@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240118073032.15015-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/18/24 12:30 AM, Xiaobing Li wrote:
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index 976e9500f651..24a7452ed98e 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>  	unsigned int sq_shift = 0;
>  	unsigned int sq_entries, cq_entries;
>  	int sq_pid = -1, sq_cpu = -1;
> +	long long sq_total_time = 0, sq_work_time = 0;
>  	bool has_lock;
>  	unsigned int i;
>  
> @@ -147,10 +148,17 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>  
>  		sq_pid = sq->task_pid;
>  		sq_cpu = sq->sq_cpu;
> +		struct rusage r;
> +
> +		getrusage(sq->thread, RUSAGE_SELF, &r);
> +		sq_total_time = r.ru_stime.tv_sec * 1000000 + r.ru_stime.tv_usec;
> +		sq_work_time = sq->work_time;
>  	}

I guess getrusage() is fine here, though I would probably just grab it
directly.

> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 65b5dbe3c850..f3e9fda72400 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -251,6 +251,9 @@ static int io_sq_thread(void *data)
>  		}
>  
>  		cap_entries = !list_is_singular(&sqd->ctx_list);
> +		ktime_t start, diff;
> +
> +		start = ktime_get();
>  		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>  			int ret = __io_sq_thread(ctx, cap_entries);

But why on earth is this part then not doing getrusage() as well?


> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
> index 8df37e8c9149..c14c00240443 100644
> --- a/io_uring/sqpoll.h
> +++ b/io_uring/sqpoll.h
> @@ -16,6 +16,7 @@ struct io_sq_data {
>  	pid_t			task_pid;
>  	pid_t			task_tgid;
>  
> +	long long			work_time;
>  	unsigned long		state;
>  	struct completion	exited;
>  };

Probably just make that an u64.

As Pavel mentioned, I think we really need to consider if fdinfo is the
appropriate API for this. It's fine if you're running stuff directly and
you're just curious, but it's a very cumbersome API in general as you
need to know the pid of the task holding the ring, the fd of the ring,
and then you can get it as a textual description. If this is something
that is deemed useful, would it not make more sense to make it
programatically available in addition, or even exclusively?

-- 
Jens Axboe


