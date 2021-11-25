Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E01845DC51
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 15:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350752AbhKYOcM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 09:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355749AbhKYOaM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 09:30:12 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DB5C0613F7
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 06:26:22 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id u1so11978786wru.13
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 06:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7XmSe1aAXPTvQ1fm56SxZqzJrQK1iBzBTq+UYVEnwM8=;
        b=SoVJb3fUupBV8lx8+u0JMq2QMezGKbxB0wn4zD30LeFLAr0UlmlXS9I6S4gqpkf8oP
         VwWaE/EZ1RTvaDDUKkPk/0kKQ4eYZK3ZgvLbIay0kdxor506yEzkJfeU8ONTJzIqXXgZ
         EuaafNjU25RUckYlLGn49CyAHCLoFTmZSpTZ0gS8PGKX5zNca0cwo5x6JiNzwQ3oucYj
         Kw4q/YMkTmKB8kv7zPvHgFiilfPc4joJEgkNX+DC/qIG4c4te8xDE8Fvnn5mDAqfHAj5
         lMwWva6eMn06gKXCMHMh3sSzIc44602G0KWPM3KSRavf9WN8O1SP+EOGADMuwsaK3KAe
         OQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7XmSe1aAXPTvQ1fm56SxZqzJrQK1iBzBTq+UYVEnwM8=;
        b=vE49HHSvlTl75iUzHc48fA1IUG31jSfEmCDyMyOK6COlMvprbD9onvvWMX1Cv+ZXRv
         wsCBJfAQ++I2E8LAHrN9+ckrEhl1Dz0JCGUZZeeo7Ht81jz3OBaAGjQ+jQCpaAA+N/jm
         +TJmSB1HfTzo5PgyxfztjwmAlWeUGsb7hIkhAxMt/Kw0g6wEkIAXuiZgfesoIBycFu8E
         /pPPwWwf5Ii6ASboC+2KAvx/X6lBlFtoX5E38wZN5PMNcqyIBMQVWV4vQrfQu328OJnL
         ze4h1ZXrVdDxyUDht6/XQskjcHu71joOMU741liEQYBW+UNu8Qqkg1EqI4I5BEKhFei/
         D60Q==
X-Gm-Message-State: AOAM530MMi0+il+PDvNu+UKVSq9enXKoTz+DD0CMqB00VFyr6FDD/Kzr
        QdrFRbeXstsCEc53k9VEZIE=
X-Google-Smtp-Source: ABdhPJxGGkbp88pJ6ofZ89D6DuXYM0RtuCkYQORK5zQELEVPUdDJfIzm8GN3Mr2S9jh+M0OK0OvVBw==
X-Received: by 2002:a05:6000:168e:: with SMTP id y14mr7410143wrd.178.1637850380741;
        Thu, 25 Nov 2021 06:26:20 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id y6sm7933520wma.37.2021.11.25.06.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 06:26:20 -0800 (PST)
Message-ID: <09aa09af-cd52-fdfc-dcad-c13d1088bce9@gmail.com>
Date:   Thu, 25 Nov 2021 14:26:07 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 2/2] io_uring: better to use REQ_F_IO_DRAIN for req->flags
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211125092103.224502-1-haoxu@linux.alibaba.com>
 <20211125092103.224502-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211125092103.224502-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/25/21 09:21, Hao Xu wrote:
> It's better to use REQ_F_IO_DRAIN for req->flags rather than
> IOSQE_IO_DRAIN though they have same value.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ae9534382b26..08b1b3de9b3f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7095,10 +7095,10 @@ static void io_init_req_drain(struct io_kiocb *req)
>   		 * If we need to drain a request in the middle of a link, drain
>   		 * the head request and the next request/link after the current
>   		 * link. Considering sequential execution of links,
> -		 * IOSQE_IO_DRAIN will be maintained for every request of our
> +		 * REQ_F_IO_DRAIN will be maintained for every request of our

Don't care much, but it's more about the userspace visible behaviour, and so
talks about IOSQE_IO_DRAIN.

Looks good,

>   		 * link.
>   		 */
> -		head->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
> +		head->flags |= REQ_F_IO_DRAIN | REQ_F_FORCE_ASYNC;
>   		ctx->drain_next = true;
>   	}
>   }
> @@ -7149,7 +7149,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   		if (unlikely(ctx->drain_next) && !ctx->submit_state.link.head) {
>   			ctx->drain_next = false;
>   			ctx->drain_active = true;
> -			req->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
> +			req->flags |= REQ_F_IO_DRAIN | REQ_F_FORCE_ASYNC;
>   		}
>   	}
>   
> 

-- 
Pavel Begunkov
