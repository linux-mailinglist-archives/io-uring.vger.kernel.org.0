Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BB15A933D
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 11:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiIAJeH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 05:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbiIAJd7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 05:33:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B671616BB
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 02:33:50 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2811HdTA000340
        for <io-uring@vger.kernel.org>; Thu, 1 Sep 2022 02:33:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=rAaoh5KIqImLmeXyPBax7UlWvK6yJ2ROkgvfLmiYSqw=;
 b=guVS2PpvQxz9/wO3BjZnjGuLnDRoVaC9D+edacpqQcQvJDdoRbK8RLH/2a9i5kgyLT6w
 xG6MxEA3nXYS//HGKafwFtv+goFERG6TI8Va86nuUu0MbyOrHA182fCSrdHfKF88FCKf
 uZ4sGxY18pwyzGkHF65i65NmbQg8TKOJLns= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j9nks4yu8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 02:33:48 -0700
Received: from twshared11415.03.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:33:13 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 961EE57693EE; Thu,  1 Sep 2022 02:33:06 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 00/12] Defer taskrun changes
Date:   Thu, 1 Sep 2022 02:32:51 -0700
Message-ID: <20220901093303.1974274-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: aerNJ5kgDDv62D80LQgpWtOC7APCjax7
X-Proofpoint-ORIG-GUID: aerNJ5kgDDv62D80LQgpWtOC7APCjax7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
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
12 is an unrelated fix to a flaky test

Changes since v1:
 - update tests to require IORING_SETUP_SINGLE_ISSUER
 - add docs for IORING_SETUP_DEFER_TASKRUN
 - add shutdown test

Dylan Yudaken (12):
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
  shutdown test: bind to ephemeral port

 man/io_uring_enter.2            |  24 ++-
 man/io_uring_setup.2            |  30 ++-
 src/include/liburing.h          |  11 ++
 src/include/liburing/io_uring.h |   7 +
 src/queue.c                     |  26 ++-
 test/Makefile                   |   1 +
 test/cq-overflow.c              | 243 ++++++++++++++++++++++-
 test/defer-taskrun.c            | 333 ++++++++++++++++++++++++++++++++
 test/eventfd-disable.c          |  33 +++-
 test/file-verify.c              |   4 +
 test/helpers.c                  |  17 +-
 test/helpers.h                  |   2 +
 test/iopoll.c                   |  17 +-
 test/multicqes_drain.c          |  50 ++++-
 test/poll-mshot-overflow.c      |  40 +++-
 test/recv-multishot.c           |  33 ++--
 test/rsrc_tags.c                |  10 +-
 test/shutdown.c                 |   7 +-
 18 files changed, 836 insertions(+), 52 deletions(-)
 create mode 100644 test/defer-taskrun.c


base-commit: a71d56ef3259216739677473ddb17ad861c3a964
--=20
2.30.2

