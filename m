Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8C1315AE4
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhBJASb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhBIXeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 18:34:31 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B73C061786
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 15:33:51 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id u14so274274wmq.4
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 15:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TpjA1LdN80Of8mHFvL3Hut9KzERd5EL5+j6pQRaj614=;
        b=AlMhopdOFSRA7iRkVTfJVXcNyy7OLQXYDVljIPCWpJ5KCwb2iRypdsQhNZhDIog9x/
         5KawF8/LdpLFbTQHYyib6MLtIFpj+l/5gIzuAMnNORaXBf0emr52z9MyTV2PKnzKpf33
         zJgr0fGPpp0oyB9Sanxite0GPBexY6wPSmwSLzCwAP+klILn129LhmDrdBDzUDCElJu6
         GQ93c+Fuk4YMcmG5bPJ7vr2OHNbwht0Ut4zuSYqehcy0uZPeDV2ls1XelYMWHJIsjq6J
         qAD6Wx0nce/4310KqUfakhP8B/dRIceFwAFKt2WkqZi9i2FSx+EnvWGoa/Pl+qDjNHur
         s2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TpjA1LdN80Of8mHFvL3Hut9KzERd5EL5+j6pQRaj614=;
        b=gA6tkS5BbwaXDGmkXmlUdikMl6rgiXpp01PLeFukW+mtnNjrEkrHSIV9bQjd1Bji0v
         uBeLgB7Pyld9ZvA9yy9ICpb/gxE1ECzKuLxor2nQX9C18SF9no3PP76VPzl4XfCugM4b
         OE1/pgInlvRsAdajww21RHZx0dWSWtwwRH+I2A8JUD6kiN3PDxZuN5cNBR/NGp2Qp8X5
         Vt9L1eA20mq8ZTWpkEJmFhnIa4ufjgYBQ1i9IbXqX4KF5NaoASGOUMjLJ4K+vh+ygiU/
         Jt17q91y+Pw/0P/POqWR8j4+9wVHKABm8mOYbUdHLMNroGx1yAykpnSQEPWComJtBQBr
         nbYQ==
X-Gm-Message-State: AOAM530f08fTaKOogj0Id4f2s0lpYEnnL3pSm1V6sWDKvqW0DdYUhePw
        kaS//7haVMY3fJylLQ3AFfudMe7H57LU8g==
X-Google-Smtp-Source: ABdhPJyirz+1F1WBsUfjJIz+T80eOBCgURo1f8ERldJRfhsM4x9KOP2FNkdnfjpxsp6PWJ8jZsqfzg==
X-Received: by 2002:a05:600c:2ca:: with SMTP id 10mr366721wmn.151.1612913629959;
        Tue, 09 Feb 2021 15:33:49 -0800 (PST)
Received: from [192.168.8.189] ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id s6sm406039wmh.2.2021.02.09.15.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 15:33:49 -0800 (PST)
Subject: Re: [PATCH v3] io_uring: fix possible deadlock in io_uring_poll
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612511388-153658-1-git-send-email-haoxu@linux.alibaba.com>
 <1612514061-177495-1-git-send-email-haoxu@linux.alibaba.com>
 <acbd48f8-9535-ff47-9337-008588d8eb8c@gmail.com>
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
Message-ID: <7fe4f425-bb5a-c04e-6c49-d4890508f560@gmail.com>
Date:   Tue, 9 Feb 2021 23:30:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <acbd48f8-9535-ff47-9337-008588d8eb8c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/02/2021 12:58, Pavel Begunkov wrote:
> On 05/02/2021 08:34, Hao Xu wrote:
>> This might happen if we do epoll_wait on a uring fd while reading/writing
>> the former epoll fd in a sqe in the former uring instance.
>> So let's don't flush cqring overflow list, just do a simple check.
> 
> I haven't tested it but tried out identical before.
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> Cc: stable@vger.kernel.org # 5.5+

Don't see it queued, so up, in case it was forgotten

> 
>>
>> Reported-by: Abaci <abaci@linux.alibaba.com>
>> Fixes: 6c503150ae33 ("io_uring: patch up IOPOLL overflow_flush sync")
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>  fs/io_uring.c | 17 +++++++++++++++--
>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 38c6cbe1ab38..5f42ad6f2155 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8718,8 +8718,21 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
>>  	smp_rmb();
>>  	if (!io_sqring_full(ctx))
>>  		mask |= EPOLLOUT | EPOLLWRNORM;
>> -	io_cqring_overflow_flush(ctx, false, NULL, NULL);
>> -	if (io_cqring_events(ctx))
>> +
>> +	/*
>> +	 * Don't flush cqring overflow list here, just do a simple check.
>> +	 * Otherwise there could possible be ABBA deadlock:
>> +	 *      CPU0                    CPU1
>> +	 *      ----                    ----
>> +	 * lock(&ctx->uring_lock);
>> +	 *                              lock(&ep->mtx);
>> +	 *                              lock(&ctx->uring_lock);
>> +	 * lock(&ep->mtx);
>> +	 *
>> +	 * Users may get EPOLLIN meanwhile seeing nothing in cqring, this
>> +	 * pushs them to do the flush.
>> +	 */
>> +	if (io_cqring_events(ctx) || test_bit(0, &ctx->cq_check_overflow))
>>  		mask |= EPOLLIN | EPOLLRDNORM;
>>  
>>  	return mask;
>>
> 

-- 
Pavel Begunkov
