Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B4C509BF1
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387536AbiDUJVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387500AbiDUJUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:20:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CB3252BF
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:01 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23KL3VGf007516
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=7y3NyL0/vkQjhzKAGscMUBM6yxvcHxVjgDg9Uq1ApMU=;
 b=RMjwK22LLW4KyqAzlxJ1pE688nLOZt+IFDUBJOn9IWdV2KeQStkO5N83S93DQpfF7VNh
 40MgXMH1cYEFuTBMCSLfUvekX7FWv/w/nU74t1URWL7jRrDm0XJiikJ59N4sMDPvSPRS
 KpxpyOa7PeBnRcSa70vH5DruhBxcy6o20gM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fjsrju43p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:18:01 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 02:18:00 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id D276D7CA7715; Thu, 21 Apr 2022 02:14:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 0/5] overflow support
Date:   Thu, 21 Apr 2022 02:14:22 -0700
Message-ID: <20220421091427.2118151-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: XcmSKYZ9fRM1m8EYrpz1frPxg4Lup32O
X-Proofpoint-GUID: XcmSKYZ9fRM1m8EYrpz1frPxg4Lup32O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        TVD_PH_BODY_ACCOUNTS_PRE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds more support overflow conditions, including testing what=
 happens when an overflow CQE is not able to be allocated.

Patches 1,2,4:
 - clean up existing documentation to account for updated kernel behaviou=
r
Patch 3:
 - exposes some API to allow applications to inspect overflow state
Patch 5:
 - test new overflow API and new kernel error signalling

Dylan Yudaken (5):
  fix documentation shortenings
  update io_uring_enter.2 docs for IORING_FEAT_NODROP
  expose CQ ring overflow state
  add docs for overflow lost errors
  overflow: add tests

 man/io_uring_enter.2            |  24 +++-
 man/io_uring_setup.2            |  11 +-
 man/io_uring_wait_cqe.3         |   2 +-
 man/io_uring_wait_cqe_nr.3      |   2 +-
 man/io_uring_wait_cqe_timeout.3 |   2 +-
 man/io_uring_wait_cqes.3        |   2 +-
 src/include/liburing.h          |  10 ++
 src/queue.c                     |  31 +++--
 test/cq-overflow.c              | 240 +++++++++++++++++++++++++++++++-
 9 files changed, 298 insertions(+), 26 deletions(-)


base-commit: b7d8dd8bbf5b8550c8a0c1ed70431cd8050709f0
--=20
2.30.2

