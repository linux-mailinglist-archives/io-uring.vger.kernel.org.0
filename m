Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B303B0EF2
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 22:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFVUre (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 16:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVUre (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 16:47:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC509C061574;
        Tue, 22 Jun 2021 13:45:16 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id n7so158680wri.3;
        Tue, 22 Jun 2021 13:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oJKHAUVoWMvgZKaBkUowP7jbYxwJkBTpJAJrtLjjKQk=;
        b=p7yWCBJM6f2Q0GP/YKsRi5+XPpTdu9Aa3H9rDSEH+e5NQ4y5//2txanDgqHnlQ4wmc
         Sw3Oe+OvmniZmYA0/hxMGuNvzpgKg/S7jbflsKvqfIBnc7vcQLWZ2ehaaxKvrqiXAFu9
         s4KCBxGZ9ZyjMZbwO09Fq2Ohw0u76FKuySaAuRrp/BTRmGYTpzINuSoxsglzpJbUnl4j
         Jk8lHexWtj4iauR+TJ3i2bA1dUSggAlhObx6VxZpE2AF+IUw9htYbPGvJNtC+t/Nh5ji
         Tm1SBNqLCh84eRpxWQXzvMpwaa6QJ3+gxKoRq8PsbFKHAIvmCq8raRrxLMcnkoVcZbB6
         AHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oJKHAUVoWMvgZKaBkUowP7jbYxwJkBTpJAJrtLjjKQk=;
        b=tbn9ImiQn/O8frlGyl1xD935GUOD/fIJpXNtnrgRwlKJinAvZyYKGZOKOtJZZ7VWw6
         09Fs/NvyUJ5FQLMQo7ZawE6dSXnxqkUk8u7/VC5FYYrV0byUrwYzTKtRSo6dN1CQ0mUN
         aIUhbWodMkoDKVZc+tIfeanKBSbP4EzYny5sSayP8gaHgL2FR1sWAUDUtu5c9m3MUS0f
         htqwIOLaPA7dqR5Is32bthw8AOoXraKwj8IZBizK6kbJ3NN9RVtREReNuSZLwXtDXxVa
         TlJiJ89F8Yu0CwvKxlwiKGtCBw9gPtNki3GjctkDM/PZvkEwg/jgE56UD73qCM4TmZ8J
         3mxw==
X-Gm-Message-State: AOAM530+c6WrDem8kGpw//H5Yj7pvlms/Agkp3DwriZDaeMlmdv5GIT7
        vWwUG51GtDgVV4YkSr3QGTZgpBCty2rIqhZe
X-Google-Smtp-Source: ABdhPJx7gGPhZp0ZFB4BT3yFnG0FJiIgsXQ7ziAi8azQqZtOpNdfEvrwjGNXp7Eeh2Fow047Z1+gdA==
X-Received: by 2002:a05:6000:1c1:: with SMTP id t1mr7151808wrx.282.1624394715000;
        Tue, 22 Jun 2021 13:45:15 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id q19sm3394293wmc.44.2021.06.22.13.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 13:45:14 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
 <60d23218.1c69fb81.79e86.f345SMTPIN_ADDED_MISSING@mx.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/2 v2] io_uring: Fix race condition when sqp thread goes
 to sleep
Message-ID: <dcc24da6-33d6-ce71-8c87-f0ef4e7f8006@gmail.com>
Date:   Tue, 22 Jun 2021 21:45:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60d23218.1c69fb81.79e86.f345SMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 7:55 PM, Olivier Langlois wrote:
> If an asynchronous completion happens before the task is preparing
> itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
> will not wake up the sqp thread.
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fc8637f591a6..02f789e07d4c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6902,7 +6902,7 @@ static int io_sq_thread(void *data)
>  		}
>  
>  		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
> -		if (!io_sqd_events_pending(sqd)) {
> +		if (!io_sqd_events_pending(sqd) && !current->task_works) {

Agree that it should be here, but we also lack a good enough
task_work_run() around, and that may send the task burn CPU
for a while in some cases. Let's do

if (!io_sqd_events_pending(sqd) && !io_run_task_work())
   ...

fwiw, no need to worry about TASK_INTERRUPTIBLE as
io_run_task_work() sets it to TASK_RUNNING.

>  			needs_sched = true;
>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>  				io_ring_set_wakeup_flag(ctx);
> 

-- 
Pavel Begunkov
