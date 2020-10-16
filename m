Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F744290044
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 10:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405240AbgJPI4k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 04:56:40 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:46234 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405239AbgJPI4k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 04:56:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UCBgXw9_1602838598;
Received: from 30.225.32.194(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UCBgXw9_1602838598)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 16 Oct 2020 16:56:38 +0800
To:     io-uring <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Question about patch "io_uring: add submission polling"
Message-ID: <635218e1-da08-4ab5-7a95-fb74de46c741@linux.alibaba.com>
Date:   Fri, 16 Oct 2020 16:55:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi£¬

I have questions about below code comments, which was included in patch
"io_uring: add submission polling",
------------------------------------------------------------
     /*
      * Drop cur_mm before scheduling, we can't hold it for
      * long periods (or over schedule()). Do this before
      * adding ourselves to the waitqueue, as the unuse/drop
      * may sleep.
      */
     if (cur_mm) {
             unuse_mm(cur_mm);
             mmput(cur_mm);
             cur_mm = NULL;
     }

     prepare_to_wait(&ctx->sqo_wait, &wait, TASK_INTERRUPTIBLE);
-------------------------------------------------------------
Stefano submited a patch "io_uring: prevent sq_thread from spinning when it should stop",
I understand what issue Stefano fixed, but don't understand below comments.

Can anyone help to explain why we need to rop cur_mm before scheduling, or
why we can't hold it for long periods (or over schedule()), and if we
unuse/drop mm after adding ourselves to the waitqueue, what issue will
happen when unuse/drop sleeps, thanks.

Regards,
Xiaoguang Wang
