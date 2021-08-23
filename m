Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A7B3F43D7
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 05:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhHWD0C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 23:26:02 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:43814 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230474AbhHWDZ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 23:25:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UlAN5vv_1629689106;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UlAN5vv_1629689106)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 23 Aug 2021 11:25:14 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.15 v2 0/2] fix failed linkchain code logic
Date:   Mon, 23 Aug 2021 11:25:04 +0800
Message-Id: <20210823032506.34857-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

the first patch is code clean.
the second is the main one, which refactors linkchain failure path to
fix a problem, detail in the commit message.

v1-->v2
 - update patch with Pavel's suggestion.

Hao Xu (2):
  io_uring: remove redundant req_set_fail()
  io_uring: fix failed linkchain code logic

 fs/io_uring.c | 60 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 16 deletions(-)

-- 
2.24.4

