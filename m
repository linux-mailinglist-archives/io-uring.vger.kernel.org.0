Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9AB2F8EAF
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 19:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbhAPSe2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 13:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbhAPSe1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 13:34:27 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57614C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 10:33:47 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id h17so9912183wmq.1
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 10:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BG6mFVgbia+Yvuhl4qv4pda1nLFncVy/hgcCFwy71sE=;
        b=VT5hmRF3Wx1zN6BQ91uLkmJfP7sjvYuKMmnQR5VwPFdRoGcRgqVxS5BA01lrDhOYll
         KD+JpcG/+ATR/ootgwTM2Qwz6PFWqacmgEoj3XswTc8vC4ZVrDzCCwLUn/27X1YwYEAe
         EB+OX5dQDufsmXuePMtTtA5+vUz0NvBh8HSxCaQAQKd2wlFpPl1rbZxU4UhUNno+3K6s
         gCEIOR7SzfAyHg8ylBUJYhhVIasxAHlDToatMrE21LgFlxfsMLbp8bCqmNO0BNLpocFu
         mjITLRtZuEJTrLCFwVfvkrVSQNn+v3Eh7yIgcCXmO+zLS9zOVcU2LEiWu3vxYk9dXXEw
         TxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BG6mFVgbia+Yvuhl4qv4pda1nLFncVy/hgcCFwy71sE=;
        b=Ocgrb1XBK2sKUM1sGUY5AjGFo3puYxYgpBPBnQoli11wwFIujkn3xbYgnCXhVTImB3
         4hBmq0Hq78sfLHo4RHF0P/7owZhwZiQH3S8DZgqp1B5HSyY39ioSvYjj1XQyQnopz7Cx
         KjfkxnizaULElvTZ+/SMX4jviqPlpU+spRZWFFTOYj2xVEaUZzsleN5Ks9kDc5MT+10Y
         qLef5z9qThTSTsivoR8opgMs/AxQuD+RRZMzMXtZJ3D5P4sZdYTZ9liHxmpxiD847Aig
         FDrfgFl4KmxBQOFYvbRXK9bfWRtR1DbGFPsy6KvBt56Q1iDuWLaHusLCntuEqjZsT5u2
         2mtg==
X-Gm-Message-State: AOAM530xUQr18uckp0QIFV7o1Hd/WuUZxi5GyOTpM2JjlM1ZMTbtxCgI
        KIDg5OSieMp5DYFKLHhctLF8N5DpnMI=
X-Google-Smtp-Source: ABdhPJzNLwyEg+9tyq99RrPy5wCQkzcRLPLQ3lIz9gy22FN55WX3pOp/aEaJ98d22itb7LJPDItFFg==
X-Received: by 2002:a1c:398a:: with SMTP id g132mr11676386wma.38.1610822025705;
        Sat, 16 Jan 2021 10:33:45 -0800 (PST)
Received: from [192.168.8.126] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id t16sm17364739wmi.3.2021.01.16.10.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 10:33:45 -0800 (PST)
Subject: Re: [PATCH v5 13/13] io_uring: support buffer registration sharing
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1610487193-21374-14-git-send-email-bijan.mottahedeh@oracle.com>
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
Message-ID: <d692a97c-6a3c-233a-b303-990613ade5e9@gmail.com>
Date:   Sat, 16 Jan 2021 18:30:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1610487193-21374-14-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/01/2021 21:33, Bijan Mottahedeh wrote:
> Implement buffer sharing among multiple rings.
> 
> A ring shares its (future) buffer registrations at setup time with
> IORING_SETUP_SHARE_BUF. A ring attaches to another ring's buffer
> registration at setup time with IORING_SETUP_ATTACH_BUF, after
> authenticating with the buffer registration owner's fd. Any updates to
> the owner's buffer registrations become immediately available to the
> attached rings.

I'm thinking it through, but there is an easy to miss potential bug,
so see below a comment to not forget.

> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> 
> Conflicts:
> 	fs/io_uring.c
> ---
>  fs/io_uring.c                 | 85 +++++++++++++++++++++++++++++++++++++++++--
>  include/uapi/linux/io_uring.h |  2 +
>  2 files changed, 83 insertions(+), 4 deletions(-)
[...]
> +
> +static int io_init_buf_data(struct io_ring_ctx *ctx, struct io_uring_params *p)
> +{
> +	if ((p->flags & (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF)) ==
> +	    (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF))
> +		return -EINVAL;
> +
> +	if (p->flags & IORING_SETUP_SHARE_BUF) {
> +		struct fixed_rsrc_data *buf_data;
> +
> +		buf_data = alloc_fixed_rsrc_data(ctx);
> +		if (IS_ERR(buf_data))
> +			return PTR_ERR(buf_data);

Because of sneaked through 5.11 fixes it'll be

if (!buf_data) return -ENOMEM

> +
> +		ctx->buf_data = buf_data;
> +		return 0;
> +	}
> +
> +	if (p->flags & IORING_SETUP_ATTACH_BUF)
> +		return io_attach_buf_data(ctx, p);
> +
> +	return 0;
> +}
> +


-- 
Pavel Begunkov
