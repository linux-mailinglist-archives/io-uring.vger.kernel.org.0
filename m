Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3B61A67B8
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 16:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgDMOQ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 10:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbgDMOQX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 10:16:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EB0C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 07:16:22 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e16so3578761pjp.1
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 07:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vk+KJlJ6AkRskY8Z0zULDWChyqQ0cPyeCcRAhqy43/I=;
        b=VvdCRW0DcLZmJwH5lAbI2TAPqZ6ep/HreTrcvuGPgvj3rYkG5RYwwiWEppPbnDSV1o
         JfvfX0gueHbJfHaYtEy0LFeMelyp4LrabraRXKyd0AY69IQVpMBVfENcmGcdq/GPPuF2
         PLdGxbsLVfv9mKcI3S/p0VH1tMk15tQYMbzYSxYURz/pRgWSUzPnmCinFBCDd35k1+k9
         A2P3Dtu01TQEf8p2+CCs4Uws+4qZNuhPDhlMEVRTtslIHXq+e1xcAFsEGfO4/W+/FMiT
         DM4KEBOlbpYq7GzAe41fOs8Yp85k7Xs9MuUlpKC2KhqFdOviHb4DnxW9iz7s6FbWZMJb
         TDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vk+KJlJ6AkRskY8Z0zULDWChyqQ0cPyeCcRAhqy43/I=;
        b=BKlzwSOLqYVOu/bjkJybtDNcWKoEhj9Y3G3gDfA2P4hXwpbowAikEfEbzHE05WGsLV
         RmT3VkCqQTYLyhwSH4eTA8twDIpB+y6XxoPi6b/ytClO51W9sy/9one7vPT1CXXQebBJ
         pxvlpjyzd/iH+7wL4OoxHHfV801KcNSwYNrxpDTKVMsfzStBh3M6Rno67K5K9RWsTVVu
         0YmPkzb7zZw/oif4ziR5JwRwKdmTVoA8SpyqkMRhxu03D+izgu78mVpgYWRdjUQieETt
         ULovYO2WdwWKNGjr3N8cqvZHAz174QkJEwbDuFjsoZ7GhWCpegi4Wii+HSnLPwA8fmnK
         8gmg==
X-Gm-Message-State: AGi0Pub83J9RjqWxqlmxznKZOdcDHyj4q5Sl3s0S9H2Prfh0ObZtxU7m
        So1bEaR9TC/1jAC7Z3GFbhwgug==
X-Google-Smtp-Source: APiQypKS4dbNAGhUMZAjM+JRrx0S8l0ixWYMMikPNGLedXkTyNv5nBO6hsDi3u2sX60CCJaysf6TwA==
X-Received: by 2002:a17:90a:c983:: with SMTP id w3mr22705310pjt.102.1586787381651;
        Mon, 13 Apr 2020 07:16:21 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id mq6sm9605510pjb.38.2020.04.13.07.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 07:16:19 -0700 (PDT)
Subject: Re: Odd timeout behavior
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hrvoje Zeba <zeba.hrvoje@gmail.com>
Cc:     io-uring@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
 <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
 <CAEsUgYiwyjpbaUbHwbx9pHD6x5DBpDop_Z4w9_QXKDd=FdjDjw@mail.gmail.com>
 <b551c2e1-b39a-efbf-24f1-4115275b7db2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0df2f436-0968-c708-84e2-da0c3daa265c@kernel.dk>
Date:   Mon, 13 Apr 2020 08:16:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b551c2e1-b39a-efbf-24f1-4115275b7db2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/20 2:21 AM, Pavel Begunkov wrote:
> On 4/12/2020 6:14 PM, Hrvoje Zeba wrote:
>> On Sun, Apr 12, 2020 at 5:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 4/12/2020 5:07 AM, Jens Axboe wrote:
>>>> On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
>>>>> Hi,
>>>>>
>>>>> I've been looking at timeouts and found a case I can't wrap my head around.
>>>>>
>>>>> Basically, If you submit OPs in a certain order, timeout fires before
>>>>> time elapses where I wouldn't expect it to. The order is as follows:
>>>>>
>>>>> poll(listen_socket, POLLIN) <- this never fires
>>>>> nop(async)
>>>>> timeout(1s, count=X)
>>>>>
>>>>> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
>>>>> not fire (at least not immediately). This is expected apart from maybe
>>>>> setting X=1 which would potentially allow the timeout to fire if nop
>>>>> executes after the timeout is setup.
>>>>>
>>>>> If you set it to 0xffffffff, it will always fire (at least on my
>>>>> machine). Test program I'm using is attached.
>>>>>
>>>>> The funny thing is that, if you remove the poll, timeout will not fire.
>>>>>
>>>>> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
>>>>>
>>>>> Could anybody shine a bit of light here?
>>>>
>>>> Thinking about this, I think the mistake here is using the SQ side for
>>>> the timeouts. Let's say you queue up N requests that are waiting, like
>>>> the poll. Then you arm a timeout, it'll now be at N + count before it
>>>> fires. We really should be using the CQ side for the timeouts.
>>>
>>> As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
>>> __immediately__ (i.e. not waiting 1s).
>>
>> Correct.
>>
>>> And still, the described behaviour is out of the definition. It's sounds
>>> like int overflow. Ok, I'll debug it, rest assured. I already see a
>>> couple of flaws anyway.
>>
>> For this particular case,
>>
>> req->sequence = ctx->cached_sq_head + count - 1;
>>
>> ends up being 1 which triggers in __req_need_defer() for nop sq.
> 
> Right, that's it. The timeout's seq counter wraps around and triggers on
> previously submitted but still inflight requests.
> 
> Jens, could you remind, do we limit number of inflight requests? We
> discussed it before, but can't find the thread. If we don't, vile stuff
> can happen with sequences.

We don't.

-- 
Jens Axboe

