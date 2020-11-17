Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7742B69F7
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 17:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgKQQWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 11:22:51 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50410 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726182AbgKQQWt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 11:22:49 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UFix48O_1605630162;
Received: from 30.15.242.88(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UFix48O_1605630162)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Nov 2020 00:22:43 +0800
Subject: Re: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for
 registered files in IOPOLL mode
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
 <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
 <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <36da9b39-241b-492f-62eb-3dacbbf78df3@linux.alibaba.com>
Date:   Wed, 18 Nov 2020 00:21:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 17/11/2020 06:17, Xiaoguang Wang wrote:
>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>> percpu_ref_put() for registered files, but it's hard to say they're very
>> light-weight synchronization primitives. In one our x86 machine, I get below
>> perf data(registered files enabled):
>> Samples: 480K of event 'cycles', Event count (approx.): 298552867297
>> Overhead  Comman  Shared Object     Symbol
>>     0.45%  :53243  [kernel.vmlinux]  [k] io_file_get
> 
> Do you have throughput/latency numbers? In my experience for polling for
> such small overheads all CPU cycles you win earlier in the stack will be
> just burned on polling, because it would still wait for the same fixed*
> time for the next response by device. fixed* here means post-factum but
> still mostly independent of how your host machine behaves.
> 
> e.g. you kick io_uring at a moment K, at device responses at a moment
> K+M. And regardless of what you do in io_uring, the event won't complete
> earlier than after M.
I'm not sure this assumption is correct for real device. IO requests can be
completed in any time, seems that there isn't so-called fixed* time. Say
we're submitting sqe-2 and sqe-1 has been issued to device, the sooner we finish
submitting sqe-2, the sooner and better we start to poll sqe-2 and sqe-2 can be
completed timely.

> 
> That's not the whole story, but as you penalising non-IOPOLL and complicate
> it, I just want to confirm that you really get any extra performance from it.
> Moreover, your drop (0.45%->0.25%) is just 0.20%, and it's comparable with
> the rest of the function (left 0.25%), that's just a dozen of instructions.
I agree that this improvement is minor, and will penalise non-IOPOLL a bit, so I'm
very ok that we drop this patchset.

Here I'd like to have some explanations why I submitted such patch set.
I found in some our arm machine, whose computing power is not that strong,
io_uring(sqpoll and iopoll enabled) even couldn't achieve the capacity of
nvme ssd(but spdk can), so I tried to reduce extral overhead in IOPOLL mode.
Indeed there're are many factors which will influence io performance, not just
io_uring framework, such as block-layer merge operations, various io statistics, etc.

Sometimes I even think whether there should be a light io_uring mainly foucs
on iopoll mode, in which it works like in one kernel task context, then we may get
rid of many atomic operations, memory-barrier, etc. I wonder whether we can
provide a high performance io stack based on io_uring, which will stand shoulder
to shoulder with spdk.

As for the throughput/latency numbers for this patch set, I tried to have
some tests in a real nvme ssd, but don't get a steady resule, sometimes it
shows minor improvements, sometimes it does not. My nvme ssd spec says 4k
rand read iops is 880k, maybe needs a higher nvme ssd to test...

Regards,
Xiaoguang Wang

> 
>>
>> Currently I don't find any good and generic solution for this issue, but
>> in IOPOLL mode, given that we can always ensure get/put registered files
>> under uring_lock, we can use a simple and plain u64 counter to synchronize
>> with registered files update operations in __io_sqe_files_update().
>>
>> With this patch, perf data show shows:
>> Samples: 480K of event 'cycles', Event count (approx.): 298811248406
>> Overhead  Comma  Shared Object     Symbol
>>     0.25%  :4182  [kernel.vmlinux]  [k] io_file_get
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 40 ++++++++++++++++++++++++++++++++++------
>>   1 file changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 219609c38e48..0fa48ea50ff9 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -201,6 +201,11 @@ struct fixed_file_table {
>>   
>>   struct fixed_file_ref_node {
>>   	struct percpu_ref		refs;
>> +	/*
>> +	 * Track the number of reqs that reference this node, currently it's
>> +	 * only used in IOPOLL mode.
>> +	 */
>> +	u64				count;
>>   	struct list_head		node;
>>   	struct list_head		file_list;
>>   	struct fixed_file_data		*file_data;
>> @@ -1926,10 +1931,17 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
>>   static inline void io_put_file(struct io_kiocb *req, struct file *file,
>>   			  bool fixed)
>>   {
>> -	if (fixed)
>> -		percpu_ref_put(&req->ref_node->refs);
>> -	else
>> +	if (fixed) {
>> +		/* See same comments in io_file_get(). */
>> +		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>> +			if (!--req->ref_node->count)
>> +				percpu_ref_kill(&req->ref_node->refs);
>> +		} else {
>> +			percpu_ref_put(&req->ref_node->refs);
>> +		}
>> +	} else {
>>   		fput(file);
>> +	}
>>   }
>>   
>>   static void io_dismantle_req(struct io_kiocb *req)
>> @@ -6344,8 +6356,16 @@ static struct file *io_file_get(struct io_submit_state *state,
>>   		fd = array_index_nospec(fd, ctx->nr_user_files);
>>   		file = io_file_from_index(ctx, fd);
>>   		if (file) {
>> +			/*
>> +			 * IOPOLL mode can always ensure get/put registered files under uring_lock,
>> +			 * so we can use a simple plain u64 counter to synchronize with registered
>> +			 * files update operations in __io_sqe_files_update.
>> +			 */
>>   			req->ref_node = ctx->file_data->node;
>> -			percpu_ref_get(&req->ref_node->refs);
>> +			if (ctx->flags & IORING_SETUP_IOPOLL)
>> +				req->ref_node->count++;
>> +			else
>> +				percpu_ref_get(&req->ref_node->refs);
>>   		}
>>   	} else {
>>   		trace_io_uring_file_get(ctx, fd);
>> @@ -7215,7 +7235,12 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>>   		ref_node = list_first_entry(&data->ref_list,
>>   				struct fixed_file_ref_node, node);
>>   	spin_unlock(&data->lock);
>> -	if (ref_node)
>> +	/*
>> +	 * If count is not zero, that means we're in IOPOLL mode, and there are
>> +	 * still reqs that reference this ref_node, let the final req do the
>> +	 * percpu_ref_kill job.
>> +	 */
>> +	if (ref_node && (!--ref_node->count))
>>   		percpu_ref_kill(&ref_node->refs);
>>   
>>   	percpu_ref_kill(&data->refs);
>> @@ -7625,6 +7650,7 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
>>   	INIT_LIST_HEAD(&ref_node->node);
>>   	INIT_LIST_HEAD(&ref_node->file_list);
>>   	ref_node->file_data = ctx->file_data;
>> +	ref_node->count = 1;
>>   	return ref_node;
>>   }
>>   
>> @@ -7877,7 +7903,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>>   	}
>>   
>>   	if (needs_switch) {
>> -		percpu_ref_kill(&data->node->refs);
>> +		/* See same comments in io_sqe_files_unregister(). */
>> +		if (!--data->node->count)
>> +			percpu_ref_kill(&data->node->refs);
>>   		spin_lock(&data->lock);
>>   		list_add(&ref_node->node, &data->ref_list);
>>   		data->node = ref_node;
>>
> 
