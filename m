Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D96040389F
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhIHLUN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 07:20:13 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:28481 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349071AbhIHLUE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 07:20:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UnhKikw_1631099920;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnhKikw_1631099920)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Sep 2021 19:18:41 +0800
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Subject: Question about async_wake
Cc:     io-uring@vger.kernel.org
Message-ID: <e65f822b-419d-4555-21e8-54e11bf294b2@linux.alibaba.com>
Date:   Wed, 8 Sep 2021 19:18:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens, Pavel,
I have a question about _async_wake(), would there be cases like
this:
    async_cancel/poll_remove           interrupt
      spin_lock_irq()
list del poll->wait_entry         event happens but irq disabled
                                   so interrupt delays
     spin_unlock_irq()
       generate cqe
                                   async_wake() called and
                                   generate cqe

If it exists, there may be multiple -ECANCELED cqes for one req,
we may do something like this to avoid it:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 30d959416eba..7822b2f9e890 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5023,9 +5023,12 @@ static int __io_async_wake(struct io_kiocb *req, 
struct io_poll_iocb *poll,
         if (mask && !(mask & poll->events))
                 return 0;

-       trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, 
mask);
+       if (list_empty(&poll->wait.entry))
+               return 0;
+       else
+               list_del_init(&poll->wait.entry);

-       list_del_init(&poll->wait.entry);
+       trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, 
mask);

         req->result = mask;
         req->io_task_work.func = func;
