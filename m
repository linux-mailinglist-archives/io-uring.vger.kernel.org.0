Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5133C51F
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 19:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhCOSDA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 14:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhCOSCy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 14:02:54 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C08C06174A;
        Mon, 15 Mar 2021 11:02:53 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so17039006wmj.2;
        Mon, 15 Mar 2021 11:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U3aH1dWCtd1BJ5vsp+a7HWjVOCqUvhB5pzQy/Fhe2ag=;
        b=TWNdJrW2jJpXaP5vrj3tJJQKLuWWTUtx1Cox8DZNd3RXKIIdl+tVmcAy73Hl504/De
         0gClSiwK0OzWJwQzofzVK65hkSNIRDKFVS6yGk+zZDxkS74iPxj8DCU6d6Rp83B1k7aE
         gTr1PPQlq467xu/Dj0/0FaHINM5bGQlbsJ0noajxCcmcf6m8uzRgFpinqxiYOM5OaHK3
         wwwmLHJxWGg0zIIp8sKuFFjVMqMkkEHLWOX5sAnRxekKmD+EWT4/K68rN30P6umVQes9
         V0VjFVxWqzIDEMDLncOSGilOELM5F9pHqXoXaxv5qQDKZvf+alV/ehB2NTe8C5eoG7NE
         2YQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=U3aH1dWCtd1BJ5vsp+a7HWjVOCqUvhB5pzQy/Fhe2ag=;
        b=chrKuqIqgzWD8TIjGkzu/q51KsxPlN8nZ22Z9BJdoYXmnkM1Sln1GTlJhUMzcGjeRv
         N80WdGcnais1LMQgINg25nLPVimPUEB9PZIYRt+0z+4j8y1EE3ff2457l46Tdem72Xm/
         eQnIiN8JLYLtsIM2mvIwUpJSjxe+DwHKANnqoKZjUK8eP7l3nVvSc+/WNmZeoglj1KJq
         UqqtDT7r4nym4GZp8Nt7/JtCAe+Ur7BqX8DgKAZJJ5Osn0SzrxUljLgitjHwwezohG84
         YXiwasEbQ8tUHX94RLuB9QZ70Dkgg76Uu9HJLfVjTr0laiv+C3P07Shfr1uUfLngGzrm
         f7bw==
X-Gm-Message-State: AOAM530GoJ1ca7nEkfzCcBvSJx0uahCf1A/BpUHcYKd+dbMmQXaVTirf
        vqEdBryQyMra3znVTGgqBHS9nKXMooGCug==
X-Google-Smtp-Source: ABdhPJxRdsmzkKnJkTBiI/kSNQNND4Uh3tD34/Jx/6Y4XMCpbTYA1zM8hy6pFmgCS9cjxsnJVRg78w==
X-Received: by 2002:a7b:ca44:: with SMTP id m4mr835960wml.103.1615831372265;
        Mon, 15 Mar 2021 11:02:52 -0700 (PDT)
Received: from [192.168.8.155] ([148.252.132.232])
        by smtp.gmail.com with ESMTPSA id r2sm18880903wrt.8.2021.03.15.11.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 11:02:51 -0700 (PDT)
To:     Jordy Zomer <jordy@pwning.systems>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315174425.2201225-1-jordy@pwning.systems>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] Fix use-after-free in io_wqe_inc_running() due to wq
 already being free'd
Message-ID: <65a85dd1-a9b0-30a1-13b9-559270f31264@gmail.com>
Date:   Mon, 15 Mar 2021 17:58:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210315174425.2201225-1-jordy@pwning.systems>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/03/2021 17:44, Jordy Zomer wrote:
> My syzkaller instance reported a use-after-free bug in io_wqe_inc_running.
> I tried fixing this by checking if wq isn't NULL in io_wqe_worker.
> If it does; return an -EFAULT. This because create_io_worker() will clean-up the worker if there's an error.
> 
> If you want I could send you the syzkaller reproducer and crash-logs :)

Yes, please.

Haven't looked up properly, but looks that wq==NULL should
never happen, so the fix is a bit racy.

> 
> Best Regards,
> 
> Jordy Zomer
> 
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> ---
>  fs/io-wq.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 0ae9ecadf295..9ed92d88a088 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -482,6 +482,10 @@ static int io_wqe_worker(void *data)
>  	char buf[TASK_COMM_LEN];
>  
>  	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
> +
> +	if (wq == NULL)
> +		return -EFAULT;
> +
>  	io_wqe_inc_running(worker);
>  
>  	sprintf(buf, "iou-wrk-%d", wq->task_pid);
> 

-- 
Pavel Begunkov
