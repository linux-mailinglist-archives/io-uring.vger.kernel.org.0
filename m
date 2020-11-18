Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B952B80B9
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 16:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgKRPjF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 10:39:05 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33967 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726457AbgKRPjF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 10:39:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UFolQW._1605713893;
Received: from 192.168.124.15(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UFolQW._1605713893)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Nov 2020 23:38:13 +0800
Subject: Re: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for
 registered files in IOPOLL mode
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
 <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
 <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
 <9713dc32-8aea-5fd2-8195-45ceedcb74dd@kernel.dk>
 <82116595-2e57-525b-0619-2d71e874bd88@gmail.com>
 <148a36f1-ff60-4af6-7683-8849c9973010@kernel.dk>
 <f8e59ed9-4329-dada-cf16-329bdb7335be@gmail.com>
 <12c010e5-d298-c48a-1841-ff0da39e2306@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <2a1f4d77-87f4-fe50-b747-8f1be1945b55@linux.alibaba.com>
Date:   Wed, 18 Nov 2020 23:36:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <12c010e5-d298-c48a-1841-ff0da39e2306@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 11/18/20 6:59 AM, Pavel Begunkov wrote:
>> On 18/11/2020 01:42, Jens Axboe wrote:
>>> On 11/17/20 9:58 AM, Pavel Begunkov wrote:
>>>> On 17/11/2020 16:30, Jens Axboe wrote:
>>>>> On 11/17/20 3:43 AM, Pavel Begunkov wrote:
>>>>>> On 17/11/2020 06:17, Xiaoguang Wang wrote:
>>>>>>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>>>>>>> percpu_ref_put() for registered files, but it's hard to say they're very
>>>>>>> light-weight synchronization primitives. In one our x86 machine, I get below
>>>>>>> perf data(registered files enabled):
>>>>>>> Samples: 480K of event 'cycles', Event count (approx.): 298552867297
>>>>>>> Overhead  Comman  Shared Object     Symbol
>>>>>>>     0.45%  :53243  [kernel.vmlinux]  [k] io_file_get
>>>>>>
>>>>>> Do you have throughput/latency numbers? In my experience for polling for
>>>>>> such small overheads all CPU cycles you win earlier in the stack will be
>>>>>> just burned on polling, because it would still wait for the same fixed*
>>>>>> time for the next response by device. fixed* here means post-factum but
>>>>>> still mostly independent of how your host machine behaves.
>>>>>
>>>>> That's only true if you can max out the device with a single core.
>>>>> Freeing any cycles directly translate into a performance win otherwise,
>>>>> if your device isn't the bottleneck. For the high performance testing
>>>>
>>>> Agree, that's what happens if a host can't keep up with a device, or e.g.
>>>
>>> Right, and it's a direct measure of the efficiency. Moving cycles _to_
>>> polling is a good thing! It means that the rest of the stack got more
>>
>> Absolutely, but the patch makes code a bit more complex and adds some
>> overhead for non-iopoll path, definitely not huge, but the showed overhead
>> reduction (i.e. 0.20%) doesn't do much either. Comparing with left 0.25%
>> it costs just a couple of instructions.
>>
>> And that's why I wanted to see if there is any real visible impact.
> 
> Definitely, it's always a tradeoff between the size of the win and
> complexity and other factors. Especially adding to io_kiocb is a big
> negative in my book.
> 
>>> efficient. And if the device is fast enough, then that'll directly
>>> result in higher peak IOPS and lower latencies.
>>>
>>>> in case 2. of my other reply. Why don't you mention throwing many-cores
>>>> into a single many (poll) queue SSD?
>>>
>>> Not really relevant imho, you can obviously always increase performance
>>> if you are core limited by utilizing multiple cores.
>>>
>>> I haven't tested these patches yet, will try and see if I get some time
>>> to do so tomorrow.
>>
>> Great
> 
> Ran it through the polled testing which is core limited, and I didn't
> see any changes...
Jens and Pavel, sorry for the noise...
I also have some tests today, in upstream kernel, I also don't see any changes,
but in our internal 4.19 kernel, I got a steady about 1% iops improvement, and
our kernel don't include Ming Lei's patch "2b0d3d3e4fcf percpu_ref: reduce memory
footprint of percpu_ref in fast path".

Regards,
Xiaoguang Wang

> 
