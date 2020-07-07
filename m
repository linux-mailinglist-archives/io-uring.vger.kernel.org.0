Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACA2216D1B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 14:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgGGMsG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 08:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGMsF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 08:48:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21950C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 05:48:05 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so44965148wru.6
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 05:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:cc:references:to:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6SE2K9sBUku4RHQpf6q5qaMdV+eKi8ozCqFlHAdLsJk=;
        b=a+I9nV62plPgEmDWlYcsuqiD4zmWItwTYL69xz/Gz+oKuBH4zJgOzYh+0mf5cyWGSl
         KCivgo+90kI27Vsb7Vlo+te3BbTlwGpinURdNPY3KC9oS5DSTUb8gKtVBtUp55uZEyb5
         TY8RHbjk8y982dIBZUrPUFjPbGZn6d5NkIgZuVneRqedrrvk1oLUif6+TTXemytBQiQ4
         JUdpQjX9yYpD839NcduFLsIDKfLwXQFdCrDnLc3B+WA9HaALfyvMdKUNJESCaIGG0TZy
         tBoi3lkWnJET+nqfuAT5+ZXC7OOPO7WBoRseonO7hxs+1mRSD1N9UE/RKgicfiBOCh/N
         trKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:cc:references:to:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6SE2K9sBUku4RHQpf6q5qaMdV+eKi8ozCqFlHAdLsJk=;
        b=htdUkRNz0nzEGtojDnFhHuKH0skNCM9ixo86+YawKTVkUmCT9eAMo5crfOhBcUUYEP
         7NLIhvyHlpeb20ibzPXn0RE+y8sqZDYWiVYxmK4gCQdAlcpeI2gc45mECjRJZq/EK75l
         qUKvGRxDYFE7c+KwEIbv7hVKzT1vHYkhQ8YjvbyuYcKAVd1MUswVa3CJ30X/HVokPJlR
         yjp9ZuD3HFhIUpUesrCl9qggVXbTZZ3C5hlsbbxq9J830fcytAXg23Y/kN1Qy9ZIj/HL
         WAU3blj9Rf/Nrfxa95Uhgwdwem38FQfy8Gjuzx0i+7s9fgmXUVVAjQmErFIsihLsLddK
         4qQA==
X-Gm-Message-State: AOAM533205bKljNsDw/+ZffC8ZRvhe/6R1QTKNz/H0mNdcxdHtIym1z4
        6k6kt8SupEyfDIUpAohZwo/2Yfed
X-Google-Smtp-Source: ABdhPJyw/okCKxxiWFRW9NWzqf3sArNiFCI//uZ1v4csluuq0Vqlm4GATzv7LVY4Bmmr5Oo8qaoTXw==
X-Received: by 2002:a5d:4a42:: with SMTP id v2mr49958726wrs.33.1594126083475;
        Tue, 07 Jul 2020 05:48:03 -0700 (PDT)
Received: from [192.168.43.52] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id d2sm856571wrs.95.2020.07.07.05.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 05:48:02 -0700 (PDT)
Subject: Re: [PATCH 5/5] io_uring: fix use after free
From:   Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>
References: <cover.1593424923.git.asml.silence@gmail.com>
 <1221be71ac8977607748d381f90439af4781c1e5.1593424923.git.asml.silence@gmail.com>
 <CAG48ez2yJdH3W_PHzvEuwpORB6MoTf9M5nOm1JL3H-wAnkJBBA@mail.gmail.com>
 <f7f4724d-a869-c867-ad8e-b2a59e89c727@gmail.com>
 <CAG48ez3fR1QyVXapvwbYzbtv4AEb0BY2ebKsV7vNFLE-6NaUQA@mail.gmail.com>
 <4f5ecae5-8272-04aa-775e-293dfef82383@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
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
Message-ID: <463baa76-18ef-b98a-070f-416cdf00250d@gmail.com>
Date:   Tue, 7 Jul 2020 15:46:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4f5ecae5-8272-04aa-775e-293dfef82383@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/07/2020 09:49, Pavel Begunkov wrote:
> On 04/07/2020 00:32, Jann Horn wrote:
>> On Fri, Jul 3, 2020 at 9:50 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> On 03/07/2020 05:39, Jann Horn wrote:
>>>> On Mon, Jun 29, 2020 at 10:44 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>> After __io_free_req() put a ctx ref, it should assumed that the ctx may
>>>>> already be gone. However, it can be accessed to put back fallback req.
>>>>> Free req first and then put a req.
>>>>
>>>> Please stick "Fixes" tags on bug fixes to make it easy to see when the
>>>> fixed bug was introduced (especially for ones that fix severe issues
>>>> like UAFs). From a cursory glance, it kinda seems like this one
>>>> _might_ have been introduced in 2b85edfc0c90ef, which would mean that
>>>> it landed in 5.6? But I can't really tell for sure without investing
>>>> more time; you probably know that better.
>>>
>>> It was there from the beginning,
>>> 0ddf92e848ab7 ("io_uring: provide fallback request for OOM situations")
>>>
>>>>
>>>> And if this actually does affect existing releases, please also stick
>>>> a "Cc: stable@vger.kernel.org" tag on it so that the fix can be
>>>> shipped to users of those releases.
>>>
>>> As mentioned in the cover letter, it's pretty unlikely to ever happen.
>>> No one seems to have seen it since its introduction in November 2019.
>>> And as the patch can't be backported automatically, not sure it's worth
>>> the effort. Am I misjudging here?
>>
>> Use-after-free bugs are often security bugs; in particular when, as in
>> this case, data is written through the freed pointer. That means that
>> even if this is extremely unlikely to occur in practice under normal
>> circumstances, you should assume that someone may invest a significant
>> amount of time into engineering some way to make this bug happen. If

Jens, how would you prefer to handle this for 5.8? I can send a patch, but
1. it's fixed in for-5.9
2. it would be a merge conflict regardless of 1.

-- 
Pavel Begunkov
