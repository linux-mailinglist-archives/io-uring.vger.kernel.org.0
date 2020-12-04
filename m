Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551372CF5B1
	for <lists+io-uring@lfdr.de>; Fri,  4 Dec 2020 21:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgLDUfk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Dec 2020 15:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgLDUfk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Dec 2020 15:35:40 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8042C0613D1
        for <io-uring@vger.kernel.org>; Fri,  4 Dec 2020 12:34:59 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 23so6546572wrc.8
        for <io-uring@vger.kernel.org>; Fri, 04 Dec 2020 12:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zuyUKisFuR+cw/f1CS3QvQ7XfZIOI2kcg/LV+ImsMVc=;
        b=Rdk6otBwP900OYucI92HQm1gt5igpLVWvIkGd9Npp5RWmPYiKDGVIPA44XJ33qcBYD
         DkZRZREVlWexU2tehpcF/WHiOnOFtyi9dW8gwsHSXyXMODS4Kh+XrsV69//jVAVw877A
         Av/k3/B1EQnXcFrleLQJlpN1/FppWYFgaTNVIy4D6ZhSMddwJnSbffRxlNZ6h7yDetx6
         ky7fkf8pyxgnglpNc1opQgg2gLqqLb8G2UDNuoyqghSKPNRqFrLhtGktpyPBk3goCr4a
         MK4VwyVVQzEjPDnIMP2Y+KTLWrJrf1kDdAbDXzAA1COa/SU33FLqCrRZkd+uu5fRocrH
         wHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zuyUKisFuR+cw/f1CS3QvQ7XfZIOI2kcg/LV+ImsMVc=;
        b=lvx+9cypka4DZj6h3JS4U3kBxtU+P9CHS2X4hBjfNyMSJHF4imdHmR1rL7HMHrDfDd
         Ok4bjnEJ92ZNrleay4GfYG+HjlI1tWmrv7njiMLTDneoGZwyWmQcopNZU26rY5ll9rVH
         vLxn4XHnKkyH5uubgBESprFJT1lyZcNnT0dIYrBQjdYIZF9dX09CvXVu8MoeFUm1JyXt
         cGJouj4a6IFpVc7WzJYhNw1wqsbtiVMhchNcK1gZReuMYMFHZSBZ2zycKL1s4Gj3N8wk
         7HTYkpZrbVRrNTHAWb7B6gOZnEHD+Ui490+Uthy9B5RBotU3vvT021FaAO0khCirsy4d
         LU3g==
X-Gm-Message-State: AOAM530E1w/4AWedX4AUhM+T9IPn15xt5ruZYvYhLSUH4r9Zu8J5M2IT
        NsweDyRlWDIX1UgZQNobwJGjvChYSe24AA==
X-Google-Smtp-Source: ABdhPJyoAq+VYYU5iggrGQc+VFLGl0JKJ+tK7dKcz0V7cf3lHeSzQEXeZdipio/wAzlX8iOAryN9Cw==
X-Received: by 2002:a5d:6046:: with SMTP id j6mr6782380wrt.317.1607114098589;
        Fri, 04 Dec 2020 12:34:58 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.93])
        by smtp.gmail.com with ESMTPSA id v125sm4286367wme.42.2020.12.04.12.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 12:34:58 -0800 (PST)
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20201202113151.1680-1-xiaoguang.wang@linux.alibaba.com>
 <32e75a1d-4e53-e096-7368-9614174db1e5@linux.alibaba.com>
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
Subject: Re: [PATCH] io_uring: always let io_iopoll_complete() complete polled
 io.
Message-ID: <c29edc14-01f1-08a8-6b7a-fbf87a43b866@gmail.com>
Date:   Fri, 4 Dec 2020 20:31:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <32e75a1d-4e53-e096-7368-9614174db1e5@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/12/2020 02:30, Joseph Qi wrote:
> This patch can also fix another BUG I'm looking at:
> 
> [   61.359713] BUG: KASAN: double-free or invalid-free in io_dismantle_req+0x938/0xf40
> ...
> [   61.409315] refcount_t: underflow; use-after-free.
> [   61.410261] WARNING: CPU: 1 PID: 1022 at lib/refcount.c:28 refcount_warn_saturate+0x266/0x2a0
> ...
> 
> It blames io_put_identity() has been called more than once and then
> identity->count is underflow.

Joseph, regarding your double-free
1. did you figure out how exactly this happens?
2. is it appears consistently so you can be sure that it's fixed
3. do you have a reproducer?
4. can you paste a full log of this BUG? (not cutting the stacktrace)

There are problems left even with this patch applied, but I need to
confirm which bug you saw.

-- 
Pavel Begunkov
