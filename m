Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E1407E91
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhILQZH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 12:25:07 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:34834 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhILQZH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 12:25:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uo4H3xv_1631463825;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo4H3xv_1631463825)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Sep 2021 00:23:51 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 0/2] poll fixes
Date:   Mon, 13 Sep 2021 00:23:43 +0800
Message-Id: <20210912162345.51651-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two fixes about poll.

Hao Xu (2):
  io_uring: fix tw list mess-up by adding tw while it's already in tw
    list
  io_uring: fix race between poll completion and cancel_hash insertion

 fs/io_uring.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
2.24.4

