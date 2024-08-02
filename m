Return-Path: <io-uring+bounces-2637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB73945D0A
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 13:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA79C1F21D7B
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 11:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4044B146D4C;
	Fri,  2 Aug 2024 11:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJDvUzuh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74210487B0
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 11:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722597293; cv=none; b=BZ7WX0vYahom3eQ/5/5dNPRb9nlTFTFfO+0tiM+y83KNvBRXiF4IcrFXP9U175GKD/D3LMq1jWZD8ckJrmLwj3lAxVb6eR5imVnQoT9TjWqKHbNtqZMSXSD8S9tX0BeftnI7x0bxyOQIukN0Xx3g8w9MLiMXTZDLRT/1lWEOxVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722597293; c=relaxed/simple;
	bh=exxUYNcSQJIH2/F/lI/Q5U/cCgoOnpEYJvdU6Jc2JQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bhxcQodTlfBvurBCo7O/VGT4b7KP9gEByFBkTp+xjj1uIG/kP6cff0s6mwD/A6fYD9a2XM2VdpoGPqC1pZelYr3HoWuZs2Ppt71OxcZNMnih6XvD+z3A9i8MdUBhpo9X0suGoLEusBG0jhr3gKrZkXc3Zpoe4obrvek9uIgJuhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJDvUzuh; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-36887ca3da2so3720455f8f.2
        for <io-uring@vger.kernel.org>; Fri, 02 Aug 2024 04:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722597290; x=1723202090; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oeLsk86q/jp6EBacPBsya97/KxIz2njnQlKyq/w99rs=;
        b=dJDvUzuhjLn5Ompxb1rC1LW4xQiTnq/MT99WYhqw76cK34fLimj8LlArEKxIskwu4B
         dieDo11C+yVnTS3v8DsLxJPZtivtdBk3G3148kc+dMCZhO2BV/crSEfWoCjtc6zB6bQU
         SEELoaROtIRuYKW4VuKOBArxeTmQSCopNLFfX23X493iwnOUmZ3/of8nzB3JyBZgvmT1
         GvUvt3XW8uNN1qxnSWEpWdAOpzHAHJaI1oggUShHsjJ7JnIxPfrg/qGbOAhyXh9RGDJK
         V6CXEUXodKaUj4iPe8W5uwSo4KcX6pp21q75tAuA8oR8BCmzRlKUDEiDEd0g+kHv/26t
         ylZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722597290; x=1723202090;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oeLsk86q/jp6EBacPBsya97/KxIz2njnQlKyq/w99rs=;
        b=vUvfHRynvDcokDzOp5CRfWnKK/6cds8nQuV9lZqdFj/AbcM6mXlwHAkmUSCHXCQqNd
         aTIEYkrVoLKkdmmM2ZRdPb3lpbZOr8LChScxm18C5HM5xcds7ahqutJGqGAi0tJWy26q
         ReVr4x+ViNAlVApH5mWdB08yvKXMNOuj98ObudXXDdKgYQMfxNF9fyDdDbXmVrk4VnP/
         cDjsJ4AEAodV8O4ylh3SCVZ3n/SkIwgSYgCPJ9JAR+kcch38JjI/WLX06uTOpetX/oQd
         1U6T3snrTFll3rvj+q690s5DQaOgwikJc4wpi5LPNh6NwUEScoTSatU1lfC4StYStVKH
         J2RA==
X-Forwarded-Encrypted: i=1; AJvYcCVBDzxD2ClwFXW95AKatu3Ottf++aYeWDyBkw9I4e7wGYBBDouJjXWSMckKd9+LPziv6nu33JAkG+Eu3sr93ZG1+WKjtjPdn+U=
X-Gm-Message-State: AOJu0YxQ8OhL48+h579TzJMEQDo+y0n1u2Fw6PIqKWOrHdF6xD3shleD
	680OCXYf5heAY49l1xcsYSUuLRcT477jbAj+OOOH9x//wh34LhOA
X-Google-Smtp-Source: AGHT+IEqw+UlxzgxIHwbT9o8OVeO1G5excZDqTzuG7pqj5AcmaQpMsu9Vy8whWy7sT42ZMHG8gTFHg==
X-Received: by 2002:a5d:4d47:0:b0:36b:3535:a9c4 with SMTP id ffacd0b85a97d-36bbc1cea9cmr2129334f8f.51.1722597259925;
        Fri, 02 Aug 2024 04:14:19 -0700 (PDT)
Received: from [192.168.42.220] (82-132-220-64.dab.02.net. [82.132.220.64])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd01ab49sm1719551f8f.40.2024.08.02.04.14.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Aug 2024 04:14:19 -0700 (PDT)
Message-ID: <eba4f346-ede3-4d1e-b33d-f07227982355@gmail.com>
Date: Fri, 2 Aug 2024 12:14:52 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: do the sqpoll napi busy poll outside the
 submission block
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <cover.1722374370.git.olivier@trillion01.com>
 <382791dc97d208d88ee31e5ebb5b661a0453fb79.1722374371.git.olivier@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <382791dc97d208d88ee31e5ebb5b661a0453fb79.1722374371.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 22:10, Olivier Langlois wrote:
> there are many small reasons justifying this change.
> 
> 1. busy poll must be performed even on rings that have no iopoll and no
>     new sqe. It is quite possible that a ring configured for inbound
>     traffic with multishot be several hours without receiving new request
>     submissions
> 2. NAPI busy poll does not perform any credential validation
> 3. If the thread is awaken by task work, processing the task work is
>     prioritary over NAPI busy loop. This is why a second loop has been
>     created after the io_sq_tw() call instead of doing the busy loop in
>     __io_sq_thread() outside its credential acquisition block.

That patch should be first as it's a fix we care to backport.
It's also

Fixes: 8d0c12a80cdeb ("io-uring: add napi busy poll support")
Cc: stable@vger.kernel.org

And a comment below

> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   io_uring/napi.h   | 9 +++++++++
>   io_uring/sqpoll.c | 7 ++++---
>   2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/napi.h b/io_uring/napi.h
> index 88f1c21d5548..5506c6af1ff5 100644
> --- a/io_uring/napi.h
> +++ b/io_uring/napi.h
> @@ -101,4 +101,13 @@ static inline int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
>   }
>   #endif /* CONFIG_NET_RX_BUSY_POLL */
>   
> +static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
> +{
> +	int ret = 0;
> +
> +	if (io_napi(ctx))
> +		ret = io_napi_sqpoll_busy_poll(ctx);
> +	return ret;
> +}
> +
>   #endif
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index cc4a25136030..ec558daa0331 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -195,9 +195,6 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>   			ret = io_submit_sqes(ctx, to_submit);
>   		mutex_unlock(&ctx->uring_lock);
>   
> -		if (io_napi(ctx))
> -			ret += io_napi_sqpoll_busy_poll(ctx);
> -
>   		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
>   			wake_up(&ctx->sqo_sq_wait);
>   		if (creds)
> @@ -322,6 +319,10 @@ static int io_sq_thread(void *data)
>   		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
>   			sqt_spin = true;
>   
> +		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +			if (io_do_sqpoll_napi(ctx))
> +				sqt_spin = true;

io_do_sqpoll_napi() returns 1 as long as there are napis in the list,
iow even if there is no activity it'll spin almost forever (60s is
forever) bypassing sq_thread_idle.

Let's not update sqt_spin here, if the user wants it to poll for
longer it can pass a larger SQPOLL idle timeout value.


> +		}
>   		if (sqt_spin || !time_after(jiffies, timeout)) {
>   			if (sqt_spin) {
>   				io_sq_update_worktime(sqd, &start);

-- 
Pavel Begunkov

