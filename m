Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B035FBB7
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 21:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353424AbhDNTgu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 15:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353449AbhDNTgs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 15:36:48 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4ACC061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 12:36:23 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j5so19995671wrn.4
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 12:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3nQZOTSwvpg/vV7zCoPFBLa91cmSpyTn5CWGyrpXQNM=;
        b=QbdAmDQ5aKDrPi8cCRsFV8kLQP3ptDX+XFUyvCS19rtvYyTjsMnn/fScMGUQ0u8V+/
         TbbLtnBh39n1tcSsmJ8Z+jZEkTIFgLq5nIGu9Xg/krZ807JnvEcl+RIyI3giZb597g13
         ZoXImLcBM7d0VeX+1+TzpcOY+f8H0V0T96w4RluOWhu4Ekn/n7XTDQLrxsgL5x6wU8Ov
         zO3TI62P8HQSyGckr4r3ihcs0SWY3fESwrvb+iHthQKpbJ5UbtIjwO4A/eXdMGOm4CzH
         3Evd77hWg2xKaH38C4Cm/aeMD4rzZvfS24fQc6razi0GRi3jNyI7DkPKY7tuPUMr36GP
         7BJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3nQZOTSwvpg/vV7zCoPFBLa91cmSpyTn5CWGyrpXQNM=;
        b=BmieYKHVnRTyu9HI4mxyQAQh70jl/MbuYzh1hVFs6mMGmNlJRzsHvIwQFdDO9WiniL
         tFtaZsb1QkKqBZlcAlihJXv1o49o3uEa3JiJr6c9cx3MNkGi8XzGuL14V7g6cpVN+lsw
         RkyCH2sBHnm0x1IbM5imsDWGm/cuNcHbPJH3odG5S30JzkyX3jIGP0cpQ6yrxwlvcMUH
         YLn3aE7WhWm58SluE7IpxQ7CbLUtRJcFfIokP7tR/ybsknKZChP0/5O7VPY7ZRMTDLtA
         HLF2FmogqkSOR0NuVsLQ3vyUa/SaNnTJ1jhS5vbdfIwZ//HV93etQxmqOZRDxijhbb93
         M1Qw==
X-Gm-Message-State: AOAM530al82zzas2vgzdDwUCo7zHTZFJRGp16+hmYq4oAQZnnPmcyqIM
        +QlRKVy/f4attc+YmnjMk/nD6BTHHkMJOg==
X-Google-Smtp-Source: ABdhPJymljGv37lBEq4yN1BlGLn5TgI2PV7e82BWPRAJSGK6zxp/vZGT3aEfmV+AgXQns2tKPmDHjg==
X-Received: by 2002:adf:dd48:: with SMTP id u8mr43851798wrm.139.1618428981785;
        Wed, 14 Apr 2021 12:36:21 -0700 (PDT)
Received: from [192.168.8.186] ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id a3sm362199wru.40.2021.04.14.12.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 12:36:21 -0700 (PDT)
Subject: Re: [PATCH v2 5.13 0/5] poll update into poll remove
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1618403742.git.asml.silence@gmail.com>
 <66cf75ca-05d9-2c92-1038-253377ba0fd5@kernel.dk>
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
Message-ID: <e9de7a38-5bb1-e04e-3685-c8db6c5e5846@gmail.com>
Date:   Wed, 14 Apr 2021 20:32:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <66cf75ca-05d9-2c92-1038-253377ba0fd5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/04/2021 17:20, Jens Axboe wrote:
> On 4/14/21 6:38 AM, Pavel Begunkov wrote:
>> 1-2 are are small improvements
>>
>> The rest moves all poll update into IORING_OP_POLL_REMOVE,
>> see 5/5 for justification.
>>
>> v2: fix io_poll_remove_one() on the remove request, not the one
>> we cancel.
> 
> I like moving update into remove, imho it makes a lot more sense. Will
> you be sending a test case patch for it too?

I was testing with your test case, 3 line change, can send it.

We definitely need a helper though. There was something for liburing
from Joakim, right?

-- 
Pavel Begunkov
