Return-Path: <io-uring+bounces-7185-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2465A6C508
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 22:22:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55378482637
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 21:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1945F231C9F;
	Fri, 21 Mar 2025 21:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cGlNMm+y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE28231A3F
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 21:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592112; cv=none; b=jgscvoy9JqIxYT+3THJbAk+eQwNIrDJnB249FOAIAt11vs/faCKbg4mobIbFiWPYdIZFs2wkPMZbsYuREEWjB487RgvZpmCIFVp5LNGuf4roqUBQm1clyo7CNvhqDD3xtPAUZl00A5fp0GGc5M64x57JNNmLiDNyJPKQN96h64c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592112; c=relaxed/simple;
	bh=yJLoXfiEouZt+KOhRHO5pH9MtYvJpUrzuErfKvPfDmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Lq8Xg8NZ0ETZyYy0z8A9DF4cztLdSTc9ivF4EtLa1CJuxrdvooLDgPvjdSi2tDiWv+zE+Y6AYMU/pejCJcmj0n7knQ6xfJcsFENxFvtc+I1ba/E3E1oZ79M7FIFE8SXFB2jwuxHmPqpwro95Ac+wh/xoglAVeolYOAwXERst1Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cGlNMm+y; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac2a81e41e3so523495366b.1
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 14:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742592108; x=1743196908; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EiE9ulQf78jT+XG0+zjO/jo//TdOQa9vYa24HtRaJCc=;
        b=cGlNMm+yAV6cK7pqDZPoGkiYmcobch4lAI3QhQe9SbGx9y+tQqUGQM2lG95hjRY9qv
         anz09v92QQ9fIJHS/NVLPsXybTUDuKWaegIi1rlhwcbV3YYBNANuqEx0KISd+onmuWaj
         9Cw5rPJCt+S6cpGicuFFzhBo+8I+RBVYGlYeXzHPGP4tPxPq7/hCEXnPpWFusU2+Ooni
         dIid7f8zXmI8nDg1hrDmJgIvTgOtJ7AA3RA7Ti14m04je95cPAbiqWSj8pTuSise2jKh
         w2GDtBk/zATtNLIH8RqHyjjSDK8cj/RubsvdtN51Q1ijW0qWHU+Ojqo//yOMy39ESilp
         oIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742592108; x=1743196908;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EiE9ulQf78jT+XG0+zjO/jo//TdOQa9vYa24HtRaJCc=;
        b=tZpN/khWC435c2B7q8Z0M+VKTk6cj8Bron4uZKsVz9VMfTfnDCdE6OT1cDb4O9mGNZ
         QH6ttGyDExOA7sB66jFz+7gpZqpoEm4bSfa83bUo90N2Of1TzzeIqveN29dHv9guCQjq
         cHeGC/oeIZ6hzuMwbdLlbSz+3o2V88E+eV5LUmH8WB54f16Kkx921l3HZuTPRAqSK5kg
         20430MlL0cQv+loJvGZcIJu5kkIqyK2hALPqZzf+XC2faRXShqdM8CouJL9D+wXmGiST
         Vc8hBBYWymWMe6WTYTZbPiqz31v2qg98JX5JFuRMU80+syBF7XmpQ0NXuWLfQTfYGIfR
         kZdA==
X-Forwarded-Encrypted: i=1; AJvYcCWLrqZoWnyieQDTZ2ksJZoDVwVuHotgPtllclx6eWXG3KTYIfYAG1uksQzmCLXwz1HxsAwDmreMkA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj4IVzuT2y47THp0pYp2pDYzALNufhqfGPOT8BC2JJ2A5hhSUI
	2ls5AqCaFoJHIIAtbS4JYABHxsMZ3fC/mmXPdbAl3ZEuTAHQopgk0KekmA==
X-Gm-Gg: ASbGncsH0w0dPv2ioqN8OwL+qWLjPgsGw6tcxCa+v9SZD88lRXxPvXHZW/FPsilYmAt
	HAEHMN9pBZQsBiPiWzjV9puZIa1Spg0+9Yc+3Vj7xqljfaP7Mbl0GPeTmKDzYQFzKiJZxnymEGE
	hhQ3nOlxnqE43N9Bf/lcsrNPdk9j+xCrEjjpRu25E0bFIo7ZYrlSf79O36WOtam/gusGDgMyK7B
	xiHionPoqbe22iqnV5ZEnWekXNvDlXWAsfIF4dtX6SNx2p9czonb0eAFb1cB0JGcaGA6YzHDlti
	SKZIcgT33buK+/wFS1lYLUBTz6JlB8QNU4nwiS723p0siKqdP/zvYA==
X-Google-Smtp-Source: AGHT+IEleBAK1c0esyrffaFSC9FhpNW5s+YNhuYQch0NR91/XgIPivKb6F8Tu0JGKw5zPe9DCCsVdQ==
X-Received: by 2002:a17:907:724f:b0:ac2:d6d1:fe65 with SMTP id a640c23a62f3a-ac3f24d788cmr472556266b.41.1742592108250;
        Fri, 21 Mar 2025 14:21:48 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef869f94sm222551466b.18.2025.03.21.14.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 14:21:47 -0700 (PDT)
Message-ID: <c84461d9-3394-4bbf-88d5-38a4a2f6dccd@gmail.com>
Date: Fri, 21 Mar 2025 21:22:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: consider ring dead once the ref is marked
 dying
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250321193134.738973-1-axboe@kernel.dk>
 <20250321193134.738973-4-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250321193134.738973-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/25 19:24, Jens Axboe wrote:
> Don't gate this on the task exiting flag. It's generally not a good idea

Do you refer to tw add and the PF_EXITING logic inside? We can't gate
it solely on dying refs as it's not sync'ed (and the patch doesn't).
And task is dying is not same as ring is closed. E.g. a task can
exit(2) but leave the ring intact to other tasks.

> to gate it on the task PF_EXITING flag anyway. Once the ring is starting
> to go through ring teardown, the ref is marked as dying. Use that as
> our fallback/cancel mechanism.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/io_uring.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 2b9dae588f04..984db01f5184 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -555,7 +555,8 @@ static void io_queue_iowq(struct io_kiocb *req)
>   	 * procedure rather than attempt to run this request (or create a new
>   	 * worker for it).
>   	 */
> -	if (WARN_ON_ONCE(!same_thread_group(tctx->task, current)))
> +	if (WARN_ON_ONCE(!same_thread_group(tctx->task, current) &&
> +			 !percpu_ref_is_dying(&req->ctx->refs)))

Should it be "||"? Otherwise I don't understand the purpose of it.

>   		atomic_or(IO_WQ_WORK_CANCEL, &req->work.flags);
>   
>   	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
> @@ -1254,7 +1255,8 @@ static void io_req_normal_work_add(struct io_kiocb *req)
>   		return;
>   	}
>   
> -	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
> +	if (!percpu_ref_is_dying(&ctx->refs) &&
> +	    !task_work_add(tctx->task, &tctx->task_work, ctx->notify_method))
>   		return;
>   
>   	io_fallback_tw(tctx, false);

-- 
Pavel Begunkov


