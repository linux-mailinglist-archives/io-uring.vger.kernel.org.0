Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B93643FC3E
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhJ2MZR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 08:25:17 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:41341 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230273AbhJ2MZP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 08:25:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uu9pzWg_1635510157;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uu9pzWg_1635510157)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 20:22:45 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.16 v4 0/6] task work optimization
Date:   Fri, 29 Oct 2021 20:22:31 +0800
Message-Id: <20211029122237.164312-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v3->v4
- remove 8/8 in v3
- remove nr_ctx
- insert a TW to the priority tw list only in sqpoll mode
- optimise the priority tw list handling logic to be compatible for
  multiple ctx case

Hao Xu (6):
  io-wq: add helper to merge two wq_lists
  io_uring: add a priority tw list for irq completion work
  io_uring: add helper for task work execution code
  io_uring: split io_req_complete_post() and add a helper
  io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
  io_uring: batch completion in prior_task_list

 fs/io-wq.h    |  21 +++++++
 fs/io_uring.c | 160 ++++++++++++++++++++++++++++++++++----------------
 2 files changed, 130 insertions(+), 51 deletions(-)

-- 
2.24.4

