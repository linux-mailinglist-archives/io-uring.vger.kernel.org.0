Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895C245F0DD
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 16:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346675AbhKZPno (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 10:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346814AbhKZPlo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 10:41:44 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9C3C06179E
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 07:32:34 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso10980422wmr.4
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 07:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OCEIHHuN+mfEu9OCXvmtqJNTxeQpkhsDg8TmGe9jVO4=;
        b=g//2yWZlIa1wx5XbL3oeb9OHCSdVufYuXaKeLKD+4sxBA9nx1cPkiKQ4VU/JvKRZ8K
         IXJfO0dfThYzj/f8bZcdmT+HU8fOqu1Zkfsk5DZD/GU8XtWeP8QZpGojixD+d5cpGmjF
         MHk0TfK3OBO/JTrsLj789Hz7P2II9tb3V+PDWAzObZzdz9oL5LzoXVvFbnAoF/sBa5uZ
         4paCJB8rf3SBHGs3KQ4NEs+OhGeMD8EYPGN/lvGqN/+gU/GB+eMX2W5fK82t8Gpx6SFW
         wDQJIedupvgYCrr99zqE9RN7/7rnjHkx55uJSGc5zmvKXBx9bxoJ7ZCc409E7KkwZKhV
         yIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OCEIHHuN+mfEu9OCXvmtqJNTxeQpkhsDg8TmGe9jVO4=;
        b=ZLxGiTl+cLD9dOi48ycTkASog1gP/cFXcjjoe9bOTtcjeHjhC18EQ7UvGz5rfqKab8
         9+VN2p5h/Y81FeGiXZmgZeR0GnWjTjZ9xdMOVFW5DT+g5K3o+cs/oL6mg//kt1jKt6Fe
         JXa8DIL9oSLnvwKr2lF3llT7Eug9wL5I9L/8oBN8+sJ+kEPMjC5S2DWOMY27dTRfBVFs
         kz/DUubAmzkVaEP42bJ1nT36XhTlNAnSikYQ2eyppFNWrYzyhUnyNBP/E12VNNbkszur
         IsHbgzSU+D+GFD2qBDSpERgKRA/q4V1QafGZ2FyDeJ06VEQJc0LpJr+YGhNL1uAQhzfG
         Df5g==
X-Gm-Message-State: AOAM530zBf/Zs7gilNHuaOD2oQwP/gJm2h16+MOEEzZDzWjilE3rqfZs
        Zi2qrXXP+CDmwkObyFjYur0vut4xQuc=
X-Google-Smtp-Source: ABdhPJz1SfA8n/0VmEqrEvVTorzHfRnxfBw+AyjTDvc/dmTE179Q1JtXxpyUSxoecMYNX00ZmHxouA==
X-Received: by 2002:a1c:a710:: with SMTP id q16mr16491354wme.138.1637940753081;
        Fri, 26 Nov 2021 07:32:33 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-175.dab.02.net. [82.132.231.175])
        by smtp.gmail.com with ESMTPSA id k37sm7504191wms.21.2021.11.26.07.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 07:32:32 -0800 (PST)
Message-ID: <4f35110d-d1a4-f6b0-6d74-0b523c7b981a@gmail.com>
Date:   Fri, 26 Nov 2021 15:32:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 1/2] io_uring: fail cancellation for EXITING tasks
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1637937097.git.asml.silence@gmail.com>
 <4c41c5f379c6941ad5a07cd48cb66ed62199cf7e.1637937097.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4c41c5f379c6941ad5a07cd48cb66ed62199cf7e.1637937097.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 14:38, Pavel Begunkov wrote:
> We need original task's context to do cancellations, so if it's dying
> and the callback is executed in a fallback mode, fail the cancellation
> attempt.

Fixes: 89b263f6d56e6 ("io_uring: run linked timeouts from task_work")
Cc: stable@kernel.org # 5.15+

> 
> Reported-by: syzbot+ab0cfe96c2b3cd1c1153@syzkaller.appspotmail.com
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a4c508a1e0cf..7dd112d44adf 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6882,10 +6882,11 @@ static inline struct file *io_file_get(struct io_ring_ctx *ctx,
>   static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
>   {
>   	struct io_kiocb *prev = req->timeout.prev;
> -	int ret;
> +	int ret = -ENOENT;
>   
>   	if (prev) {
> -		ret = io_try_cancel_userdata(req, prev->user_data);
> +		if (!(req->task->flags & PF_EXITING))
> +			ret = io_try_cancel_userdata(req, prev->user_data);
>   		io_req_complete_post(req, ret ?: -ETIME, 0);
>   		io_put_req(prev);
>   	} else {
> 

-- 
Pavel Begunkov
