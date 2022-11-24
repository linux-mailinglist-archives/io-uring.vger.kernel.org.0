Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CC1637547
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiKXJgi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiKXJge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFA3122940
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:32 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsEDK024604
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=s2048-2021-q4;
 bh=v8Mq2WfWG/qKec5MINauWOq4ZV88F5gX8bov+j5qRBo=;
 b=Kt9+ukQnLdP+jmg7cL2MjQZ/hYShcrY2fWMDhpDoQjODzkSNONPqY0v/tIGoZwOnp4KA
 bfC8KAanqcWZQRPtFw7gmZPbl/ob5yngXRtiKRnYGWmfSK0zz1leOYm6bFVSlOve+Van
 6TWJBeY92UU9SU1vDvVmAVafGeI2n1JIM7UbuTnL0ewWVpqAryDKmBBLSuHROdRXaG9l
 awX6mLhWZLQAraKZjaUZk6tIdZ1SZcFjGxlqtDy1UmJie+aa4awUu6HvuC6ydL3cM2oq
 u6ZUqbMF/nvacsWwecyL+opQ447aqSf9ZEevbNJZCDcEyHIN419Ogca6EQ0HkalI7iVk tA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m1cg3s8wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:32 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:31 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id D4AA5A173A07; Thu, 24 Nov 2022 01:36:18 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 0/9] io_uring: batch multishot completions
Date:   Thu, 24 Nov 2022 01:35:50 -0800
Message-ID: <20221124093559.3780686-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LexHN6iAVB8OQ_tWCnicJze4yw9-00eg
X-Proofpoint-GUID: LexHN6iAVB8OQ_tWCnicJze4yw9-00eg
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Multishot completions currently all go through io_post_aux_cqe which will
do a lock/unlock pair of the completion spinlock, and also possibly signal
an eventfd if registered. This can slow down applications that use these
features.

This series allows the posted completions to be batched using the same
IO_URING_F_COMPLETE_DEFER as exists for non multishot completions. A
critical property of this is that all multishot completions must be
flushed to the CQ ring before the non-multishot completion (say an error)
or else ordering will break. This implies that if some completions were
deferred, then the rest must also be to keep that ordering. In order to do
this the first few patches move all the completion code into a simpler
path that defers completions when possible.

The batching is done by keeping an array of 16 CQEs, and adding to it
rather than posting immediately. If it fills up the posting happens then.

A microbenchmark was run ([1]) to test this and showed a 2.3x rps
improvment (8.3 M/s vs 19.3 M/s).

Patches 1-3 clean up the completion paths
Patch 4 introduces the cqe array
Patch 5 allows io_post_aux_cqe to use the cqe array to defer completions
Patches 6-8 are small cleanups
Patch 9 enables defered completions for multishot polled requests

v3:
 - rebase onto recent changes. A lot of duplicate changes so dropped 4 patc=
hes

v2:
 - Rebase. This includes having to deal with the allow_overflow flag
 - split io_post_aux_cqe up
 - remove msg_ring changes (as not needed)
 - add the patch 10-12 cleanups

[1]: https://github.com/DylanZA/liburing/commit/9ac66b36bcf4477bfafeff1c5f1=
07896b7ae31cf
Run with $ make -j && ./benchmark/reg.b -s 1 -t 2000 -r 10

Dylan Yudaken (9):
  io_uring: io_req_complete_post should defer if available
  io_uring: always lock in io_apoll_task_func
  io_uring: defer all io_req_complete_failed
  io_uring: allow defer completion for aux posted cqes
  io_uring: add io_aux_cqe which allows deferred completion
  io_uring: make io_fill_cqe_aux static
  io_uring: add lockdep assertion in io_fill_cqe_aux
  io_uring: remove overflow param from io_post_aux_cqe
  io_uring: allow multishot polled reqs to defer completion

 include/linux/io_uring_types.h |   2 +
 io_uring/io_uring.c            | 101 ++++++++++++++++++++++++++-------
 io_uring/io_uring.h            |   9 ++-
 io_uring/msg_ring.c            |   4 +-
 io_uring/net.c                 |   7 ++-
 io_uring/poll.c                |   9 +--
 io_uring/rsrc.c                |   4 +-
 7 files changed, 101 insertions(+), 35 deletions(-)


base-commit: 6321e75e0bc52b0feff9643292acc92494c00e8d
--=20
2.30.2

