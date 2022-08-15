Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB5592F79
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbiHONM3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242705AbiHONM1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:12:27 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F7D15FE6
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:25 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ENDAbf008857
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=2e03wNl5VQUBm0I291lQ6WlcB1MUFpnXGdU/suH4/kw=;
 b=nifRl93PxPlazv/QpNsIPGlUW3hnSUvVFtj06r6q0EE3v6sz28aNVSrW++G0fEe/0Q5S
 3yewEqoiN4/hQaZZV2OWYksOg+BI8zyUIG1QukK2ZzqfDePgcKnyii0CiS4dqM/KWAeY
 NDnqaVoeDGnhzYv9lvIbNh40NfM4Bt8rTIc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hx9pyj355-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:12:20 -0700
Received: from twshared8442.02.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:12:18 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E8D3449B72CF; Mon, 15 Aug 2022 06:09:54 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 00/11] Defer taskrun changes
Date:   Mon, 15 Aug 2022 06:09:36 -0700
Message-ID: <20220815130947.1002152-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Du6zUq7zEYegA9Bm4CVqeGa9Z0Jy2XKl
X-Proofpoint-ORIG-GUID: Du6zUq7zEYegA9Bm4CVqeGa9Z0Jy2XKl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds support to liburing for the IORING_SETUP_DEFER_TASKRUN f=
lag.

The second half of the series is a bit mixed and includes some documentat=
ion
fixes, overflow cleanups and test cleanups. I sent these a couple of mont=
hs
ago and forgot about it, but now it does depend on the new API so it need=
s to
be ordered.
I can send it separately if you like.

Patches:

1 copies the definition from the kernel include file
2 introduces new APIs required for this feature
3/4/5 add tests for IORING_SETUP_DEFER_TASKRUN

6/7/8 clean and update existing documentation to match upstream
9 exposes the overflow state to the application
10 uses this and tests overflow functionality
11 gives an explicit warning if there is a short read in file-verify

Dylan Yudaken (11):
  Copy defer task run definition from kernel
  add io_uring_submit_and_get_events and io_uring_get_events
  add a t_probe_defer_taskrun helper function for tests
  update existing tests for defer taskrun
  add a defer-taskrun test
  fix documentation shortenings
  update io_uring_enter.2 docs for IORING_FEAT_NODROP
  add docs for overflow lost errors
  expose CQ ring overflow state
  overflow: add tests
  file-verify test: log if short read

 man/io_uring_enter.2            |  24 +++-
 man/io_uring_setup.2            |  11 +-
 man/io_uring_wait_cqe.3         |   2 +-
 man/io_uring_wait_cqe_nr.3      |   2 +-
 man/io_uring_wait_cqe_timeout.3 |   2 +-
 man/io_uring_wait_cqes.3        |   2 +-
 src/include/liburing.h          |  11 ++
 src/include/liburing/io_uring.h |   7 +
 src/queue.c                     |  28 ++--
 test/Makefile                   |   1 +
 test/cq-overflow.c              | 248 +++++++++++++++++++++++++++++++-
 test/defer-taskrun.c            | 217 ++++++++++++++++++++++++++++
 test/eventfd-disable.c          |  32 ++++-
 test/file-verify.c              |   4 +
 test/helpers.c                  |  12 ++
 test/helpers.h                  |   2 +
 test/iopoll.c                   |  16 ++-
 test/multicqes_drain.c          |  49 ++++++-
 test/poll-mshot-overflow.c      |  39 ++++-
 test/recv-multishot.c           |  32 +++--
 test/rsrc_tags.c                |  10 +-
 21 files changed, 697 insertions(+), 54 deletions(-)
 create mode 100644 test/defer-taskrun.c


base-commit: 15cc446cb8b0caa5c939423d31182eba66141539
--=20
2.30.2

