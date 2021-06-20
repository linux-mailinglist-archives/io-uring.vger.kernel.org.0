Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC443AE07B
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 22:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFTU6P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 16:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhFTU6P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 16:58:15 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1636DC061574;
        Sun, 20 Jun 2021 13:56:02 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j1so43469wrn.9;
        Sun, 20 Jun 2021 13:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=shKC0p6Ek6zmQ/GH4KSg3z9ZXW8o7AGbCpX4k6kG53A=;
        b=ckzauND7zZ610SGhmBRRvFicfBpSIBkPLnoBM8bQ4Tc/8umnWjytYwlVy44jkXyEcy
         vWWfAvySwgszVzqRyaimyzDu1C2+3hk7pAy7qnJkDGUrK0JmhVwqplQatf7Fhzmamu8t
         vaVl5KbDrMDtUoMTIokoxZmDw8H0NqqlGBk9FGxzNFDwwZ8D7tSR+sRRm3qg6lSl2l4U
         DVEYkwPFBWBwjn0V+uCTO7XqFyyiaX8kgFiCQu+QlCxYgK2FrFSaDymByiALNK2fkTBr
         K0hGVYqbB66wo2CUDQR7fu0oujPeWistfk7VfTeDuFopaxuymgsuMOIwn4Re6jse0XFC
         u2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=shKC0p6Ek6zmQ/GH4KSg3z9ZXW8o7AGbCpX4k6kG53A=;
        b=bnW7n268SIO23TMXv61EQsWbOoz1mvJb/lGGGmV3LxvQTaKoclKk2JRBEhShCZQJZ6
         KB8JJDQizZqpcxb7/qLgV56+olwR6ij2krDqsZESoGyFZ549UzJgj/T23RDs8IGzbVvQ
         ITED7vxSkcaEGREUEVZqRMXD6UIE/q+3OAM+MUjR3TkdNex2eFK+UoLqR+Htshnv/JJG
         z5DTWr9epANAscitL44YQmYIN65U5s3cfuxSg0JDPXsSSvvUKOKgqje4L7lfYujsaFOh
         XP9lmvU+FoXB3wetRDLH/n6vBEEDll2HZGQXZnZYYjMacJageERq+zuMXPt08+oOFjaK
         yorQ==
X-Gm-Message-State: AOAM533b+nXKq8YrRV4SMzaSUyrsQOURKfRI55PKCD8ANZK/QXeldjd8
        SrDi8Opzzu34jPDhDQDHa+dU91iLo2FECg==
X-Google-Smtp-Source: ABdhPJwTldTeeZ8xPvlD/IrNrjPzvJ6cDYzJRlpJBSGiT9ZsZCf6CcvRTx/ScGBwMuFnHCDMVNz/+Q==
X-Received: by 2002:a5d:64c7:: with SMTP id f7mr24491370wri.36.1624222560516;
        Sun, 20 Jun 2021 13:56:00 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.72])
        by smtp.gmail.com with ESMTPSA id 4sm14850292wry.74.2021.06.20.13.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 13:56:00 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
 <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
 <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
 <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
 <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
 <a12e218a-518d-1dac-5e8c-d9784c9850b0@gmail.com>
 <b0a8c92cffb3dc1b48b081e5e19b016fee4c6511.camel@trillion01.com>
 <7d9a481b-ae8c-873e-5c61-ab0a57243905@gmail.com>
 <f511d34b1a1ae5f76c9c4ba1ab87bbf15046a588.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
Message-ID: <bc6d5e7b-fc63-827f-078b-b3423da0e5f7@gmail.com>
Date:   Sun, 20 Jun 2021 21:55:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f511d34b1a1ae5f76c9c4ba1ab87bbf15046a588.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/21 11:45 PM, Olivier Langlois wrote:
> On Thu, 2021-06-17 at 19:10 +0100, Pavel Begunkov wrote:
>>>
>>> For the patch performance testing I did use the simplest config:
>>> Single thread, 1 TCP connection, no sqpoll.
>>
>> Queue depth (QD) 1, right?
> 
> Since my io_uring usage is wrapped into a library and some parameters
> are fixed and adjusted to be able to handle the largest use-case
> scenario, QD was set to 256 for that test.
> 
> There is also few accessory fds such as 2 eventfd that are polled to
> interrupt the framework event loop but in practice they were silent
> during the whole testing period.
> 
> but no big batch submission for sure. At most maybe 2 sqes per
> submission.
> 
> 1 to provide back the buffer and the other to reinsert the read
> operation.

I see

[...]
>> 2) Do they return equivalent number of bytes? And what the
>> read/recv size (e.g. buffer size)?
> 
> Nothing escape your eagle vision attention Pavel...

It all may sound over scrutinising, but I just used to analyse
performance magic and see how edges may be polished. Not
a requirement for the patch 

> I set my read size to an arbitrarilly big size (20KB) just to be sure
> that I should, most of the time, never end up with partial reads and
> perform more syscalls that I could get away with big enough buffer
> size.
> 
> TBH, I didn't pay that much attention to this detail. out of my head, I
> would say that the average size is all over the place. It can go from
> 150 Bytes up to 15KB but I would think that the average must be between
> 1-2 MTU (around 2500 bytes).
> 
> That being said, the average read size must spread equally to the
> packets going to the regular path vs those of take the new shortcut, so
> I believe that the conclusion should still hold despite not having
> considered this aspect in the test.
>>
>> Because in theory can be that during a somewhat small delay for
>> punting to io-wq, more data had arrived and so async completion
>> pulls more data that takes more time. In that case the time
>> difference should also account the difference in amount of
>> data that it reads.
> 
> Good point. This did not even occur to me to consider this aspect but
> how many more packets would the network stack had the time to receive
> in an extra 16uSec period? (I am not on one of those crazy Fiber optic
> 200Gbps Mellanox card....) 1,2,3,4? We aren't talking multiple extra
> MBs to copy here...

Say 1-2. Need to check, but I think while processing them and
copying to the userspace there might arrive another one, and so
you have full 20KB instead of 4KB that would have been copied
inline. Plus io-wq overhead, 16us wouldn't be unreasonable then.

But that's "what if" thinking.

>>
>> 3) Curious, why read but not recv as you're working with sockets
> 
> I have learn network programming with the classic Stevens book. As far
> as I remember from what I have learned in the book, it is that the only
> benefit of recv() over read() is if you need to specify one of the
> funky flags that recv() allow you to provide to it, read() doesn't give
> access to that functionality.
> 
> If there is a performance benefit to use recv() over read() for tcp
> fds, that is something I am not aware of and if you confirm me that it
> is the case, that would be very easy for me to change my read calls for
> recv() ones...
> 
> Now that you ask the question, maybe read() is implemented with recv()

All sinks into the common code rather early

> but AFAIK, the native network functions are sendmsg and recvmsg so
> neither read() or recv() would have an edge over the other in that
> department, AFAIK...

For io_uring part, e.g. recv is slimmer than recvmsg, doesn't
need to copy extra.

Read can be more expensive on the io_uring side because it
may copy/alloc extra stuff. Plus additional logic on the
io_read() part for generality.

But don't expect it to be much of a difference, but never
tested.

> while we are talking about read() vs recv(), I am curious too about
> something, while working on my other patch (store back buffer in case
> of failure), I did notice that buffer address and bid weren't stored in
> the same fields.
> 
> io_put_recv_kbuf() vs io_put_rw_kbuf()
> 
> I didn't figure out why those values weren't stored in the same
> io_kiocb fields for recv operations...
> 
> Why is that?

Just because how it was done. May use cleaning up. e.g. I don't
like rewriting req->rw.addr with a selected buffer.

In general, the first 64B (cacheline) of io_kiocb (i.e. request)
is taken by per-opcode data, and we try to fit everything
related to a particular opcode there and not spill into
generic parts of the struct.

Another concern, in general, is not keeping everything tight
enough and shuffled right, so it doesn't read extra cachelines
in hot path.

>>
>> 4) Did you do any userspace measurements. And a question to
>> everyone in general, do we have any good net benchmarking tool
>> that works with io_uring? Like netperf? Hopefully spitting
>> out latency distribution.
> 
> No, I haven't.

With what was said, I'd expect ~same mean and elevated ~99%
reduced by the patch, which is also great. Latency is always
the hardest part.

>> Also, not particularly about reissue stuff, but a note to myself:
>> 59us is much, so I wonder where the overhead comes from.
>> Definitely not the iowq queueing (i.e. putting into a list).
>> - waking a worker?
>> - creating a new worker? Do we manage workers sanely? e.g.
>>   don't keep them constantly recreated and dying back.
>> - scheduling a worker?
> 
> creating a new worker is for sure not free but I would remove that
> cause from the suspect list as in my scenario, it was a one-shot event.

Not sure what you mean, but speculating, io-wq may have not
optimal policy for recycling worker threads leading to
recreating/removing more than needed. Depends on bugs, use
cases and so on.

> First measurement was even not significantly higher than all the other
> measurements.

You get a huge max for io-wq case. Obviously nothing can be
said just because of max. We'd need latency distribution
and probably longer runs, but I'm still curious where it's
coming from. Just keeping an eye in general

>>
>> Olivier, for how long did you run the test? >1 min?
> 
> much more than 1 minute. I would say something between 20-25 minutes.
> 
> I wanted a big enough sample size for those 2.5% special path events so
> that the conclusion could be statistically significant.

Great, if io-wq worker creation doesn't work right, then it's
because of policies and so on.

-- 
Pavel Begunkov
