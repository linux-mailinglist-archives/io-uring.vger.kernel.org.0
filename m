Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFDB729A1A
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbjFIMeG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjFIMeF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:34:05 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666F930FD
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:33:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4QUpu+B3zyPMmOmmHqxZyuzGpgT2iJe7tXWq73uhRWg=;
        b=Hzxzp/yre4ogNKk2/gJ79rAj/jUHAM+xJ//6o5K+47BNRYc2nmULwFHcNxCR34iXCMOF0n
        /vIRFzwOnzpsDkxH9SVr32svxE/4lLj2mtmGgtBCYnC6rYiJ+9b4UJn7B9WSDM6Twn5rLT
        wPmI+kTbRLUtk4K7DXiu17GA132nvUA=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 00/11] fixed worker
Date:   Fri,  9 Jun 2023 20:20:20 +0800
Message-Id: <20230609122031.183730-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

The initial feature request by users is here:
https://github.com/axboe/liburing/issues/296

Fixed worker provide a way for users to control the io-wq threads. A
fixed worker is worker thread which exists no matter there are works
to do or not. We provide a new register api to register fixed workers,
and a register api to unregister them as well. The parameter of the
register api is the number of fixed workers users want.

For example:

```c
io_uring_register_iowq_fixed_workers(&ring, { .nr_workers = 5 })
do I/O works
io_uring_unregister_iowq_fixed_workers(&ring)

```

After registration, there will be 5 fixed workers. User can setup their
affinity, priority etc. freely, without adding any new register api to
set up attributions. These workers won't be destroyed until users call
unregister api.

Note, registering some fixed workers doesn't mean no creating normal
workers. When there is no free workers, new normal workers can be
created when works come. So a work may be picked up by fixed workers or
normal workers.

If users want to offload works only to fixed workers, they can specify
a flag FIXED_ONLY when registering fixed workers.

```c
io_uring_register_iowq_fixed_workers(&ring, { .nr_workers = 5, .flags |=
FIXED_ONLY })

```

In above case, no normal workers will be created before calling
io_uring_register_iowq_fixed_workers().

Note:
 - When registering fixed workers, those fixed workers are per io-wq.
   So if an io_uring instance is shared by multiple tasks, and you want
   all tasks to use fixed workers, all tasks have to call the regitser
   api.
 - if specifying FIXED_ONLY when registering fixed workers, that is per
   io_uring instance. all works in this instance are handled by fixed
   workers.

Therefore, if an io_uring instance is shared by two tasks, and you want
all requests in this instance to be handled only by fixed workers, you
have to call the register api in these two tasks and specify FIXED_ONLY
at least once when calling register api.


Hao Xu (11):
  io-wq: fix worker counting after worker received exit signal
  io-wq: add a new worker flag to indicate worker exit
  io-wq: add a new type io-wq worker
  io-wq: add fixed worker members in io_wq_acct
  io-wq: add a new parameter for creating a new fixed worker
  io-wq: return io_worker after successful inline worker creation
  io_uring: add new api to register fixed workers
  io_uring: add function to unregister fixed workers
  io-wq: add strutures to allow to wait fixed workers exit
  io-wq: distinguish fixed worker by its name
  io_uring: add IORING_SETUP_FIXED_WORKER_ONLY and its friend

 include/uapi/linux/io_uring.h |  20 +++
 io_uring/io-wq.c              | 275 ++++++++++++++++++++++++++++++----
 io_uring/io-wq.h              |   3 +
 io_uring/io_uring.c           | 132 +++++++++++++++-
 4 files changed, 397 insertions(+), 33 deletions(-)

-- 
2.25.1

