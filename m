Return-Path: <io-uring+bounces-2122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B778FD1B3
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 17:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B0D2282BB0
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 15:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D2635280;
	Wed,  5 Jun 2024 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMOfK0LE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347361773D
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717601542; cv=none; b=B3ETXN+p8oxHzk4IcWLZNrsiWxWzMudBmJf7BX6SqmcWtU50iQKNfUYXVKBZtL57sFAYvtpZ/1tSDT05I4/YpZ1ULPUdlL6oaRP0oV2uWdumGx+jqYqCVpwLPEhamCcbJbQQPy9lREo7uKJXA1eeqNYcJSfF8szblTJaRS472Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717601542; c=relaxed/simple;
	bh=8PILADw9rhnOIQi8oYQGcO4WGiygPzfjB10W5p8bxVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=naqgSM/1hcdBUApwy2m7qDBQLD5q/29x0Fp8nr2E4PzRpXYttWL2pt2/rx6drZ/sHxhwGXMi20K738ATbt5kGKs40L6/5NpfliUx/QU3z2/VgDP0S7sTGf0p1zfxAZOcJ1om4RauMXE2lA/j2prBICwrE1Rq25foL9nKnBdp2rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMOfK0LE; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52b93370ad0so6426505e87.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 08:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717601539; x=1718206339; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hQJinLmefZXFVGrhkVwiHGTQFlNB2zVDvwVPOwYi/5I=;
        b=BMOfK0LEtA52aXc3wFm9k/28L5ffaBp6WvvGotSv72HlD5k758RXP6SFE4iqXldNTB
         ug8/YEeepavT0ZRbNrDk9Z+RL5yt2qbDq+x/aXMab8R3rpMwRZYWOTjbvGNaUSHNisCt
         ek+f7BzT8XWWqXvUHk5Wu22+udo4UIvMppCKEfKSHfg0yDV0KFyukmeluQnWeRnXCcsY
         UbBXH3dROPhyax61k/cV4Y+/zqtD+MI9KWA6nz/P+KsB5n3trB0ktNGCeyou3oiiADcT
         BKMZG68769wFyiHyRS/QVK/GDvAK4MMdDXapy0epxD8e8vWhUgzDt0j+BdB1JiJgspBU
         akYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717601539; x=1718206339;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQJinLmefZXFVGrhkVwiHGTQFlNB2zVDvwVPOwYi/5I=;
        b=ru1Xv5rQshJEWckjFrGw9wd/m6UCiEWV32EPNkc2CceBQ/Vtxqcg8ehTqkbHdMEhLl
         NnlQNuKAFgqlR8ZhJM8pDx+TYupRTrkTRhl4BctQPq1J67IrSiMoPOCZPR8E4Pt7lXWU
         9YAJjDCxu07T/D5ECheVQlKG6CBirgbjy2wp4ys/BNI0SY0VocI/heQt+EZloSoovZAx
         yPjJxZNNvDdrheS8jdZNkaNm4jag8b34+LzhN04yYfv6x8f5Hy0qWRHAO2WpuolCYnkk
         /9ATEWrW3wOu35BOergCL9VGMRKQDhJck6BQJlawFWjJ1lfEkRXTBhHapfsXwrjYS9Fh
         M8Rg==
X-Forwarded-Encrypted: i=1; AJvYcCX9itJfC4dNIdgryMaLme+JsOSWpjPV2LSAMBdPGBT40Y3prrbfm74jhVYclKauCyPJDYKhHQF5bYryWRNSVyb/0nLoxwdEa58=
X-Gm-Message-State: AOJu0YxMjjAN1oAYZ/qvzjyQDCZQv7gttANCHFAs7AF8ulccE7h/bMDu
	I4TXbH4wquF0OISkFEjfTupnDlX1rQB/G2k2H/UrxI1yo1P8+G0J
X-Google-Smtp-Source: AGHT+IFHc2TKV3xrOVyEeWcdd4DYjijXTv+QttR9GwONJ9U3slqo5hSBh1RCiDbIkQkMPldtM7opQw==
X-Received: by 2002:ac2:5b89:0:b0:52b:8343:618f with SMTP id 2adb3069b0e04-52bab4dc99dmr2548858e87.24.1717601538919;
        Wed, 05 Jun 2024 08:32:18 -0700 (PDT)
Received: from [192.168.42.45] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6abcd1f832sm96003466b.157.2024.06.05.08.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 08:32:18 -0700 (PDT)
Message-ID: <e5146117-b6cd-427d-a25e-366f73552663@gmail.com>
Date: Wed, 5 Jun 2024 16:32:22 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] io_uring/msg_ring: add basic wakeup batch support
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240605141933.11975-1-axboe@kernel.dk>
 <20240605141933.11975-9-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240605141933.11975-9-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 14:51, Jens Axboe wrote:
> Factor in the number of overflow entries waiting, on both the msg ring
> and local task_work add side.

Did you forget to add the local tw change to the patch?


> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/msg_ring.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index 9a7c63f38c46..eeca1563ceed 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -109,6 +109,8 @@ static void io_msg_add_overflow(struct io_msg *msg,
>   				u32 flags)
>   	__releases(&target_ctx->completion_lock)
>   {
> +	unsigned nr_prev, nr_wait;
> +
>   	if (list_empty(&target_ctx->cq_overflow_list)) {
>   		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &target_ctx->check_cq);
>   		atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);
> @@ -117,10 +119,14 @@ static void io_msg_add_overflow(struct io_msg *msg,
>   	ocqe->cqe.user_data = msg->user_data;
>   	ocqe->cqe.res = ret;
>   	ocqe->cqe.flags = flags;
> -	target_ctx->nr_overflow++;
> +	nr_prev = target_ctx->nr_overflow++;
>   	list_add_tail(&ocqe->list, &target_ctx->cq_overflow_list);
>   	spin_unlock(&target_ctx->completion_lock);
> -	wake_up_state(target_ctx->submitter_task, TASK_INTERRUPTIBLE);
> +	rcu_read_lock();
> +	io_defer_tw_count(target_ctx, &nr_wait);
> +	nr_prev += nr_wait;
> +	io_defer_wake(target_ctx, nr_prev + 1, nr_prev);
> +	rcu_read_unlock();
>   }
>   
>   static int io_msg_fill_remote(struct io_msg *msg, unsigned int issue_flags,

-- 
Pavel Begunkov

