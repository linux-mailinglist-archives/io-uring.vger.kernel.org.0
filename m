Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEF130DD67
	for <lists+io-uring@lfdr.de>; Wed,  3 Feb 2021 16:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhBCO7Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Feb 2021 09:59:25 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:33617 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232322AbhBCO67 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Feb 2021 09:58:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNmPdAz_1612364276;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNmPdAz_1612364276)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 22:58:04 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 0/2] fix deadlock in __io_req_task_submit()
Date:   Wed,  3 Feb 2021 22:57:54 +0800
Message-Id: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset is to fix a deadlock issue in __io_req_task_submit(), the
first patch is a prep one and the second patch does the work.

Hao Xu (2):
  io_uring: add uring_lock as an argument to io_sqe_files_unregister()
  io_uring: don't hold uring_lock when calling io_run_task_work*

 fs/io_uring.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

-- 
1.8.3.1

