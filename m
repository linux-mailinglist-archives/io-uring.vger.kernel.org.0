Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42566635B01
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiKWLHQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237592AbiKWLGz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:06:55 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC4E638B
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:38 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB6NIO029885
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=s2048-2021-q4;
 bh=ANqCwDP0VQgf/k+B+gikdWWP3y3TelykF2FHHc0L21g=;
 b=N4edcWsF3Xw0OF/gnD+nlS5a26AQyYdhA8nsMiv5hVb7VqTUyXHPvFeDvPLP97V6Q4Zm
 0jg2whuBE4AjXC7D6QaVOEfPPkdHuoAUNeI/hYxh47V1G9RVOAE2aJdrxCJu4G4Env5c
 d83JevPLcAEIwTrMN7jN0+VRsSO8dFH67kkUznFLylC/k5iN9cC1OPLYlJS7OtEzBlIy
 8ubLiOZ9NO8EmJZSvtuWxt3XldHVafnY7fRcThVf78XJR9mYeKxfrjqifHaTp9MMhqhQ
 kXTtHBDGZT9fDkC0Tcn5/IF4slOqtazvLpoAXsTClVJ1kiCj2tl0wvxRFAGa52E17/Kq fQ== 
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m0y4uqtyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:38 -0800
Received: from twshared8047.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:36 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 7C036A0804B6; Wed, 23 Nov 2022 03:06:26 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 00/13] io_uring: batch multishot completions
Date:   Wed, 23 Nov 2022 03:06:01 -0800
Message-ID: <20221123110614.3297343-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: jqzeNA70TP1SFBbpBPvszLJi2VXLOdjH
X-Proofpoint-ORIG-GUID: jqzeNA70TP1SFBbpBPvszLJi2VXLOdjH
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
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
Patches 10-12 are small cleanups
Patch 13 enables defered completions for multishot polled requests

v2:
 - Rebase. This includes having to deal with the allow_overflow flag
 - split io_post_aux_cqe up
 - remove msg_ring changes (as not needed)
 - add the patch 10-12 cleanups

[1]: https://github.com/DylanZA/liburing/commit/9ac66b36bcf4477bfafeff1c5f1=
07896b7ae31cf
Run with $ make -j && ./benchmark/reg.b -s 1 -t 2000 -r 10

Dylan Yudaken (13):
  io_uring: merge io_req_tw_post and io_req_task_complete
  io_uring: __io_req_complete should defer if available
  io_uring: split io_req_complete_failed into post/defer
  io_uring: lock on remove in io_apoll_task_func
  io_uring: timeout should use io_req_task_complete
  io_uring: simplify io_issue_sqe
  io_uring: make io_req_complete_post static
  io_uring: allow defer completion for aux posted cqes
  io_uring: add io_aux_cqe which allows deferred completion
  io_uring: make io_fill_cqe_aux static
  io_uring: add lockdep assertion in io_fill_cqe_aux
  io_uring: remove overflow param from io_post_aux_cqe
  io_uring: allow multishot polled reqs to defer completion

 include/linux/io_uring_types.h |   2 +
 io_uring/io_uring.c            | 141 ++++++++++++++++++++++++---------
 io_uring/io_uring.h            |  10 +--
 io_uring/msg_ring.c            |   4 +-
 io_uring/net.c                 |   7 +-
 io_uring/poll.c                |   9 ++-
 io_uring/rsrc.c                |   4 +-
 io_uring/timeout.c             |   3 +-
 8 files changed, 125 insertions(+), 55 deletions(-)


base-commit: 449157d5268d68f9ce9445df70776f312af35117
--=20
2.30.2

