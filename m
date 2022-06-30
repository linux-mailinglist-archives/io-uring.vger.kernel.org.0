Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C4F562096
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 18:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbiF3Qt5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 12:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiF3Qt4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 12:49:56 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD54031374
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:55 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UEpoSr008207
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=4yUvxILKdW0nEwGprBucMPOnKka27lRwKNB3EcGeIjk=;
 b=SozEfPd07C/ni26WP9nfi4jvo2t6ZLFKCLpNRkWnVvPV62OgYW6qY65OwguNNmUqZOlV
 f2siiqMMa78BckdPHLfEv7a2AmRBVy5ZwC2cT5VdgWSxL0OCSlhR04P9z2RfymyGi8r5
 DEbYMLZhzFYBTuldakDivqbqGlPvrUWrkK0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0qgr1b9y-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:54 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 09:49:51 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A0FB225D4CCF; Thu, 30 Jun 2022 09:49:22 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 liburing 0/7] liburing: multishot receive 
Date:   Thu, 30 Jun 2022 09:49:11 -0700
Message-ID: <20220630164918.3958710-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: gLzW7kMHbt_IK_h_YixJcLpUSchU3sVQ
X-Proofpoint-ORIG-GUID: gLzW7kMHbt_IK_h_YixJcLpUSchU3sVQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_12,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds an API, tests and documentation for the multi shot receive func=
tionality.

It also adds some testing for overflow paths in accept & poll which previ=
ously was
not tested.

Patch 1 adds a helper t_create_socket_pair which provides two connected s=
ockets
without needing a hard coded port

Patch 2-5 adds multishot recv api, tests and docs
Patch 6,7 add tests for overflow in poll

v3:
 * remove TCP_NODELAY stuff from patch 1 as it was useless
 * fix return codes from recv-multishot test
 * use ioprio field for multishot

v2:
 * added a multishot recv api rather than expecting applications to use t=
he
   flags directly
 * fixed the io_uring.h include
 * added overflow tests for recv multishot
 * added tests for poll/accept

Dylan Yudaken (7):
  add t_create_socket_pair
  add IORING_RECV_MULTISHOT to io_uring.h
  add io_uring_prep_(recv|recvmsg)_multishot
  add IORING_RECV_MULTISHOT docs
  add recv-multishot test
  add poll overflow test
  add accept with overflow test

 man/io_uring_prep_recv.3              |  22 ++
 man/io_uring_prep_recv_multishot.3    |   1 +
 man/io_uring_prep_recvmsg.3           |  20 ++
 man/io_uring_prep_recvmsg_multishot.3 |   1 +
 src/include/liburing.h                |  16 ++
 src/include/liburing/io_uring.h       |   5 +
 test/Makefile                         |   2 +
 test/accept.c                         | 129 +++++++---
 test/helpers.c                        |  90 +++++++
 test/helpers.h                        |   5 +
 test/poll-mshot-overflow.c            | 128 ++++++++++
 test/recv-multishot.c                 | 343 ++++++++++++++++++++++++++
 12 files changed, 734 insertions(+), 28 deletions(-)
 create mode 120000 man/io_uring_prep_recv_multishot.3
 create mode 120000 man/io_uring_prep_recvmsg_multishot.3
 create mode 100644 test/poll-mshot-overflow.c
 create mode 100644 test/recv-multishot.c


base-commit: 6c90ac3c9fb874d406656c9e7a68805c83a055a0
--=20
2.30.2

