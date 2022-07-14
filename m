Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9D574C7F
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 13:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiGNLym (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 07:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiGNLyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 07:54:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F80C2F018
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 04:54:41 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E6xCqJ029777
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 04:54:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=1px2IfowTR6lqw5ueHXcsUZNaeLSMoz3e1UFL2d8mM0=;
 b=TQb/gBt2DIRiSgmdA6a1FmxUSS2wVO5OA4EQXuRMlwPzEGcu+S1EhLjTPlkJd9MOGXG7
 chzbFFxKj8yUhRlm0WmSjYUWq/qX17Z+Cs8YWQEtYoR2TxteFqPR/vl8YUcY7qaGKrv2
 YKCgHYfPnrxigl/kZRpcba2OSjJD1UtxbW8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hae0w19kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 04:54:40 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 14 Jul 2022 04:54:39 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 9A8CB2FD10CC; Thu, 14 Jul 2022 04:54:31 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC v2 liburing 0/2] multishot recvmsg
Date:   Thu, 14 Jul 2022 04:54:26 -0700
Message-ID: <20220714115428.1569612-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _AXOk2OXCiEL_Fb9vy6SP9aK8jgaMD-H
X-Proofpoint-ORIG-GUID: _AXOk2OXCiEL_Fb9vy6SP9aK8jgaMD-H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_08,2022-07-14_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds an API (patch 1) and a test (#2) for multishot recvmsg.

I have not included docs yet, but I want to get feedback on the API for h=
andling
the result (if there is any).

There was no feedback on v1, but in v2 I added more API to make it easier=
 to deal
with truncated payloads. Additionally there is extra testing for this.

Dylan Yudaken (2):
  add multishot recvmsg API
  add tests for multishot recvmsg

 src/include/liburing.h          |  66 ++++++++++++
 src/include/liburing/io_uring.h |   7 ++
 test/recv-multishot.c           | 180 ++++++++++++++++++++++++++++----
 3 files changed, 234 insertions(+), 19 deletions(-)


base-commit: a705a6b307adfa52ba6315df0b8d5964a3b898b2
--=20
2.30.2

