Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E5436C6C8
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 15:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhD0NOn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 09:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235795AbhD0NOn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 09:14:43 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE89C061574
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 06:13:58 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j5so58473382wrn.4
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 06:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bUwmB8vg8cs6gl6fgQhCS5Y9HasCWefLVuRxANtxfuc=;
        b=ciuuT9Fb26/2MR3V7Rb98oLRzWp3FVe6ftOFedBLMczNPytW/n7hSkLfKMr109iThz
         2eGbyxG1NRM2CiAUFGuTK9OaIf6qigb2yWMiKbAd/aiWvCG1hI1bJfPEfNVALugyFdTf
         6mslWSKoSJ1QA09jqLsqL/y8juQYCqyRwKOlcPhrRJBLCt19MGSIAHv0ZCJ/BcihljxA
         bV2mR8otnFBzRpYD5bTkboFOokz8dv9SslfLUl2ISV+/Pe8nP+3BvpGomkAYOxedB+T6
         FncmY3Y/lRp0kbWTxAmXuDBz6mvZVIf1RiLCtF3C36j1eYON3Q6UhtF6KnPA8yspz6q2
         WLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bUwmB8vg8cs6gl6fgQhCS5Y9HasCWefLVuRxANtxfuc=;
        b=DjjaKfB1WQeZ9i8em3jFzeA2C/JYbXHiBHkFmUF2hxC1GVfiXYrkK2WELWR0G/5DVs
         6b+oN9IY/Be9pKQh4ahdMdFRtZBWIk4p9Pq7z4aAlvaMbPH73Gbya7V1JHJ9JCBNlzQT
         osaXONxVUB9U/hjtVzV7sFJZSuG3Dw6tMgyt1+GSkOifH0139KU4NtVzZi7FkDppAiGV
         NhtDpWuc39q2h2FcuN9pJaIzQ7W5lFG6qOG3E/ouyz8rqqrf6utx0oQ7OzTbCMmgeOe4
         Ag7yET4jASiLJae4oYr6AcM5qgbREwXqtMdZ8bWS80Lx4mN9mQdf6ZPG6wpBdwd0UEg3
         Pl2w==
X-Gm-Message-State: AOAM5334r9Bp7lmpubc+6MICPoGJXCNEEg3xdtDICfvwLhXP7BQ6+JDV
        nWbzbyI31BYao+zhFOc0leSaUAoLyUs=
X-Google-Smtp-Source: ABdhPJzO87GUEvr4f0+0f7xKdi2qc8RRXN2/CzEIuFu/XB6T1mTx4THMwVSa80j68hUxNpa6AWZ0BQ==
X-Received: by 2002:adf:f64f:: with SMTP id x15mr29806156wrp.266.1619529237748;
        Tue, 27 Apr 2021 06:13:57 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id y16sm3806777wrp.78.2021.04.27.06.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 06:13:57 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: don't set IORING_SQ_NEED_WAKEUP when
 sqthread is dying
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619527526-103300-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <24c7503d-769f-953e-854f-5090b4bfca3b@gmail.com>
Date:   Tue, 27 Apr 2021 14:13:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1619527526-103300-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/21 1:45 PM, Hao Xu wrote:
> we don't need to re-fork the sqthread over exec, so no need to set
> IORING_SQ_NEED_WAKEUP when sqthread is dying.

It forces users to call io_uring_enter() for it to return
-EOWNERDEAD. Consider that scenario with the ring given
away to some other task not in current group, e.g. via socket.

if (ctx->flags & IORING_SETUP_SQPOLL) {
	io_cqring_overflow_flush(ctx, false);

	ret = -EOWNERDEAD;
	if (unlikely(ctx->sq_data->thread == NULL)) {
		goto out;
	}
	...
}

btw, can use a comment

> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6b578c380e73..92dcd1c21516 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6897,8 +6897,6 @@ static int io_sq_thread(void *data)
>  
>  	io_uring_cancel_sqpoll(sqd);
>  	sqd->thread = NULL;
> -	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
> -		io_ring_set_wakeup_flag(ctx);
>  	io_run_task_work();
>  	io_run_task_work_head(&sqd->park_task_work);
>  	mutex_unlock(&sqd->lock);
> 

-- 
Pavel Begunkov
