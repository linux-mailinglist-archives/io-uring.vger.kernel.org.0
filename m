Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1BA631E89
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKUKga (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiKUKgK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:36:10 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FCD27CE5
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:05 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKNw8Am031436
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=s2048-2021-q4;
 bh=l8DuvicMTRUxwUYfOiT9wR28CJ3GwHzYpX9zBTv4VfM=;
 b=BUjvANGlPCgisooZHHWXMMvg8Od0Ry+CJyZ2E5MEU5cxKK36Rgi8oV9OlQ0vNFDTeZqq
 gVIXEmOM7Er8B9R6nHlxMW2Yc79JwpXJEWnbg5n7KNzugyadOaP446d9kyqVjRwOI/hn
 5d28d9JnlSOnJS2y/85iqzpMGnP9et9B1JFZR0zZ1LJu7OHc/aMRf73RBxQ6bLzbDCCV
 VDxFjY+tKUatmu8D2NA5y1OWvK8YSDXl4LIlV5F5QpQRejb5/Y3P5rwF58oeBOPgIpCf
 rUkqIV/Xi+H2F68te0www98OJCfWK18t280BvGCsnbP0pJsjsFZYUjE1tnpcP5h/wH7W mQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kxwv03nys-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:36:04 -0800
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:36:03 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id DDA129E66F66; Mon, 21 Nov 2022 02:03:54 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 00/10] io_uring: batch multishot completions
Date:   Mon, 21 Nov 2022 02:03:43 -0800
Message-ID: <20221121100353.371865-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: W7Fo1NOoUR_Kb6coHZRvl9OIjwNzhN2m
X-Proofpoint-GUID: W7Fo1NOoUR_Kb6coHZRvl9OIjwNzhN2m
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
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

Patches 1-7 clean up the completion paths
Patch 8 introduces the cqe array
Patch 9 allows io_post_aux_cqe to use the cqe array to defer completions
Patch 10 enables defered completions for multishot polled requests

[1]: https://github.com/DylanZA/liburing/commit/9ac66b36bcf4477bfafeff1c5f1=
07896b7ae31cf
Run with $ make -j && ./benchmark/reg.b -s 1 -t 2000 -r 10

Note - I this will have a merge conflict with the recent
"io_uring: inline __io_req_complete_post()" commit. I can respin once that
is in for-next.

Dylan Yudaken (10):
  io_uring: merge io_req_tw_post and io_req_task_complete
  io_uring: __io_req_complete should defer if available
  io_uring: split io_req_complete_failed into post/defer
  io_uring: lock on remove in io_apoll_task_func
  io_uring: timeout should use io_req_task_complete
  io_uring: simplify io_issue_sqe
  io_uring: make io_req_complete_post static
  io_uring: allow defer completion for aux posted cqes
  io_uring: allow io_post_aux_cqe to defer completion
  io_uring: allow multishot polled reqs to defer completion

 include/linux/io_uring_types.h |   2 +
 io_uring/io_uring.c            | 133 +++++++++++++++++++++++++--------
 io_uring/io_uring.h            |   5 +-
 io_uring/msg_ring.c            |  10 ++-
 io_uring/net.c                 |  15 ++--
 io_uring/poll.c                |   7 +-
 io_uring/rsrc.c                |   4 +-
 io_uring/timeout.c             |   3 +-
 8 files changed, 126 insertions(+), 53 deletions(-)


base-commit: 40fa774af7fd04d06014ac74947c351649b6f64f
--=20
2.30.2

