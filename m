Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E665373930
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 13:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhEELWQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 07:22:16 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:57457 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232912AbhEELV7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 07:21:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UXnTrbE_1620213652;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UXnTrbE_1620213652)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 May 2021 19:20:53 +0800
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
 <6cc0020d-bfad-d723-6cc3-8bb2b8c4d313@gmail.com>
 <ab087171-9396-2b68-beab-ca1a4ad25bb0@linux.alibaba.com>
 <ae26b825-37b8-11d3-4c44-9b23a27e2d69@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <e66a348f-6ee7-0235-6cb7-3c6374598a55@linux.alibaba.com>
Date:   Wed, 5 May 2021 19:20:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <ae26b825-37b8-11d3-4c44-9b23a27e2d69@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/29 下午5:28, Pavel Begunkov 写道:
> On 4/29/21 5:37 AM, Hao Xu wrote:
>> 在 2021/4/28 下午10:37, Pavel Begunkov 写道:
>>> On 4/28/21 3:34 PM, Pavel Begunkov wrote:
>>>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>>>> sqes are submitted by sqthread when it is leveraged, which means there
>>>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>>>> number of sqes in the original task context.
>>>>> Tests result below:
>>>>
>>>> Frankly, it can be a nest of corner cases if not now then in the future,
>>>> leading to a high maintenance burden. Hence, if we consider the change,
>>>> I'd rather want to limit the userspace exposure, so it can be removed
>>>> if needed.
>>>>
>>>> A noticeable change of behaviour here, as Hao recently asked, is that
>>>> the ring can be passed to a task from a completely another thread group,
>>>> and so the feature would execute from that context, not from the
>>>> original/sqpoll one.
>>>
>>> So maybe something like:
>>> if (same_thread_group()) {
>>>      /* submit */
>>> }I thought this case(cross independent processes) for some time, Pavel,
>> could you give more hints about how this may trigger errors?
> 
> Currently? We need to audit cancellation, but don't think it's a problem.
> 
> But as said, it's about the future. Your patch adds a new quirky
> userspace behaviour (submitting from alien context as described), and
> once commited it can't be removed and should be maintained.
> 
> I can easily imagine it either over-complicating cancellations (and
> we had enough of troubles with it), or just preventing more important
> optimisations, or anything else often happening with new features.
> 
> 
>>>
>>>>
>>>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>>>> ignored if the previous point is addressed.
>>>
>>> I'd question whether it'd be better with the flag or without doing
>>> this feature by default.
>> Just like what Jens said, the flag here is to allow users to do their
>> decision, there may be cases like a application wants to offload as much
>> as possible IO related work to sqpoll, so that it can be dedicated to
>> computation work etc.
>>>
>>>>
>>>>>
>>>>> 99th latency:
>>>>> iops\idle    10us    60us    110us    160us    210us    260us    310us    360us    410us    460us    510us
>>>>> with this patch:
>>>>> 2k          13    13    12    13    13    12    12    11    11    10.304    11.84
>>>>> without this patch:
>>>>> 2k          15    14    15    15    15    14    15    14    14    13    11.84
>>>>
>>>> Not sure the second nine describes it well enough, please can you
>>>> add more data? Mean latency, 50%, 90%, 99%, 99.9%, t-put.
>> Sure, I will.
> 
> Forgot but it's important, should compared with non-sqpoll as well
> because the feature is taking the middle ground between them.
Hi Pavel,
I found that the previous tests are not correct since when I did the
test I enabled IOPOLL and in io_uring_enter(), I didn't add a if:
if (IOPOLL disabled)
    submit at most 8 sqes in original context

this optimization cannot run under SQPOLL+IOPOLL.

So I did another tests with my new code, under 2k IOPS, against an
Intel optane device. The fio command is:
echo "
[global]
ioengine=io_uring
sqthread_poll=1
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=160
group_reporting=1
filename=/dev/nvme1n1
sqthread_poll_cpu=30
randrepeat=0

[job0]
cpus_allowed=35
iodepth=128
rate_iops=${1}
io_sq_thread_idle=${2}" | ./fio/fio -

the result is:
(
1. big numbers in 'th' are in ns, others in us,
2. for no sqpoll mode, sq_idle doesn't affect the metrics, so they're
    just repetitive tests.
)

2k+idle_submit_min8																						
metrics\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
min_lat	9	9	9	9	9	9	9	9	9	9	8
max_lat	2233	2802	3000	3518	3078	2052	2583	2914	4176	2255	3275
avg_lat	11.26	11.25	11.24	11.29	11.29	11.21	11.24	11.21	11.23	11.27	9.53
50th	7648	7648	7648	7648	7648	7648	7648	7584	7584	7648	9152
90th	7840	7840	7840	7840	7840	7840	7840	7776	7840	7904	9408
99th	10944	11200	11712	11328	12096	12352	11584	12096	11712	11072	12992
99.99th	73216	38144	56576	38656	38144	70144	40192	38144	40704	38144	39680
fio(usr)	3.66%	3.53%	3.80%	3.60%	3.41%	3.93%	3.55%	3.57%	3.58%	3.75%	3.82%
fio(sys)	0.77%	0.70%	0.64%	0.65%	0.82%	0.71%	0.69%	0.69%	0.68%	0.72%	0.07%
fio(usr+sys)	4.43%	4.23%	4.44%	4.25%	4.23%	4.64%	4.24%	4.26%	4.26% 
4.47%	3.89%
											
											
											
2k+idle_without_submit_min8											
metrics\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
min_lat	11	8	8	8	8	8	8	8	8	8	8
max_lat	12643	11703	11617	3050	8662	3402	5179	4307	2897	4204	3017
avg_lat	12.75	12.77	12.5	12.43	12.5	12.39	12.39	12.33	12.16	12.1	9.44
50th	11	11	11	11	11	11	11	11	11	11	9024
90th	11	11	11	11	11	11	11	11	11	11	9280
99th	18	17	15	16	16	16	16	16	15	15	13120
99.99th	930	1090	635	635	693	652	717	635	510	330	39680
fio(usr)	4.59%	3.29%	4.06%	4.10%	4.18%	4.30%	4.73%	4.12%	4.11%	3.83%	3.80%
fio(sys)	0.39%	0.45%	0.46%	0.42%	0.34%	0.39%	0.37%	0.37%	0.33%	0.39%	0.07%
fio(usr+sys)	4.98%	3.74%	4.52%	4.52%	4.52%	4.69%	5.10%	4.49%	4.44% 
4.22%	3.87%
											
											
											
2k+without_sqpoll											
metrics\idle	10us	60us	110us	160us	210us	260us	310us 360us	410us	460us	510us
min_lat	8	8	8	7	8	8	8	8	8	8	8
max_lat	623	602	273	388	271	290	891	495	519	396	245
avg_lat	13.12	13.14	13.15	13.1	13.16	13.06	13.06	13.15	13.12	13.14	13.1
50th	10560	10560	10560	10560	10560	10432	10560	10560	10560	10560	10560
90th	10816	10816	10944	10816	10816	10816	10816	10944	10816	10944	10816
99th	14144	14656	14272	13888	14400	14016	14400	14272	14400	14528	14272
99.99th	42752	50432	43246	41216	56576	42240	43264	42240	47360	58624	42240
fio(usr)	2.31%	2.33%	2.81%	2.30%	2.34%	2.34%	2.12%	2.26%	2.09%	2.36%	2.34%
fio(sys)	0.82%	0.79%	0.93%	0.81%	0.79%	0.77%	0.79%	0.86%	1.02%	0.76%	0.79%
fio(usr+sys)	3.13%	3.12%	3.74%	3.11%	3.13%	3.11%	2.91%	3.12%	3.11% 
3.12%	3.13%

Cpu usage of sqthread hasn't been recorded, but I think the trending
would be like the result in the previous email.
 From the data, the 'submit in original context' change reduce the avg
latency and 'th' latency, meanwhile costs too much cpu usage of the
original context. may be 'submit min(to_submit, 8)' is too much in 2k
IOPS. I'll try other combination of IOPS and idle time.

Thanks,
Hao
> 
>>>>
>>>> Btw, how happened that only some of the numbers have fractional part?
>>>> Can't believe they all but 3 were close enough to integer values.
>> This confused me a little bit too, but it is indeed what fio outputs.
> 
> That's just always when I see such, something tells me that data has
> been manipulated. Even if it's fio, it's really weird and suspicious,
> and worth to look what's wrong with it.
Could you tell me what it is.
> 
>>>>
>>>>> fio config:
>>>>> ./run_fio.sh
>>>>> fio \
>>>>> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
>>>>> --direct=1 --rw=randread --time_based=1 --runtime=300 \
>>>>> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
>>>>> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
>>>>> --io_sq_thread_idle=${2}
>>>>>
>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>> ---
>>>>>    fs/io_uring.c                 | 29 +++++++++++++++++++++++------
>>>>>    include/uapi/linux/io_uring.h |  1 +
>>>>>    2 files changed, 24 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 1871fad48412..f0a01232671e 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
>>>>>    {
>>>>>        struct io_ring_ctx *ctx = req->ctx;
>>>>>        struct io_kiocb *link = io_prep_linked_timeout(req);
>>>>> -    struct io_uring_task *tctx = req->task->io_uring;
>>>>> +    struct io_uring_task *tctx = NULL;
>>>>> +
>>>>> +    if (ctx->sq_data && ctx->sq_data->thread)
>>>>> +        tctx = ctx->sq_data->thread->io_uring;
>>>>
>>>> without park it's racy, sq_data->thread may become NULL and removed,
>>>> as well as its ->io_uring.
>>>>
>>>>> +    else
>>>>> +        tctx = req->task->io_uring;
>>>>>          BUG_ON(!tctx);
>>>>>        BUG_ON(!tctx->io_wq);
>>>>
>>>> [snip]
>>>>
>>>
>>
> 

