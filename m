Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1CA416ACB
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 06:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbhIXEX7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 00:23:59 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:33176 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229853AbhIXEX7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 00:23:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UpOc.4M_1632457344;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UpOc.4M_1632457344)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Sep 2021 12:22:25 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH v2 0/2] improvements for poll requests
Date:   Fri, 24 Sep 2021 12:22:22 +0800
Message-Id: <20210924042224.8061-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Echo_server codes can be clone from:
https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git
branch is xiaoguangwang/io_uring_multishot. There is a simple HOWTO
in this repository.

Usage:
In server: port 10016, 1000 connections, packet size 16 bytes, and
enable fixed files.
  taskset -c 10 io_uring_echo_server_multi_shot  -f -p 10016 -n 1000 -l 16

In client:
  taskset -c 13,14,15,16 ./echo -addr 11.238.147.21:10016 -n 1000 -size 16

Before this patchset, the tps is like below:
1:15:53 req: 1430425, req/s: 286084.693
11:15:58 req: 1426021, req/s: 285204.079
11:16:03 req: 1416761, req/s: 283352.146
11:16:08 req: 1417969, req/s: 283165.637
11:16:13 req: 1424591, req/s: 285349.915
11:16:18 req: 1418706, req/s: 283738.725
11:16:23 req: 1411988, req/s: 282399.052
11:16:28 req: 1419097, req/s: 283820.477
11:16:33 req: 1417816, req/s: 283563.262
11:16:38 req: 1422461, req/s: 284491.702
11:16:43 req: 1418176, req/s: 283635.327
11:16:48 req: 1414525, req/s: 282905.276
11:16:53 req: 1415624, req/s: 283124.140
11:16:58 req: 1426435, req/s: 284970.486

with this patchset:
2021/09/24 11:10:01 start to do client
11:10:06 req: 1444979, req/s: 288995.300
11:10:11 req: 1442559, req/s: 288511.689
11:10:16 req: 1427253, req/s: 285450.390
11:10:21 req: 1445236, req/s: 288349.853
11:10:26 req: 1423949, req/s: 285480.941
11:10:31 req: 1445304, req/s: 289060.815
11:10:36 req: 1441036, req/s: 288207.119
11:10:41 req: 1441117, req/s: 288220.695
11:10:46 req: 1441451, req/s: 288292.731
11:10:51 req: 1438801, req/s: 287759.157
11:10:56 req: 1433227, req/s: 286646.338
11:11:01 req: 1438307, req/s: 287661.577

about 1.3% tps improvements.

Changes in v2:
  I dropped the poll request completion batching patch in V1, since
it shows performance fluctuations, hard to say whether it's useful.

Xiaoguang Wang (2):
  io_uring: reduce frequent add_wait_queue() overhead for multi-shot
    poll request
  io_uring: don't get completion_lock in io_poll_rewait()

 fs/io_uring.c | 66 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

-- 
2.14.4.44.g2045bb6

