Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB02C2159D1
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgGFOny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgGFOny (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:43:54 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3359C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:43:53 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so39676872wme.5
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qe1wljEVfBdYk/kIc9msm8p45RK5rL4ZEREviEs0a2o=;
        b=sQD8x44Otq+crOKPko40skYgepeRYDe/qbabgQStgmAa/4W5pPTRrk95PEhk+cwhi7
         Ssm+2FxWgtDGgghi+Mzz2cjkjZfTD/DCeh0VMtFOfSwQZRLWl2HLjWQ5g9nL5vdnN0gc
         n0WN+tLNPgSj1ZpKfLDkougn5d/uc23wLQLcICk57q6uaOJxupGy5YQuY30kJsFkykAg
         JBK31u/IS6vb3D3QhyIqvgOwJsZebhV8fSMhiMoTAJKbfvI/0GDMeF3fzCjF50xhROEy
         AACYZ4L0r/ozmMbe5FdKbodRHupjBwWQlnvmU/on3uAljao8/Fotr9W49t4LSlz08tue
         N6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qe1wljEVfBdYk/kIc9msm8p45RK5rL4ZEREviEs0a2o=;
        b=O7hNGNMdDCvU5jLyJHSapf/Yi9O0lSG6JBiR9AJa8GWUqlF1JpN4CF/hEQw2LgAaSS
         yAHugD5y48hVHYlN9WMBObYgG3oDcUvT7pqyUtIEFi1st09qZIPEGyoBip7UuRmdnMzK
         nIhJ/L0v7B0mcOgNkOopuJMBxkZlMLRssXrR++zLvFINc1PcfaLkJT+bLuB2EyeZTd8U
         6lM0R1nQMPoWs1/F4Zcr9x841zDSlcTFurT5BVqFHlicyojWO6vKj1aM5iKQv3Ju1Zs4
         NNFe9RROmvkcwPagOexYuJdIkg/uo8ih7XFbet1Hwk1i17LrSyM+oHcuFnr8VhygtHLc
         k8xQ==
X-Gm-Message-State: AOAM532rJhynmMx7AEF/XCoWHcOxQYM7pCPRyrXu2cgrxHhGRPmkSzck
        ttZk7z+YrRv/yCNvr5uNGwXmGAof
X-Google-Smtp-Source: ABdhPJz9vOre0qWWZ744BVyyFEm1PZodmJNdMzK08KunY7DcjGScmvPSmZUHOIP3+A826G9y1SGg4A==
X-Received: by 2002:a7b:c10c:: with SMTP id w12mr11844424wmi.87.1594046632160;
        Mon, 06 Jul 2020 07:43:52 -0700 (PDT)
Received: from [192.168.43.52] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id e17sm23871849wrr.88.2020.07.06.07.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 07:43:51 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1594044830.git.asml.silence@gmail.com>
 <da2c8de6c06d9ec301b08d023a962fdb85781796.1594044830.git.asml.silence@gmail.com>
 <e8cfe972-0b28-8c5d-122d-0a724b3424fa@kernel.dk>
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
Subject: Re: [PATCH 3/3] io_uring: briefly loose locks while reaping events
Message-ID: <6a21bbfd-d1b2-09f0-af08-b964b810a449@gmail.com>
Date:   Mon, 6 Jul 2020 17:42:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e8cfe972-0b28-8c5d-122d-0a724b3424fa@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/07/2020 17:31, Jens Axboe wrote:
> On 7/6/20 8:14 AM, Pavel Begunkov wrote:
>> It's not nice to hold @uring_lock for too long io_iopoll_reap_events().
>> For instance, the lock is needed to publish requests to @poll_list, and
>> that locks out tasks doing that for no good reason. Loose it
>> occasionally.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 020944a193d0..568e25bcadd6 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2059,11 +2059,14 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
>>  
>>  		io_iopoll_getevents(ctx, &nr_events, 1);
>>  
>> +		/* task_work takes the lock to publish a req to @poll_list */
>> +		mutex_unlock(&ctx->uring_lock);
>>  		/*
>>  		 * Ensure we allow local-to-the-cpu processing to take place,
>>  		 * in this case we need to ensure that we reap all events.
>>  		 */
>>  		cond_resched();
>> +		mutex_lock(&ctx->uring_lock);
>>  	}
>>  	mutex_unlock(&ctx->uring_lock);
>>  }
> 
> This would be much better written as:
> 
> if (need_resched()) {
> 	mutex_unlock(&ctx->uring_lock);
> 	cond_resched();
> 	mutex_lock(&ctx->uring_lock);
> }
> 
> to avoid shuffling the lock when not needed to. Every cycle counts for
> polled IO.

It happens only when io_uring is being killed, can't imagine any sane app
trying to catch CQEs after doing that. I'll resend

-- 
Pavel Begunkov
