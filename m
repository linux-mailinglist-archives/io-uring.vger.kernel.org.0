Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C061A5F10
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 16:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgDLOkR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 10:40:17 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:42490 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgDLOkR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 10:40:17 -0400
Received: by mail-pl1-f178.google.com with SMTP id v2so2520055plp.9
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 07:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tz/jny7Ip7OhDAryrKrEsZIBGKHG/Pn3f5+/jQOeisg=;
        b=dLaBsoRi9p6BfKd6ifvCa+VM0PBjIb1fICGGXjTGXzgO1edk5z0zc4+CbzDg4+5OjJ
         VVH23sZMA9XX/LN8x0MfiwY9F12mI50HuZXkJGLoXdtNevhYn55HGdYZ/IE2aHTkm+ns
         VfwFnW6m5VssfdtWriEvSCJFiFNUlzq0spgIvU8oT+/x/KHZYpTnupWz6cdKNbD8kfCG
         s/5gdIxK5UmrIJEmMhfzbJJszq3LmSCvdE5FdE63odlLWa9cpkgXkByCeSNP1DMjqKcj
         VOBe+27Mm/6t4Jh0Wq8zwV48LLrVqr0U7Fx0lsFDC59HwN9wICylgOBUxVVO3DWdnfW2
         IHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tz/jny7Ip7OhDAryrKrEsZIBGKHG/Pn3f5+/jQOeisg=;
        b=ECndy1e9fq/2Rn2qPRVyYBK1lQgAFas3cXNhi4WKUyR4PjppEaEYjzICkJs46qmhg0
         F9wYLSpY/+P1GSduC7VIjI/660VbA9VTunnmExgvUwC2O2/lN90DPSgXnmgICSIK1hKc
         Rs0ktDiFo9LtGRYm+OytaQmziUfkhtTBmbldD9cyNjAMTe3xZoeU8DcL6szhTR8r++Rw
         +zyxVkWx2Wzp6Kw5mRu0FsM/6K6CkuzsG2nW95aRQH0JF/9uSzgEu8sD0L4iFcfifN1S
         2vGv06ZvWAbH/3YsXOQ1BRQ+ACl+AArbI/LFGqRzN47gSmCo2UY7CJC3qSbyCm/eOr11
         CYCg==
X-Gm-Message-State: AGi0PuYQBSAftOBLu1y5NY/VTOx67I+58u/1W6Hmw3ZJvAcnLQQbM6lp
        l32w4vbov5TrswEIMyr5J77NAg==
X-Google-Smtp-Source: APiQypIWmaoX1VlVv7ZpYUStiEMHlq7Ln/5dLWaH7q/LJNlnOCfynW47f08+xrlh/K9/9XkMP4mZ4w==
X-Received: by 2002:a17:902:b409:: with SMTP id x9mr13822210plr.125.1586702416270;
        Sun, 12 Apr 2020 07:40:16 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d17sm5801022pgk.5.2020.04.12.07.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 07:40:15 -0700 (PDT)
Subject: Re: Odd timeout behavior
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hrvoje Zeba <zeba.hrvoje@gmail.com>, io-uring@vger.kernel.org,
        "zhangyi (F)" <yi.zhang@huawei.com>
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk>
 <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <969e4361-aae9-f713-c3b6-c79107352871@kernel.dk>
Date:   Sun, 12 Apr 2020 08:40:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/20 3:15 AM, Pavel Begunkov wrote:
> On 4/12/2020 5:07 AM, Jens Axboe wrote:
>> On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
>>> Hi,
>>>
>>> I've been looking at timeouts and found a case I can't wrap my head around.
>>>
>>> Basically, If you submit OPs in a certain order, timeout fires before
>>> time elapses where I wouldn't expect it to. The order is as follows:
>>>
>>> poll(listen_socket, POLLIN) <- this never fires
>>> nop(async)
>>> timeout(1s, count=X)
>>>
>>> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
>>> not fire (at least not immediately). This is expected apart from maybe
>>> setting X=1 which would potentially allow the timeout to fire if nop
>>> executes after the timeout is setup.
>>>
>>> If you set it to 0xffffffff, it will always fire (at least on my
>>> machine). Test program I'm using is attached.
>>>
>>> The funny thing is that, if you remove the poll, timeout will not fire.
>>>
>>> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
>>>
>>> Could anybody shine a bit of light here?
>>
>> Thinking about this, I think the mistake here is using the SQ side for
>> the timeouts. Let's say you queue up N requests that are waiting, like
>> the poll. Then you arm a timeout, it'll now be at N + count before it
>> fires. We really should be using the CQ side for the timeouts.
> 
> As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
> __immediately__ (i.e. not waiting 1s). Currently, it should work more
> like "fire after N events *submitted after the timeout* completed", so
> SQ vs CQ is another topic, but IMHO is not related.
> 
> And still, the described behaviour is out of the definition. It's sounds
> like int overflow. Ok, I'll debug it, rest assured. I already see a
> couple of flaws anyway.

Yeah agree it's two separate issues, the -1U must be a simple overflow.
So probably not that tricky to fix. 

Reason I bring up the other part is that Hrvoje's test case had other
cases as well, and the SQ vs CQ trigger is worth looking into. For
example, if we do:

enqueue N polls
enqueue timeout, count == 2, t = 10s
enqueue 2 nops

I'd logically expect the timeout to trigger when nop #2 is completed.
But it won't be, because we still have N polls waiting. What the count
== 2 is really saying (right now) is "trigger timeout when CQ passes SQ
by 2", which seems a bit odd.

-- 
Jens Axboe

