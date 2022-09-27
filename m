Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9376C5EBFA0
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 12:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiI0KWT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 06:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiI0KWQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 06:22:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47534CDCE1
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:15 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28R73f5J011292
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=u4a8mVCvItkfbP/sIljkQWGAeAfbrL24QWRUoYtWmQ0=;
 b=lKK1tBVMzG1+b2RsCEAq72rq9WJ1lMxdhdJGw3Jq2RP6uf2UoHCvH17APh8IVePtON0N
 y3B4M5AEMJbzJFRuRX/sBHoEXK3QCMcDcXWgLF3Yw4XNFHF7QtBsezAebsC1jyx34m6s
 gRqUNotHa5VfWvwl8FyEhHh0Sk/B+OzVR08= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3juvf18wyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:14 -0700
Received: from twshared9024.02.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 03:22:14 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1987F6B9F4C4; Tue, 27 Sep 2022 03:22:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 0/3] 6.0 updates
Date:   Tue, 27 Sep 2022 03:21:59 -0700
Message-ID: <20220927102202.69069-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: lXbX8VdwVFQ9hVX16V8H4VSrR-ObvgnB
X-Proofpoint-ORIG-GUID: lXbX8VdwVFQ9hVX16V8H4VSrR-ObvgnB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_03,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

liburing updates for 6.0:

Patch 1 updates to account for the single issuer ring being assigned at
ring creation time.
Patch 2 updates man pages from 5.20 -> 6.0
Patch 3 reduces test flakiness

v2:
 - handle IORING_SETUP_R_DISABLED semantics
 - fix unique path in open-direct-pick test=20

Dylan Yudaken (3):
  handle single issuer task registration at ring creation
  update documentation to reflect no 5.20 kernel
  give open-direct-pick.c a unique path

 man/io_uring_prep_recv.3    |  2 +-
 man/io_uring_prep_recvmsg.3 |  2 +-
 man/io_uring_setup.2        | 18 +++++++++---------
 test/defer-taskrun.c        |  8 ++++++--
 test/open-direct-pick.c     |  2 +-
 test/single-issuer.c        | 34 ++++++++++++++++++++++++++--------
 6 files changed, 44 insertions(+), 22 deletions(-)


base-commit: 1cba5d6c9e41e2f55ac4c3f93f5e05f9b5082a3e
--=20
2.30.2

