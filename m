Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674B41F07C5
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 17:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgFFP47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Jun 2020 11:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbgFFP46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Jun 2020 11:56:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E256C03E96A
        for <io-uring@vger.kernel.org>; Sat,  6 Jun 2020 08:56:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l10so12733143wrr.10
        for <io-uring@vger.kernel.org>; Sat, 06 Jun 2020 08:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aK0560q/p9LRAOQYYUg4WdBO1cEWXjJfj+EK4N5hhPk=;
        b=Zm/fGqWGtAvh3DHkr6DALgaJGBOIy8x7A/b9Eb7sgugUidtQ0Uz+XmW21HdU24jjrt
         jteHZRrB8TCvq8Ond/gu+fAEn20dSiWFMtiWfDxxsmv5L1Z37wkVgvVUPYDazEYiQvRE
         KqMMAFXH/GP6HMdbrBO2GMxPeE3mxPsKxkI90RIGTjZJvWjTzguM/BZAxDQ3VQeluaA5
         xvZNV4EZsRzwW/kmMkkVutOwnTC4OjEW11ejywlajPydNLifzHRRyXt25L+RaJcBJ4mA
         HXiL3vL5p5oyLJez1LoRAiTzHqP423E0Ga1V/7Vz+WZBbspP9T5Lov+J8Hhij5d//0kC
         s2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aK0560q/p9LRAOQYYUg4WdBO1cEWXjJfj+EK4N5hhPk=;
        b=VCwp8Uadpdwd+SQqaKbNCa2DNwu4tzYyozZ+N23E0MOVTIBTraUOoTnrFjw+a5Bevh
         XD1OC/ZY8dIYFiY3ZE2E6X0ssaPfs5pzrmGItlPK9rEtj8KWdzNiiZt0mA+uSPFe92c7
         BHM0xsPli9iZqpuwymFAoFhdg2r10L6VCglJ9ZBW2P7HNXd0H4WMW7Z0Y41f/IXVPasn
         BuxAT0ERCdOez3PQ1u1a9lnotQMAfzrnnoWMNhkNVuQkHR7Cg8VgebQUhZIbPXlHqAed
         DLmKtVWpXbf666oz8vNa/izeZDFKnYO/rqHlU38nyWTJPGKsHEnfxCBB7vr61N50yA2C
         9pbg==
X-Gm-Message-State: AOAM533vLlqehCcj19trh31G/vTlYuWKAwq7iwBLTbLABgpSYr8iqLa8
        oQtyV4VFgZAMmHn4GEnAylqRffu1
X-Google-Smtp-Source: ABdhPJw3ZxWQZ86Gbh6NX8VqI6mVUP2755ZzHLAiPW7J4tZlw13UHDhaZEWsDkIoP2V6MGd+yp+UHA==
X-Received: by 2002:adf:a507:: with SMTP id i7mr16381643wrb.0.1591459016746;
        Sat, 06 Jun 2020 08:56:56 -0700 (PDT)
Received: from [192.168.43.208] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id g82sm15831460wmf.1.2020.06.06.08.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Jun 2020 08:56:56 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200606151248.17663-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: execute task_work_run() before dropping mm
Message-ID: <350132ea-aade-27f4-1fcc-ba0539a459a1@gmail.com>
Date:   Sat, 6 Jun 2020 18:55:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200606151248.17663-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/06/2020 18:12, Xiaoguang Wang wrote:
> While testing io_uring in our internal kernel, note it's not upstream
> kernel, we see below panic:
> [  872.498723] x29: ffff00002d553cf0 x28: 0000000000000000
> [  872.508973] x27: ffff807ef691a0e0 x26: 0000000000000000
> [  872.519116] x25: 0000000000000000 x24: ffff0000090a7980
> [  872.529184] x23: ffff000009272060 x22: 0000000100022b11
> [  872.539144] x21: 0000000046aa5668 x20: ffff80bee8562b18
> [  872.549000] x19: ffff80bee8562080 x18: 0000000000000000
> [  872.558876] x17: 0000000000000000 x16: 0000000000000000
> [  872.568976] x15: 0000000000000000 x14: 0000000000000000
> [  872.578762] x13: 0000000000000000 x12: 0000000000000000
> [  872.588474] x11: 0000000000000000 x10: 0000000000000c40
> [  872.598324] x9 : ffff000008100c00 x8 : 000000007ffff000
> [  872.608014] x7 : ffff80bee8562080 x6 : ffff80beea862d30
> [  872.617709] x5 : 0000000000000000 x4 : ffff80beea862d48
> [  872.627399] x3 : ffff80bee8562b18 x2 : 0000000000000000
> [  872.637044] x1 : ffff0000090a7000 x0 : 0000000000208040
> [  872.646575] Call trace:
> [  872.653139]  task_numa_work+0x4c/0x310
> [  872.660916]  task_work_run+0xb0/0xe0
> [  872.668400]  io_sq_thread+0x164/0x388
> [  872.675829]  kthread+0x108/0x138
> 
> The reason is that once io_sq_thread has a valid mm, schedule subsystem
> may call task_tick_numa() adding a task_numa_work() callback, which will
> visit mm, then above panic will happen.
> 
> To fix this bug, only call task_work_run() before dropping mm.

So, the problem is that poll/async paths re-issue requests with
__io_queue_sqe(), which doesn't care about current->mm, and which
can be NULL for io_sq_thread(). Right?

> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6391a00ff8b7..32381984b2a6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6134,6 +6134,13 @@ static int io_sq_thread(void *data)
>  		 * to enter the kernel to reap and flush events.
>  		 */
>  		if (!to_submit || ret == -EBUSY) {
> +			/*
> +			 * Current task context may already have valid mm, that
> +			 * means some works that visit mm may have been queued,
> +			 * so we must execute the works before dropping mm.
> +			 */
> +			if (current->task_works)
> +				task_work_run();

Even though you're not dropping mm, the thread might not have it in the first
place. see how it's done in io_init_req(). How about setting mm either lazily
in io_poll_task_func()/io_async_task_func(), or before task_work_run() in
io_sq_thread().

>  			/*
>  			 * Drop cur_mm before scheduling, we can't hold it for
>  			 * long periods (or over schedule()). Do this before
> @@ -6152,8 +6159,6 @@ static int io_sq_thread(void *data)
>  			if (!list_empty(&ctx->poll_list) ||
>  			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
>  			    !percpu_ref_is_dying(&ctx->refs))) {
> -				if (current->task_works)
> -					task_work_run();
>  				cond_resched();
>  				continue;
>  			}
> @@ -6185,11 +6190,7 @@ static int io_sq_thread(void *data)
>  					finish_wait(&ctx->sqo_wait, &wait);
>  					break;
>  				}
> -				if (current->task_works) {
> -					task_work_run();
> -					finish_wait(&ctx->sqo_wait, &wait);
> -					continue;
> -				}
> +
>  				if (signal_pending(current))
>  					flush_signals(current);
>  				schedule();
> 

-- 
Pavel Begunkov
