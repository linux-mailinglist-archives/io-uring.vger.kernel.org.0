Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5BD39A197
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 14:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhFCMzo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 08:55:44 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:38584 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229950AbhFCMzo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 08:55:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Ub9lXwA_1622724837;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ub9lXwA_1622724837)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Jun 2021 20:53:58 +0800
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Hao Xu <haoxu@linux.alibaba.com>
Subject: Question about poll_multi_file
Message-ID: <e90a3bdd-d60c-9b82-e711-c7a0b4f32c09@linux.alibaba.com>
Date:   Thu, 3 Jun 2021 20:53:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
I've a question about poll_multi_file in io_do_iopoll().
It keeps spinning in f_op->iopoll() if poll_multi_file is
true (and we're under the requested amount). But in my
understanding, reqs may be in different hardware queues
for blk-mq device even in this situation.
Should we consider the hardware queue number as well? Some
thing like below:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7b0e6bc9ea3d..479a75022449 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2533,10 +2533,13 @@ static void io_iopoll_req_issued(struct io_kiocb 
*req, bool in_async)
                 ctx->poll_multi_file = false;
         } else if (!ctx->poll_multi_file) {
                 struct io_kiocb *list_req;
+               unsigned int queue_num0, queue_num1;

                 list_req = list_first_entry(&ctx->iopoll_list, struct 
io_kiocb,
                                                 inflight_entry);
-               if (list_req->file != req->file)
+               queue_num0 = 
blk_qc_t_to_queue_num(list_req->rw.kiocb.ki_cookie);
+               queue_num1 = blk_qc_t_to_queue_num(req->rw.kiocb.ki_cookie);
+               if (list_req->file != req->file || queue_num0 != queue_num1)
                         ctx->poll_multi_file = true;
         }
