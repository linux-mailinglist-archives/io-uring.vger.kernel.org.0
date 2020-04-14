Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A61A703A
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 02:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390556AbgDNAoy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 20:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390520AbgDNAoy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 20:44:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9653C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 17:44:52 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n24so1298993plp.13
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 17:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3oXC9kXqXsZPBSpX65mdWC7irYbI7v4NdwyrsnVkhsE=;
        b=WbTOxIojCKQQaxNixKOfY13BzNTKrPE0AGfkGZvIFuZfuAi87AtnOTBlkio8soc1Nm
         q38/ggPF/VhZ579ViSugRnBWGb5f8qRi0JOhE82vkeNdhvCjZPysMYJhjlVOMILIVslt
         hSLCTDvhIDhEv5+1uczmRRtHWUED3UPRN1jom73MwQIbhd190Ac7aYTg2luvT9urqLoE
         8J/D4UqYxihR/McZIqQJDMhW/FNBKlUCbV9XJROcx8AEmDwbJUiaoVrZiIzKVjOajkt6
         G0hSEkpsyUNSAZ1LJXXWvu0hFasNpsrPiw34ds/+ZmP/uyV7yvy2aJl09z3AgBqViQ7z
         TN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3oXC9kXqXsZPBSpX65mdWC7irYbI7v4NdwyrsnVkhsE=;
        b=ZubQDuxbk0iwZToskIZo2PT0er+p1BejNziNOMO96gavpLdDsMqkiK7ISVzpykOxyK
         p9/9RkjlAo1GYC/U4ugMljAp5iP3zbg13zsnDCxl5Mtug1Q0rhcWI22CyFQed/oVThC1
         0mEIDAqt2/UGe84zulBHh89WPl4SF+R22S5R+Qe7N09+olQ5MjNctfTrJbdER7Ddji9z
         RMKR5MkK0HPkLet/FLVF8E8Bq0LRmI2MirzXkbq5sfkKlEsUIhRj6z5Nll74L0hvz+R9
         ZO9IO+U6tInV7QOs/lk3pc08tyagFujjHLaZl/73x4p3AB+5iwpItQaOE8Mm8hNmHtXO
         CMbg==
X-Gm-Message-State: AGi0PuYaAqxsaOxtiixew7NuWgR/Yb4Ra8ZLo8/R/B0W665DuRDmiNpQ
        V6RolU2Q8DyApcLrxERWWDwaJQ==
X-Google-Smtp-Source: APiQypJtURuGW/leJ1HivG8bV7vBcgI5tQpiinqszmAZxHjfOgvHVEErFZaf5Upt3i5oLMHu6cCGmA==
X-Received: by 2002:a17:902:a713:: with SMTP id w19mr8761219plq.197.1586825091939;
        Mon, 13 Apr 2020 17:44:51 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i16sm9652482pfq.165.2020.04.13.17.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 17:44:50 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c3055911-599f-0776-d0f8-6f8872df75e2@kernel.dk>
Date:   Mon, 13 Apr 2020 18:44:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6835cec5-c8a5-dc49-c4e3-0df276c8537a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/20 1:09 PM, Pavel Begunkov wrote:
> On 13/04/2020 17:16, Jens Axboe wrote:
>> On 4/13/20 2:21 AM, Pavel Begunkov wrote:
>>> On 4/12/2020 6:14 PM, Hrvoje Zeba wrote:
>>>> On Sun, Apr 12, 2020 at 5:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>
>>>>> On 4/12/2020 5:07 AM, Jens Axboe wrote:
>>>>>> On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I've been looking at timeouts and found a case I can't wrap my head around.
>>>>>>>
>>>>>>> Basically, If you submit OPs in a certain order, timeout fires before
>>>>>>> time elapses where I wouldn't expect it to. The order is as follows:
>>>>>>>
>>>>>>> poll(listen_socket, POLLIN) <- this never fires
>>>>>>> nop(async)
>>>>>>> timeout(1s, count=X)
>>>>>>>
>>>>>>> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
>>>>>>> not fire (at least not immediately). This is expected apart from maybe
>>>>>>> setting X=1 which would potentially allow the timeout to fire if nop
>>>>>>> executes after the timeout is setup.
>>>>>>>
>>>>>>> If you set it to 0xffffffff, it will always fire (at least on my
>>>>>>> machine). Test program I'm using is attached.
>>>>>>>
>>>>>>> The funny thing is that, if you remove the poll, timeout will not fire.
>>>>>>>
>>>>>>> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
>>>>>>>
>>>>>>> Could anybody shine a bit of light here?
>>>>>>
>>>>>> Thinking about this, I think the mistake here is using the SQ side for
>>>>>> the timeouts. Let's say you queue up N requests that are waiting, like
>>>>>> the poll. Then you arm a timeout, it'll now be at N + count before it
>>>>>> fires. We really should be using the CQ side for the timeouts.
>>>>>
>>>>> As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
>>>>> __immediately__ (i.e. not waiting 1s).
>>>>
>>>> Correct.
>>>>
>>>>> And still, the described behaviour is out of the definition. It's sounds
>>>>> like int overflow. Ok, I'll debug it, rest assured. I already see a
>>>>> couple of flaws anyway.
>>>>
>>>> For this particular case,
>>>>
>>>> req->sequence = ctx->cached_sq_head + count - 1;
>>>>
>>>> ends up being 1 which triggers in __req_need_defer() for nop sq.
>>>
>>> Right, that's it. The timeout's seq counter wraps around and triggers on
>>> previously submitted but still inflight requests.
>>>
>>> Jens, could you remind, do we limit number of inflight requests? We
>>> discussed it before, but can't find the thread. If we don't, vile stuff
>>> can happen with sequences.
>>
>> We don't.
> 
> I was too quick to judge, there won't be anything too bad, and only if we throw
> 2^32 requests (~1TB).
> 
> For the issue at hand, how about limiting timeouts' sqe->off by 2^31? This will
> solve the issue for now, and I can't imagine anyone waiting for over one billion
> requests to pass.

I'm fine with that, but how do we handle someone asking for > INT_MAX?

-- 
Jens Axboe

