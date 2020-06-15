Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660A71F9C7C
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 18:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgFOQCj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 12:02:39 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60120 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727785AbgFOQCj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 12:02:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U.i1GmH_1592236956;
Received: from 30.8.168.89(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.i1GmH_1592236956)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Jun 2020 00:02:36 +0800
To:     io-uring <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        joseph qi <joseph.qi@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: race between REQ_F_NEED_CLEANUP and
 io_complete_rw_iopoll,io_complete_rw
Message-ID: <4e043e31-f993-b230-b394-447af6b0a37d@linux.alibaba.com>
Date:   Tue, 16 Jun 2020 00:02:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

After looking into more codes, I guess there will be more races between
REQ_F_NEED_CLEANUP and io_complete_rw_iopoll/io_complete_rw.
In the end of io_read() or io_write(), there are such below codes:
     req->flags &= ~REQ_F_NEED_CLEANUP;
     kfree(iovec);
     return ret;

When "req->flags &= ~REQ_F_NEED_CLEANUP" is executed, io request may also
have been completed, then there will be many req->flags modifications called
by io_complete_rw_iopoll() or io_complete_rw(), such as req_set_fail_links(req),
req->flags |= REQ_F_OVERFLOW in __io_cqring_fill_event(). All these races can
introduce severe bugs.

I wonder below patch whether can fix these races:
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 13e24a6137d5..3bab6b414864 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2654,8 +2654,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
                 }
         }
  out_free:
-       kfree(iovec);
-       req->flags &= ~REQ_F_NEED_CLEANUP;
+       if (!(req->flags & REQ_F_NEED_CLEANUP))
+               kfree(iovec);
         return ret;
  }

If REQ_F_NEED_CLEANUP is set, we always make __io_req_aux_free() do the cleanup work.


Regards,
Xiaoguang Wang
