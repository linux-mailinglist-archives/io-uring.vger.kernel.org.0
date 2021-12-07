Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE61846B79C
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 10:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhLGJna (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 04:43:30 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:6283 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229461AbhLGJna (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 04:43:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzkVFio_1638869991;
Received: from hao-A29R.hz.ali.com(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzkVFio_1638869991)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Dec 2021 17:39:58 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v7 0/5] task optimization
Date:   Tue,  7 Dec 2021 17:39:46 +0800
Message-Id: <20211207093951.247840-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v4->v5
- change the implementation of merge_wq_list

v5->v6
- change the logic of handling prior task list to:
  1) grabbed uring_lock: leverage the inline completion infra
  2) otherwise: batch __req_complete_post() calls to save
     completion_lock operations.

v6->v7
- add Pavel's fix of wrong spin unlock
- remove a patch and rebase work

Hao Xu (5):
  io-wq: add helper to merge two wq_lists
  io_uring: add a priority tw list for irq completion work
  io_uring: add helper for task work execution code
  io_uring: split io_req_complete_post() and add a helper
  io_uring: batch completion in prior_task_list

 fs/io-wq.h    |  22 ++++++++
 fs/io_uring.c | 142 ++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 126 insertions(+), 38 deletions(-)

-- 
2.25.1

