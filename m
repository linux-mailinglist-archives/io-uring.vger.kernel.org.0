Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617031F0C76
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 17:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgFGPiC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 11:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgFGPiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 11:38:02 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE304C08C5C3
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 08:38:01 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r15so13959025wmh.5
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 08:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+5nD44ZpViHFo7/bacHrR4Io6/Ips4S3K4ZmmBsE9JY=;
        b=DycoCDvgDgYjbxQscNIhFLZ5iLKJEfwgH6q0OkljyHTrpopBcq6dnfn1NDwHibx7sY
         yOQgn0mNPBEM/L6HdaS98ZW+LXfEnbZvL9FXwriXeFUKHlpIL2GqpBfqLSMZixttNThV
         EkxqCJxFyeGjl60up62qlqQ0RCuLZULPcQpV6KU0cQ3Qu1zxbX48hn/8UdYjexxBnnjL
         0XNaCwntM+tUEiK3+NbzjgwmHrAIZXdDnKF1zE9KpaE3bs0rcKCsUpTiXAj6dpPzA4Xz
         KGdiiQdlyK+66SwXoUZu/kshkg+viGGEN0vnGQvfhem1nUawjpQwvjApSMCh6uKuqO8U
         fuSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+5nD44ZpViHFo7/bacHrR4Io6/Ips4S3K4ZmmBsE9JY=;
        b=uUP3ubq/SIR2LrAI7/2L9reZ8/LWd9+r/tmPt3sRfmenec0kyFWsObg33shpeOZHBh
         o3mIGRwpqiX/DN7tgcN0mO6gckKYfTWCJ3AXCWBhhUu3ZsESmB9Heiz/RftPsvEKwmv1
         D3eWG2P6l2Wlu0Ek+qNJtJeI64jBVdwCpUSyInvGG2nNwtNACCb7ZG30CQfl9NfFrHI6
         NysINLZQwp8CoeVo8wJRPtWjXJjO9d4yLHzUHczxcKClCl14FOCGWSaEfWujBntfyTaO
         WWQvzI1upxE5mHwPnrHYmz49asjxCAZFxboxCIRHM9VPYBA/LsrfS64EuZ96MfWPJRwv
         lIlg==
X-Gm-Message-State: AOAM530Q49Chla3e+wsDEM0GxJH0xjAD2O8kCRp9H7SyAzP7v+xvllpA
        JdBJLDkScQojvIfW87iOJlVc/fjb
X-Google-Smtp-Source: ABdhPJzoVZXEKGwcF4pGhszNUGLtfSraOveINCdUD3SmFyk9gs6IWP2ibMsugP+CGfIMhCSd6EmYpA==
X-Received: by 2002:a1c:ddc1:: with SMTP id u184mr11717609wmg.115.1591544280248;
        Sun, 07 Jun 2020 08:38:00 -0700 (PDT)
Received: from [192.168.43.101] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id y80sm21152626wmc.34.2020.06.07.08.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 08:37:59 -0700 (PDT)
Subject: Re: [PATCH] io_uring: execute task_work_run() before dropping mm
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200606151248.17663-1-xiaoguang.wang@linux.alibaba.com>
 <350132ea-aade-27f4-1fcc-ba0539a459a1@gmail.com>
 <96f61793-3b44-6de1-c3b6-b54e86d4c203@linux.alibaba.com>
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
Message-ID: <87c92562-b862-08d7-ce32-7c09280f0ba5@gmail.com>
Date:   Sun, 7 Jun 2020 18:36:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <96f61793-3b44-6de1-c3b6-b54e86d4c203@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/06/2020 15:37, Xiaoguang Wang wrote:
>>> The reason is that once io_sq_thread has a valid mm, schedule subsystem
>>> may call task_tick_numa() adding a task_numa_work() callback, which will
>>> visit mm, then above panic will happen.
>>>
>>> To fix this bug, only call task_work_run() before dropping mm.
>>
>> So, the problem is that poll/async paths re-issue requests with
>> __io_queue_sqe(), which doesn't care about current->mm, and which
>> can be NULL for io_sq_thread(). Right?
> No, above panic is not triggered by poll/async paths.
> See below code path:
> ==> task_tick_fair()
> ====> task_tick_numa()
> ======> task_work_add, work is task_numa_work, which will visit mm.
> 
> In sqpoll mode, there maybe are sqes that need mm, then above codes
> maybe executed by schedule subsystem. In io_sq_thread, we drop mm before
> task_work_run, if there is a task_numa_work, panic occurs.
> 

Got it, thanks for explaining

-- 
Pavel Begunkov
