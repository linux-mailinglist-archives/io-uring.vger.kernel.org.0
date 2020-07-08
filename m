Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192A421901F
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 21:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgGHTDC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 15:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgGHTDC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 15:03:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBD3C061A0B;
        Wed,  8 Jul 2020 12:03:01 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z13so50079972wrw.5;
        Wed, 08 Jul 2020 12:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xcX2tFrTyv5Vvy0OeMBAnDAgRISAArqBf1hManw/d+Q=;
        b=lJomwGxaa4ftxoqx+VOe5191HVPVtYQe4gn3kuG0t+lms8exhscbx+agG8g2Y1q8n1
         V62xiaD8XDnfiPsw8xVSaLh9cQcPeSgmwGxWvKwJBVyW9MtKCl5ZH+jXXrNaPt+4dbJJ
         1E0nveTiFN1l/3oLjw0MvF+DcX5lnqjJGoCI6UqBwY6cV2qg3necP5oB+DXCaxVazIMK
         EAKIb/U6t8XwxxPm0XQsoFECXkXsU4MHcV1ODYT+t+y6hnfAq4btXnros/kwdbbXmIsM
         rFD9iBwF7FNTAM/Ybys4Mt7YI7IeMiNEo0Y1D2nudOPLjaEFcqLxxhLUm2gVE5vxbq57
         mlzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xcX2tFrTyv5Vvy0OeMBAnDAgRISAArqBf1hManw/d+Q=;
        b=i+uFp0wLZw29zVHTeHGTBfz+FChZqe1E2o3aC4dBo4107nJSqc3rFBJv1BBD59icm3
         0yz7/Bf/pt2irJF/V5FbG5Avuq+t1Ug02M095rL9ZPqjiT7mm+LVZ9dx7aSfBS2ks/b7
         3B6DgwYjIM/EQL6ofB9riHA+Lvx38AaXyzl4lXHsI3agq056hiWWvY6wurE0Irtm4E68
         IMEmowD96InvKOwL1o46t2oJIC56miUPYfKzKLV+z5uyLaSwOUDZH73psSyLQ42MHkcj
         fbqzE4KMPjpqOHapmgpakZba2OpBzOp7/b3D0fC+cuvwlXuLcKqN0MW9G5CbTBf+KIgb
         5fjQ==
X-Gm-Message-State: AOAM533VNKtq024m+1HKBYzvfO+zN8Qg0C/plVL7NPuIRh7zrgcBG2IB
        d8ZAG64b8pVoBa+v0mS+1EZgSAIs
X-Google-Smtp-Source: ABdhPJyGqAYiVUXMHAgTjG9sDBL/LEZq6lD2FZVIT+MwLs6NuoErh4p7Mp4GihfJLLjmUUI5D+2egQ==
X-Received: by 2002:adf:e701:: with SMTP id c1mr61197602wrm.350.1594234979997;
        Wed, 08 Jul 2020 12:02:59 -0700 (PDT)
Received: from [192.168.43.42] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id b18sm1278454wrs.46.2020.07.08.12.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 12:02:59 -0700 (PDT)
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200708184711.GA31157@mwanda>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix a use after free in io_async_task_func()
Message-ID: <4ea3c931-1738-14e2-aac6-55ef9b3dedeb@gmail.com>
Date:   Wed, 8 Jul 2020 22:01:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200708184711.GA31157@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/07/2020 21:47, Dan Carpenter wrote:
> The "apoll" variable is freed and then used on the next line.  We need
> to move the free down a few lines.

My bad, thanks for spotting that!
A comment below

> 
> Fixes: 0be0b0e33b0b ("io_uring: simplify io_async_task_func()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/io_uring.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 70828e2470e2..f2993070a9e8 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4652,12 +4652,13 @@ static void io_async_task_func(struct callback_head *cb)
>  	/* restore ->work in case we need to retry again */
>  	if (req->flags & REQ_F_WORK_INITIALIZED)
>  		memcpy(&req->work, &apoll->work, sizeof(req->work));
> -	kfree(apoll);

__io_req_task_submit() can take some time, e.g. waiting for a mutex, so
I'd rather free it before, but save req->poll.canceled in a local var.

>  
>  	if (!READ_ONCE(apoll->poll.canceled))
>  		__io_req_task_submit(req);
>  	else
>  		__io_req_task_cancel(req, -ECANCELED);
> +
> +	kfree(apoll);
>  }
>  
>  static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
> 

-- 
Pavel Begunkov
