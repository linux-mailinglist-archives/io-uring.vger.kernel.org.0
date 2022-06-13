Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09C4548C75
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 18:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiFMPjV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 11:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350820AbiFMPi5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 11:38:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FE5157EBA
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:20 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25CMSs1J028958
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=z5VQFbs0Gkbf6fmMARQ8k5mVu8HhtalpgX7rFcQmvss=;
 b=rg3BWWM2lw3E+fKrC/l5lu7k6FHHHP8EpsZpThw8wWrNXSH3upfUUNwfAcQzTbej3NS3
 3GpOZw09DpclVFo1xCY8mc0EU9MUtmp2QwyLzn8z5M+a7NUpyaBec50AZQJPfSG9ArSX
 CL/+2HSij7kbGjPwjOF3f+e9ix5FEPFy1Qo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmq3kgedd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:01 -0700
Received: from twshared25107.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 13 Jun 2022 06:12:58 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 4C99119A7602; Mon, 13 Jun 2022 06:12:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 0/4] Buffer ring API fixes
Date:   Mon, 13 Jun 2022 06:12:49 -0700
Message-ID: <20220613131253.974205-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 29z_42u7K17NXq-GGKqiKHx-_x1E6j32
X-Proofpoint-ORIG-GUID: 29z_42u7K17NXq-GGKqiKHx-_x1E6j32
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_05,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This set makes some changes to the new buf_ring API to help it's
usability.  Most importantly the _add function needs a mask parameter
to prevent buffer overflow. I added a _mask helper function to
calculate this. Even though its trivial it feels better to not force
the user to think about it.

Additionally _init is required as otherwise there is no provided way
to sync the tail with the kernel.

Lastly I add a test that showed up some issues found in 5.19-rc1.

Patch 1 is a small man fix
Patch 2/3 are the API changes
Patch 4 is the test.

Dylan Yudaken (4):
  remove non-existent manpage reference
  add mask parameter to io_uring_buf_ring_add
  add io_uring_buf_ring_init
  buf-ring: add tests that cycle through the provided buffer ring

 man/io_uring_buf_ring_add.3      |   5 ++
 man/io_uring_buf_ring_init.3     |  30 +++++++
 man/io_uring_buf_ring_mask.3     |  27 +++++++
 man/io_uring_register_buf_ring.3 |   6 +-
 src/include/liburing.h           |  18 ++++-
 test/buf-ring.c                  | 133 +++++++++++++++++++++++++++++++
 test/send_recvmsg.c              |   4 +-
 7 files changed, 218 insertions(+), 5 deletions(-)
 create mode 100644 man/io_uring_buf_ring_init.3
 create mode 100644 man/io_uring_buf_ring_mask.3


base-commit: 807c8169e153a3985f1a4deddc302846673ef979
--=20
2.30.2

