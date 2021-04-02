Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405963529CD
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 12:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhDBKgR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 06:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBKgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 06:36:16 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453F0C0613E6
        for <io-uring@vger.kernel.org>; Fri,  2 Apr 2021 03:36:14 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so4941857wma.0
        for <io-uring@vger.kernel.org>; Fri, 02 Apr 2021 03:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y1JZehTFSsiwSgAU3h9zNn76INRGFiVIgTywqmwM2sY=;
        b=UKTY5VG6BlMT+BKNdBEVROtne/65zPqU+gs4TRrcdjGTtMzUvYr1a+L0hFAwlwnuhC
         AtoZXvMYPEcj07F6X/j+a3UHXNeKUx/qY5bwGt6BEPa6Fj/Iv2TdtSOLsn/JgDX52JwP
         dJhSIMBp9EQj+5Xv30yLECsaniebmiBvyLRjeC5lUkQJtCnXFktJy7P8etJ9PwZEySFC
         b9xyrtpYUuiUt/RjWGbGnONMWNfTacr8cADNGwnTm57jwdj3qFCGBc/UMulTIOkjHOI2
         O748irVy63CtdWvqgASoCt/RygFIU27gQevL4BoOQm1wzj1MDV1UXyeVbFZe9T3nFglW
         ORrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y1JZehTFSsiwSgAU3h9zNn76INRGFiVIgTywqmwM2sY=;
        b=NsT0DYuq4YVI9QJQpzMmdt0ETqSdDDsivVXA6g9yyrzfvyyp83m7rmXfCKn1wuiqkq
         4vX0FEPtQmVEBc7WBmhMBBBjvYRgN//QG4V+DL1reAlI8fERP6oZNl9wrDzeIoPOiIor
         jkcIMcqAdcbb+xi7Vdhv+PXwvcB3652X4mW2i7VE0tqoXp+y/Lojo9sdJLb3vD/H1JSS
         sMQSKH6UdWanTBwLxAzIMfIxsKZZXH8jIHAe+hKwHfCnXCrsOK9VmgPBWvJoeMLEzzhx
         TZfZo4af7OMBFX4yh/0oPZQ4taKKoj1as0HZHjkOIGErg9BdQXbgquEpt0HhWIE6aQi2
         kt0w==
X-Gm-Message-State: AOAM530IUrQYCaaBUYpONCBht2GAikHR6sfn7OjV/AnwXyACwyN51h64
        Sf10wXBIXerDxFvlDmWIuOJ1gf9ZAw5aNw==
X-Google-Smtp-Source: ABdhPJwv8rWYFHr0o2z/iNabNkYV9o/TZwaeNUoWuoW0YT2ngiwSEWmKFA04Myi1rKz3RrXLPysa1g==
X-Received: by 2002:a1c:7d41:: with SMTP id y62mr12626044wmc.48.1617359772821;
        Fri, 02 Apr 2021 03:36:12 -0700 (PDT)
Received: from [192.168.8.131] ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id v18sm15568409wrf.41.2021.04.02.03.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 03:36:12 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
References: <a96971ea-2787-149a-a4bd-422fa696a586@kernel.dk>
 <48023516-ac7d-8393-f603-f9bf4faa722f@linux.alibaba.com>
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
Subject: Re: [PATCH] io_uring: don't mark S_ISBLK async work as unbounded
Message-ID: <a4661870-a839-f949-e5cf-18022d070384@gmail.com>
Date:   Fri, 2 Apr 2021 11:32:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <48023516-ac7d-8393-f603-f9bf4faa722f@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/04/2021 09:52, Hao Xu wrote:
> 在 2021/4/1 下午10:57, Jens Axboe 写道:
>> S_ISBLK is marked as unbounded work for async preparation, because it
>> doesn't match S_ISREG. That is incorrect, as any read/write to a block
>> device is also a bounded operation. Fix it up and ensure that S_ISBLK
>> isn't marked unbounded.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
> Hi Jens, I saw a (un)bounded work is for a (un)bounded worker to
> execute. What is the difference between bounded and unbounded?

Unbounded works are not bounded in execution time, i.e. they may take
forever to complete. E.g. recv depends on the other end to send something,
that not necessarily will ever happen.


> 
> Thanks,
> Hao
>> ---
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 6d7a1b69712b..a16b7df934d1 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1213,7 +1213,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>>       if (req->flags & REQ_F_ISREG) {
>>           if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
>>               io_wq_hash_work(&req->work, file_inode(req->file));
>> -    } else {
>> +    } else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
>>           if (def->unbound_nonreg_file)
>>               req->work.flags |= IO_WQ_WORK_UNBOUND;
>>       }
>>
> 

-- 
Pavel Begunkov
