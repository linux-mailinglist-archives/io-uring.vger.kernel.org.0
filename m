Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915B845D71F
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 10:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354118AbhKYJ0V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 04:26:21 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:60007 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347547AbhKYJYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 04:24:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyFCEEt_1637832063;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyFCEEt_1637832063)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 17:21:08 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.17 0/2] small fix and code clean
Date:   Thu, 25 Nov 2021 17:21:01 +0800
Message-Id: <20211125092103.224502-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hao Xu (2):
  io_uring: fix no lock protection for ctx->cq_extra
  io_uring: better to use REQ_F_IO_DRAIN for req->flags

 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.24.4

