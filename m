Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4571F9EE0
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 19:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbgFORxl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 13:53:41 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:50102 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729124AbgFORxl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 13:53:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.iU8MY_1592243618;
Received: from 30.39.240.224(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.iU8MY_1592243618)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Jun 2020 01:53:38 +0800
Subject: Re: [PATCH 2/2] io_uring: add memory barrier to synchronize
 io_kiocb's result and iopoll_completed
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200615092450.3241-1-xiaoguang.wang@linux.alibaba.com>
 <20200615092450.3241-3-xiaoguang.wang@linux.alibaba.com>
 <a11acc23-1ad6-2281-4712-e78e46f414d7@kernel.dk>
 <e47dd9c1-60a6-8365-6754-88437cf828f5@linux.alibaba.com>
 <97cfe28d-cbbe-680a-2f4f-8794d4f90728@kernel.dk>
 <d37647d3-da74-7c30-94c8-f18d0afcd958@linux.alibaba.com>
 <2d6f383f-a033-fe30-f4cb-e5b9439dbbac@kernel.dk>
 <c529d919-e70c-3e79-77c8-b5cb7ffead4d@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <d431b935-3f10-7f70-a243-a0f308e58f59@linux.alibaba.com>
Date:   Tue, 16 Jun 2020 01:53:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <c529d919-e70c-3e79-77c8-b5cb7ffead4d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 6/15/20 9:35 AM, Jens Axboe wrote:
>> On 6/15/20 9:32 AM, Xiaoguang Wang wrote:
>>> hi,
>>>
>>>> On 6/15/20 8:48 AM, Xiaoguang Wang wrote:
>>>>> hi,
>>>>>
>>>>>> On 6/15/20 3:24 AM, Xiaoguang Wang wrote:
>>>>>>> In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
>>>>>>> completed are two independent store operations, to ensure that once
>>>>>>> iopoll_completed is ture and then req->result must been perceived by
>>>>>>> the cpu executing io_do_iopoll(), proper memory barrier should be used.
>>>>>>>
>>>>>>> And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
>>>>>>> we'll need to issue this io request using io-wq again. In order to just
>>>>>>> issue a single smp_rmb() on the completion side, move the re-submit work
>>>>>>> to io_iopoll_complete().
>>>>>>
>>>>>> Did you actually test this one?
>>>>> I only run test cases in liburing/test in a vm.
>>>>>
>>>>>>
>>>>>>> @@ -1736,11 +1748,20 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>>>>>>>     {
>>>>>>>     	struct req_batch rb;
>>>>>>>     	struct io_kiocb *req;
>>>>>>> +	LIST_HEAD(again);
>>>>>>> +
>>>>>>> +	/* order with ->result store in io_complete_rw_iopoll() */
>>>>>>> +	smp_rmb();
>>>>>>>     
>>>>>>>     	rb.to_free = rb.need_iter = 0;
>>>>>>>     	while (!list_empty(done)) {
>>>>>>>     		int cflags = 0;
>>>>>>>     
>>>>>>> +		if (READ_ONCE(req->result) == -EAGAIN) {
>>>>>>> +			req->iopoll_completed = 0;
>>>>>>> +			list_move_tail(&req->list, &again);
>>>>>>> +			continue;
>>>>>>> +		}
>>>>>>>     		req = list_first_entry(done, struct io_kiocb, list);
>>>>>>>     		list_del(&req->list);
>>>>>>>     
>>>>>>
>>>>>> You're using 'req' here before you initialize it...
>>>>> Sorry, next time when I submit patches, I'll construct test cases which
>>>>> will cover my codes changes.
>>>>
>>>> I'm surprised the compiler didn't complain, or that the regular testing
>>>> didn't barf on it.
>>> I'm also surprised, will try to find the reason.
>>> And indeed the iopoll test case failed, but below command displayed nothing:
>>> [lege@localhost test]$ sudo ./iopoll
>>> Then I considered this test case pass wrongly.
>>>
>>> dmesg show errors:
>>> [  127.806945] ==================================================================
>>> [  127.806983] BUG: KASAN: use-after-free in io_iopoll_complete+0xbb/0x980
>>> [  127.806989] Read of size 4 at addr ffff8886e3e98808 by task io_uring-sq/1643
>>>
>>> [  127.806999] CPU: 16 PID: 1643 Comm: io_uring-sq Not tainted 5.7.0+ #501
>>> [  127.807013] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
>>> [  127.807021] Call Trace:
>>> [  127.807040]  dump_stack+0x75/0xa0
>>> [  127.807047]  ? io_iopoll_complete+0xbb/0x980
>>> [  127.807062]  print_address_description.constprop.6+0x1a/0x220
>>> [  127.807086]  ? _raw_write_lock_irqsave+0xd0/0xd0
>>> [  127.807092]  ? io_free_req_many.part.79+0x208/0x2a0
>>> [  127.807107]  ? __rcu_read_unlock+0x37/0x200
>>> [  127.807112]  ? io_iopoll_complete+0xbb/0x980
>>> [  127.807117]  ? io_iopoll_complete+0xbb/0x980
>>> [  127.807122]  kasan_report.cold.9+0x1f/0x42
>>> [  127.807128]  ? io_iopoll_complete+0xbb/0x980
>>> [  127.807133]  io_iopoll_complete+0xbb/0x980
>>> [  127.807138]  ? io_timeout_fn+0x140/0x140
>>> [  127.807150]  ? __switch_to+0x2e9/0x5a0
>>> [  127.807157]  io_iopoll_getevents+0x287/0x310
>>> [  127.807163]  ? io_iopoll_complete+0x980/0x980
>>> [  127.807172]  ? finish_wait+0xcb/0xf0
>>> [  127.807179]  io_sq_thread+0x1c1/0x600
>>> [  127.807185]  ? __ia32_sys_io_uring_enter+0x450/0x450
>>> [  127.807194]  ? preempt_count_add+0x77/0xd0
>>> [  127.807200]  ? _raw_spin_lock_irqsave+0x84/0xd0
>>> [  127.807206]  ? _raw_write_lock_irqsave+0xd0/0xd0
>>> [  127.807210]  ? finish_wait+0xf0/0xf0
>>> [  127.807215]  ? preempt_count_sub+0x18/0xc0
>>> [  127.807224]  ? __kthread_parkme+0xaf/0xd0
>>> [  127.807231]  ? __ia32_sys_io_uring_enter+0x450/0x450
>>> [  127.807235]  kthread+0x1e4/0x210
>>> [  127.807241]  ? kthread_create_on_node+0xa0/0xa0
>>> [  127.807246]  ret_from_fork+0x22/0x30
>>
>> There you go, so it did fail, just didn't register as a failure. I should
>> probably add a dmesg check for the liburing tests, and fail a test if
>> we trigger a WARNING or BUG condition. I'll look into that.
> 
> I pushed a commit to liburing so that it should now catch dmesg
> errors logged while running a test.
Cool, thanks.
Will run new tests, and if there are not failures, I'll send a V2 soon.

Regards,
Xiaoguang Wang


> 
