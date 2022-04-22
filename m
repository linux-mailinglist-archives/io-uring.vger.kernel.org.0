Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD850B66C
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447157AbiDVLvc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 07:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380235AbiDVLvb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 07:51:31 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F8441FAA
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:37 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23M5bo5L002085
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=MKGTvS4zGryhoQsE3DntuGBBRJeH/2T8Ecybn+X05O4=;
 b=e+JBfTZpbkBH7/IdgRUZARQA7EFl5U2Q2+fPDytHSINYVdqinedPsTmCY2pLbaqupOKE
 twge4MZW7SuyLA7sSI3p6KVXrqUNTMMA4grIifD3BKaXVx9gcsp3fu35g2r3ndtOqL/Z
 gJxsuFyXssEtuuABgSgQATcg5pC/iFWy8Pg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fkpcmhpqv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:36 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 04:48:35 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 7E03F7DC56AD; Fri, 22 Apr 2022 04:48:31 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 0/7] run tests in parallel
Date:   Fri, 22 Apr 2022 04:48:08 -0700
Message-ID: <20220422114815.1124921-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PBrSTQDSykTj1oxg07mApij6jB49s_Yp
X-Proofpoint-GUID: PBrSTQDSykTj1oxg07mApij6jB49s_Yp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_03,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series allows tests to be run in parallel, which speeds up
iterating. Rather than build this functionality into the shell scripts, i=
t
seemed much easier to use make's parallel execution to do this.

My bash/make skills are not top notch, so I might have missed something
obvious, however it does seem to work locally very nicely.


Patch #1 is a bug that seems to trigger quite often when running in paral=
lel
Patch #2-5 fix bugs that prevent tests running in parallel
Patch #6 adds a make target that depends on running each test
Patch #7 Is not related to parallel tests. It is a prep for a later serie=
s to use nop to test IOPOLL.

Dylan Yudaken (7):
  test: handle mmap return failures in pollfree test
  test: use unique path for socket
  test: use unique ports
  test: use unique filenames
  test: mkdir -p output folder
  test: add make targets for each test
  test: use remove_buffers instead of nop to generate error codes

 test/232c93d07b74.c    |  2 +-
 test/Makefile          | 10 +++++++++-
 test/accept-test.c     |  2 +-
 test/defer.c           | 28 ++++++++++++++++++++--------
 test/link.c            |  6 +++---
 test/openat2.c         |  6 +++---
 test/pollfree.c        |  4 ++--
 test/recv-msgall.c     |  2 +-
 test/runtests-quiet.sh | 10 ++++++++++
 test/runtests.sh       |  2 +-
 test/send_recv.c       |  2 +-
 test/send_recvmsg.c    |  2 +-
 test/sq-poll-dup.c     |  2 +-
 test/sq-poll-share.c   |  2 +-
 14 files changed, 55 insertions(+), 25 deletions(-)
 create mode 100755 test/runtests-quiet.sh


base-commit: b7d8dd8bbf5b8550c8a0c1ed70431cd8050709f0
--=20
2.30.2

