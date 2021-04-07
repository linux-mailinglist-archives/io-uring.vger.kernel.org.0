Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0C3356B0D
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 13:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbhDGLX4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 07:23:56 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:44570 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234656AbhDGLXm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 07:23:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUnhk8L_1617794605;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUnhk8L_1617794605)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Apr 2021 19:23:31 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5.13 v2] io_uring: maintain drain requests' logic
Date:   Wed,  7 Apr 2021 19:23:22 +0800
Message-Id: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

more tests comming, send this out first for comments.

Hao Xu (3):
  io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot requests
  io_uring: maintain drain logic for multishot requests
  io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD

 fs/io_uring.c                 | 34 +++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  8 +++-----
 2 files changed, 32 insertions(+), 10 deletions(-)

-- 
1.8.3.1

