Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4537C4145E4
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 12:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhIVKOd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 06:14:33 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:49298 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234817AbhIVKOR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 06:14:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpDsdJl_1632305558;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpDsdJl_1632305558)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Sep 2021 18:12:45 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 0/3] poll fixes
Date:   Wed, 22 Sep 2021 18:12:35 +0800
Message-Id: <20210922101238.7177-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Three poll fixes.

Hao Xu (3):
  io_uring: fix race between poll completion and cancel_hash insertion
  io_uring: fix lacking of EPOLLONESHOT
  io_uring: fix potential req refcount underflow

 fs/io_uring.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

-- 
2.24.4

