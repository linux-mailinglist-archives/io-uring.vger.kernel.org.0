Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0618C469194
	for <lists+io-uring@lfdr.de>; Mon,  6 Dec 2021 09:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239520AbhLFIjR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Dec 2021 03:39:17 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:56719 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231612AbhLFIjQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Dec 2021 03:39:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzZ65NM_1638779746;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzZ65NM_1638779746)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 06 Dec 2021 16:35:46 +0800
Subject: Re: [PATCH v6 0/6] task work optimization
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
 <e63b44a9-72ba-09fd-82d8-448fce356a9a@gmail.com>
 <a3515db3-2c22-fa32-746e-3210d84386e9@gmail.com>
 <8e22c1fa-faf0-4708-2101-86fd0d34ef86@linux.alibaba.com>
 <50cd05fb-243c-9b24-108f-15a1554ed7bc@gmail.com>
 <0b2067e3-6d18-3ada-9647-c519176d6a9e@linux.alibaba.com>
 <6a785450-dfd6-74ac-f604-a92324853fc0@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a150232e-d6db-c996-8b35-0a69b64c1e13@linux.alibaba.com>
Date:   Mon, 6 Dec 2021 16:35:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6a785450-dfd6-74ac-f604-a92324853fc0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/12/5 下午11:42, Pavel Begunkov 写道:
> On 12/5/21 15:02, Hao Xu wrote:
>> 在 2021/12/3 下午10:21, Pavel Begunkov 写道:
>>> On 12/3/21 07:30, Hao Xu wrote:
>>>> 在 2021/12/3 上午10:01, Pavel Begunkov 写道:
>>>>> On 12/3/21 01:39, Pavel Begunkov wrote:
>>>>>> On 11/26/21 10:07, Hao Xu wrote:
>>>>>>> v4->v5
>>>>>>> - change the implementation of merge_wq_list
>>>>>>>
>>> [...]
>>>>> But testing with liburing tests I'm getting the stuff below,
>>>>> e.g. cq-overflow hits it every time. Double checked that
>>>>> I took [RESEND] version of 6/6.
>>>>>
>>>>> [   30.360370] BUG: scheduling while atomic: 
>>>>> cq-overflow/2082/0x00000000
>>>>> [   30.360520] Call Trace:
>>>>> [   30.360523]  <TASK>
>>>>> [   30.360527]  dump_stack_lvl+0x4c/0x63
>>>>> [   30.360536]  dump_stack+0x10/0x12
>>>>> [   30.360540]  __schedule_bug.cold+0x50/0x5e
>>>>> [   30.360545]  __schedule+0x754/0x900
>>>>> [   30.360551]  ? __io_cqring_overflow_flush+0xb6/0x200
>>>>> [   30.360558]  schedule+0x55/0xd0
>>>>> [   30.360563]  schedule_timeout+0xf8/0x140
>>>>> [   30.360567]  ? prepare_to_wait_exclusive+0x58/0xa0
>>>>> [   30.360573]  __x64_sys_io_uring_enter+0x69c/0x8e0
>>>>> [   30.360578]  ? io_rsrc_buf_put+0x30/0x30
>>>>> [   30.360582]  do_syscall_64+0x3b/0x80
>>>>> [   30.360588]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>> [   30.360592] RIP: 0033:0x7f9f9680118d
>>>>> [   30.360618]  </TASK>
>>>>> [   30.362295] BUG: scheduling while atomic: 
>>>>> cq-overflow/2082/0x7ffffffe
>>>>> [   30.362396] Call Trace:
>>>>> [   30.362397]  <TASK>
>>>>> [   30.362399]  dump_stack_lvl+0x4c/0x63
>>>>> [   30.362406]  dump_stack+0x10/0x12
>>>>> [   30.362409]  __schedule_bug.cold+0x50/0x5e
>>>>> [   30.362413]  __schedule+0x754/0x900
>>>>> [   30.362419]  schedule+0x55/0xd0
>>>>> [   30.362423]  schedule_timeout+0xf8/0x140
>>>>> [   30.362427]  ? prepare_to_wait_exclusive+0x58/0xa0
>>>>> [   30.362431]  __x64_sys_io_uring_enter+0x69c/0x8e0
>>>>> [   30.362437]  ? io_rsrc_buf_put+0x30/0x30
>>>>> [   30.362440]  do_syscall_64+0x3b/0x80
>>>>> [   30.362445]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>> [   30.362449] RIP: 0033:0x7f9f9680118d
>>>>> [   30.362470]  </TASK>
>>>>> <repeated>
>>>>>
>>>> cannot repro this, all the liburing tests work well on my side..
>>>
>>> One problem is when on the first iteration tctx_task_work doen't
>>> have anything in prior_task_list, it goes to handle_tw_list(),
>>> which sets up @ctx but leaves @locked=false (say there is
>>> contention). And then on the second iteration it goes to
>>> handle_prior_tw_list() with non-NULL @ctx and @locked=false,
>>> and tries to unlock not locked spin.
>>>
>>> Not sure that's the exactly the problem from traces, but at
>>> least a quick hack resetting the ctx at the beginning of
>>> handle_prior_tw_list() heals it.
>> Good catch, thanks.
>>>
>>> note: apart from the quick fix the diff below includes
>>> a couple of lines to force it to go through the new path.
>>>
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 66d119ac4424..3868123eef87 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2272,6 +2272,9 @@ static inline void ctx_commit_and_unlock(struct 
>>> io_ring_ctx *ctx)
>>>   static void handle_prior_tw_list(struct io_wq_work_node *node, 
>>> struct io_ring_ctx **ctx,
>>>                                   bool *locked)
>>>   {
>>> +       ctx_flush_and_put(*ctx, locked);
>>> +       *ctx = NULL;
>>> +
>>>          do {
>>>                  struct io_wq_work_node *next = node->next;
>>>                  struct io_kiocb *req = container_of(node, struct 
>>> io_kiocb,
>>> @@ -2283,7 +2286,8 @@ static void handle_prior_tw_list(struct 
>>> io_wq_work_node *node, struct io_ring_ct
>>>                          ctx_flush_and_put(*ctx, locked);
>>>                          *ctx = req->ctx;
>>>                          /* if not contended, grab and improve 
>>> batching */
>>> -                       *locked = mutex_trylock(&(*ctx)->uring_lock);
>>> +                       *locked = false;
>>> +                       // *locked = mutex_trylock(&(*ctx)->uring_lock);
>> I believe this one is your debug code which I shouldn't take, should I?
> 
> Right, just for debug, helped to catch the issue. FWIW, it doesn't seem
> ctx_flush_and_put() is a good solution but was good enough to verify
> my assumptions.
How about a new compl_lock variable to indicate the completion_lock
state, which will make the complete_post() batching as large as possible.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5771489a980d..e17892183f82 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2231,36 +2231,34 @@ static inline void ctx_commit_and_unlock(struct 
io_ring_ctx *ctx)
  }

  static void handle_prior_tw_list(struct io_wq_work_node *node, struct 
io_ring_ctx **ctx,
-                                bool *locked)
+                                bool *uring_locked, bool *compl_locked)
  {
-       ctx_flush_and_put(*ctx, locked);
-       *ctx = NULL;
-
         do {
                 struct io_wq_work_node *next = node->next;
                 struct io_kiocb *req = container_of(node, struct io_kiocb,
                                                 ¦   io_task_work.node);

                 if (req->ctx != *ctx) {
-                       if (unlikely(!*locked) && *ctx)
+                       if (unlikely(*compl_locked)) {
                                 ctx_commit_and_unlock(*ctx);
-                       ctx_flush_and_put(*ctx, locked);
+                               *compl_locked = false;
+                       }
+                       ctx_flush_and_put(*ctx, uring_locked);
                         *ctx = req->ctx;
                         /* if not contended, grab and improve batching */
-                       *locked = mutex_trylock(&(*ctx)->uring_lock);
+                       *uring_locked = mutex_trylock(&(*ctx)->uring_lock);
                         percpu_ref_get(&(*ctx)->refs);
-                       if (unlikely(!*locked))
+                       if (unlikely(!*uring_locked)) {
                                 spin_lock(&(*ctx)->completion_lock);
+                               *compl_locked = true;
+                       }
                 }
-               if (likely(*locked))
-                       req->io_task_work.func(req, locked);
+               if (likely(*uring_locked))
+                       req->io_task_work.func(req, uring_locked);
                 else
                         __io_req_complete_post(req, req->result, 
io_put_rw_kbuf(req));
                 node = next;
         } while (node);
-
-       if (unlikely(!*locked) && *ctx)
-               ctx_commit_and_unlock(*ctx);
  }

  static void handle_tw_list(struct io_wq_work_node *node, struct 
io_ring_ctx **ctx, bool *locked)
@@ -2284,7 +2282,7 @@ static void handle_tw_list(struct io_wq_work_node 
*node, struct io_ring_ctx **ct

  static void tctx_task_work(struct callback_head *cb)
  {
-       bool locked = false;
+       bool uring_locked = false, compl_locked = false;
         struct io_ring_ctx *ctx = NULL;
         struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
                                                 ¦ task_work);
@@ -2293,7 +2291,7 @@ static void tctx_task_work(struct callback_head *cb)
                 struct io_wq_work_node *node1, *node2;

                 if (!tctx->task_list.first &&
-                   !tctx->prior_task_list.first && locked)
+                   !tctx->prior_task_list.first && uring_locked)
                         io_submit_flush_completions(ctx);

                 spin_lock_irq(&tctx->task_lock);
@@ -2308,14 +2306,18 @@ static void tctx_task_work(struct callback_head *cb)
                         break;

                 if (node1)
-                       handle_prior_tw_list(node1, &ctx, &locked);
+                       handle_prior_tw_list(node1, &ctx, &uring_locked, 
&compl_locked);

                 if (node2)
-                       handle_tw_list(node2, &ctx, &locked);
+                       handle_tw_list(node2, &ctx, &uring_locked);
                 cond_resched();
         }

-       ctx_flush_and_put(ctx, &locked);
+       if (unlikely(compl_locked)) {
+               ctx_commit_and_unlock(ctx);
+               compl_locked = false; // this may not be needed
+       }
+       ctx_flush_and_put(ctx, &uring_locked);
  }

  static void io_req_task_work_add(struct io_kiocb *req, bool priority)
@@ -2804,7 +2806,7 @@ static void io_complete_rw(struct kiocb *kiocb, 
long res)
                 return;
         req->result = res;
         req->io_task_work.func = io_req_task_complete;
-       io_req_task_work_add(req, true);
+       io_req_task_work_add(req, !!(req->ctx->flags & 
IORING_SETUP_SQPOLL));
  }

  static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
