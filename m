Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE702DC2A8
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 16:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgLPPDY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 10:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgLPPDY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 10:03:24 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A872BC06179C
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 07:02:43 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a12so23458571wrv.8
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 07:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dfyHNqyrg4a5bL71u0X10qClMyJis6/imzl9ualstgs=;
        b=gBnW8HOs6noT1/IAfBYO9e5PHKsZaZNM8DowYf6tSzLbE1nB2sHTygm8VJ8HHy8WWP
         1klmMnFz2H5RIC/xkN3t57JO2lx7LGbM1uvD25SdDt1d3EGmPR0MsSmguDhLLYtfViw6
         5gLFyZZPIuYj2IKjJ4dGf4WTd8jq0AbqpExWps1FJ8+ADpL72bFLzAIKYaApIJgl6uT/
         l7WQJxnaeTamtqkzlvQ6P5ohLkaFcOfPxge8XCMKYmuK283kk0tEq8OMZh77YcyVbup/
         ERokPfDcIZCaWZVSeodW+0ZnKsdjhdJubLCKg1+48M5ZDnk8k0AFdH9OgXaQz9ymca14
         S7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfyHNqyrg4a5bL71u0X10qClMyJis6/imzl9ualstgs=;
        b=JY22xpyiREvZPUUCopiPEf1RfBO79928NsimLI1EZ351+hO4Ks96uI1iHSiQkWlXy+
         jug5L6BEff6LSi3rWAj0uiN6CpkLxFbLRrhKE70QkDzgpzHw+n2EZuzclU+UJuEIbKwO
         D46nbmG+7ikJCPAk707bR21IJ0OGPSV7wKeCDl6JmAF6aa7rSQlMM9zNBqRuL3z5yA1X
         f5x51foZ/zyz1okb3CGe3obAOyLZQUEL1dYsUnIPAxkWCFjbHyUgFu45BzrDuRyRGSGQ
         GdYo6rPQ7amoQT8LcazjmYf/+Kpac49fDqqtyRyXqVcSCtWv+WJPHgx7mQXdhuDUma20
         kiHg==
X-Gm-Message-State: AOAM5322+KA5tqMFy27QK2ngh2wUacZzWwU5gAoZZBpWyoiCPIpRJtFe
        vfJpKmRwlvrWbz4ee5PPZ4qQ8fjQu938eA==
X-Google-Smtp-Source: ABdhPJxZmGDtW2/BRwIIx5046FoT9QeXCenZ9cSL5SFY02W5GCnuijxvSlZtjRaOh96KAB4eUaNPfw==
X-Received: by 2002:adf:84c1:: with SMTP id 59mr23631816wrg.409.1608130962180;
        Wed, 16 Dec 2020 07:02:42 -0800 (PST)
Received: from [192.168.8.128] ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id q143sm3224556wme.28.2020.12.16.07.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 07:02:41 -0800 (PST)
Subject: Re: [PATCH v2 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-9-git-send-email-bijan.mottahedeh@oracle.com>
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
Message-ID: <1156b074-076c-a780-9144-e91cf61505a1@gmail.com>
Date:   Wed, 16 Dec 2020 14:59:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1607379352-68109-9-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/12/2020 22:15, Bijan Mottahedeh wrote:
> Apply fixed_rsrc functionality for fixed buffers support.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
[...]
> +static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
> +			       unsigned nr_tables, unsigned nr_bufs)
> +{
> +	int i;
> +		

trailing tabs, btw

> +	for (i = 0; i < nr_tables; i++) {
> +		struct fixed_rsrc_table *table = &buf_data->table[i];
> +		unsigned this_bufs;

-- 
Pavel Begunkov
