Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FB01BE33A
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD2P6T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 11:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2P6T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 11:58:19 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C416DC03C1AD
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 08:58:18 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k1so3186765wrx.4
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 08:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P1nAnH1qoyjSBG7uz8UWKBU86HNkwr37357tFZ3UqcQ=;
        b=pMWYk9q7YczX7G+sWgYAUyPO6iPlfcro1vFAByLsRsbwtUhf6v2jykvxfzZsR4cbWT
         O5qhjhBmXE5I3OFCNkFHxxRNL4KkNHuHsYBdd/1hFFKITMs0CwVY14QwaO/mZ70LlrLr
         p4QEtIAzxkwigSzFEywWlxKIp9X9HVzyP0+lDnIzSwI24EbKb60SRFLeSX1SbyYdqP8a
         50xvVVMQM0VwVH4YUIuKsKZmb7MEapr89B8HBn2spSogQV3iOhwkLsSKu8rWMHPkihUu
         0kkzKKdUCU3fl3Zh6tqrpwYhKp4eSKz0zoF1E9oHVUojvPYtmW5iicvPtTI7ZspC31b9
         so5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=P1nAnH1qoyjSBG7uz8UWKBU86HNkwr37357tFZ3UqcQ=;
        b=uU0fw8b930shhBXTS9lepM9GdX8kb3xI0tCuodeVJ1eys0gZ+MQ2Qo2h4V64QyFH3v
         Ga1Ns92n9Nf36ePhcw4ST8xdedNITd/rbVN57tIXvuy00yokuZ2UBCpHOaOGlKJYm2AR
         fwvRSzC0ylwAJUEAekzcAeXgvDd+95eTvzDQJ55ozatYxVJJ/h25EKNAtULYLINT3YJU
         i4GYM+EW2wYMGJRFBTOhnv8DNdYRsMBe+3jkQ7V8EKPxEVAVqCHndS3qPB0k3nsSJLeY
         1RpPqG2u+p5DP3liTB3PelItHBetXGZcVo5PCq21kp95xXeTZ6hs9fOc+FMbN03OQWjd
         B4Qw==
X-Gm-Message-State: AGi0PuYxglHtyZok377jEdJbQhvXCm+x+ytDx7BgkZeznFd76WnXs5OM
        nV1ENf23yK6IP6/xb+3btzfWgctc
X-Google-Smtp-Source: APiQypIUuT7XHkd40LFcY/XINoVPyjZUxBzxJi6rHPQPtPTK6AXXQ2djMUiyPdzle8tSgB/b9kEtBg==
X-Received: by 2002:a5d:4301:: with SMTP id h1mr41223885wrq.144.1588175897011;
        Wed, 29 Apr 2020 08:58:17 -0700 (PDT)
Received: from [192.168.43.25] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id p6sm30684475wrt.3.2020.04.29.08.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 08:58:16 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>
Cc:     Clay Harris <bugs@claycon.org>, io-uring <io-uring@vger.kernel.org>
References: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com>
 <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
 <CAG48ez1fc1_U7AtWAM+Jh6QjV-oAtAW2sQ2XSz9s+53SN_wSFg@mail.gmail.com>
 <6a444e4c-bd51-b32c-b9e0-5e157b20e79d@kernel.dk>
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
Subject: Re: Feature request: Please implement IORING_OP_TEE
Message-ID: <639bc18d-7419-29b9-bbbe-0b011795f38b@gmail.com>
Date:   Wed, 29 Apr 2020 18:57:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6a444e4c-bd51-b32c-b9e0-5e157b20e79d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/04/2020 23:02, Jens Axboe wrote:
> On 4/27/20 12:22 PM, Jann Horn wrote:
>> On Mon, Apr 27, 2020 at 5:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 4/27/20 9:40 AM, Clay Harris wrote:
>>>> I was excited to see IORING_OP_SPLICE go in, but disappointed that tee
>>>> didn't go in at the same time.  It would be very useful to copy pipe
>>>> buffers in an async program.
>>>
>>> Pavel, care to wire up tee? From a quick look, looks like just exposing
>>> do_tee() and calling that, so should be trivial.
>>
>> Just out of curiosity:
>>
>> What's the purpose of doing that via io_uring? Non-blocking sys_tee()
>> just shoves around some metadata, it doesn't do any I/O, right? Is
>> this purely for syscall-batching reasons? (And does that mean that you
>> would also add syscalls like epoll_wait() and futex() to io_uring?) Or
>> is this because you're worried about blocking on the pipe mutex?
> 
> Right, it doesn't do any IO. It does potentially block on the inode
> mutex, but that's about it. I think the reasons are mainly:

Good catch, the waiting probably can happen with splice as well.
I need to read it through, but looks strange that it just ignores O_NONBLOCK,
is there some upper bound for holding it or something?

> 
> - Keep the interfaces the same, instead of using both sync and async
>   calls.
> - Bundling/batch reasons, either in same submission, or chained.
> 
> Some folks have talked about futex, and epoll_wait would also be a
> natural extension as well, since we already have the ctl part.

-- 
Pavel Begunkov
