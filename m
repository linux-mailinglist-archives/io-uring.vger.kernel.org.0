Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC613E9D3A
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 06:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhHLEPM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 00:15:12 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58385 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhHLEPL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 00:15:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UikT1XN_1628741676;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UikT1XN_1628741676)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Aug 2021 12:14:45 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.15 0/3] small code clean
Date:   Thu, 12 Aug 2021 12:14:33 +0800
Message-Id: <20210812041436.101503-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some small code clean.

Hao Xu (3):
  io_uring: extract io_uring_files_cancel() in io_uring_task_cancel()
  io_uring: remove files pointer in cancellation functions
  io_uring: code clean for completion_lock in io_arm_poll_handler()

 fs/io_uring.c            | 15 ++++++---------
 include/linux/io_uring.h |  9 +++++----
 kernel/exit.c            |  2 +-
 3 files changed, 12 insertions(+), 14 deletions(-)

-- 
2.24.4

