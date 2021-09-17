Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ECE40FFE7
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 21:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343489AbhIQTjy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 15:39:54 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:53919 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236021AbhIQTjt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 15:39:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoidwXr_1631907500;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoidwXr_1631907500)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 03:38:25 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [RFC 0/5] leverage completion cache for poll requests
Date:   Sat, 18 Sep 2021 03:38:15 +0800
Message-Id: <20210917193820.224671-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1st is a non-related code clean
2nd ~ 4th are fixes.
5th is the the main logic, I tested it with an echo-server, both in
single-shot mode and multishot mode poll, not much difference compared
to code before with regard to req/s. But that may be resulted from my
poor network knowledge, feel free to test it and leave comments.

Hao Xu (5):
  io_uring: return boolean value for io_alloc_async_data
  io_uring: code clean for io_poll_complete()
  io_uring: fix race between poll completion and cancel_hash insertion
  io_uring: fix lacking of EPOLLONESHOT
  io_uring: leverage completion cache for poll requests

 fs/io_uring.c | 70 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 17 deletions(-)

-- 
2.24.4

