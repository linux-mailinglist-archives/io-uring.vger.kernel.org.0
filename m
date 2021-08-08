Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CBA3E39D4
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 12:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhHHKNN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Aug 2021 06:13:13 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:50207 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229679AbhHHKNN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Aug 2021 06:13:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UiISL52_1628417568;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UiISL52_1628417568)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 08 Aug 2021 18:12:53 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 0/3] code clean and nr_worker fixes
Date:   Sun,  8 Aug 2021 18:12:44 +0800
Message-Id: <20210808101247.189083-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v1-->v2
  - fix bug of creating io-wokers unconditionally
  - fix bug of no nr_running and worker_ref decrementing when fails
  - fix bug of setting IO_WORKER_BOUND_FIXED incorrectly.

Hao Xu (3):
  io-wq: fix no lock protection of acct->nr_worker
  io-wq: fix lack of acct->nr_workers < acct->max_workers judgement
  io-wq: fix IO_WORKER_F_FIXED issue in create_io_worker()

 fs/io-wq.c | 52 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 10 deletions(-)

-- 
2.24.4

