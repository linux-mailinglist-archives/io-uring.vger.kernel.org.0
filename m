Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783512AE533
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 02:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbgKKBAu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Nov 2020 20:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730254AbgKKBAt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Nov 2020 20:00:49 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74909C0613D1
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 17:00:49 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id h62so495069wme.3
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 17:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PfikgVvpUvXZs7DQuOy+rTzLYd8b6L/qeLd1NMfmpZI=;
        b=tFrmibFfidrT43C6ZlEuEgqCsHOVQpN2Q/8FdSKTAuTAtOf2St1tyw+wIL29gQenWa
         qnJxiQhT/QRGOXT0YQOUXtAg7QpsX3rbCI/4BK87iupISzb0odF1UdEkMtsZUK0ojKx3
         kT5tb6J9DZiCGzjCRo60lpD91jsk83AXdHLklWSdtTW9tNdyO/u89wtphWLazsdiafhK
         LFeqWtfLcIJEUsL9oTXKQhp5G7pnWYKUl6Q/my51KtHS5DhrFVeujy75lg23cx8obcGe
         Id8UHULAX/zZvb+UHGPkM/on5NO75M8eV1uaM1gbrLtGuPrkO7xVvkUlMwiILAn1sTrZ
         mmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PfikgVvpUvXZs7DQuOy+rTzLYd8b6L/qeLd1NMfmpZI=;
        b=en8qvbrIuiMQw45RqGNF5K6WHQ+NKjPiviwtWeEPw+q4eHk86YWtRtQTynKIiCdPqi
         qMAgMkzLvJCDbrw0iEMMP2W5Bbfywbe75LSEvuApANNbxo5LD3ey0HaBofo1AdCJ+ioD
         bjjUwyonk/z3u6LlBI/kXwsLZJvtrwBapa3nysqOjvACKMPoyB/rvmojLyZdO48kX6Hi
         wknX4LqAf64EOEQF4UFMFoNYQTYtxsvxmwuKzRe7ATb8Ry6ULgkBbP7skLS6R6imB3rF
         Oozj8CiarQjrcIOC6Y28/rIs29eQbWnaMHZs59p9yybErH5dFPNIDKEOzSQH+X73pzFd
         1EoQ==
X-Gm-Message-State: AOAM5318WL3bskXYCDOLToKZ//1oCm/aZEzroQQFTpn9NxrLTZRZzv8W
        aaTXiPzI3l2QJJUGjLDu1NmZgz2VGAjKRQ==
X-Google-Smtp-Source: ABdhPJzlugzh515bJVZcvSKwjDoA6x+yYmRpwlzraGDFEOIL4fEm7P9LR2AILqOptyCkBJKCSxWVfA==
X-Received: by 2002:a1c:9dcc:: with SMTP id g195mr820921wme.113.1605056447817;
        Tue, 10 Nov 2020 17:00:47 -0800 (PST)
Received: from [192.168.1.96] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x81sm598256wmg.5.2020.11.10.17.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 17:00:47 -0800 (PST)
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwgKGMz9UcvpFr1239kmdvmKPuzAyBEwKi_rxDog1MshRQ@mail.gmail.com>
 <acc66238-0d27-cd22-dac4-928777a8efbc@gmail.com>
 <CAM1kxwjSyLb9ijs0=RZUA06E20qjwBnAZygwM3ckh10WozExag@mail.gmail.com>
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
Subject: Re: io_uring-only sendmsg + recvmsg zerocopy
Message-ID: <3913bbb5-50ec-6ad9-13c9-d49a8b7f7e89@gmail.com>
Date:   Wed, 11 Nov 2020 00:57:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwjSyLb9ijs0=RZUA06E20qjwBnAZygwM3ckh10WozExag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/2020 00:07, Victor Stewart wrote:
> On Tue, Nov 10, 2020 at 11:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> we'd be looking at approx +100% throughput each on the send and recv
>>> paths (per TCP_ZEROCOPY_RECEIVE benchmarks).>
>>> these would be io_uring only operations given the sendmsg completion
>>> logic described below. want to get some conscious that this design
>>> could/would be acceptable for merging before I begin writing the code.
>>>
>>> the problem with zerocopy send is the asynchronous ACK from the NIC
>>> confirming transmission. and you can’t just block on a syscall til
>>> then. MSG_ZEROCOPY tackled this by putting the ACK on the
>>> MSG_ERRQUEUE. but that logic is very disjointed and requires a double
>>> completion (once from sendmsg once the send is enqueued, and again
>>> once the NIC ACKs the transmission), and requires costly userspace
>>> bookkeeping.
>>>
>>> so what i propose instead is to exploit the asynchrony of io_uring.
>>>
>>> you’d submit the IORING_OP_SENDMSG_ZEROCOPY operation, and then
>>> sometime later receive the completion event on the ring’s completion
>>> queue (either failure or success once ACK-ed by the NIC). 1 unified
>>> completion flow.
>>
>> I though about it after your other email. It makes sense for message
>> oriented protocols but may not for streams. That's because a user
>> may want to call
>>
>> send();
>> send();
>>
>> And expect right ordering, and that where waiting for ACK may add a lot
>> of latency, so returning from the call here is a notification that "it's
>> accounted, you may send more and order will be preserved".
>>
>> And since ACKs may came a long after, you may put a lot of code and stuff
>> between send()s and still suffer latency (and so potentially throughput
>> drop).
>>
>> As for me, for an optional feature sounds sensible, and should work well
>> for some use cases. But for others it may be good to have 2 of
>> notifications (1. ready to next send(), 2. ready to recycle buf).
>> E.g. 2 CQEs, that wouldn't work without a bit of io_uring patching. 
>>
> 
> we could make it datagram only, like check the socket was created with

no need, streams can also benefit from it.

> SOCK_DGRAM and fail otherwise... if it requires too much io_uring
> changes / possible regression to accomodate a 2 cqe mode.

May be easier to do via two requests with the second receiving
errors (yeah, msg_control again).

>>> we can somehow tag the socket as registered to io_uring, then when the
>>
>> I'd rather tag a request
> 
> as long as the NIC is able to find / callback the ring about
> transmission ACK, whatever the path of least resistance is is best.
> 
>>
>>> NIC ACKs, instead of finding the socket's error queue and putting the
>>> completion there like MSG_ZEROCOPY, the kernel would find the io_uring
>>> instance the socket is registered to and call into an io_uring
>>> sendmsg_zerocopy_completion function. Then the cqe would get pushed
>>> onto the completion queue.>
>>> the "recvmsg zerocopy" is straight forward enough. mimicking
>>> TCP_ZEROCOPY_RECEIVE, i'll go into specifics next time.
>>
>> Receive side is inherently messed up. IIRC, TCP_ZEROCOPY_RECEIVE just
>> maps skbuffs into userspace, and in general unless there is a better
>> suited protocol (e.g. infiniband with richier src/dst tagging) or a very
>> very smart NIC, "true zerocopy" is not possible without breaking
>> multiplexing.
>>
>> For registered buffers you still need to copy skbuff, at least because
>> of security implications.
> 
> we can actually just force those buffers to be mmap-ed, and then when
> packets arrive use vm_insert_pin or remap_pfn_range to change the
> physical pages backing the virtual memory pages submmited for reading
> via msg_iov. so it's transparent to userspace but still zerocopy.
> (might require the user to notify io_uring when reading is
> completed... but no matter).

Yes, with io_uring zerocopy-recv may be done better than
TCP_ZEROCOPY_RECEIVE but
1) it's still a remap. Yes, zerocopy, but not ideal
2) won't work with registered buffers, which is basically a set
of pinned pages that have a userspace mapping. After such remap
that mapping wouldn't be in sync and that gets messy.

>>> the other big concern is the lifecycle of the persistent memory
>>> buffers in the case of nefarious actors. but since we already have
>>> buffer registration for O_DIRECT, I assume those mechanics already
>>
>> just buffer registration, not specifically for O_DIRECT
>>
>>> address those issues and can just be repurposed?
>>
>> Depending on how long it could stuck in the net stack, we might need
>> to be able to cancel those requests. That may be a problem.
> 
> I spoke about this idea with Willem the other day and he mentioned...
> 
> "As long as the mappings aren't unwound on process exit. But then you

The pages won't be unpinned until all/related requests are gone, but
for that on exit io_uring waits for them to complete. That's one of the
reasons why either requests should be cancellable or short-lived and
somewhat predictably time-bound.

> open up to malicious applications that purposely register ranges and
> then exit. The basics are straightforward to implement, but it's not
> that easy to arrive at something robust."
> 
>>
>>>
>>> and so with those persistent memory buffers, you'd only pay the cost
>>> of pinning the memory into the kernel once upon registration, before
>>> you even start your server listening... thus "free". versus pinning
>>> per sendmsg like with MSG_ZEROCOPY... thus "true zerocopy".
-- 
Pavel Begunkov
