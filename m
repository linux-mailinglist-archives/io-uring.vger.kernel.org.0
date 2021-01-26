Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32418305832
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 11:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314271AbhAZXCx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 18:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbhAZRZR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 12:25:17 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05632C061352;
        Tue, 26 Jan 2021 09:24:22 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d22so20744104edy.1;
        Tue, 26 Jan 2021 09:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rXdrRsGhj1nVaU/LhEQmWVDqTDKRL6AiUbAzoR14U/Q=;
        b=dssj/O/2ZBdNudvVz5W2VrCqJcBSQ3WkMa/+yX8XkxKJcyARtjRQEFL65tsJVgBXYG
         34TxH0xv5IjzWW8eFUPGws3aTV2FTUDr5KOUsRBci+cUnKoMh/GL/sNzLRZg2f3QiSEu
         lUFPfHCcgqJUQwlGkPS2H7LPA27SmThY6QddfHbVASPkQcnIjqm/tly4GImiMa8uQSML
         HFgSX+77QiMHqfBihlBOmjdtMTHDGyjDSmx4G2urhkqM6vmKVYlMbcNeBHQKgOlbsM5k
         hNIAFTpV7Ck02mO6na+o3js9WJL6zqScpHg59J/lZ6EbgDhLcDOoBDXvU1az+AzD6qyG
         Yz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rXdrRsGhj1nVaU/LhEQmWVDqTDKRL6AiUbAzoR14U/Q=;
        b=D7Xvfyt1KzN3NqH7D+138A4JQl3flI5FCt4SZq0YE/JE3+O6cVWFF1SGjilHTZ2ryv
         R/Hs2+rMB7EePOqIydVDko7CRFleAE2EmQ19kpOFD99kS/T0ZAj43AwmOIGwya0opOCo
         aH1R9rncB4jIfGFjKB9QGSJJ1xjF9DM3tGS1/9VJ8p8Yql8Pp7xSHlhVgkWCMN91RUuh
         jtHdySf9BDSsKrCG6cjNYjdZh5nSmIyGvbbw+VcO/qFVD5S4/9S7Ob8C9Tg9pCrEJ+At
         VmH1i21hzkzniADjyqpzenqZqvliYgHUwyvVE8QW9Xr/M0SKjAxjLejXbck7zzkrSDRt
         lDDg==
X-Gm-Message-State: AOAM532f2pHfXWXErK7heI3D/Gp1D+ZoXKZXET51e05Gk3Y681rsJE+v
        +IEb71Zfp4iBHwdJt1m1YiA1xxqoosY=
X-Google-Smtp-Source: ABdhPJzrksf33ja4yDHmx6t7wrasuKi8/7n1ukCKJ5v6U1Qc1Ambq9leA3x6YXmqidQkBSFL158/4A==
X-Received: by 2002:aa7:dcc9:: with SMTP id w9mr5334384edu.22.1611681860554;
        Tue, 26 Jan 2021 09:24:20 -0800 (PST)
Received: from [192.168.8.158] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o13sm12666412edt.64.2021.01.26.09.24.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 09:24:19 -0800 (PST)
Subject: Re: [PATCH] fs: io_uring.c: Add skip option for __io_sqe_files_update
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     noah <goldstein.n@wustl.edu>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20201220065025.116516-1-goldstein.w.n@gmail.com>
 <0cdf2aac-6364-742d-debb-cfd58b4c6f2b@gmail.com>
 <20201222021043.GA139782@gmail.com>
 <32c9ce7e-569d-3f94-535e-00e072de772e@gmail.com>
 <CAFUsyf+m8SseZ1NzZoYJe4KSH30v-XJeP5P9FvtxQT_5bvsK9Q@mail.gmail.com>
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
Message-ID: <792d56e4-b258-65b4-d0b5-dbfd728d5a02@gmail.com>
Date:   Tue, 26 Jan 2021 17:20:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAFUsyf+m8SseZ1NzZoYJe4KSH30v-XJeP5P9FvtxQT_5bvsK9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/01/2021 17:14, Noah Goldstein wrote:
> On Tue, Jan 26, 2021 at 7:29 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 22/12/2020 02:10, Noah Goldstein wrote:
>>> On Sun, Dec 20, 2020 at 03:18:05PM +0000, Pavel Begunkov wrote:
>>>> On 20/12/2020 06:50, noah wrote:> From: noah <goldstein.n@wustl.edu>
>>>>>
>>>>> This patch makes it so that specify a file descriptor value of -2 will
>>>>> skip updating the corresponding fixed file index.
>>>>>
>>>>> This will allow for users to reduce the number of syscalls necessary
>>>>> to update a sparse file range when using the fixed file option.
>>>>
>>>> Answering the github thread -- it's indeed a simple change, I had it the
>>>> same day you posted the issue. See below it's a bit cleaner. However, I
>>>> want to first review "io_uring: buffer registration enhancements", and
>>>> if it's good, for easier merging/etc I'd rather prefer to let it go
>>>> first (even if partially).
>>
>> Noah, want to give it a try? I've just sent a prep patch, with it you
>> can implement it cleaner with one continue.
> 
>  Absolutely. Will get on it ASAP.

Perfect. Even better if you add a liburing test

-- 
Pavel Begunkov
