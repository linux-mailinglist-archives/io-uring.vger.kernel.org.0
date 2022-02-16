Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91444B876D
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 13:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbiBPMOm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 07:14:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiBPMOl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 07:14:41 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DA22A229C
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 04:14:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V4d7eK5_1645013665;
Received: from 30.225.24.82(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V4d7eK5_1645013665)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 20:14:26 +0800
Message-ID: <f7f658cd-d76f-26c4-6549-0b3d2008d249@linux.alibaba.com>
Date:   Wed, 16 Feb 2022 20:14:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: napi_busy_poll
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
 <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
 <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
 <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
 <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
 <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
 <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/2/16 上午2:05, Olivier Langlois 写道:
> On Tue, 2022-02-15 at 03:37 -0500, Olivier Langlois wrote:
>>
>> That being said, I have not been able to make it work yet. For some
>> unknown reasons, no valid napi_id is extracted from the sockets added
>> to the context so the net_busy_poll function is never called.
>>
>> I find that very strange since prior to use io_uring, my code was
>> using
>> epoll and the busy polling was working fine with my application
>> sockets. Something is escaping my comprehension. I must tired and
>> this
>> will become obvious...
>>
> The napi_id values associated with my sockets appear to be in the range
> 0 < napi_id < MIN_NAPI_ID
> 
> from busy_loop.h:
> /*		0 - Reserved to indicate value not set
>   *     1..NR_CPUS - Reserved for sender_cpu
>   *  NR_CPUS+1..~0 - Region available for NAPI IDs
>   */
> #define MIN_NAPI_ID ((unsigned int)(NR_CPUS + 1))
> 
> I have found this:
> https://lwn.net/Articles/619862/
> 
> hinting that busy_poll may be incompatible with RPS
> (Documentation/networking/scaling.rst) that I may have discovered
> *AFTER* my epoll -> io_uring transition (I don't recall exactly the
> sequence of my learning process).
> 
> With my current knowledge, it makes little sense why busy polling would
> not be possible with RPS. Also, what exactly is a NAPI device is quite
> nebulous to me... Looking into the Intel igb driver code, it seems like
> 1 NAPI device is created for each interrupt vector/Rx buffer of the
> device.
> 
> Bottomline, it seems like I have fallen into a new rabbit hole. It may
> take me a day or 2 to figure it all... you are welcome to enlight me if
> you know a thing or 2 about those topics... I am kinda lost right
> now...
> 
Hi Olivier,
I've write something to express my idea, it would be great if you can
try it.
It's totally untested and only does polling in sqthread, won't be hard
to expand it to cqring_wait. My original idea is to poll all the napi
device but seems that may be not efficient. so for a request, just
do napi polling for one napi.
There is still one problem: when to delete the polled NAPIs.

Regards,
Hao

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 538f90bd0508..2e32d5fe0641 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -63,6 +63,7 @@
  #include <net/sock.h>
  #include <net/af_unix.h>
  #include <net/scm.h>
+#include <net/busy_poll.h>
  #include <linux/anon_inodes.h>
  #include <linux/sched/mm.h>
  #include <linux/uaccess.h>
@@ -443,6 +444,7 @@ struct io_ring_ctx {
                 spinlock_t                      rsrc_ref_lock;
         };

+       struct list_head                napi_list;
         /* Keep this last, we don't need it for the fast path */
         struct {
                 #if defined(CONFIG_UNIX)
@@ -1457,6 +1459,7 @@ static __cold struct io_ring_ctx 
*io_ring_ctx_alloc(struct io_uring_params *p)
         INIT_WQ_LIST(&ctx->locked_free_list);
         INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
         INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+       INIT_LIST_HEAD(&ctx->napi_list);
         return ctx;
  err:
         kfree(ctx->dummy_ubuf);
@@ -5419,6 +5422,70 @@ IO_NETOP_FN(send);
  IO_NETOP_FN(recv);
  #endif /* CONFIG_NET */

+#ifdef CONFIG_NET_RX_BUSY_POLL
+struct napi_entry {
+       struct list_head        list;
+       unsigned int            napi_id;
+};
+
+static void io_add_napi(struct file *file, struct io_ring_ctx *ctx)
+{
+       unsigned int napi_id;
+       struct socket *sock;
+       struct sock *sk;
+       struct napi_entry *ne;
+
+       if (!net_busy_loop_on())
+               return;
+
+       sock = sock_from_file(file);
+       if (!sock)
+               return;
+
+       sk = sock->sk;
+       if (!sk)
+               return;
+
+       napi_id = READ_ONCE(sk->sk_napi_id);
+       if (napi_id < MIN_NAPI_ID)
+               return;
+
+       list_for_each_entry(ne, &ctx->napi_list, list) {
+               if (ne->napi_id == napi_id)
+                       return;
+       }
+
+       ne = kmalloc(sizeof(*ne), GFP_KERNEL);
+       if (!ne)
+               return;
+
+       list_add_tail(&ne->list, &ctx->napi_list);
+}
+
+static void io_napi_busy_loop(struct io_ring_ctx *ctx)
+{
+       struct napi_entry *ne;
+
+       if (list_empty(&ctx->napi_list) || !net_busy_loop_on())
+               return;
+
+       list_for_each_entry(ne, &ctx->napi_list, list)
+               napi_busy_loop(ne->napi_id, NULL, NULL, false, 
BUSY_POLL_BUDGET);
+}
+#else
+
+static inline void io_add_napi(struct file *file, struct io_ring_ctx *ctx)
+{
+       return;
+}
+
+static inline void io_napi_busy_loop(struct io_ring_ctx *ctx)
+{
+       return;
+}
+#endif /* CONFIG_NET_RX_BUSY_POLL */
+
+
  struct io_poll_table {
         struct poll_table_struct pt;
         struct io_kiocb *req;
@@ -5583,6 +5650,7 @@ static void io_poll_task_func(struct io_kiocb 
*req, bool *locked)
         struct io_ring_ctx *ctx = req->ctx;
         int ret;

+       io_add_napi(req->file, req->ctx);
         ret = io_poll_check_events(req);
         if (ret > 0)
                 return;
@@ -5608,6 +5676,7 @@ static void io_apoll_task_func(struct io_kiocb 
*req, bool *locked)
         struct io_ring_ctx *ctx = req->ctx;
         int ret;

+       io_add_napi(req->file, req->ctx);
         ret = io_poll_check_events(req);
         if (ret > 0)
                 return;
@@ -7544,6 +7613,9 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, 
bool cap_entries)
                         wake_up(&ctx->sqo_sq_wait);
                 if (creds)
                         revert_creds(creds);
+#ifdef CONFIG_NET_RX_BUSY_POLL
+               io_napi_busy_loop(ctx);
+#endif
         }

         return ret;

