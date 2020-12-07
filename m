Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054E92D14B4
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgLGP2R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgLGP2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:28:16 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCBBC0617B0
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:27:30 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id v14so11803100wml.1
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=60Fw2+w5hU92F1M0eAfb0NYzP933vqkOgH9ggtztrSc=;
        b=TC9Q+xGXFwVbQiPLk4fvb+QsTvE1IUM4JyvS31yk18jcLhQps8eZ8QqZc456jVJ0YX
         qteCDr/dI/WqWvfbtCnCMAnlo5yMQbRkcxyxSEI7IxrXkxaYprVaMX64K8yK/aozL0K4
         zPEv5Wx+bqPa6oCH//DYlBMM2ZfJ+pZg8ArGlWo8zg7xd5uQ/4svF7YAhvPIblQIu3rw
         oo0mclAka2X74Q36oAJ/FvGYQVNCLx6oRg1NIJDA7K8mTwKTwa4D8j41rzEW0uX2mx3d
         gjijGdQXaU3zX0m6ZlB6YksOYT+3+st0i+0YLaeYqkC0vh5Xx79toRjSYYpOJzxo/n1q
         CuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60Fw2+w5hU92F1M0eAfb0NYzP933vqkOgH9ggtztrSc=;
        b=VexsGNZLQHlVn1bHQ4XfaIq5eRsZSaBmZWHZD9sA4QEozgvVMdH3lZllz91EflA7dN
         Y7KKM+hxpmnzzRgqefIdEDmyi7wRVj5+4wvWMNTwX8v4IJOKfjBrgRX3MkyKh0Gm0bqt
         HnngRF+e1+CRi6tU99NHbL55cx5HLr+4d1Hjkfk6JFqxFgLUzxfFjUAra3nqpiP9JbmE
         ZHyB7wwJiY6QN36KT98l6cPAe5vnl7gFHEWd/BW0WSTpShp8krvzyIDaR5TfQzGcgY18
         dM76kf4GefxoclWaJfzDiVDqbocY7/agWBZuhWxpULJY7rQBXcB/A0PkgKwhwoaCpAjg
         S6SQ==
X-Gm-Message-State: AOAM531il25OlmVkaEjYpf6+0w8x1aq1z3mlbDcPodze6WMr0OgUdnED
        4DwNilGsEt80/Sx/BPcJVbURH3152OwPhg==
X-Google-Smtp-Source: ABdhPJx0pxoUrosTiTDrEzqs0F+aBW8VK94si6/BxC+3Z/XLY7jchu5sXa5H/8Az+/IogvqiE9NrKw==
X-Received: by 2002:a1c:4156:: with SMTP id o83mr18903087wma.178.1607354848854;
        Mon, 07 Dec 2020 07:27:28 -0800 (PST)
Received: from [192.168.8.104] ([185.69.145.78])
        by smtp.gmail.com with ESMTPSA id j7sm14756668wmb.40.2020.12.07.07.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:27:28 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1607293068.git.asml.silence@gmail.com>
 <bb6bd92a-e6be-5683-debc-82c0a2b02a98@kernel.dk>
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
Subject: Re: [PATCH 5.10 0/5] iopoll fixes
Message-ID: <32957a33-7a4d-98f6-5609-fe9ae43b1892@gmail.com>
Date:   Mon, 7 Dec 2020 15:24:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bb6bd92a-e6be-5683-debc-82c0a2b02a98@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/12/2020 15:05, Jens Axboe wrote:
> On 12/6/20 3:22 PM, Pavel Begunkov wrote:
>> Following up Xiaoguang's patch, which is included in the series, patch
>> up when similar bug can happen. There are holes left calling
>> io_cqring_events(), but that's for later.
>>
>> The last patch is a bit different and fixes the new personality
>> grabbing.
>>
>> Pavel Begunkov (4):
>>   io_uring: fix racy IOPOLL completions
>>   io_uring: fix racy IOPOLL flush overflow
>>   io_uring: fix io_cqring_events()'s noflush
>>   io_uring: fix mis-seting personality's creds
>>
>> Xiaoguang Wang (1):
>>   io_uring: always let io_iopoll_complete() complete polled io.
>>
>>  fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 39 insertions(+), 13 deletions(-)
> 
> I'm going to apply 5/5 for 5.10, the rest for 5.11. None of these are no

Didn't get what you mean by "None of these are no in this series."

> in this series, and we're very late at this point. They are all marked for
> stable, so not a huge concern on my front.

Makes sense. I hope it applies to 5.11 well. 

-- 
Pavel Begunkov
