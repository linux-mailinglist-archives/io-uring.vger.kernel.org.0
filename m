Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4895C3EFE04
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 09:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbhHRHn5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 03:43:57 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43866 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238014AbhHRHn5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 03:43:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UjeejBw_1629272596;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UjeejBw_1629272596)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Aug 2021 15:43:21 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.15 0/3] fix failed linkchain code logic
Date:   Wed, 18 Aug 2021 15:43:13 +0800
Message-Id: <20210818074316.22347-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

the first and last patch are code clean.
the second is the main one, which refactors linkchain failure path to
fix a problem, detail in the commit message.

Hao Xu (3):
  io_uring: remove redundant req_set_fail()
  io_uring: fix failed linkchain code logic
  io_uring: move fail path of request submittion to the end

 fs/io_uring.c | 97 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 33 deletions(-)

-- 
2.24.4

