Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37323174F92
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 21:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCAUd4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 15:33:56 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53759 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgCAUd4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 15:33:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id f15so8946619wml.3;
        Sun, 01 Mar 2020 12:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QFjnXFL+93+jG81t0lP2dF6Miy5v15MOEbx0tXp+jSU=;
        b=No9LAtV8ZtzU8MTfHfwBLf0zoPLMP8N97CTxsuQpG16JwQgxtxbTJA/4nCke4JuKWK
         xDxH0gAjPENNGVw6x3XjvS8HTBxSZUnAykWvlkmp989YAuyPZdkurGnli13SJ9UsN375
         kQteAsn/+7PYzPXEflCbTB3h9aIO58TN5IujmhZIOue+SolmQoMq8G+xfvNwYPlBA76F
         pcau8q45wsnO7Bq1gA8o7qGRoE61S8/agKNL0H4FHLjTt1crRZ/HSdYO82TCzgUm+scT
         1MfEjod4em/prZ+dACw8HqXTGrgHIpo8L4Rp9zgYaoaNvgn6qfyppRVcrHQ8eMTt1HIP
         2OAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QFjnXFL+93+jG81t0lP2dF6Miy5v15MOEbx0tXp+jSU=;
        b=NBfF+xLOPEt3+Qp6FtbpstT6A7fWcJwXQ++rNEhKwF9Lh747uLOo9htwMTJKSVWCNv
         oqo/GTP6QauArqoEE7/f70fBQ47vpbqNROJoUdY6QB8ddRRd5XuWf+GGrLH2hjN1Nl1J
         IVMU7aB87JYRWvRMEsk2Nuv+f3Ypk321/ktNE55hSBrR0RT08OR/WtrL61KxyREryYed
         ddjkTbKMqOM2wW0Bl+b16I65ptw7vUi9P3l8/FTKRGN8RiIYwteNZ4h2yNx9nAuhFzSs
         riAAt3D48LIgzDQpsWyZblqUXOZCjHyU5QFvwwUKmF1faoYu2jNhOyJCBZZBb9KPQVOl
         ALNw==
X-Gm-Message-State: APjAAAWbLNzQaIbThpzWbKYNkaXPWw1DbOkgeczFBQG1GodffMAxZLrh
        1qw7c3EKWnO/eKBTEko/45579BAr
X-Google-Smtp-Source: APXvYqxis0WXn+zIVWuPZg2gCj103k+sbss5epT0HIQn0JNLErzK8UEJOK4rTfBaNr4UZP49slcPcg==
X-Received: by 2002:a1c:6a17:: with SMTP id f23mr15977199wmc.33.1583094834013;
        Sun, 01 Mar 2020 12:33:54 -0800 (PST)
Received: from [192.168.43.139] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id u25sm4263546wml.17.2020.03.01.12.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 12:33:53 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <d54ddeae-ad02-6232-36f3-86d09105c7a4@kernel.dk>
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
Subject: Re: [PATCH RFC 0/9] nxt propagation + locking optimisation
Message-ID: <cab8e903-fb6f-eae5-68a6-2a467160997e@gmail.com>
Date:   Sun, 1 Mar 2020 23:33:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d54ddeae-ad02-6232-36f3-86d09105c7a4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/03/2020 22:14, Jens Axboe wrote:
> On 3/1/20 9:18 AM, Pavel Begunkov wrote:
>> There are several independent parts in the patchset, but bundled
>> to make a point.
>> 1-2: random stuff, that implicitly used later.
>> 3-5: restore @nxt propagation
>> 6-8: optimise locking in io_worker_handle_work()
>> 9: optimise io_uring refcounting
>>
>> The next propagation bits are done similarly as it was before, but
>> - nxt stealing is now at top-level, but not hidden in handlers
>> - ensure there is no with REQ_F_DONT_STEAL_NEXT
>>
>> [6-8] is the reason to dismiss the previous @nxt propagation appoach,
>> I didn't found a good way to do the same. Even though it looked
>> clearer and without new flag.
>>
>> Performance tested it with link-of-nops + IOSQE_ASYNC:
>>
>> link size: 100
>> orig:  501 (ns per nop)
>> 0-8:   446
>> 0-9:   416
>>
>> link size: 10
>> orig:  826
>> 0-8:   776
>> 0-9:   756
> 
> This looks nice, I'll take a closer look tomorrow or later today. Seems
> that at least patch 2 should go into 5.6 however, so may make sense to
> order the series like that.

It's the first one modifying io-wq.c, so should be fine to pick from the middle
as is.

> 
> BTW, Andres brought up a good point, and that's hashed file write works.
> Generally they complete super fast (just copying into the page cache),
> which means that that worker will be hammering the wq lock a lot. Since
> work N+1 can't make any progress before N completes (since that's how
> hashed work works), we should pull a bigger batch of these work items
> instead of just one at the time. I think that'd potentially make a huge
> difference for the performance of buffered writes.

Flashed the same thought. It should be easy enough for hashed requests. Though,
general batching would make us to think about fairness, work stealing, etc.

BTW, what's the point of hashing only heads of a link? Sounds like it can lead
to the write-write collisions, which it tries to avoid.

> 
> Just throwing it out there, since you're working in that space anyway
> and the rewards will be much larger.

I will take a look, but not sure when, I yet have some hunches myself.

-- 
Pavel Begunkov
