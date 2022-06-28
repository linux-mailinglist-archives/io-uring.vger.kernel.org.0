Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C355E799
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346420AbiF1PE3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347720AbiF1PE2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:04:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9746924942
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:27 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SAE6Vn013125
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=iL3vvNqwF+xwU2stpu+T6Capm21a3+/267xzL8Qa9tc=;
 b=nOXFI3lKYz3dC8cLPuiEwGBcBZzAs87eQO0vtuYNSwlImMAZIaIoTNjdaZo+rFaUh9Sf
 WTe+WdWwLgDDS2dgSvlc98ToAqwYRUgAUpEB5BKhONjz6emI2GFLql+jHEcxIIJiPhMh
 vPhdfUh5uDkl6hj+nTnWEOM5PCajCJ1pRek= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gyxx31ytw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:27 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:04:26 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id AC52E244BD53; Tue, 28 Jun 2022 08:04:18 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 0/4] liburing: multishot receive 
Date:   Tue, 28 Jun 2022 08:04:10 -0700
Message-ID: <20220628150414.1386435-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _09bFGCjoTxKuQH-KLQHyHahr4_zdG_3
X-Proofpoint-ORIG-GUID: _09bFGCjoTxKuQH-KLQHyHahr4_zdG_3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds tests and documentation for the multi shot receive functionalit=
y.

Patch 1 adds a helper t_create_socket_pair which provides two connected s=
ockets
without needing a hard coded port

Patch 2-4 adds multishot recv tests and docs

Dylan Yudaken (4):
  add t_create_socket_pair
  add IORING_RECV_MULTISHOT to io_uring.h
  add recv-multishot test
  add IORING_RECV_MULTISHOT docs

 man/io_uring_prep_recv.3        |  15 ++
 man/io_uring_prep_recvmsg.3     |  15 ++
 src/include/liburing/io_uring.h |  53 ++++--
 test/Makefile                   |   1 +
 test/helpers.c                  |  97 ++++++++++
 test/helpers.h                  |   5 +
 test/recv-multishot.c           | 308 ++++++++++++++++++++++++++++++++
 7 files changed, 480 insertions(+), 14 deletions(-)
 create mode 100644 test/recv-multishot.c


base-commit: 732bf609b670631731765a585a68d14ed3fdc9b7
--=20
2.30.2

