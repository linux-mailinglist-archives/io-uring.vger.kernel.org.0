Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17D31A6420
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 10:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgDMIVa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 04:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgDMIV2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 04:21:28 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59121C014CDB
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 01:21:28 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id q17so4314424ljm.6
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 01:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hZATgtvNBOZV97pHb4X/EVKI1mtumINzVUfPmpkdFNo=;
        b=sFIC2VBT76+XJFq2uQ7RS8TSTYDf/6+cU225fP71Fv0PQMBgk7/7dMUaIw16uXoa1q
         cCp8GEPz4k1IdPciVdah/3+T+nb50AEBzpdRXWVmI0rYhegnM5NVfdAj3Ng51SKDy9nd
         SD6i9A+0md+V8v3YSaicjJ9gzemhf4rc6LRjBVshg13xe+Ac0JVTjFpVaI+huFbETGxd
         kAqXQ4gcMynlI20wITzi/r3X7o5y/NCVhgbLrZQ8iMTpvjCwGDgTpYOq4CU9IlWAa4Hw
         0PYD9HG7Me7mWw5ADu+0DkJQANTrVWQT1209nVjkJkNS6BHXQ6Cfdi3UHuZXzYpL4V3K
         +X9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hZATgtvNBOZV97pHb4X/EVKI1mtumINzVUfPmpkdFNo=;
        b=egk3TaJvc+zuMOQPQM/zWSQf/H6D8jQMFou2l7aaxy2M9s2fENmSykLjKTwFJwqfyb
         s9X5C7QSSgylsdHzFL0/NK+S7r2a29JPN2JIdL0MrRhaq10S5N7X5zAVt4Ljxepz+fBW
         Xt7Cte/MeV+wsBRe+oo3HbnOtxCDH4ijWD0ahRUzjcg0RRAicsj179xAOMFlT/Jqnq/F
         Z9gvNyqAbGbKC44v/mAglODBzvRoFdYKMtSCuNddIQ30Vj8JbnoXBQ/m6318M5L/Zz0x
         4iq9Pn3Kl5o+8t+DTHx7dhuAVhdJhyl/oYUpifjErK+/0gIPlx86tLsMBJzGEGD2gz7W
         CKZA==
X-Gm-Message-State: AGi0PuaUNo+diD6l9sZKTDlxLSgQgEqbRMErcYzYF2NlInmJPmWV+IrZ
        7Y/2sB6/GzJQDS2rDfp+OUI=
X-Google-Smtp-Source: APiQypIoPEaIRmGyJjsR8KKQTvaklQRs9MgXoH/asOsKdaMgMAZChX/H8fhoHaLsakkaG2mdA7FnvA==
X-Received: by 2002:a2e:8085:: with SMTP id i5mr3072071ljg.74.1586766086745;
        Mon, 13 Apr 2020 01:21:26 -0700 (PDT)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id y22sm3787555lfg.92.2020.04.13.01.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 01:21:26 -0700 (PDT)
Subject: Re: Odd timeout behavior
To:     Hrvoje Zeba <zeba.hrvoje@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        "zhangyi (F)" <yi.zhang@huawei.com>
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
 <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
 <CAEsUgYiwyjpbaUbHwbx9pHD6x5DBpDop_Z4w9_QXKDd=FdjDjw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b551c2e1-b39a-efbf-24f1-4115275b7db2@gmail.com>
Date:   Mon, 13 Apr 2020 11:21:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAEsUgYiwyjpbaUbHwbx9pHD6x5DBpDop_Z4w9_QXKDd=FdjDjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/2020 6:14 PM, Hrvoje Zeba wrote:
> On Sun, Apr 12, 2020 at 5:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 4/12/2020 5:07 AM, Jens Axboe wrote:
>>> On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
>>>> Hi,
>>>>
>>>> I've been looking at timeouts and found a case I can't wrap my head around.
>>>>
>>>> Basically, If you submit OPs in a certain order, timeout fires before
>>>> time elapses where I wouldn't expect it to. The order is as follows:
>>>>
>>>> poll(listen_socket, POLLIN) <- this never fires
>>>> nop(async)
>>>> timeout(1s, count=X)
>>>>
>>>> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
>>>> not fire (at least not immediately). This is expected apart from maybe
>>>> setting X=1 which would potentially allow the timeout to fire if nop
>>>> executes after the timeout is setup.
>>>>
>>>> If you set it to 0xffffffff, it will always fire (at least on my
>>>> machine). Test program I'm using is attached.
>>>>
>>>> The funny thing is that, if you remove the poll, timeout will not fire.
>>>>
>>>> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
>>>>
>>>> Could anybody shine a bit of light here?
>>>
>>> Thinking about this, I think the mistake here is using the SQ side for
>>> the timeouts. Let's say you queue up N requests that are waiting, like
>>> the poll. Then you arm a timeout, it'll now be at N + count before it
>>> fires. We really should be using the CQ side for the timeouts.
>>
>> As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
>> __immediately__ (i.e. not waiting 1s).
> 
> Correct.
> 
>> And still, the described behaviour is out of the definition. It's sounds
>> like int overflow. Ok, I'll debug it, rest assured. I already see a
>> couple of flaws anyway.
> 
> For this particular case,
> 
> req->sequence = ctx->cached_sq_head + count - 1;
> 
> ends up being 1 which triggers in __req_need_defer() for nop sq.

Right, that's it. The timeout's seq counter wraps around and triggers on
previously submitted but still inflight requests.

Jens, could you remind, do we limit number of inflight requests? We
discussed it before, but can't find the thread. If we don't, vile stuff
can happen with sequences.

-- 
Pavel Begunkov
