Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A247845BCBE
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 13:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbhKXMcG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 07:32:06 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:38161 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245311AbhKXMZT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 07:25:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy7GZoS_1637756522;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy7GZoS_1637756522)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 20:22:08 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v5 0/6] task work optimization
Date:   Wed, 24 Nov 2021 20:21:56 +0800
Message-Id: <20211124122202.218756-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v4->v5
- change the implementation of merge_wq_list

Hao Xu (6):
  io-wq: add helper to merge two wq_lists
  io_uring: add a priority tw list for irq completion work
  io_uring: add helper for task work execution code
  io_uring: split io_req_complete_post() and add a helper
  io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
  io_uring: batch completion in prior_task_list

 fs/io-wq.h    |  22 +++++++
 fs/io_uring.c | 158 +++++++++++++++++++++++++++++++++-----------------
 2 files changed, 128 insertions(+), 52 deletions(-)

-- 
2.24.4

