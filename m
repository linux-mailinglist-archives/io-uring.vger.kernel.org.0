Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C08426AF1
	for <lists+io-uring@lfdr.de>; Fri,  8 Oct 2021 14:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241654AbhJHMiq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Oct 2021 08:38:46 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:37538 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230204AbhJHMip (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Oct 2021 08:38:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ur.V7Wc_1633696602;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ur.V7Wc_1633696602)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Oct 2021 20:36:49 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.16 0/2] async hybrid, a new way for pollable requests
Date:   Fri,  8 Oct 2021 20:36:40 +0800
Message-Id: <20211008123642.229338-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

this is a new feature for pollable requests, see detail in commit
message.


Hao Xu (2):
  io_uring: add IOSQE_ASYNC_HYBRID flag for pollable requests
  io_uring: implementation of IOSQE_ASYNC_HYBRID logic

 fs/io_uring.c                 | 48 +++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |  4 ++-
 2 files changed, 46 insertions(+), 6 deletions(-)

-- 
2.24.4

