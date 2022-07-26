Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAC95812EE
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 14:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiGZMPQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 08:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiGZMPP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 08:15:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412ED9FDF
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:13 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q0ofp5003549
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=riPgs84PBkpD5dxmmDAJnH34tM6Yb+KAJr7BMBdlDaU=;
 b=cQKc3LebGMq8hKtzh4MCzhRCZgCsObgAppxKXZeylA0NgHUwOK4YTma1wWYKwbweDvZy
 auG4aktzJsX+bJjTGNz0dBkD8EZjKmy8Xt2UtaRMT5L9tftvODcfSeb742GW0OOwP3jk
 d/5SJyUWeNmk163pX2i9OHt4kcyHegl9T9U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hj1usm8wx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:13 -0700
Received: from twshared39111.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 05:15:11 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0234E397A78A; Tue, 26 Jul 2022 05:15:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 0/5] multishot recvmsg docs and example
Date:   Tue, 26 Jul 2022 05:14:57 -0700
Message-ID: <20220726121502.1958288-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 5ntc71WlmXNVq9z4NrByQxHwEvGkwWt4
X-Proofpoint-ORIG-GUID: 5ntc71WlmXNVq9z4NrByQxHwEvGkwWt4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some multishot recvmsg patches for liburing:

Patches 1-3  cleanup the API a little while we're doing this.
Patch 4 adds docs for the new API
Patch 5 adds an example UDP echo server that uses the API


Dylan Yudaken (5):
  more consistent multishot recvmsg API parameter names
  order like functions together in liburing.h
  change io_uring_recvmsg_payload_length return type
  add documentation for multishot recvmsg
  add an example for a UDP server

 .gitignore                            |   1 +
 examples/Makefile                     |   1 +
 examples/io_uring-udp.c               | 388 ++++++++++++++++++++++++++
 man/io_uring_prep_recvmsg.3           |  30 ++
 man/io_uring_prep_recvmsg_multishot.3 |   1 +
 man/io_uring_recvmsg_cmsg_firsthdr.3  |   1 +
 man/io_uring_recvmsg_cmsg_nexthdr.3   |   1 +
 man/io_uring_recvmsg_name.3           |   1 +
 man/io_uring_recvmsg_out.3            |  78 ++++++
 man/io_uring_recvmsg_payload.3        |   1 +
 man/io_uring_recvmsg_payload_length.3 |   1 +
 man/io_uring_recvmsg_validate.3       |   1 +
 src/include/liburing.h                |  48 ++--
 13 files changed, 529 insertions(+), 24 deletions(-)
 create mode 100644 examples/io_uring-udp.c
 create mode 120000 man/io_uring_prep_recvmsg_multishot.3
 create mode 120000 man/io_uring_recvmsg_cmsg_firsthdr.3
 create mode 120000 man/io_uring_recvmsg_cmsg_nexthdr.3
 create mode 120000 man/io_uring_recvmsg_name.3
 create mode 100644 man/io_uring_recvmsg_out.3
 create mode 120000 man/io_uring_recvmsg_payload.3
 create mode 120000 man/io_uring_recvmsg_payload_length.3
 create mode 120000 man/io_uring_recvmsg_validate.3


base-commit: 30a20795d7e4f300c606c6a2aa0a4c9492882d1d
--=20
2.30.2

