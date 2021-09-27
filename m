Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A046141945F
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 14:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhI0Mhr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 08:37:47 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:43850 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234261AbhI0Mhr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 08:37:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpooWsS_1632746160;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpooWsS_1632746160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 20:36:07 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 0/2] fixes of poll
Date:   Mon, 27 Sep 2021 20:35:58 +0800
Message-Id: <20210927123600.234405-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two fixes to address poll issues.

Hao Xu (2):
  io_uring: fix concurrent poll interruption
  io_uring: fix tw list mess-up by adding tw while it's already in tw
    list

 fs/io_uring.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

-- 
2.24.4

