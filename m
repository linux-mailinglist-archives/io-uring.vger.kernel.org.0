Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8269A3F97A3
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbhH0Jrt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 05:47:49 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:33619 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245118AbhH0JrQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 05:47:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UmFsqUh_1630057569;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmFsqUh_1630057569)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 27 Aug 2021 17:46:26 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.15 v3 0/2] fix failed linkchain code logic
Date:   Fri, 27 Aug 2021 17:46:07 +0800
Message-Id: <20210827094609.36052-1-haoxu@linux.alibaba.com>
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
v2-->v3
 - move req->result initiation to better place
 - add helpers for failing link node

Hao Xu (2):
  io_uring: remove redundant req_set_fail()
  io_uring: fix failed linkchain code logic

 fs/io_uring.c | 62 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 15 deletions(-)

-- 
2.24.4

