Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156CD2D90D5
	for <lists+io-uring@lfdr.de>; Sun, 13 Dec 2020 23:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgLMWHy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Dec 2020 17:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbgLMWHo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Dec 2020 17:07:44 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32D7C0613CF;
        Sun, 13 Dec 2020 14:07:03 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id y17so14534850wrr.10;
        Sun, 13 Dec 2020 14:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lBXMEqxPoCArGe/I6OnwcDSg9d8UKL6dxdEKdckdY0Y=;
        b=E7D8ziH4GIdg/RQqlVCBYAdfLR5JpW8Yb+gt70vfqcnAE46RLL2iyxoLKXIR3t46L+
         4o7+53Lj0C6M9agbXSJ5vaVn71vemMTJXyG6jZn5hNutQmRLicyzLVvp5XmBetD4lSJt
         KZcYDcCMe1WRnrBCSc4A8uNVflgBNSo+LfpH4XaYQGOjsmwKnwwAU8wo874qIRwnvccK
         CXmPrWgW4kcdw0B75B/GJkAPzX9H2mloI/7V34yWBxdSHmmCxLSjqGZeBOfHEd5F6hiV
         6thdcfktAc2IACDtaDoVgm4eICL/suNKXVTa2VO2g3+bCAybeQ6opItptM5D5hgoucDj
         RXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lBXMEqxPoCArGe/I6OnwcDSg9d8UKL6dxdEKdckdY0Y=;
        b=q+s/Hn25Zlf4rNvC+/98fbhRi3hjABhqpkXaUlqcG09Re/vliFWRwi14mJw1EcdSwo
         rCiUT3ss45L3bfPNeq75Cfmb0gTeQaOD4P4BvvCz3328qJjfRCjd1SSKb/5Qii7smgY4
         lGYUqtv0/CNBdcINSEExA21mKzeVifOu3AC3TTm3d7POchml/oQxi4T2O5rS7/juAumb
         WrejYWfQJ9H77rBF/PbezR38LlbaM398KLp59G9r1TjLIB6ez7LklN9avvEJ1NijR0Kt
         L2wsImCc8DOhutissa4wxCCrfMNTuU8bC869E9zHTDpJn9/zdyxW8MCRvYsvrRtKqmQw
         srYg==
X-Gm-Message-State: AOAM530QRMzfGD3HaWZo0AoLmxaAqJDIoMXg78yjLwHjJialdboARqe0
        IsPahQ9XUGf7TEBLjZn4zYAGTaNDMJXHgml4
X-Google-Smtp-Source: ABdhPJxiG+V19Qk5Ilz69c1NzPDdXzK7qamS3a85K7gKkoRtZqjt8nZ86u7UhIeFGeBQ+0hig7k99w==
X-Received: by 2002:adf:e84c:: with SMTP id d12mr26697597wrn.382.1607897222442;
        Sun, 13 Dec 2020 14:07:02 -0800 (PST)
Received: from [192.168.8.124] ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id a144sm27679946wmd.47.2020.12.13.14.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 14:07:01 -0800 (PST)
Subject: Re: [RFC 0/2] nocopy bvec for direct IO
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <b165cd42-be79-69ed-ae06-a3f3ff633c62@kernel.dk>
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
Message-ID: <b3edacbf-8501-8fcf-b492-2e4cc25c34d6@gmail.com>
Date:   Sun, 13 Dec 2020 22:03:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b165cd42-be79-69ed-ae06-a3f3ff633c62@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/12/2020 16:53, Jens Axboe wrote:
> On 12/8/20 7:19 PM, Pavel Begunkov wrote:
>> The idea is to avoid copying, merging, etc. bvec from iterator to bio
>> in direct I/O and use the one we've already got. Hook it up for io_uring.
>> Had an eye on it for a long, and it also was brought up by Matthew
>> just recently. Let me know if I forgot or misplaced some tags.
>>
>> A benchmark got me 430KIOPS vs 540KIOPS, or +25% on bare metal. And perf
>> shows that bio_iov_iter_get_pages() was taking ~20%. The test is pretty
>> silly, but still imposing. I'll redo it closer to reality for next
>> iteration, anyway need to double check some cases.
>>
>> If same applied to iomap, common chunck can be moved from block_dev
>> into bio_iov_iter_get_pages(), but if there any benefit for filesystems,
>> they should explicitly opt in with ITER_BVEC_FLAG_FIXED.
> 
> Ran this on a real device, and I get a 10% bump in performance with it.
> That's pretty amazing! So please do pursue this one and pull it to
> completion.

I'm curious, what block size did you use?

-- 
Pavel Begunkov
