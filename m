Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9BA431751
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 13:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhJRLbm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 07:31:42 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56169 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230493AbhJRLbl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 07:31:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Usdq2Cm_1634556563;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Usdq2Cm_1634556563)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 19:29:29 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 0/2] async hybrid for pollable requests
Date:   Mon, 18 Oct 2021 19:29:21 +0800
Message-Id: <20211018112923.16874-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/2 is a prep patch. 2/2 is the main one.
The good thing: see commit message.
the side effect: for normal io-worker path, added two if and two local
variables. for FORCE_ASYNC path, added three if and several dereferences

I think it is fine since the io-worker path is not the fast path, and
the benefit of this patchset is worth it.

Btw, we need to tweak the io-cancel.c a bit, not a big problem.
liburing tests will come later.

v1-->v2:
 - split logic of force_nonblock
 - tweak added code in io_wq_submit_work to reduce overhead
 from Pavel's commments.

Hao Xu (2):
  io_uring: split logic of force_nonblock
  io_uring: implement async hybrid mode for pollable requests

 fs/io_uring.c                 | 85 ++++++++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |  4 +-
 2 files changed, 66 insertions(+), 23 deletions(-)

-- 
2.24.4

