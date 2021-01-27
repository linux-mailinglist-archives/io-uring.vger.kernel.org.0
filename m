Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923663059EF
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 12:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbhA0Lgd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 06:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbhA0Lea (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 06:34:30 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D01C061574
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 03:33:27 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id r12so2135029ejb.9
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 03:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mKBW9k5l/7fNMUwYA+MVI0QxRQnH4tcHv6errSACT0w=;
        b=fYvNqrwwlH6MJdnOe4+HycsEv/lrqbxgbHeZ58aX/XuPXkyVGk3jp1Hbl6cT1VFYUg
         ALhRr+gc6r55rgmE7GSGJB5lPfyOOPSosBLWDfZctwi0sDj1KsDa+/TLWrtN92pMya6U
         j3gRJ3d7GP12zhZ/2kcSd3VgwbVjwd1gLhPfCuooE97CNBXMMB42OwQL2IoIrDcaZung
         pxASQHgjCr72FfhtjIAauAMziuoO8PdJ/SHvIjOLIaB+f036ezXhX3pA0IMZmGtLCSgN
         PoBRF9o+mTSqJXAKoRAfxyjT8z7X+FlBafui+ft8ZfacmyJGGN1x/motx10HEnsS36GR
         Nh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mKBW9k5l/7fNMUwYA+MVI0QxRQnH4tcHv6errSACT0w=;
        b=o6xJ4e/gc+JSIDILBBUjwqQ3YxGCibGXSB4hz9sGQzYIK3EIaWNrGrGn1icn8aqwtL
         QRvxR/OGWkh9WaNYCXqmZ7ZHqZlEzEhfqxKd4pKYYbHl1SS9umI2vfpnbTMEgFr2W1BZ
         Vhi13SY02QbhJgIj1Bb5y7QFnXMmyCPx/43eOEnRVXJEIsB8vOtvPXMxmkvaXJvO2Jb7
         pubENieMWngKcHZVh18ycESGVl97EmbpYKgwXV/a7XlSxMshGOxSCwD6HcwGB6nDn6vu
         Fs0c5AQM5oIYb0Do/3LeSQHUjmULf6nyZM7mePkujCJ0y08C8Fich2eQjn4gAdNHT9HG
         djLw==
X-Gm-Message-State: AOAM532zeZTvU40AnwokbYpZ9bJf+Mg6+yjYatKSNM6BCI7R7rSTJk0A
        QCfC8JYc2mKSjkXBCbrLGY2a0oL3+gk=
X-Google-Smtp-Source: ABdhPJym4acB1qXemZWSwP6hhhgd6ivfHiPqepLpjAnl6d1c3Gd5MUK1p4yI7UJZzCcx/oRLtmrf6g==
X-Received: by 2002:a17:906:a384:: with SMTP id k4mr6424561ejz.194.1611747206323;
        Wed, 27 Jan 2021 03:33:26 -0800 (PST)
Received: from [192.168.8.160] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id ar1sm694914ejc.30.2021.01.27.03.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 03:33:25 -0800 (PST)
Subject: Re: [PATCH RESEND RESEND] io_uring: fix flush cqring overflow list
 while TASK_INTERRUPTIBLE
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1611731204-171460-1-git-send-email-haoxu@linux.alibaba.com>
 <1611731649-174664-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <a2b711fd-81c5-c495-62b3-5be742b7db58@gmail.com>
Date:   Wed, 27 Jan 2021 11:29:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1611731649-174664-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/01/2021 07:14, Hao Xu wrote:
[...]
> This is caused by calling io_cqring_overflow_flush() which may sleep
> after calling prepare_to_wait_exclusive() which set task state to
> TASK_INTERRUPTIBLE

Looks good. The loop may use some refactoring for 5.12

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Fixes: 6c503150ae33 ("io_uring: patch up IOPOLL overflow_flush sync")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c07913ec0cca..3ca69a425182 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7266,14 +7266,18 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  						TASK_INTERRUPTIBLE);
>  		/* make sure we run task_work before checking for signals */
>  		ret = io_run_task_work_sig();
> -		if (ret > 0)
> +		if (ret > 0) {
> +			finish_wait(&ctx->wait, &iowq.wq);
>  			continue;
> +		}
>  		else if (ret < 0)
>  			break;
>  		if (io_should_wake(&iowq))
>  			break;
> -		if (test_bit(0, &ctx->cq_check_overflow))
> +		if (test_bit(0, &ctx->cq_check_overflow)) {
> +			finish_wait(&ctx->wait, &iowq.wq);
>  			continue;
> +		}
>  		if (uts) {
>  			timeout = schedule_timeout(timeout);
>  			if (timeout == 0) {
> 

-- 
Pavel Begunkov
