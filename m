Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651201A8502
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 18:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391720AbgDNQcN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 12:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391710AbgDNQcD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 12:32:03 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09F4C061A0C
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2020 09:32:03 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u13so14612233wrp.3
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2020 09:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sgtOMqTo5JNQMDKzJ289pbpTTtR6PBUeVMRoZdFxRYU=;
        b=vCOc7Em9GX0eerU1lwDeyBhTBsgtBT2DHGb0jGZiJB7XfkrqoOECNGFk4rfdcc5LBJ
         U/zY+y6QXOVSB8hUVpdVi+JFmMEtaoFyd+6qfaHdBUtWOjYM3sjQOQnV8McZqO9PGASw
         ertDL75YW2rg69qkvNSdIqErykKD3tS67uFlgP9cIrq0LU7MMzhOfN5t3vKMRMQN2tVe
         ZMtVBNc9KOx666X74gLN26X+74Zkf4VXOHRY1z7HBHC0CanLEy0Z+kjLthnqAnr2nJF5
         suODtdaMkjfGsl+SJpGBrT8jhhbDjV8mbwBbvyKccOpb0oVmtfFThbUt52makz2FZ3gs
         wiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sgtOMqTo5JNQMDKzJ289pbpTTtR6PBUeVMRoZdFxRYU=;
        b=HrCXjp5d/HGSAiwXfqet46dl+CFtCqsS41A7iTgpJA3eH1reVtHee9GxFEqiCSbh0d
         uGl5e7UD7vTpNtPbhGPuuVhVUlHh1LAxSoEhEncGt9gxmyN8lAmXvtX/TzaJhwJ713Yu
         w8UEGZrwtDEm40JHT9GuNqJnTjJDOlSA24gZ5/Q1/wzgPJMUtKIuE62ZHVfHVx2ezY6v
         4z9xT/s1VpevF5iymlOeImmYF8jIz41FNzqwzQyWMSVcrTvpLQNsrwO9vvKQq0kP0SlY
         umkl5KNS+JMgJVPq/KcfyMGtmMWHNBf03gajMux70ZPrVCM5gPv3YN+6i0rfLDj0+fpi
         815A==
X-Gm-Message-State: AGi0PuYj0XNd/FP4s5G5QjLq57hio8XpcogiNlTowBUasmJ14UekINs7
        dNv73WsUZjp1oisrjQhilEY=
X-Google-Smtp-Source: APiQypK+e0AIzvL7qcPsS1vJeXOjl9AHX/pbsHM8Vd2Ala5LoQoNfOKwBGVfGIp8LTSL9MW4lJZLZQ==
X-Received: by 2002:adf:efc2:: with SMTP id i2mr24123779wrp.420.1586881922244;
        Tue, 14 Apr 2020 09:32:02 -0700 (PDT)
Received: from [192.168.43.192] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id v7sm19895705wrs.96.2020.04.14.09.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 09:32:01 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Hrvoje Zeba <zeba.hrvoje@gmail.com>
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
 <2eba8624-b487-cc5a-61d0-9c046ad88eec@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Odd timeout behavior
Message-ID: <f27a79b0-75d3-9c18-1d60-0f1e1a9cfa65@gmail.com>
Date:   Tue, 14 Apr 2020 19:31:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2eba8624-b487-cc5a-61d0-9c046ad88eec@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/04/2020 19:04, Jens Axboe wrote:
> On 4/14/20 9:46 AM, Pavel Begunkov wrote:
>> On 14/04/2020 03:44, Jens Axboe wrote:
>>> On 4/13/20 1:09 PM, Pavel Begunkov wrote:
>>>> On 13/04/2020 17:16, Jens Axboe wrote:
>>>>> On 4/13/20 2:21 AM, Pavel Begunkov wrote:
>>>>>> On 4/12/2020 6:14 PM, Hrvoje Zeba wrote:
>>>>>>> On Sun, Apr 12, 2020 at 5:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>>>>
>>>>>>>> On 4/12/2020 5:07 AM, Jens Axboe wrote:
>>>>>>>>> On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> I've been looking at timeouts and found a case I can't wrap my head around.
>>>>>>>>>>
>>>>>>>>>> Basically, If you submit OPs in a certain order, timeout fires before
>>>>>>>>>> time elapses where I wouldn't expect it to. The order is as follows:
>>>>>>>>>>
>>>>>>>>>> poll(listen_socket, POLLIN) <- this never fires
>>>>>>>>>> nop(async)
>>>>>>>>>> timeout(1s, count=X)
>>>>>>>>>>
>>>>>>>>>> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
>>>>>>>>>> not fire (at least not immediately). This is expected apart from maybe
>>>>>>>>>> setting X=1 which would potentially allow the timeout to fire if nop
>>>>>>>>>> executes after the timeout is setup.
>>>>>>>>>>
>>>>>>>>>> If you set it to 0xffffffff, it will always fire (at least on my
>>>>>>>>>> machine). Test program I'm using is attached.
>>>>>>>>>>
>>>>>>>>>> The funny thing is that, if you remove the poll, timeout will not fire.
>>>>>>>>>>
>>>>>>>>>> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
>>>>>>>>>>
>>>>>>>>>> Could anybody shine a bit of light here?
>>>>>>>>>
>>>>>>>>> Thinking about this, I think the mistake here is using the SQ side for
>>>>>>>>> the timeouts. Let's say you queue up N requests that are waiting, like
>>>>>>>>> the poll. Then you arm a timeout, it'll now be at N + count before it
>>>>>>>>> fires. We really should be using the CQ side for the timeouts.
>>>>>>>>
>>>>>>>> As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
>>>>>>>> __immediately__ (i.e. not waiting 1s).
>>>>>>>
>>>>>>> Correct.
>>>>>>>
>>>>>>>> And still, the described behaviour is out of the definition. It's sounds
>>>>>>>> like int overflow. Ok, I'll debug it, rest assured. I already see a
>>>>>>>> couple of flaws anyway.
>>>>>>>
>>>>>>> For this particular case,
>>>>>>>
>>>>>>> req->sequence = ctx->cached_sq_head + count - 1;
>>>>>>>
>>>>>>> ends up being 1 which triggers in __req_need_defer() for nop sq.
>>>>>>
>>>>>> Right, that's it. The timeout's seq counter wraps around and triggers on
>>>>>> previously submitted but still inflight requests.
>>>>>>
>>>>>> Jens, could you remind, do we limit number of inflight requests? We
>>>>>> discussed it before, but can't find the thread. If we don't, vile stuff
>>>>>> can happen with sequences.
>>>>>
>>>>> We don't.
>>>>
>>>> I was too quick to judge, there won't be anything too bad, and only if we throw
>>>> 2^32 requests (~1TB).
>>>>
>>>> For the issue at hand, how about limiting timeouts' sqe->off by 2^31? This will
>>>> solve the issue for now, and I can't imagine anyone waiting for over one billion
>>>> requests to pass.
>>>
>>> I'm fine with that, but how do we handle someone asking for > INT_MAX?
>>
>>> INT_MAX is allowed, but I want to return -EINVAL instead.
>> If you mean UINT_MAX, then sqe->off is u32, so can't happen.
> 
> No, I mean count > INT_MAX, what you're suggesting we just don't support.

Got it. That's what my question was about.

> If there are apps right now using that, how do we handle it?

1. if # of inflight requests is limited (empirically/naturally or not), then we
can extend req->seq to >= 33 bits (leaving sqe->off u32), and it'll just work.

e.g. if req->seq is u64, then we need 2^64 - 2^32 inflight requests to hit the
issue. And I don't expect anybody creating requests worth of 1ZB (2^30 TB).

2. or to think about something

I'll send 1., and then out of curiosity give a thought to 2.

-- 
Pavel Begunkov
