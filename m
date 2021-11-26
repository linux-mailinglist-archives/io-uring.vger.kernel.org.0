Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2301345EB10
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 11:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhKZKNA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 05:13:00 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:35372 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376602AbhKZKLA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 05:11:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyM4V-6_1637921260;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyM4V-6_1637921260)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 18:07:46 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v6 0/6] task work optimization
Date:   Fri, 26 Nov 2021 18:07:34 +0800
Message-Id: <20211126100740.196550-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
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


Hao Xu (6):
  io-wq: add helper to merge two wq_lists
  io_uring: add a priority tw list for irq completion work
  io_uring: add helper for task work execution code
  io_uring: split io_req_complete_post() and add a helper
  io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
  io_uring: batch completion in prior_task_list

 fs/io-wq.h    |  22 +++++++
 fs/io_uring.c | 168 ++++++++++++++++++++++++++++++++++----------------
 2 files changed, 136 insertions(+), 54 deletions(-)

-- 
2.24.4

