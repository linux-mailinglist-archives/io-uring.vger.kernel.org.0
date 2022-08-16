Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEDB595F59
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbiHPPi4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 11:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbiHPPiT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 11:38:19 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FD5C2
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 08:37:46 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GBVjDs020558
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 08:37:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=V9yYoa+NokyIICc/7pE2jRpAh4BhT7xgCYmIfDozaCM=;
 b=Ucb7xmm/+7N/j6DcQxdeg9QlNchywuAsPXMhXj5RO3BvbZxB38zeeoiZjDQik+wAseOu
 8pALWQGbd/BJ90FPQB+DaewJwy1u9tR+luMJcHr/l5+Zkf3BKvWvdn/bmuIABSQiZGOq
 FGjJ9qX94FSkINySFNwijFKBK1dzQVVwzX8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j0aek9kb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 08:37:46 -0700
Received: from twshared25684.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 16 Aug 2022 08:37:44 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id CD2614AAA7BE; Tue, 16 Aug 2022 08:37:38 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next v2 0/6] io_uring: defer task work to when it is needed
Date:   Tue, 16 Aug 2022 08:37:22 -0700
Message-ID: <20220816153728.2160601-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: xTQHOQBRraEi5R5izGpfxxqdDX9eKJ0S
X-Proofpoint-ORIG-GUID: xTQHOQBRraEi5R5izGpfxxqdDX9eKJ0S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have seen workloads which suffer due to the way task work is currently
scheduled. This scheduling can cause non-trivial tasks to run interruptin=
g
useful work on the workload. For example in network servers, a large asyn=
c
recv may run, calling memcpy on a large packet, interrupting a send. Whic=
h
would add latency.

This series adds an option to defer async work until user space calls
io_uring_enter with the GETEVENTS flag. This allows the workload to choos=
e
when to schedule async work and have finer control (at the expense of
complexity of managing this) of scheduling.

Patches 1,2 are prep patches
Patch 3 changes io_uring_enter to not pre-run task work
Patch 4/5/6 adds the new flag and functionality

Changes since v1:
 - Removed the first patch (using ctx variable) which was broken
 - Require IORING_SETUP_SINGLE_ISSUER and make sure waiter task
   is the same as the submitter task
 - Just don't run task work at the start of io_uring_enter (Pavel's
   suggestion)
 - Remove io_move_task_work_from_local
 - Fix locking bugs

Dylan Yudaken (6):
  io_uring: remove unnecessary variable
  io_uring: introduce io_has_work
  io_uring: do not run task work at the start of io_uring_enter
  io_uring: add IORING_SETUP_DEFER_TASKRUN
  io_uring: move io_eventfd_put
  io_uring: signal registered eventfd to process deferred task work

 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |   7 ++
 io_uring/cancel.c              |   2 +-
 io_uring/io_uring.c            | 222 ++++++++++++++++++++++++++-------
 io_uring/io_uring.h            |  30 ++++-
 io_uring/rsrc.c                |   2 +-
 6 files changed, 215 insertions(+), 51 deletions(-)


base-commit: 5993000dc6b31b927403cee65fbc5f9f070fa3e4
prerequisite-patch-id: cb1d024945aa728d09a131156140a33d30bc268b
--=20
2.30.2

