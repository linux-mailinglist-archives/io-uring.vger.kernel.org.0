Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD57531432
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbiEWOpe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 10:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbiEWOpc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 10:45:32 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D67A2F02A;
        Mon, 23 May 2022 07:45:30 -0700 (PDT)
Received: from kwepemi100008.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L6KpS1wYyz1JC1p;
        Mon, 23 May 2022 22:44:00 +0800 (CST)
Received: from kwepemm600004.china.huawei.com (7.193.23.242) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 23 May 2022 22:45:28 +0800
Received: from [10.174.177.238] (10.174.177.238) by
 kwepemm600004.china.huawei.com (7.193.23.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 23 May 2022 22:45:27 +0800
Message-ID: <a2b0340c-7bf7-a00e-6338-aca8ca02a1e2@huawei.com>
Date:   Mon, 23 May 2022 22:45:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH] io_uring: add a schedule condition in io_submit_sqes
To:     Jens Axboe <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <chengzhihao1@huawei.com>, <linux-kernel@vger.kernel.org>
References: <20220521143327.3959685-1-guoxuenan@huawei.com>
 <00772002-8df8-3a41-6e6c-20e3854ad3f0@kernel.dk>
From:   Guo Xuenan <guoxuenan@huawei.com>
In-Reply-To: <00772002-8df8-3a41-6e6c-20e3854ad3f0@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.238]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600004.china.huawei.com (7.193.23.242)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens

On 2022/5/22 10:42, Jens Axboe wrote:
> On 5/21/22 8:33 AM, Guo Xuenan wrote:
>> when set up sq ring size with IORING_MAX_ENTRIES, io_submit_sqes may
>> looping ~32768 times which may trigger soft lockups. add need_resched
>> condition to avoid this bad situation.
>>
>> set sq ring size 32768 and using io_sq_thread to perform stress test
>> as follows:
>> watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [iou-sqp-600:601]
>> Kernel panic - not syncing: softlockup: hung tasks
>> CPU: 2 PID: 601 Comm: iou-sqp-600 Tainted: G L 5.18.0-rc7+ #3
>> Hardware name: linux,dummy-virt (DT)
>> Call trace:
>>   dump_backtrace+0x218/0x228
>>   show_stack+0x20/0x68
>>   dump_stack_lvl+0x68/0x84
>>   dump_stack+0x1c/0x38
>>   panic+0x1ec/0x3ec
>>   watchdog_timer_fn+0x28c/0x300
>>   __hrtimer_run_queues+0x1d8/0x498
>>   hrtimer_interrupt+0x238/0x558
>>   arch_timer_handler_virt+0x48/0x60
>>   handle_percpu_devid_irq+0xdc/0x270
>>   generic_handle_domain_irq+0x50/0x70
>>   gic_handle_irq+0x8c/0x4bc
>>   call_on_irq_stack+0x2c/0x38
>>   do_interrupt_handler+0xc4/0xc8
>>   el1_interrupt+0x48/0xb0
>>   el1h_64_irq_handler+0x18/0x28
>>   el1h_64_irq+0x74/0x78
>>   console_unlock+0x5d0/0x908
>>   vprintk_emit+0x21c/0x470
>>   vprintk_default+0x40/0x50
>>   vprintk+0xd0/0x128
>>   _printk+0xb4/0xe8
>>   io_issue_sqe+0x1784/0x2908
>>   io_submit_sqes+0x538/0x2880
>>   io_sq_thread+0x328/0x7b0
>>   ret_from_fork+0x10/0x20
>> SMP: stopping secondary CPUs
>> Kernel Offset: 0x40f1e8600000 from 0xffff800008000000
>> PHYS_OFFSET: 0xfffffa8c80000000
>> CPU features: 0x110,0000cf09,00001006
>> Memory Limit: none
>> ---[ end Kernel panic - not syncing: softlockup: hung tasks ]---
>>
>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> ---
>>   fs/io_uring.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 92ac50f139cd..d897c6798f00 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7864,7 +7864,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>>   			if (!(ctx->flags & IORING_SETUP_SUBMIT_ALL))
>>   				break;
>>   		}
>> -	} while (submitted < nr);
>> +	} while (submitted < nr && !need_resched());
>>   
>>   	if (unlikely(submitted != nr)) {
>>   		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
> This is wrong, you'll potentially end up doing random short submits for
> non-sqpoll as well.
Sorry, Indeed, this is not a good solution. Since, the function 
io_submit_sqes
not only called by io_sq_thread, it also called by syscall 
io_uring_enter sending
large amounts of requests, will also trigger soft lockup.
> sqpoll already supports capping how many it submits in one go, it just
> doesn't do it if it's only running one ring. As simple as the below,
> with 1024 pulled out of thin air. Would be great if you could experiment
> and submit a v2 based on this principle instead. Might still need a
yes, Jens, your patch sloved sq-poll-thread problem, but the problem may 
not
completely solved; when using syscall io_uring_enter to subimit large 
amounts

of requests.So in my opinion How about 1) add cond_resched() in the 
while cycle

part of io_submit_sqes ?. OR 2) set macro IORING_MAX_ENTRIES smaller? (i'm

curious about the value,why we set it with 32768)

> cond_resched() carefully placed in io_sq_thread().
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e0823f58f795..3830d7b493b9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7916,7 +7916,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>   	unsigned int to_submit;
>   	int ret = 0;
>   
> -	to_submit = io_sqring_entries(ctx);
> +	/* cap at 1024 to avoid doing too much in one submit round */
> +	to_submit = min(io_sqring_entries(ctx), 1024U);
Yes, it works.;)
>   	/* if we're handling multiple rings, cap submit size for fairness */
>   	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
>   		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
>
