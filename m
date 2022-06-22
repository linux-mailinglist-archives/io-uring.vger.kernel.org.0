Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139095549E2
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 14:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiFVM2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 08:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352156AbiFVM2l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 08:28:41 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E012196
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 05:28:39 -0700 (PDT)
Message-ID: <04cf05c8-ece7-2f9d-807b-3168abe1f76e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655900916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4YVNUqQgXxoPzMV+Gs1U5K05iTIfRPUIc/Gabajk2dE=;
        b=DkYHeUQQEQYn6HfYq9jKs5tmdW+EKZ/aKoc2fTp+pZ/ZpNd2ONXW/HZvSs3fVNYbogK84V
        6Ck/EWjhFEX0Tgt4eV2xyfX/6e/I/sdciPddgyKPd1Csp6lFcR+ld1PzDeQyVyOF3+gtFM
        TksEsNuc0K06v43nLsUMaIQXNsJNZ2U=
Date:   Wed, 22 Jun 2022 20:28:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC for-next 0/8] io_uring: tw contention improvments
Content-Language: en-US
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
 <0abf5e2225f649cbda3c0e38997a25c61ce9a5c0.camel@fb.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <0abf5e2225f649cbda3c0e38997a25c61ce9a5c0.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/22 19:51, Dylan Yudaken wrote:
> On Wed, 2022-06-22 at 19:24 +0800, Hao Xu wrote:
>> On 6/22/22 19:16, Hao Xu wrote:
>>> On 6/22/22 17:31, Dylan Yudaken wrote:
>>>> On Tue, 2022-06-21 at 15:34 +0800, Hao Xu wrote:
>>>>> On 6/21/22 15:03, Dylan Yudaken wrote:
>>>>>> On Tue, 2022-06-21 at 13:10 +0800, Hao Xu wrote:
>>>>>>> On 6/21/22 00:18, Dylan Yudaken wrote:
>>>>>>>> Task work currently uses a spin lock to guard task_list
>>>>>>>> and
>>>>>>>> task_running. Some use cases such as networking can
>>>>>>>> trigger
>>>>>>>> task_work_add
>>>>>>>> from multiple threads all at once, which suffers from
>>>>>>>> contention
>>>>>>>> here.
>>>>>>>>
>>>>>>>> This can be changed to use a lockless list which seems to
>>>>>>>> have
>>>>>>>> better
>>>>>>>> performance. Running the micro benchmark in [1] I see 20%
>>>>>>>> improvment in
>>>>>>>> multithreaded task work add. It required removing the
>>>>>>>> priority
>>>>>>>> tw
>>>>>>>> list
>>>>>>>> optimisation, however it isn't clear how important that
>>>>>>>> optimisation is.
>>>>>>>> Additionally it has fairly easy to break semantics.
>>>>>>>>
>>>>>>>> Patch 1-2 remove the priority tw list optimisation
>>>>>>>> Patch 3-5 add lockless lists for task work
>>>>>>>> Patch 6 fixes a bug I noticed in io_uring event tracing
>>>>>>>> Patch 7-8 adds tracing for task_work_run
>>>>>>>>
>>>>>>>
>>>>>>> Compared to the spinlock overhead, the prio task list
>>>>>>> optimization is
>>>>>>> definitely unimportant, so I agree with removing it here.
>>>>>>> Replace the task list with llisy was something I considered
>>>>>>> but I
>>>>>>> gave
>>>>>>> it up since it changes the list to a stack which means we
>>>>>>> have to
>>>>>>> handle
>>>>>>> the tasks in a reverse order. This may affect the latency,
>>>>>>> do you
>>>>>>> have
>>>>>>> some numbers for it, like avg and 99% 95% lat?
>>>>>>>
>>>>>>
>>>>>> Do you have an idea for how to test that? I used a
>>>>>> microbenchmark
>>>>>> as
>>>>>> well as a network benchmark [1] to verify that overall
>>>>>> throughput
>>>>>> is
>>>>>> higher. TW latency sounds a lot more complicated to measure
>>>>>> as it's
>>>>>> difficult to trigger accurately.
>>>>>>
>>>>>> My feeling is that with reasonable batching (say 8-16 items)
>>>>>> the
>>>>>> latency will be low as TW is generally very quick, but if you
>>>>>> have
>>>>>> an
>>>>>> idea for benchmarking I can take a look
>>>>>>
>>>>>> [1]: https://github.com/DylanZA/netbench
>>>>>
>>>>> It can be normal IO requests I think. We can test the latency
>>>>> by fio
>>>>> with small size IO to a fast block device(like nvme) in SQPOLL
>>>>> mode(since for non-SQPOLL, it doesn't make difference). This
>>>>> way we
>>>>> can
>>>>> see the influence of reverse order handling.
>>>>>
>>>>> Regards,
>>>>> Hao
>>>>
>>>> I see little difference locally, but there is quite a big stdev
>>>> so it's
>>>> possible my test setup is a bit wonky
>>>>
>>>> new:
>>>>       clat (msec): min=2027, max=10544, avg=6347.10, stdev=2458.20
>>>>        lat (nsec): min=1440, max=16719k, avg=119714.72,
>>>> stdev=153571.49
>>>> old:
>>>>       clat (msec): min=2738, max=10550, avg=6700.68, stdev=2251.77
>>>>        lat (nsec): min=1278, max=16610k, avg=121025.73,
>>>> stdev=211896.14
>>>>
>>>
>>> Hi Dylan,
>>>
>>> Could you post the arguments you use and the 99% 95% latency as
>>> well?
>>>
>>> Regards,
>>> Hao
>>>
>>
>> One thing I'm worrying about is under heavy workloads, there are
>> contiguous TWs coming in, thus the TWs at the end of the TW list
>> doesn't
>> get the chance to run, which leads to the latency of those ones
>> becoming
>> high.
> 
> Pavel mentioned I should change some arguments, so I reran it. I'll
> just post all the output below as not sure exactly what you are looking
> for. Note I checked that it was definitely batching and it is doing
> batches of 10-20 in tctx_task_work
> 
> 
> *** config ***
> 
> [global]
> ioengine=io_uring
> sqthread_poll=1
> registerfiles=1
> fixedbufs=1
> hipri=0
> thread=1
> direct=0
> rw=randread
> time_based=1
> runtime=600
> ramp_time=30
> randrepeat=0
> group_reporting=0
> sqthread_poll_cpu=15
> iodepth=32
> 
> [job0]
> filename=/dev/nullb0
> cpus_allowed=1
> bs=512
> 
> *** new ***
> job0: (g=0): rw=randread, bs=(R) 512B-512B, (W) 512B-512B, (T) 512B-
> 512B, ioengine=io_uring, iodepth=32
> fio-3.30-59-gd4bf5
> Starting 1 thread
> Jobs: 1 (f=0): [f(1)][100.0%][r=360MiB/s][r=738k IOPS][eta 00m:00s]
> job0: (groupid=0, jobs=1): err= 0: pid=37255: Wed Jun 22 03:44:23 2022
>    read: IOPS=596k, BW=291MiB/s (305MB/s)(171GiB/600001msec)
>      clat (msec): min=30343, max=630343, avg=369885.75, stdev=164921.26
>       lat (usec): min=14, max=1802, avg=53.23, stdev=18.84
>      clat percentiles (msec):
>       |  1.00th=[17113],  5.00th=[17113], 10.00th=[17113],
> 20.00th=[17113],
>       | 30.00th=[17113], 40.00th=[17113], 50.00th=[17113],
> 60.00th=[17113],
>       | 70.00th=[17113], 80.00th=[17113], 90.00th=[17113],
> 95.00th=[17113],
>       | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113],
> 99.95th=[17113],
>       | 99.99th=[17113]
>     bw (  KiB/s): min=169237, max=381603, per=100.00%, avg=298171.22,
> stdev=70580.65, samples=1199
>     iops        : min=338474, max=763206, avg=596342.60,
> stdev=141161.31, samples=1199
>    lat (msec)   : >=2000=100.00%
>    cpu          : usr=99.98%, sys=0.00%, ctx=4378, majf=0, minf=9
>    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=100.0%,
>> =64=0.0%
>       submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%,
>> =64=0.0%
>       issued rwts: total=357661967,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=32
> 
> Run status group 0 (all jobs):
>     READ: bw=291MiB/s (305MB/s), 291MiB/s-291MiB/s (305MB/s-305MB/s),
> io=171GiB (183GB), run=600001-600001msec
> 
> Disk stats (read/write):
>    nullb0: ios=72127555/0, merge=11/0, ticks=1396298/0,
> in_queue=1396298, util=100.00%
>    
> *** old ***
> 
> job0: (g=0): rw=randread, bs=(R) 512B-512B, (W) 512B-512B, (T) 512B-
> 512B, ioengine=io_uring, iodepth=32
> fio-3.30-59-gd4bf5
> Starting 1 thread
> Jobs: 1 (f=1): [r(1)][100.0%][r=367MiB/s][r=751k IOPS][eta 00m:00s]
> job0: (groupid=0, jobs=1): err= 0: pid=19216: Wed Jun 22 04:43:36 2022
>    read: IOPS=609k, BW=297MiB/s (312MB/s)(174GiB/600001msec)
>      clat (msec): min=30333, max=630333, avg=368961.53, stdev=164532.01
>       lat (usec): min=14, max=5830, avg=52.11, stdev=18.64
>      clat percentiles (msec):
>       |  1.00th=[17113],  5.00th=[17113], 10.00th=[17113],
> 20.00th=[17113],
>       | 30.00th=[17113], 40.00th=[17113], 50.00th=[17113],
> 60.00th=[17113],
>       | 70.00th=[17113], 80.00th=[17113], 90.00th=[17113],
> 95.00th=[17113],
>       | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113],
> 99.95th=[17113],
>       | 99.99th=[17113]
>     bw (  KiB/s): min=170273, max=386932, per=100.00%, avg=304548.39,
> stdev=70732.20, samples=1200
>     iops        : min=340547, max=773864, avg=609096.94,
> stdev=141464.41, samples=1200
>    lat (msec)   : >=2000=100.00%
>    cpu          : usr=99.98%, sys=0.00%, ctx=3912, majf=0, minf=5
>    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=100.0%,
>> =64=0.0%
>       submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%,
>> =64=0.0%
>       issued rwts: total=365258392,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=32
> 
> Run status group 0 (all jobs):
>     READ: bw=297MiB/s (312MB/s), 297MiB/s-297MiB/s (312MB/s-312MB/s),
> io=174GiB (187GB), run=600001-600001msec
> 
> Disk stats (read/write):
>    nullb0: ios=69031421/0, merge=1/0, ticks=1323086/0, in_queue=1323086,
> util=100.00%
> 

Ok, the clat percentiles seems meanless here... from the min max and avg
data it should be fine. Thanks for testing.
