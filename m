Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1631A841A
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 18:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391258AbgDNQEY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 12:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388029AbgDNQES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 12:04:18 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31F7C061A0C
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2020 09:04:17 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a23so104545plm.1
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2020 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bdzBnxJ033dSlXb8TGT3AomktpzuMXnRJiZnLcLevWM=;
        b=sSbWV7lPGPk6dG0FSHGHm/AIZo0IH3cnopq0pjU92mghQZr++2Guo18kwprppIvd0n
         DlL23x9qWufsMG6w9C0gv6T02SNa8IUKfsL4i6G6BhfPKwLYjBy4lAp/F2oJClTRjWdf
         ip+Tdvs6cyl85xF6cBntaiMFiPrUMKn3IOlnm6Z4ZUY7F/DrfTLt8Pu7gFlLttxn0vBD
         5r8Pohqkh9GPTEqVEUQvpfqEVNII5B8dGUqCAhxi7MuHRL8CzgD0mqNGCQ0/o96IRe8N
         eDrY2n74M0kqrYSfYubHfD5zFLxSbkp7/x+YjPbfdLxZi83xxdehV15gec6dXbLZovYx
         Ebag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bdzBnxJ033dSlXb8TGT3AomktpzuMXnRJiZnLcLevWM=;
        b=KQFs2A82V4UwQOjkgKtRuawloMHyXFMuVjojAPcEGB4ldIe7TuQ7/U4H+LetHISHxE
         JnAddBFKtgfqnzfQQG7+wqDjN7pudnLwkWQCxF/q9I0C0jsB8HiktG3W/8aNoIISP8Mo
         aVLC5Zsav2AV4peWYy8mItd9PWrWTL7pPxYUUQBt1+liSh3c9vYTqMfLZjWBxfEkG7Fo
         qwk+c0jfkbsuLFO+6Lwddwn0Bx+jSnz5a010mD3t6XenmLO+i+QDSH8TrFsnGOq9Kgqm
         RiVFl1pbnco6i2a7R5dgRd/vPYECo7o54EULqtVYYO86Jmb9u/jNhrpdC0b+dmPeIHVI
         HaQA==
X-Gm-Message-State: AGi0PuYx31roZC6Bf7c5D8CQzgQK+HVPLJlGqCm1yC9c5sf2KUo0K1fj
        9Pif18Y/yeGksvIpUSRO4O0Sog==
X-Google-Smtp-Source: APiQypLykmHnR68J2Qzm/x5McHJoX3DPHBWIvpkNF7AIsuJD2VQhEWqikwuvVo4uYnHNbzr3G2x6sw==
X-Received: by 2002:a17:902:8d91:: with SMTP id v17mr584378plo.53.1586880257307;
        Tue, 14 Apr 2020 09:04:17 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w134sm11492547pfd.41.2020.04.14.09.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 09:04:16 -0700 (PDT)
Subject: Re: Odd timeout behavior
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hrvoje Zeba <zeba.hrvoje@gmail.com>
Cc:     io-uring@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
 <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
 <CAEsUgYiwyjpbaUbHwbx9pHD6x5DBpDop_Z4w9_QXKDd=FdjDjw@mail.gmail.com>
 <b551c2e1-b39a-efbf-24f1-4115275b7db2@gmail.com>
 <0df2f436-0968-c708-84e2-da0c3daa265c@kernel.dk>
 <6835cec5-c8a5-dc49-c4e3-0df276c8537a@gmail.com>
 <c3055911-599f-0776-d0f8-6f8872df75e2@kernel.dk>
 <05510b01-4d0f-28c4-b987-999e4e91ce66@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2eba8624-b487-cc5a-61d0-9c046ad88eec@kernel.dk>
Date:   Tue, 14 Apr 2020 10:04:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <05510b01-4d0f-28c4-b987-999e4e91ce66@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/20 9:46 AM, Pavel Begunkov wrote:
> On 14/04/2020 03:44, Jens Axboe wrote:
>> On 4/13/20 1:09 PM, Pavel Begunkov wrote:
>>> On 13/04/2020 17:16, Jens Axboe wrote:
>>>> On 4/13/20 2:21 AM, Pavel Begunkov wrote:
>>>>> On 4/12/2020 6:14 PM, Hrvoje Zeba wrote:
>>>>>> On Sun, Apr 12, 2020 at 5:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>>>
>>>>>>> On 4/12/2020 5:07 AM, Jens Axboe wrote:
>>>>>>>> On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> I've been looking at timeouts and found a case I can't wrap my head around.
>>>>>>>>>
>>>>>>>>> Basically, If you submit OPs in a certain order, timeout fires before
>>>>>>>>> time elapses where I wouldn't expect it to. The order is as follows:
>>>>>>>>>
>>>>>>>>> poll(listen_socket, POLLIN) <- this never fires
>>>>>>>>> nop(async)
>>>>>>>>> timeout(1s, count=X)
>>>>>>>>>
>>>>>>>>> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
>>>>>>>>> not fire (at least not immediately). This is expected apart from maybe
>>>>>>>>> setting X=1 which would potentially allow the timeout to fire if nop
>>>>>>>>> executes after the timeout is setup.
>>>>>>>>>
>>>>>>>>> If you set it to 0xffffffff, it will always fire (at least on my
>>>>>>>>> machine). Test program I'm using is attached.
>>>>>>>>>
>>>>>>>>> The funny thing is that, if you remove the poll, timeout will not fire.
>>>>>>>>>
>>>>>>>>> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
>>>>>>>>>
>>>>>>>>> Could anybody shine a bit of light here?
>>>>>>>>
>>>>>>>> Thinking about this, I think the mistake here is using the SQ side for
>>>>>>>> the timeouts. Let's say you queue up N requests that are waiting, like
>>>>>>>> the poll. Then you arm a timeout, it'll now be at N + count before it
>>>>>>>> fires. We really should be using the CQ side for the timeouts.
>>>>>>>
>>>>>>> As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
>>>>>>> __immediately__ (i.e. not waiting 1s).
>>>>>>
>>>>>> Correct.
>>>>>>
>>>>>>> And still, the described behaviour is out of the definition. It's sounds
>>>>>>> like int overflow. Ok, I'll debug it, rest assured. I already see a
>>>>>>> couple of flaws anyway.
>>>>>>
>>>>>> For this particular case,
>>>>>>
>>>>>> req->sequence = ctx->cached_sq_head + count - 1;
>>>>>>
>>>>>> ends up being 1 which triggers in __req_need_defer() for nop sq.
>>>>>
>>>>> Right, that's it. The timeout's seq counter wraps around and triggers on
>>>>> previously submitted but still inflight requests.
>>>>>
>>>>> Jens, could you remind, do we limit number of inflight requests? We
>>>>> discussed it before, but can't find the thread. If we don't, vile stuff
>>>>> can happen with sequences.
>>>>
>>>> We don't.
>>>
>>> I was too quick to judge, there won't be anything too bad, and only if we throw
>>> 2^32 requests (~1TB).
>>>
>>> For the issue at hand, how about limiting timeouts' sqe->off by 2^31? This will
>>> solve the issue for now, and I can't imagine anyone waiting for over one billion
>>> requests to pass.
>>
>> I'm fine with that, but how do we handle someone asking for > INT_MAX?
> 
>> INT_MAX is allowed, but I want to return -EINVAL instead.
> If you mean UINT_MAX, then sqe->off is u32, so can't happen.

No, I mean count > INT_MAX, what you're suggesting we just don't support.
If there are apps right now using that, how do we handle it?

-- 
Jens Axboe

