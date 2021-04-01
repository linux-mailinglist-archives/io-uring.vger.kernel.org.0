Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280EC35114C
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhDAI41 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 04:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhDAI4G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 04:56:06 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5499C0613E6
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 01:56:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z2so1009467wrl.5
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 01:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gOrnr5xPya+RszEsxJ+rvGA0gyJLG1zEIbg6364PSOk=;
        b=Hs04ABJUQ6tALZuDB7ucQeTQxsoDyxc91JGrqUSeTdhhZl0cWr0/zoeT9qgt1R3UW7
         ZqArluvH6712kSObO4vfwcJlRQDyR/gp/19idXgDu4LZ3S8CLuFLI/70cue3h47MhbeJ
         kLU/xN1GSRUMGCOGxfjUnSkvLUorflk4mBWyPf84X2+Tx4OIVIx/dmRswKM7DlJy6DVG
         Ao23b8b+Gz91jBxVnNnelPxYxfE3XVOSAmV+hUX4P/ZK0L+6EBwQDCg3oR+TjbvLaK3E
         /AwS4HIpslqdY5u6fQVGFSYHg1G7O1YiVEfIYQEnITmJApW8iz6GXaITFAQ6bEnrR7cT
         ZnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gOrnr5xPya+RszEsxJ+rvGA0gyJLG1zEIbg6364PSOk=;
        b=pGdalv17CgrzGesG/+aW7cszHVNvCPxIbv8LTYbAzSR2qdv4gMMnCby5Z7AUdaPyAk
         g6wYByhfhDemnSKaGHRA/jjOmKG1gqJETxVvHz/8yzGhxHSHM8ugHdIIi2pF4eaZlrWU
         WZGn43JvPCqF4570+0j3skInRivxObMLKOoOHnFr5yF1bsLqJCecSjqO84FR0sj4Yw/J
         HM5txkNyTKBOyhkukwJRtZACmppgIwAZjrKXH0ton9DHP6q0Q8IKsvP6er/CWn+pI2SM
         wrP6rg3UWVIWzp7EjpWX1FpKNqyQLKKVM5IqbSMI62aJd2SgmInwDFRn0y3Flc8ZZoD/
         xkfQ==
X-Gm-Message-State: AOAM530vnTtdbDr5UNUF/UjbS/tyX13NcmLCOVI2zdwUsf+rVmF3BT/z
        Up9YL+/BVpZeXHUOZPrEqGA8EqTZY9dHmg==
X-Google-Smtp-Source: ABdhPJzN81EVTUVU+2ZjBPfvQPEjaW3zmzPIztAKlZHxPFztfD0iihgAnJxHwd+Pvvi5Zk3z3OOMLw==
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr8654471wrw.247.1617267360281;
        Thu, 01 Apr 2021 01:56:00 -0700 (PDT)
Received: from [192.168.8.122] ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id h13sm6677901wmq.29.2021.04.01.01.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 01:55:59 -0700 (PDT)
Subject: Re: buffer overflow in io_sq_thread()
To:     Alexey Dobriyan <adobriyan@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <YGTamC6s+HyF+4BA@localhost.localdomain>
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
Message-ID: <55d32b30-ea39-c8b2-2912-8e7081e0f624@gmail.com>
Date:   Thu, 1 Apr 2021 09:51:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <YGTamC6s+HyF+4BA@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 31/03/2021 21:24, Alexey Dobriyan wrote:
> The code below will overflow because TASK_COMM_LEN is 16 but PID can be
> as large as 1 billion which is 10 digit number.
> 
> Currently not even Fedora ships pid_max that large but still...

And is safer limited in any case. Thanks

> 
> 	Alexey
> 
> static int io_sq_thread(void *data)
> {
>         struct io_sq_data *sqd = data;
>         struct io_ring_ctx *ctx;
>         unsigned long timeout = 0;
>         char buf[TASK_COMM_LEN];
>         DEFINE_WAIT(wait);
> 
>         sprintf(buf, "iou-sqp-%d", sqd->task_pid);
> 

-- 
Pavel Begunkov
