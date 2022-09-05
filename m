Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064475AD3CD
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiIENY7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbiIENY5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:24:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7F813DD5
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:24:56 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 284NwsKc004203
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:24:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=KE9I45MgUSS9DNHz8lex/ORUA6uucLfHW67f4IB9C8U=;
 b=T/uEEn4OFp5Pr+BrMCAWKldEq5+i+xWleHe2pektmJscCLwL1SwV7saqJk99Bvl318eD
 ntyGhgVCYz0Ke3UrzXr7Ipe7I2CforKM/2GrVSCawTjpTLCY0OXTUVuRkoeVTwmsk8Rz
 UV0Zw9C4Qgr6vP2454ix235kRXuzzlreTog= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jc2kx0wmn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:24:55 -0700
Received: from twshared8288.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:24:53 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 140425AC5168; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 00/11] Defer taskrun changes
Date:   Mon, 5 Sep 2022 06:22:47 -0700
Message-ID: <20220905132258.1858915-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: caVIwtKimoiuKzM-0ap5poDZF4_CVmjV
X-Proofpoint-GUID: caVIwtKimoiuKzM-0ap5poDZF4_CVmjV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_02,2022-06-22_01
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

This flag needs a couple of new API calls to force a call to get events f=
or
users that are polling the io_uring fd (or a registered eventfd).

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

Changes since v2:
 - Add documentation and .map file for new API
 - remove shutdown test

Changes since v1:
 - update tests to require IORING_SETUP_SINGLE_ISSUER
 - add docs for IORING_SETUP_DEFER_TASKRUN
 - add shutdown test

Dylan Yudaken (11):
  Copy defer task run definition from kernel
  Add documentation for IORING_SETUP_DEFER_TASKRUN flag
  add io_uring_submit_and_get_events and io_uring_get_events
  add a t_probe_defer_taskrun helper function for tests
  update existing tests for defer taskrun
  add a defer-taskrun test
  update io_uring_enter.2 docs for IORING_FEAT_NODROP
  add docs for overflow lost errors
  expose CQ ring overflow state
  overflow: add tests
  file-verify test: log if short read

 man/io_uring_cq_has_overflow.3       |  25 ++
 man/io_uring_enter.2                 |  24 +-
 man/io_uring_get_events.3            |  33 +++
 man/io_uring_setup.2                 |  30 ++-
 man/io_uring_submit_and_get_events.3 |  31 +++
 src/include/liburing.h               |  12 +
 src/include/liburing/io_uring.h      |   7 +
 src/liburing.map                     |   2 +
 src/queue.c                          |  26 ++-
 test/Makefile                        |   1 +
 test/cq-overflow.c                   | 243 ++++++++++++++++++-
 test/defer-taskrun.c                 | 333 +++++++++++++++++++++++++++
 test/eventfd-disable.c               |  33 ++-
 test/file-verify.c                   |   4 +
 test/helpers.c                       |  17 +-
 test/helpers.h                       |   2 +
 test/iopoll.c                        |  17 +-
 test/multicqes_drain.c               |  50 +++-
 test/poll-mshot-overflow.c           |  40 +++-
 test/recv-multishot.c                |  33 ++-
 test/rsrc_tags.c                     |  10 +-
 21 files changed, 922 insertions(+), 51 deletions(-)
 create mode 100644 man/io_uring_cq_has_overflow.3
 create mode 100644 man/io_uring_get_events.3
 create mode 100644 man/io_uring_submit_and_get_events.3
 create mode 100644 test/defer-taskrun.c


base-commit: 3bd7d6b27e6b7d7950bba1491bc9c385378fe4dd
--=20
2.30.2

