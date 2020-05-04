Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37051C3F09
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 17:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgEDPxZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 11:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729479AbgEDPxY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 11:53:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA69C061A0E;
        Mon,  4 May 2020 08:53:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s8so11268752wrt.9;
        Mon, 04 May 2020 08:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a51OfRZ33jZudrw71sJOVnYwq5K9qTUEcP4pBHMr04A=;
        b=JrfRQ8/P7x/T5NAffxXkepwKmvwZK3c+IHiTDqRUz4I+CNaR9rIsAzheuLUPeKecdq
         18Eu9YPwKO2809csIUMr18/QT/Mn8nZAJD0u5pjdAZkHJozr0R1EjeFLBnhf837aCOU6
         L59+dtAztMayqeD6CD/REdfp9qG7Vlb4Tbx0SOGtM+oyfXGQ/Rv9Yd6useR0gIbDKhJ9
         xIZwAfxSDfoX8qYL9/jzm1zHQ0FWYT7N1mLUQT+BsVJPrWviGg6xTuQ7ilmKvPOF/Njj
         fxhZsgH1JINnmYdmLeSPiGer6dXPYo7PvFpjYRShDwEd6eJuskfc8bQ7lZOPTbUB3jIo
         OwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=a51OfRZ33jZudrw71sJOVnYwq5K9qTUEcP4pBHMr04A=;
        b=KJ7E4uyXaXbRK20JcoldnPi9KkLzQ2NaMIgrK40HmBVV7wiiwFTcSyA3VT7RjCoypP
         fW4DPdIdyfJ+J0KdVMcU6XcuJ6DA4tiPwOYeh0oMB7rhSTqhbzGKsw5guS1O3sPbHNpm
         leDyx+wehElP2GtoZC4o4t5VEHjrkbY2cMlI8W/cBI7qOjF2a5ZjM4ggnLLTrWsa+B/B
         /MQsK0WinWKimJQRAkH3JcVxs6YWoN0MgSvvuXnBsosYB0J2YQMg+25t+bEts6xGWop+
         l6Qvq5RXnTwXWrZrII0VtjacKqWwxqPEokEl4RV21j+JIvinvTemalyGOCjKKG46no2g
         OA7g==
X-Gm-Message-State: AGi0PuYFZ+MUOMd00KlPmlv/xt49XraUT+vfTUDPJqoLJVK94ibJL/As
        ETOaUv5PFTdmjF9p6d3Mg6jxNFEC
X-Google-Smtp-Source: APiQypLktSGrl9Czf2iXPJCpsgaisVYVHpeQnFjMU3AhYBvXXlyz7dbfXsF3KL0dP0oidqNycuHqrw==
X-Received: by 2002:a5d:6742:: with SMTP id l2mr12713590wrw.138.1588607602913;
        Mon, 04 May 2020 08:53:22 -0700 (PDT)
Received: from [192.168.43.158] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id k14sm19424026wrp.53.2020.05.04.08.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 08:53:22 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: Remove logically dead code in io_splice
To:     Jens Axboe <axboe@kernel.dk>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200504151912.GA22779@embeddedor>
 <b26c33c8-e636-edf6-3d43-7b3394850d7a@kernel.dk>
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
Message-ID: <55bf573d-52f9-9131-ff08-49231a88abce@gmail.com>
Date:   Mon, 4 May 2020 18:52:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b26c33c8-e636-edf6-3d43-7b3394850d7a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/05/2020 18:25, Jens Axboe wrote:
> On 5/4/20 9:19 AM, Gustavo A. R. Silva wrote:
>> In case force_nonblock happens to be true, the function returns
>> at:
>>
>>  2779         if (force_nonblock)
>>  2780                 return -EAGAIN;
>>
>> before reaching this line of code. So, the null check on force_nonblock
>> at 2785, is never actually being executed.
>>
>> Addresses-Coverity-ID: 1492838 ("Logically dead code")
>> Fixes: 2fb3e82284fc ("io_uring: punt splice async because of inode mutex")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>  fs/io_uring.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index e5dfbbd2aa34..4b1efb062f7f 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2782,7 +2782,7 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
>>  	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
>>  	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
>>  	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
>> -	if (force_nonblock && ret == -EAGAIN)
>> +	if (ret == -EAGAIN)
>>  		return -EAGAIN;
> 
> This isn't right, it should just remove the two lines completely. But
> also see:

Oh, right, it will ignore O_NONBLOCK and be resubmitted, as going through
io_wq_submit_work(). I need to be more attentive.


> 
> https://lore.kernel.org/io-uring/529ea928-88a6-2cbe-ba8c-72b4c68cc7e8@kernel.dk/T/#u
> 

-- 
Pavel Begunkov
