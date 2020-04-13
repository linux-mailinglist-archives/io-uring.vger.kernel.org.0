Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928241A6C5A
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 21:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbgDMTK7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 15:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387811AbgDMTK6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 15:10:58 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DC9C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 12:10:56 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h9so11317842wrc.8
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 12:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iJHBBht6J8Nhx+dHs06dLkqg9+W1dZmmNUeIXDHGJcU=;
        b=sDPDxrU4INr09MaYuP/K5lS1qXqIcVzmOn1osTrcOEELcz57i9wZskfAfKTR1tP8oU
         28kZCkT4kAzbpYi2iSi+i0Fhu2jbFEowivA5337YI05wscr+JeAlugaPcEekcT3ubACu
         /yPT2M6wMKW5U8pUUvIfz1qQSJiLDyqiJs/i2rqxDA6cyIOvK+dgZbVGDwOgXCgmPUGv
         LrmkfXmwV1HXJRv2QIdSu7qvLSOvMJ+XCsbLJkJR4PFh4C6wyoN6wJ7tu56IgDvKlpBL
         HseY3tYZLO7HBdI6wBGiHifMdE5O+YSmaCrDbDBkuKlabuOyIUDhALbCUnVDIVOXzUgZ
         6Ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iJHBBht6J8Nhx+dHs06dLkqg9+W1dZmmNUeIXDHGJcU=;
        b=FPiY1bpnRF7ko4cAIvTNI68I1Ho2FulpoyK8qcKcqTEnpgyjYZw1vjqY83r4QHvi5Y
         MmXcPXgDAJThdSE3/7RxY1apEnvsPJ3X2rP0BUrliJhvpx5BqoI8MG6gvtPfGIf2wsKW
         b6es5nNq1h2+xm5XVAqLLIIXOt8w/woU13x07kEa6nC0vRToJbWI7KPHrlkuk5PrIuNt
         fM/fVFr0fVxlR70D59WaP1XKDc899YU7VlULXx35wEzZ76CWXtUR833aN3dinMoDClc5
         1qJJ57CnPvhjV9idQ7tfk/ZJ98JDn9IivkAExnvjCBK339iFKy1UXb25H2BF0aOtwyqd
         HjyA==
X-Gm-Message-State: AGi0PuaH4ZWZMwrt8TG9pNq303NJ0Ov8Nt32b1vZl7BThBGbqDe6J8W3
        /qWk3BNomtCcIAwYI4R2GQ0=
X-Google-Smtp-Source: APiQypK/3YOhZtK1iCf2HbOKdBiKTmCgEKIYqeusLrATIM24B6KLokbpevMo+krcS5CwidnvPOjOMg==
X-Received: by 2002:adf:aade:: with SMTP id i30mr19786163wrc.336.1586805055345;
        Mon, 13 Apr 2020 12:10:55 -0700 (PDT)
Received: from [192.168.43.75] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id s9sm3351490wrg.27.2020.04.13.12.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 12:10:54 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Hrvoje Zeba <zeba.hrvoje@gmail.com>
Cc:     io-uring@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
 <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
 <CAEsUgYiwyjpbaUbHwbx9pHD6x5DBpDop_Z4w9_QXKDd=FdjDjw@mail.gmail.com>
 <b551c2e1-b39a-efbf-24f1-4115275b7db2@gmail.com>
 <0df2f436-0968-c708-84e2-da0c3daa265c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Odd timeout behavior
Message-ID: <6835cec5-c8a5-dc49-c4e3-0df276c8537a@gmail.com>
Date:   Mon, 13 Apr 2020 22:09:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0df2f436-0968-c708-84e2-da0c3daa265c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/04/2020 17:16, Jens Axboe wrote:
> On 4/13/20 2:21 AM, Pavel Begunkov wrote:
>> On 4/12/2020 6:14 PM, Hrvoje Zeba wrote:
>>> On Sun, Apr 12, 2020 at 5:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 4/12/2020 5:07 AM, Jens Axboe wrote:
>>>>> On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I've been looking at timeouts and found a case I can't wrap my head around.
>>>>>>
>>>>>> Basically, If you submit OPs in a certain order, timeout fires before
>>>>>> time elapses where I wouldn't expect it to. The order is as follows:
>>>>>>
>>>>>> poll(listen_socket, POLLIN) <- this never fires
>>>>>> nop(async)
>>>>>> timeout(1s, count=X)
>>>>>>
>>>>>> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
>>>>>> not fire (at least not immediately). This is expected apart from maybe
>>>>>> setting X=1 which would potentially allow the timeout to fire if nop
>>>>>> executes after the timeout is setup.
>>>>>>
>>>>>> If you set it to 0xffffffff, it will always fire (at least on my
>>>>>> machine). Test program I'm using is attached.
>>>>>>
>>>>>> The funny thing is that, if you remove the poll, timeout will not fire.
>>>>>>
>>>>>> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
>>>>>>
>>>>>> Could anybody shine a bit of light here?
>>>>>
>>>>> Thinking about this, I think the mistake here is using the SQ side for
>>>>> the timeouts. Let's say you queue up N requests that are waiting, like
>>>>> the poll. Then you arm a timeout, it'll now be at N + count before it
>>>>> fires. We really should be using the CQ side for the timeouts.
>>>>
>>>> As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
>>>> __immediately__ (i.e. not waiting 1s).
>>>
>>> Correct.
>>>
>>>> And still, the described behaviour is out of the definition. It's sounds
>>>> like int overflow. Ok, I'll debug it, rest assured. I already see a
>>>> couple of flaws anyway.
>>>
>>> For this particular case,
>>>
>>> req->sequence = ctx->cached_sq_head + count - 1;
>>>
>>> ends up being 1 which triggers in __req_need_defer() for nop sq.
>>
>> Right, that's it. The timeout's seq counter wraps around and triggers on
>> previously submitted but still inflight requests.
>>
>> Jens, could you remind, do we limit number of inflight requests? We
>> discussed it before, but can't find the thread. If we don't, vile stuff
>> can happen with sequences.
> 
> We don't.

I was too quick to judge, there won't be anything too bad, and only if we throw
2^32 requests (~1TB).

For the issue at hand, how about limiting timeouts' sqe->off by 2^31? This will
solve the issue for now, and I can't imagine anyone waiting for over one billion
requests to pass.

-- 
Pavel Begunkov
