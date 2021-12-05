Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD87468B91
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 16:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhLEPF5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 10:05:57 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:50022 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235147AbhLEPF4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 10:05:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzSGA7g_1638716546;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzSGA7g_1638716546)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 05 Dec 2021 23:02:27 +0800
Subject: Re: [PATCH v6 0/6] task work optimization
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
 <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
 <a3515db3-2c22-fa32-746e-3210d84386e9@gmail.com>
 <8e22c1fa-faf0-4708-2101-86fd0d34ef86@linux.alibaba.com>
 <50cd05fb-243c-9b24-108f-15a1554ed7bc@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <0b2067e3-6d18-3ada-9647-c519176d6a9e@linux.alibaba.com>
Date:   Sun, 5 Dec 2021 23:02:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <50cd05fb-243c-9b24-108f-15a1554ed7bc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/12/3 下午10:21, Pavel Begunkov 写道:
> On 12/3/21 07:30, Hao Xu wrote:
>> 在 2021/12/3 上午10:01, Pavel Begunkov 写道:
>>> On 12/3/21 01:39, Pavel Begunkov wrote:
>>>> On 11/26/21 10:07, Hao Xu wrote:
>>>>> v4->v5
>>>>> - change the implementation of merge_wq_list
>>>>>
> [...]
>>> But testing with liburing tests I'm getting the stuff below,
>>> e.g. cq-overflow hits it every time. Double checked that
>>> I took [RESEND] version of 6/6.
>>>
>>> [   30.360370] BUG: scheduling while atomic: cq-overflow/2082/0x00000000
>>> [   30.360520] Call Trace:
>>> [   30.360523]  <TASK>
>>> [   30.360527]  dump_stack_lvl+0x4c/0x63
>>> [   30.360536]  dump_stack+0x10/0x12
>>> [   30.360540]  __schedule_bug.cold+0x50/0x5e
>>> [   30.360545]  __schedule+0x754/0x900
>>> [   30.360551]  ? __io_cqring_overflow_flush+0xb6/0x200
>>> [   30.360558]  schedule+0x55/0xd0
>>> [   30.360563]  schedule_timeout+0xf8/0x140
>>> [   30.360567]  ? prepare_to_wait_exclusive+0x58/0xa0
>>> [   30.360573]  __x64_sys_io_uring_enter+0x69c/0x8e0
>>> [   30.360578]  ? io_rsrc_buf_put+0x30/0x30
>>> [   30.360582]  do_syscall_64+0x3b/0x80
>>> [   30.360588]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> [   30.360592] RIP: 0033:0x7f9f9680118d
>>> [   30.360618]  </TASK>
>>> [   30.362295] BUG: scheduling while atomic: cq-overflow/2082/0x7ffffffe
>>> [   30.362396] Call Trace:
>>> [   30.362397]  <TASK>
>>> [   30.362399]  dump_stack_lvl+0x4c/0x63
>>> [   30.362406]  dump_stack+0x10/0x12
>>> [   30.362409]  __schedule_bug.cold+0x50/0x5e
>>> [   30.362413]  __schedule+0x754/0x900
>>> [   30.362419]  schedule+0x55/0xd0
>>> [   30.362423]  schedule_timeout+0xf8/0x140
>>> [   30.362427]  ? prepare_to_wait_exclusive+0x58/0xa0
>>> [   30.362431]  __x64_sys_io_uring_enter+0x69c/0x8e0
>>> [   30.362437]  ? io_rsrc_buf_put+0x30/0x30
>>> [   30.362440]  do_syscall_64+0x3b/0x80
>>> [   30.362445]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> [   30.362449] RIP: 0033:0x7f9f9680118d
>>> [   30.362470]  </TASK>
>>> <repeated>
>>>
>> cannot repro this, all the liburing tests work well on my side..
> 
> One problem is when on the first iteration tctx_task_work doen't
> have anything in prior_task_list, it goes to handle_tw_list(),
> which sets up @ctx but leaves @locked=false (say there is
> contention). And then on the second iteration it goes to
> handle_prior_tw_list() with non-NULL @ctx and @locked=false,
> and tries to unlock not locked spin.
> 
> Not sure that's the exactly the problem from traces, but at
> least a quick hack resetting the ctx at the beginning of
> handle_prior_tw_list() heals it.
Good catch, thanks.
> 
> note: apart from the quick fix the diff below includes
> a couple of lines to force it to go through the new path.
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 66d119ac4424..3868123eef87 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2272,6 +2272,9 @@ static inline void ctx_commit_and_unlock(struct 
> io_ring_ctx *ctx)
>   static void handle_prior_tw_list(struct io_wq_work_node *node, struct 
> io_ring_ctx **ctx,
>                                   bool *locked)
>   {
> +       ctx_flush_and_put(*ctx, locked);
> +       *ctx = NULL;
> +
>          do {
>                  struct io_wq_work_node *next = node->next;
>                  struct io_kiocb *req = container_of(node, struct io_kiocb,
> @@ -2283,7 +2286,8 @@ static void handle_prior_tw_list(struct 
> io_wq_work_node *node, struct io_ring_ct
>                          ctx_flush_and_put(*ctx, locked);
>                          *ctx = req->ctx;
>                          /* if not contended, grab and improve batching */
> -                       *locked = mutex_trylock(&(*ctx)->uring_lock);
> +                       *locked = false;
> +                       // *locked = mutex_trylock(&(*ctx)->uring_lock);
I believe this one is your debug code which I shouldn't take, should I?
>                          percpu_ref_get(&(*ctx)->refs);
>                          if (unlikely(!*locked))
>                                  spin_lock(&(*ctx)->completion_lock);
> @@ -2840,7 +2844,7 @@ static void io_complete_rw(struct kiocb *kiocb, 
> long res)
>                  return;
>          req->result = res;
>          req->io_task_work.func = io_req_task_complete;
> -       io_req_task_work_add(req, !!(req->ctx->flags & 
> IORING_SETUP_SQPOLL));
> +       io_req_task_work_add(req, true);
>   }
> 
> 
> 

