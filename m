Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292521E29CC
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 20:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgEZSMa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 14:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgEZSMa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 14:12:30 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE447C03E96D;
        Tue, 26 May 2020 11:12:29 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l21so24847266eji.4;
        Tue, 26 May 2020 11:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UyrWKgMFxAn8D6HctBFM/hqJsEY5ARHgLrpHqlBMPtw=;
        b=AfINMofYMY+AKu2WUfhJPci3ZYAG3mXHWZU45nrQBUf0ybSJZRHQEcdEQF+nofBS1p
         bIN07u7ucVxr8U6jgrCxEmSxkqfj0MeVcyTipLcx0L5hDHxvKycwfzr2JoyCn2E7Cxuh
         i/7icstnCZAuZ3+vY0/MBcW0RM+GnUKU3/zfOuAEEMqTkt1t7j9eGbW118+RNmB4MitO
         ce3o53Y2kMCkxQWu9iucKill71QaYC8mhxNLTi9VfnGDxwK/EMpjb0AiSbleSg6J2O0O
         KOVKhEZTuDHFx5v5ddQrOhrwWangvx0lV9FYl39il9OCp2fNqF9epr6MzRNBbnIGWeYb
         IBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UyrWKgMFxAn8D6HctBFM/hqJsEY5ARHgLrpHqlBMPtw=;
        b=P1mh3IDrZjrNGhXZQhdA0CPKVJ6goFaZ5LZZTnOqtahzuZGXyDFT2T1ZwoMuPkD+dC
         fa5DxpqPePxFmID2+e5OS6aBbf7ftJ0WxC9XGjHZw4tH5zXeIt854TnkK5LAUtRLsrYD
         0rx2SMQsCcHAbzuQVG39r1DQkBpISURmMhvDW/HMIfdp8IR1TTLSJLezbemnHc1c2pY7
         mIUeHD+p1hP1WBfWA0UU5TseiBM1+U9GMHQ+Vr8r6VH+Rlf6RGyA3LuqEXJGIg1/UPqb
         CfnQYqi5DOz1uVoU3TVowoN9IfQ/R3ieiu4OKM9QqaySy6gF9YZ5FpMRzHnyXRYhp8Bi
         miDg==
X-Gm-Message-State: AOAM532Oca7iR5sU/DKPnSLZ9ix9lgJ8rDcs0drGs5Gamjw/gKilxnn0
        3lwQ+1Nb0xiztlQuVCpkeCusA/lc
X-Google-Smtp-Source: ABdhPJxdRfrmrAq2+rgcBNEmYxaCjlFMWPs/i1c6ff9fbaOrYTrZaNdoSRHjgMIh3PLa5h5WmHWDIQ==
X-Received: by 2002:a17:906:858b:: with SMTP id v11mr2143875ejx.348.1590516748181;
        Tue, 26 May 2020 11:12:28 -0700 (PDT)
Received: from [192.168.43.99] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id j12sm559462edv.47.2020.05.26.11.12.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 11:12:27 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: let io_req_aux_free() handle fixed files
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1590513806.git.asml.silence@gmail.com>
 <3e06564a15ca706f5f71ed25e8e3f5ea1520117e.1590513806.git.asml.silence@gmail.com>
 <7c1727c0-43c2-b4dc-8093-55030ae49057@kernel.dk>
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
Message-ID: <7a408a46-9f9f-a5d5-ae29-93b719edf79b@gmail.com>
Date:   Tue, 26 May 2020 21:11:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7c1727c0-43c2-b4dc-8093-55030ae49057@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/05/2020 21:03, Jens Axboe wrote:
> On 5/26/20 11:34 AM, Pavel Begunkov wrote:
>> Remove duplicated code putting fixed files in io_free_req_many(),
>> __io_req_aux_free() does the same thing, let it handle them.
> 
> This one is already changed in mainline:
> 
> 
>> commit 9d9e88a24c1f20ebfc2f28b1762ce78c0b9e1cb3 (tag: io_uring-5.7-2020-05-15)
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed May 13 12:53:19 2020 -0600
> 
>     io_uring: polled fixed file must go through free iteration
> 

I see, missed it.

And thanks for adding the fixes tag for the other one.

-- 
Pavel Begunkov
