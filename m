Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206365548B8
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 14:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357601AbiFVLwt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 07:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357602AbiFVLws (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 07:52:48 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309893D1D4
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 04:52:47 -0700 (PDT)
Message-ID: <57f5d153-c75c-0382-b65a-bcbc49d08f2c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655898765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eOanqE1DpetsQVoC6x/C1uZu22YR/IKrHblZpop/1oA=;
        b=UZyoUtJ5tnpOiVp40OWckXM/P2Hz4/qc0OXODPMKHFut1iqVARZa1gskvSdAYqCH0RDcDo
        b0RrIRvLUUieAnp0EQrsVNxph6CMyclDw6G6E1kMjgxwbsE6RFd9eiC1cs2XFU2BkSEZMY
        VZYjhDXhQ7INpBR0qmxfQuQS7qiCKHw=
Date:   Wed, 22 Jun 2022 19:52:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC for-next 0/8] io_uring: tw contention improvments
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>
References: <20220620161901.1181971-1-dylany@fb.com>
 <15e36a76-65d5-2acb-8cb7-3952d9d8f7d1@linux.dev>
 <f8c8e52996aaa8fb8c72ae46f0e87e733a9053aa.camel@fb.com>
 <1c29ad13-cc42-8bc5-0f12-3413054a4faf@linux.dev>
 <02e7f2adc191cd207eb17dd84efa10f86d965200.camel@fb.com>
 <e209418f-2023-d0df-da98-2102b5e533c7@linux.dev>
 <b9820bd1-0312-476f-13c1-9483d882e918@linux.dev>
In-Reply-To: <b9820bd1-0312-476f-13c1-9483d882e918@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/22 19:24, Hao Xu wrote:
> On 6/22/22 19:16, Hao Xu wrote:
>> On 6/22/22 17:31, Dylan Yudaken wrote:
>>> On Tue, 2022-06-21 at 15:34 +0800, Hao Xu wrote:
>>>> On 6/21/22 15:03, Dylan Yudaken wrote:
>>>>> On Tue, 2022-06-21 at 13:10 +0800, Hao Xu wrote:
>>>>>> On 6/21/22 00:18, Dylan Yudaken wrote:
>>>>>>> Task work currently uses a spin lock to guard task_list and
>>>>>>> task_running. Some use cases such as networking can trigger
>>>>>>> task_work_add
>>>>>>> from multiple threads all at once, which suffers from
>>>>>>> contention
>>>>>>> here.
>>>>>>>
>>>>>>> This can be changed to use a lockless list which seems to have
>>>>>>> better
>>>>>>> performance. Running the micro benchmark in [1] I see 20%
>>>>>>> improvment in
>>>>>>> multithreaded task work add. It required removing the priority
>>>>>>> tw
>>>>>>> list
>>>>>>> optimisation, however it isn't clear how important that
>>>>>>> optimisation is.
>>>>>>> Additionally it has fairly easy to break semantics.
>>>>>>>
>>>>>>> Patch 1-2 remove the priority tw list optimisation
>>>>>>> Patch 3-5 add lockless lists for task work
>>>>>>> Patch 6 fixes a bug I noticed in io_uring event tracing
>>>>>>> Patch 7-8 adds tracing for task_work_run
>>>>>>>
>>>>>>
>>>>>> Compared to the spinlock overhead, the prio task list
>>>>>> optimization is
>>>>>> definitely unimportant, so I agree with removing it here.
>>>>>> Replace the task list with llisy was something I considered but I
>>>>>> gave
>>>>>> it up since it changes the list to a stack which means we have to
>>>>>> handle
>>>>>> the tasks in a reverse order. This may affect the latency, do you
>>>>>> have
>>>>>> some numbers for it, like avg and 99% 95% lat?
>>>>>>
>>>>>
>>>>> Do you have an idea for how to test that? I used a microbenchmark
>>>>> as
>>>>> well as a network benchmark [1] to verify that overall throughput
>>>>> is
>>>>> higher. TW latency sounds a lot more complicated to measure as it's
>>>>> difficult to trigger accurately.
>>>>>
>>>>> My feeling is that with reasonable batching (say 8-16 items) the
>>>>> latency will be low as TW is generally very quick, but if you have
>>>>> an
>>>>> idea for benchmarking I can take a look
>>>>>
>>>>> [1]: https://github.com/DylanZA/netbench
>>>>
>>>> It can be normal IO requests I think. We can test the latency by fio
>>>> with small size IO to a fast block device(like nvme) in SQPOLL
>>>> mode(since for non-SQPOLL, it doesn't make difference). This way we
>>>> can
>>>> see the influence of reverse order handling.
>>>>
>>>> Regards,
>>>> Hao
>>>
>>> I see little difference locally, but there is quite a big stdev so it's
>>> possible my test setup is a bit wonky
>>>
>>> new:
>>>      clat (msec): min=2027, max=10544, avg=6347.10, stdev=2458.20
>>>       lat (nsec): min=1440, max=16719k, avg=119714.72, stdev=153571.49
>>> old:
>>>      clat (msec): min=2738, max=10550, avg=6700.68, stdev=2251.77
>>>       lat (nsec): min=1278, max=16610k, avg=121025.73, stdev=211896.14
>>>
>>
>> Hi Dylan,
>>
>> Could you post the arguments you use and the 99% 95% latency as well?
>>
>> Regards,
>> Hao
>>
> 
> One thing I'm worrying about is under heavy workloads, there are
> contiguous TWs coming in, thus the TWs at the end of the TW list doesn't
> get the chance to run, which leads to the latency of those ones becoming
> high.

Ah, looked at the code again, seems we take the whole list not a single
node at each time, so it shouldn't be a big problem.

