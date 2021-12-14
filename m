Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12493473CCE
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 06:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhLNF5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 00:57:43 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:57406 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhLNF5m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 00:57:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-b..w5_1639461454;
Received: from localhost.localdomain(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-b..w5_1639461454)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Dec 2021 13:57:40 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [POC RFC 0/3] support graph like dependent sqes
Date:   Tue, 14 Dec 2021 13:57:31 +0800
Message-Id: <20211214055734.61702-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a proof of concept which is incompleted, send it early for
thoughts and suggestions.

We already have IOSQE_IO_LINK to describe linear dependency
relationship sqes. While this patchset provides a new feature to
support DAG dependency. For instance, 4 sqes have a relationship
as below:
      --> 2 --
     /        \
1 ---          ---> 4
     \        /
      --> 3 --
IOSQE_IO_LINK serializes them to 1-->2-->3-->4, which unneccessarily
serializes 2 and 3. But a DAG can fully describe it.

For the detail usage, see the following patches' messages.

Tested it with 100 direct read sqes, each one reads a BS=4k block data
in a same file, blocks are not overlapped. These sqes form a graph:
      2
      3
1 --> 4 --> 100
     ...
      99

This is an extreme case, just to show the idea.

results below:
io_link:
IOPS: 15898251
graph_link:
IOPS: 29325513
io_link:
IOPS: 16420361
graph_link:
IOPS: 29585798
io_link:
IOPS: 18148820
graph_link:
IOPS: 27932960

Tested many times, numbers are not very stable but shows the difference.

something to concern:
1. overhead to the hot path: several IF checks
2. many memory allocations
3. many atomic_read/inc/dec stuff

many things to be done:
1. cancellation, failure path
2. integrate with other features.
3. maybe need some cache design to overcome the overhead of memory
   allcation
4. some thing like topological sorting to avoid rings in the graph

Any thoughts?

Hao Xu (3):
  io_uring: add data structure for graph sqe feature
  io_uring: implement new sqe opcode to build graph like links
  io_uring: implement logic of IOSQE_GRAPH request

 fs/io_uring.c                 | 231 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   9 ++
 2 files changed, 235 insertions(+), 5 deletions(-)

-- 
2.25.1

