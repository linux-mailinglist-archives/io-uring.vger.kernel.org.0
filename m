Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11E93E3A4F
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 14:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhHHM4D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Aug 2021 08:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhHHM4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Aug 2021 08:56:03 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E65C061760;
        Sun,  8 Aug 2021 05:55:43 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so9489004wmb.5;
        Sun, 08 Aug 2021 05:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KumXTSRy1ccI0diRB9WIg9PzVSWqHO8LNyHxSxpOrJs=;
        b=MzW+ITtgPThujFWV0WY9+sTfUnfb7Z+ir0p06CFXCaFQcfXRmwyrl2uxwwQmoJ0QPp
         QliKo61Y8PgkOH3KfDQbfjtgkYiesATvnXNdoAg0NkxHED4aIp5yuV/zdgPHQ7VYsZIH
         O3eULSIsSGbrKRJSzq0+UQkBcF6MqRWhIrXQx2jaAu7X03X6ejO8/D/eDkYnILzI356V
         xbK6V6+0+tt3KPueMEB6/K9sbPTgALTgTxRLAM+27rjzhsEGd77KhtRIOG5iK+bn11RM
         o8n1drlKg48NnRJq4peJbVLyINErz5Aq7n0NBnTdbPaMdyCIpQHfEe0y5POHbhXujMsu
         iQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KumXTSRy1ccI0diRB9WIg9PzVSWqHO8LNyHxSxpOrJs=;
        b=epj/SXw+g3CJ76elIFVQMhp4i1fcx+PysI1rMouyx2m7MFd2AcB9OoItbR7KALcG2P
         ZGH4gx4ccIeqCUYwHkfWFJQYoQW/Olj3DOI7tQNv/Wf7eqiDtwg9Sf8kKsEi6Ib0m9QK
         dAglg7RGw2b2QUQF5g28k/hoUdTDidBl1hM4ultcnGn1x0wk1IZgZGqzruyWdpyZs7Gd
         tCCjHsYbMuje598MZkvSQMNrC1U5BxvgXDus8zuXBzwJh98maJUBD67X6Y33Qd1gVZ5q
         j2u65y0Wbpwk6gvZ3Hzl9hidf/b3bm30v1Lwjf4KSPN8b5osCdr+OxPy1pQrrJ5GxEmT
         e6TA==
X-Gm-Message-State: AOAM531l7xn92uEbcVaZdMTyqEwC148i9g2CDgCNpZkSYy4NgJDiJ3E/
        lyOJ2i+wA046NJfOtGj21So=
X-Google-Smtp-Source: ABdhPJzcWa7TsLPHPMKznGhYudbIIp0nmOrWESKLxL5ksihDXUjUPVrJOiUkJc8gn7lNKuYvj52vMg==
X-Received: by 2002:a1c:f019:: with SMTP id a25mr17834949wmb.96.1628427340979;
        Sun, 08 Aug 2021 05:55:40 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id n3sm14177687wmi.0.2021.08.08.05.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 05:55:40 -0700 (PDT)
To:     Nadav Amit <nadav.amit@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>
References: <20210808001342.964634-1-namit@vmware.com>
 <20210808001342.964634-2-namit@vmware.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task
 work
Message-ID: <488f005c-fd92-9881-2700-b2eb1adbb78e@gmail.com>
Date:   Sun, 8 Aug 2021 13:55:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210808001342.964634-2-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/8/21 1:13 AM, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> When using SQPOLL, the submission queue polling thread calls
> task_work_run() to run queued work. However, when work is added with
> TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains

static int io_req_task_work_add(struct io_kiocb *req)
{
	...
	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
	if (!task_work_add(tsk, &tctx->task_work, notify))
	...
}

io_uring doesn't set TIF_NOTIFY_SIGNAL for SQPOLL. But if you see it, I'm
rather curious who does.


> set afterwards and is never cleared.
> 
> Consequently, when the submission queue polling thread checks whether
> signal_pending(), it may always find a pending signal, if
> task_work_add() was ever called before.
> 
> The impact of this bug might be different on different kernel versions.
> It appears that on 5.14 it would only cause unnecessary calculation and
> prevent the polling thread from sleeping. On 5.13, where the bug was
> found, it stops the polling thread from finding newly submitted work.
> 
> Instead of task_work_run(), use tracehook_notify_signal() that clears
> TIF_NOTIFY_SIGNAL. Test for TIF_NOTIFY_SIGNAL in addition to
> current->task_works to avoid a race in which task_works is cleared but
> the TIF_NOTIFY_SIGNAL is set.
> 
> Fixes: 685fe7feedb96 ("io-wq: eliminate the need for a manager thread")
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  fs/io_uring.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5a0fd6bcd318..f39244d35f90 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -78,6 +78,7 @@
>  #include <linux/task_work.h>
>  #include <linux/pagemap.h>
>  #include <linux/io_uring.h>
> +#include <linux/tracehook.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -2203,9 +2204,9 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
>  
>  static inline bool io_run_task_work(void)
>  {
> -	if (current->task_works) {
> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
>  		__set_current_state(TASK_RUNNING);
> -		task_work_run();
> +		tracehook_notify_signal();
>  		return true;
>  	}
>  
> 

-- 
Pavel Begunkov
