Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E26816A130
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 10:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgBXJK4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 04:10:56 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:38143 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbgBXJKz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 04:10:55 -0500
Received: by mail-wr1-f44.google.com with SMTP id e8so9412089wrm.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 01:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aM1tNe5CKXYcvsrIJpNur35kFGAyK/urNu2p5XT7KIo=;
        b=tPuTpYtvKIbn6DIQGdBTS7YsmbQ9dbp+l7SjH/h8Z/jOck1q/J2TKHBKHGE75hZOix
         SL+djE8cfLxzvo8SArLo4m0ahfDlDys6yDv6b1nXR/fTXuKGn6orr7VJryflV4KlquM2
         wPOVY57QvndVmH+cpjwRm+Usl8eWFwItIG6zI+A0YFi4C9Pg0eUs+LCnDa8sCP59UJ3A
         0Lkrs/BfM8a3smAxL8SM2ilnI09if6EEviensevIn5D1Th7h8yHcRDjRlaeBtgeII1cm
         pGtmv0AYRP41EgYT/K8VVwFZ0wiV5dzhG3RBhkC49xKhy0EoVpIPHYvIwYGjigWZI/KS
         6FwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aM1tNe5CKXYcvsrIJpNur35kFGAyK/urNu2p5XT7KIo=;
        b=RGl6IbWyOmeyROpKQR6wCwoWrUdsruP66k5mUJytQTpTOx6n4xyEtBtongJX3JLhRJ
         kfiMImaCXeb5yys09wKCY1Z12JiqRLWZW3yRIgVJ8V+BW2O/urNo1oGdHX5YZg+YuuN6
         rN2j5fRtrwmeWX3PBMqqnp8gjPLdrTYD8EnqZgQX0HNwrapd6v9dald0QpqSbN0WoxL5
         pW8c0TdUly3Pv3ZUo+Gp4Nj5GZfRbCs6QOUicfRV80dMgKzopTQM1a63zu3Kwshv6xK0
         V5l16ZMBWkAEbZSDMtfSbzyRY7T6cPmeS7mvrLiAbEZDP+TNvLeCMYDFJtnULtWR+UWD
         Eqow==
X-Gm-Message-State: APjAAAWtMx9ejP6veLXkTfKtErL4p/bg2aGAPg3hojchSoP+QnY2pL2I
        OUwJIeqe3AKija4Ck41KI+aLEKbh
X-Google-Smtp-Source: APXvYqyelsHei+/t4pOWNmM7+KR4o9l+55SgB59goe0Ogg03bWnsJLkfQBUMbFu90MRYSNKsJIwTVw==
X-Received: by 2002:a5d:4bd2:: with SMTP id l18mr1870996wrt.99.1582535453923;
        Mon, 24 Feb 2020 01:10:53 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id z16sm390320wrp.33.2020.02.24.01.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 01:10:53 -0800 (PST)
To:     Andres Freund <andres@anarazel.de>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
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
Subject: Re: Deduplicate io_*_prep calls?
Message-ID: <5f355efb-1091-89b5-546f-8dbbc984f65b@gmail.com>
Date:   Mon, 24 Feb 2020 12:10:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/02/2020 10:12, Andres Freund wrote:
> Hi,
> 
> On 2020-02-23 20:52:26 -0700, Jens Axboe wrote:
>> The fast case is not being deferred, that's by far the common (and hot)
>> case, which means io_issue() is called with sqe != NULL. My worry is
>> that by moving it into a prep helper, the compiler isn't smart enough to
>> not make that basically two switches.
> 
> I'm not sure that benefit of a single switch isn't offset by the lower
> code density due to the additional per-opcode branches.  Not inlining
> the prepare function results in:
> 

The first looks good, I like the change. Do you have performance numbers?
e.g. tools/io_uring/io_uring-bench (do_nop=1, with high DEPTH e.g. 100)
would be good enough to estimate relative overhead.
I don't expect any difference, TBH.


> There's still some unnecessary branching on force_nonblocking. The
> second patch just separates the cases needing force_nonblocking
> out. Probably not quite the right structure.
> 

It's trickier there. It can get into io_prep_issue_sqe_nonblock() ->
io_req_prep() with sqe=NULL. With a glance look, it should crash.
The culprit is __io_queue_sqe() with linked requests.

Also, io_issue_sqe_nonblock() would look better than io_prep_issue_sqe_nonblock().

BTW, did you tried to run regression tests? It's under liburing repository.

> 
> Not quite sure what the policy is with attaching POC patches? Also send
> as separate emails?

I'd prefer it inlined (i.e. as text, not attachment), so it can be
inline-commented.

-- 
Pavel Begunkov
