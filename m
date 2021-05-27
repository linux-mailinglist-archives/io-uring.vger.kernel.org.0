Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB38393008
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 15:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhE0NsS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 09:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236335AbhE0NsR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 09:48:17 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7674C061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 06:46:43 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so221815otp.11
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 06:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/XKLXUdZgb1RxrjyfkAzYf1QNJ7nzXzU4iF7iH+4PNw=;
        b=iTj6Wwz4CGf+MDRw1wd8DSDTpYPytbaRtbdap32xpWB50FP+X0wmHA3GTpwaqruL0K
         I2+aDZxQ3fKfFl3r8861J5RSolK7InK0h3ZnoFfwZ2ejX4I66gNkW1Dv/l8PoPjIs9Ys
         nsjzLQdqovv28/IyTDYlZBpFJHHYNnMBojiaTYb503zXCHGPN+2n2TFyOO223ixJSx3o
         Q+m6c4rKlaYcH3I1vyhDOmTkMpSnw1C8jINniQZPFnQuVOUYNZl5EKdWGGBTQp02XNYe
         jzj4B72Gbka8vvcaBu/sJXdaelJh/cjm6dSEbcnsL6UQYjGvJNYfOoZfIZ8xuMKuEFO1
         eSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XKLXUdZgb1RxrjyfkAzYf1QNJ7nzXzU4iF7iH+4PNw=;
        b=UDQMQbni8HgrbPDkFeJqQF2Qd0iCsTuVKZzQKHmHqiL+v13981YARAidJzV7jEHI/B
         kQPQ8KkqXbWhvNF922MLATPTb8U8V/JxbhacoP00PBy4j4sQLmKQ6bBk11LZSSnH8NC6
         8Nz/h5NA+fybH9s9EPxmLDSDo8GhpFCy/s+EpzwDtjiUlkA51L5Mc+3AXOJmBLFAfMCr
         VlXduCGcdxwo4NvRUR7R75EPOpcXWbZN3x2RPk5IyXPxr2jirr/QghGjCOiT0Wwo3704
         He8MHpt97Oh8jRS2mqCRgPzehMHEoT3sN32qpemqqsWQu6cMunTcIZQ8QTL3tXSekaQf
         DayQ==
X-Gm-Message-State: AOAM530Q1n5OLkJRR3xifx+KAmxeRbkwYYfUnaHA7yEXcAz6ZnhdTl7f
        4tXGSXjI4pCZt3S/ROX/6ZO9vw==
X-Google-Smtp-Source: ABdhPJyuWwjuzcrzHQxBxvpsmU4sMzLkkCHgtooxoD0sv7tq7ERllNF06ycsrJ+To0Kys29HW1rcWQ==
X-Received: by 2002:a9d:624a:: with SMTP id i10mr2807749otk.7.1622123203011;
        Thu, 27 May 2021 06:46:43 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id o13sm487170ote.32.2021.05.27.06.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 06:46:42 -0700 (PDT)
Subject: Re: [PATCH] io_uring: handle signals before letting io-worker exit
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <60ae94d1.1c69fb81.94f7a.2a35SMTPIN_ADDED_MISSING@mx.google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3d1bd9e2-b711-0aac-628e-89b95ff8dbc3@kernel.dk>
Date:   Thu, 27 May 2021 07:46:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <60ae94d1.1c69fb81.94f7a.2a35SMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 12:21 PM, Olivier Langlois wrote:
> This is required for proper core dump generation.
> 
> Because signals are normally serviced before resuming userspace and an
> io_worker thread will never resume userspace, it needs to explicitly
> call the signal servicing functions.
> 
> Also, notice that it is possible to exit from the io_wqe_worker()
> function main loop while having a pending signal such as when
> the IO_WQ_BIT_EXIT bit is set.
> 
> It is crucial to service any pending signal before calling do_exit()
> Proper coredump generation is relying on PF_SIGNALED to be set.
> 
> More specifically, exit_mm() is using this flag to wait for the
> core dump completion before releasing its memory descriptor.
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io-wq.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 5361a9b4b47b..b76c61e9aff2 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -9,8 +9,6 @@
>  #include <linux/init.h>
>  #include <linux/errno.h>
>  #include <linux/sched/signal.h>
> -#include <linux/mm.h>
> -#include <linux/sched/mm.h>
>  #include <linux/percpu.h>
>  #include <linux/slab.h>
>  #include <linux/rculist_nulls.h>
> @@ -193,6 +191,26 @@ static void io_worker_exit(struct io_worker *worker)
>  
>  	kfree_rcu(worker, rcu);
>  	io_worker_ref_put(wqe->wq);
> +	/*
> +	 * Because signals are normally serviced before resuming userspace and an
> +	 * io_worker thread will never resume userspace, it needs to explicitly
> +	 * call the signal servicing functions.
> +	 *
> +	 * Also notice that it is possible to exit from the io_wqe_worker()
> +	 * function main loop while having a pending signal such as when
> +	 * the IO_WQ_BIT_EXIT bit is set.
> +	 *
> +	 * It is crucial to service any pending signal before calling do_exit()
> +	 * Proper coredump generation is relying on PF_SIGNALED to be set.
> +	 *
> +	 * More specifically, exit_mm() is using this flag to wait for the
> +	 * core dump completion before releasing its memory descriptor.
> +	 */
> +	if (signal_pending(current)) {
> +		struct ksignal ksig;
> +
> +		get_signal(&ksig);
> +	}
>  	do_exit(0);
>  }

Do we need the same thing in fs/io_uring.c:io_sq_thread()?

-- 
Jens Axboe

