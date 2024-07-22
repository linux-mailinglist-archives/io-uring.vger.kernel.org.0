Return-Path: <io-uring+bounces-2536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D55938F18
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 14:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B2191C21101
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 12:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 270A916A94A;
	Mon, 22 Jul 2024 12:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMWgq8Yv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5460216415;
	Mon, 22 Jul 2024 12:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721651442; cv=none; b=cyHyGggoxtrI9opAD0YOABpdCVnhdrrKei8KSi1wgRP3G1UJ6kzaKvrfovKQAFZcx6LFnQccI17Hdr3RbtvNa4gpOi9/501ZqSUEVtJTBaVthMnJndAIL/f1XvO9y3mG5lqNnY5xS7ybgy7ZeHQXyvZmby0FU3btJWJF70zREVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721651442; c=relaxed/simple;
	bh=a3uw0GVgBFz5Uu3CthKf4SZG+vNQXvq8b9msqSOJ+uM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R158AFBgGuO9ADndsYC4wNRvXl5wwGUjYKWnOvfbzM0VebD+Nk6UowehLcKLqrATDeNNtz5zlHYTucO838TEGIhSOGgNK+fiK39wkVf357Am701k4ke849oiZT3wNGODX8qESF1r1z1hUHIfbERFgcmgUKh0YSYoYkM1lgcfxSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CMWgq8Yv; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52f01993090so1535347e87.2;
        Mon, 22 Jul 2024 05:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721651438; x=1722256238; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eptFeU8CJqEx351tabLE2guumHvDrPbBEYemGsbHeAw=;
        b=CMWgq8YvXLXaxYFawjB0hxjjOHlfC0otdqWlCzs5v8nfyrbvS8sQgD8NLrRRuUB4sJ
         ondIfIAYH9tvLsF6enu7E1XrRIOFf+bRf2kuJXn6s+m6Apo2MjETMNiu41sI4HwIBjOc
         c3kfeDY8oQQsoxyK0NGqsOBe961AkgLvJCRB1EOP1FITa6RQG8J+0QHoSBjI9EAdIiaw
         +spyOhPAuUti/aejOSTVXvTFwlNyCPoFcq4ZPs4IKAHwRcxUXMCmiWawRrPp5TJBs1gc
         aSvY1us619H9gmHUdllxbjiOggdtqr8R4gzzf3LM03rV82s0cwl+AMI8NUcAPtUMSdE3
         n1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721651438; x=1722256238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eptFeU8CJqEx351tabLE2guumHvDrPbBEYemGsbHeAw=;
        b=mjZ6Km9wgjLm+XSzEiwbJUnhUHVmJz39Hbt5xhKrlbGBPhY+6qQvDaybz0mArsjkIi
         58/tdUlpzF26R8aNZxx/9oUJecmvw8HSQGmtVIeRmdSRMTmpGqRkBkt6ZxoQuAO1T3ok
         23sOOI+LAdcx7dvQMcMb2NpJWtz69mUIcVSRafNXM8qiqeChsKNBPctD0fXWU4aPvm7H
         WxwfZOFPJmV7LSanvND84XQm6pDQcgJzmxxmIt1RONsC6w6cZ+dXX7SsXZnorGKCN3UR
         deF2eSMiWJE0P1apno0g9RLrzxMxpaCLCk1pig7iEw3bdTpWIcTIqK3fAyqGkKVIMgku
         hgkw==
X-Forwarded-Encrypted: i=1; AJvYcCWdy25BFEfEmBcOx9U7SO1zgksRJ5l3ApqCd+kWevQubgnyWf5ZIgxNIQSjHszUS3pnqxP2mC2WW2vO5Pgt0IniPTwQFmJl3Y+WyKM/
X-Gm-Message-State: AOJu0YxJk1evgh9AHWcsgK6lADFyP2ERzjKAfasVIuRtEvF3EUmGDzIE
	Else/Dt2sdAjGQXvfxqy3WdT24MbI2ovRr3sq+UsBGtJlzXHTdR+
X-Google-Smtp-Source: AGHT+IHfBGCsUGlWcxXpDH//Hdu/An4ggrc6YusD9TiHaUYb4RxNEcCbwk4td1ScSnWnNGfhVZUe0Q==
X-Received: by 2002:a05:6512:4009:b0:52c:dd0c:4c57 with SMTP id 2adb3069b0e04-52efb74cf2emr4287191e87.27.1721651438007;
        Mon, 22 Jul 2024 05:30:38 -0700 (PDT)
Received: from [192.168.42.33] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a3c7be7fdsm422418566b.86.2024.07.22.05.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 05:30:37 -0700 (PDT)
Message-ID: <822ea7ba-5199-44bc-a976-0ba55509c909@gmail.com>
Date: Mon, 22 Jul 2024 13:31:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 RESEND] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20240709092951epcas5p24783c3bb5c23277cf23a72a6e1855751@epcas5p2.samsung.com>
 <20240709092944.3208051-1-xue01.he@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240709092944.3208051-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 10:29, hexue wrote:
> io_uring use polling mode could improve the IO performence, but it will
> spend 100% of CPU resources to do polling.
> 
> This set a signal "IORING_SETUP_HY_POLL" to application, aim to provide
> a interface for user to enable a new hybrid polling at io_uring level.
> 
> A new hybrid poll is implemented on the io_uring layer. Once IO issued,
> it will not polling immediately, but block first and re-run before IO
> complete, then poll to reap IO. This poll function could be a suboptimal
> solution when running on a single thread, it offers the performance lower
> than regular polling but higher than IRQ, and CPU utilization is also lower
> than polling.
> 
> Test Result
> fio-3.35, Gen 4 device
> -------------------------------------------------------------------------------------
> Performance
> -------------------------------------------------------------------------------------
>                    write          read           randwrite       randread
> regular poll    BW=3939MiB/s    BW=6596MiB/s    IOPS=190K       IOPS=526K
> IRQ             BW=3927MiB/s    BW=6567MiB/s    IOPS=181K       IOPS=216K
> hybrid poll     BW=3933MiB/s    BW=6600MiB/s    IOPS=190K       IOPS=390K(suboptimal)
> -------------------------------------------------------------------------------------
> CPU Utilization
> -------------------------------------------------------------------------------------
>                  write   read    randwrite       randread
> regular poll    100%    100%    100%            100%
> IRQ             38%     53%     100%            100%
> hybrid poll     76%     32%     70%              85%
> -------------------------------------------------------------------------------------
> 
> --
...
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 1a2128459cb4..5505f4292ce5 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> +static int io_uring_hybrid_poll(struct io_kiocb *req,
> +				struct io_comp_batch *iob, unsigned int poll_flags)
> +{
> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	int ret;
> +	u64 runtime, sleep_time;
> +
> +	sleep_time = io_delay(ctx, req);
> +
> +	/* it doesn't implement with io_uring passthrough now */
> +	ret = req->file->f_op->iopoll(&rw->kiocb, iob, poll_flags);

->iopoll vs ->uring_cmd_iopoll, same comment as in my
previous review


> +
> +	req->iopoll_end = ktime_get_ns();
> +	runtime = req->iopoll_end - req->iopoll_start - sleep_time;
> +	if (runtime < 0)
> +		return 0;
> +
> +	/* use minimize sleep time if there are different speed
> +	 * drivers, it could get more completions from fast one
> +	 */
> +	if (ctx->available_time > runtime)
> +		ctx->available_time = runtime;
> +	return ret;
> +}
> +
>   int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   {
>   	struct io_wq_work_node *pos, *start, *prev;
> @@ -1133,7 +1203,9 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   		if (READ_ONCE(req->iopoll_completed))
>   			break;
>   
> -		if (req->opcode == IORING_OP_URING_CMD) {
> +		if (ctx->flags & IORING_SETUP_HY_POLL) {
> +			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
> +		} else if (req->opcode == IORING_OP_URING_CMD) {
>   			struct io_uring_cmd *ioucmd;
>   
>   			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);

-- 
Pavel Begunkov

