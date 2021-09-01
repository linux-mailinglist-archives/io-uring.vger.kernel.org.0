Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22F33FD781
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 12:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhIAKTm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 06:19:42 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:51920 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232662AbhIAKTi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 06:19:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UmvU9H3_1630491513;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmvU9H3_1630491513)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Sep 2021 18:18:40 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 0/2] refactor sqthread cpu binding logic
Date:   Wed,  1 Sep 2021 18:18:31 +0800
Message-Id: <20210901101833.69535-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset is to enhance sqthread cpu binding logic, we didn't
consider cgroup setting before. In container environment, theoretically
sqthread is in its container's task group, it shouldn't occupy cpu out
of its container. Otherwise it may cause some problems, for example:
resource balancer may controll cpu resource allocation by a container's
current cpu usage, here sqthread should be counted in.

v1-->v2
 - add helper to do cpu in current-cpuset test

v2-->v3
 - split it to 2 patches, first as prep one, second as comsumer
 - remove warnning, since cpuset may change anytime, we cannot catch
   all cases, so make the behaviour consistent.

Hao Xu (2):
  cpuset: add a helper to check if cpu in cpuset of current task
  io_uring: consider cgroup setting when binding sqpoll cpu

 fs/io_uring.c          | 19 ++++++++++++++-----
 include/linux/cpuset.h |  7 +++++++
 kernel/cgroup/cpuset.c | 11 +++++++++++
 3 files changed, 32 insertions(+), 5 deletions(-)

-- 
2.24.4

