Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6E81D1A7A
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 18:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgEMQD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 12:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730063AbgEMQD3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 12:03:29 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4E3C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 09:03:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l18so65566wrn.6
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 09:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PXp6AteMxo6nougODUALPWvTRnz4YKG8qKKWMAQqx7Y=;
        b=pV8GrHZ2r3C2tnUuQ9vFmtwlaPEiOhkOVu5ymmUNVkeTmc9muJdP+t2u8dS5wGFZ29
         fg+BQf+WUC6+qyXibMTdNSrfKIfoPg92XqZvn/2CkBlhVfIeMy6DRSw5H5NMoPuG/Spn
         2cx5yqD8nHcDAJrsN7Q09wIXkRe95HtAfHKkDnwjqq7Q2/vY/QjcPS7hRWBWPjUK3tSM
         u+EVVq0OBr6nTGXldP3rhih9/nlUMReXTQYwE38qS8rwQSBvmRfQalFVmKiJMcRgOzek
         kXvVzGftjSfb11y9zehnrDdK5L21qmZYyHztj3ajlZ/IiwUnTEEASudDDjIj6WTztSQu
         i3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PXp6AteMxo6nougODUALPWvTRnz4YKG8qKKWMAQqx7Y=;
        b=Tqv78qClkIS5ud05kmyo873VVxRj9j02V7H9d/rT7gid67cyHGbhNK1u5UKhWcCZPL
         aSQB46jt0nk99XvXT1f78/GpPM0iMRE+jmtt+1PCQmwQ+hj7hB4g+fuYt9mW3Xz0HDCS
         C78PdlU1V1GH/x1yS0bUDfDSfzQ9v4QRMI8ViUL2inVUpp0oh/eTRe5ROpDyAxMhpy71
         ndJ/SDrHLzZi3/qXaUG2BGbAssyooJbV7AOfpBxl070wOTitH4+63W0rZj9caVMBw4gN
         0n8cqWRQrlVNCN9Rsfrcbaoxqt4FLP4mj+yLmrOVGshXceI9fGxrW1fiJ+R0e03GOixM
         5yOw==
X-Gm-Message-State: AOAM531P4GOcv8iDnjisdRaS+fMj9PvaZeULnE0wUcvcLCQvYEGh+p6q
        hN5YXAmiFkMExE6u8A8tXrR79xj0
X-Google-Smtp-Source: ABdhPJw5WfiMPzlztd64TqLJIcQ+1aZ55xIDT8V4ak+Z2x4fUnwJMG3CZjZgArGsvG8k1+1Jq2LfMQ==
X-Received: by 2002:adf:fe90:: with SMTP id l16mr63585wrr.222.1589385805885;
        Wed, 13 May 2020 09:03:25 -0700 (PDT)
Received: from [192.168.43.127] ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id r9sm19277309wmg.47.2020.05.13.09.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 09:03:25 -0700 (PDT)
To:     Dmitry Sychov <dmitry.sychov@gmail.com>,
        Sergiy Yevtushenko <sergiy.yevtushenko@gmail.com>
Cc:     Mark Papadakis <markuspapadakis@icloud.com>,
        "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com>
 <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com>
 <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
 <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com>
 <CAO5MNut+nD-OqsKgae=eibWYuPim1f8-NuwqVpD87eZQnrwscA@mail.gmail.com>
 <CADPKF+dR=uQx9Dnu83ADghgei4KxwqnfBwONvp-ou--aePq0xg@mail.gmail.com>
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
Subject: Re: Any performance gains from using per thread(thread local) urings?
Message-ID: <c66f786b-999b-de45-ce18-f6a2df0e7d8c@gmail.com>
Date:   Wed, 13 May 2020 19:02:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CADPKF+dR=uQx9Dnu83ADghgei4KxwqnfBwONvp-ou--aePq0xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/05/2020 17:22, Dmitry Sychov wrote:
> Anyone could shed some light on the inner implementation of uring please? :)

It really depends on the workload, hardware, etc.

io_uring instances are intended to be independent, and each have one CQ and SQ.
The main user's concern should be synchronisation (in userspace) on CQ+SQ. E.g.
100+ cores hammering on a spinlock/mutex protecting an SQ wouldn't do any good.

Everything that can't be inline completed\submitted during io_urng_enter(), will
be offloaded to an internal thread pool (aka io-wq), which is per io_uring by
default, but can be shared if specified. There are pros and cons, but I'd
recommend first to share a single io-wq, and then experiment and tune.

Also, in-kernel submission is not instantaneous and done by only thread at any
moment. Single io_uring may bottleneck you there or add high latency in some cases.

And there a lot of details, probably worth of a separate write-up.

> 
> Specifically how well kernel scales with the increased number of user
> created urings?

Should scale well, especially for rw. Just don't overthrow the kernel with
threads from dozens of io-wqs.

> 
>> If kernel implementation will change from single to multiple queues,
>> user space is already prepared for this change.
> 
> Thats +1 for per-thread urings. An expectation for the kernel to
> become better and better in multiple urings scaling in the future.
> 
> On Wed, May 13, 2020 at 4:52 PM Sergiy Yevtushenko
> <sergiy.yevtushenko@gmail.com> wrote:
>>
>> Completely agree. Sharing state should be avoided as much as possible.
>> Returning to original question: I believe that uring-per-thread scheme is better regardless from how queue is managed inside the kernel.
>> - If there is only one queue inside the kernel, then it's more efficient to perform multiplexing/demultiplexing requests in kernel space
>> - If there are several queues inside the kernel, then user space code better matches kernel-space code.
>> - If kernel implementation will change from single to multiple queues, user space is already prepared for this change.
>>
>>
>> On Wed, May 13, 2020 at 3:30 PM Mark Papadakis <markuspapadakis@icloud.com> wrote:
>>>
>>>
>>>
>>>> On 13 May 2020, at 4:15 PM, Dmitry Sychov <dmitry.sychov@gmail.com> wrote:
>>>>
>>>> Hey Mark,
>>>>
>>>> Or we could share one SQ and one CQ between multiple threads(bound by
>>>> the max number of CPU cores) for direct read/write access using very
>>>> light mutex to sync.
>>>>
>>>> This also solves threads starvation issue  - thread A submits the job
>>>> into shared SQ while thread B both collects and _processes_ the result
>>>> from the shared CQ instead of waiting on his own unique CQ for next
>>>> completion event.
>>>>
>>>
>>>
>>> Well, if the SQ submitted by A and its matching CQ is consumed by B, and A will need access to that CQ because it is tightly coupled to state it owns exclusively(for example), or other reasons, then you’d still need to move that CQ from B back to A, or share it somehow, which seems expensive-is.
>>>
>>> It depends on what kind of roles your threads have though; I am personally very much against sharing state between threads unless there a really good reason for it.
>>>
>>>
>>>
>>>
>>>
>>>
>>>> On Wed, May 13, 2020 at 2:56 PM Mark Papadakis
>>>> <markuspapadakis@icloud.com> wrote:
>>>>>
>>>>> For what it’s worth, I am (also) using using multiple “reactor” (i.e event driven) cores, each associated with one OS thread, and each reactor core manages its own io_uring context/queues.
>>>>>
>>>>> Even if scheduling all SQEs through a single io_uring SQ — by e.g collecting all such SQEs in every OS thread and then somehow “moving” them to the one OS thread that manages the SQ so that it can enqueue them all -- is very cheap, you ‘d still need to drain the CQ from that thread and presumably process those CQEs in a single OS thread, which will definitely be more work than having each reactor/OS thread dequeue CQEs for SQEs that itself submitted.
>>>>> You could have a single OS thread just for I/O and all other threads could do something else but you’d presumably need to serialize access/share state between them and the one OS thread for I/O which maybe a scalability bottleneck.
>>>>>
>>>>> ( if you are curious, you can read about it here https://medium.com/@markpapadakis/building-high-performance-services-in-2020-e2dea272f6f6 )
>>>>>
>>>>> If you experiment with the various possible designs though, I’d love it if you were to share your findings.
>>>>>
>>>>> —
>>>>> @markpapapdakis
>>>>>
>>>>>
>>>>>> On 13 May 2020, at 2:01 PM, Dmitry Sychov <dmitry.sychov@gmail.com> wrote:
>>>>>>
>>>>>> Hi Hielke,
>>>>>>
>>>>>>> If you want max performance, what you generally will see in non-blocking servers is one event loop per core/thread.
>>>>>>> This means one ring per core/thread. Of course there is no simple answer to this.
>>>>>>> See how thread-based servers work vs non-blocking servers. E.g. Apache vs Nginx or Tomcat vs Netty.
>>>>>>
>>>>>> I think a lot depends on the internal uring implementation. To what
>>>>>> degree the kernel is able to handle multiple urings independently,
>>>>>> without much congestion points(like updates of the same memory
>>>>>> locations from multiple threads), thus taking advantage of one ring
>>>>>> per CPU core.
>>>>>>
>>>>>> For example, if the tasks from multiple rings are later combined into
>>>>>> single input kernel queue (effectively forming a congestion point) I
>>>>>> see
>>>>>> no reason to use exclusive ring per core in user space.
>>>>>>
>>>>>> [BTW in Windows IOCP is always one input+output queue for all(active) threads].
>>>>>>
>>>>>> Also we could pop out multiple completion events from a single CQ at
>>>>>> once to spread the handling to cores-bound threads .
>>>>>>
>>>>>> I thought about one uring per core at first, but now I'am not sure -
>>>>>> maybe the kernel devs have something to add to the discussion?
>>>>>>
>>>>>> P.S. uring is the main reason I'am switching from windows to linux dev
>>>>>> for client-sever app so I want to extract the max performance possible
>>>>>> out of this new exciting uring stuff. :)
>>>>>>
>>>>>> Thanks, Dmitry
>>>>>
>>>

-- 
Pavel Begunkov
