Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23065EAC68
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 18:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiIZQZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 12:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbiIZQZF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 12:25:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE1C1183F
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:25 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28Q1iP66019682
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nIBzuXFFjcPs9XBHXuISf24s6+E/K2m/4v7oh1DBVoY=;
 b=GvNoqhO/SmDUOMx8dHv5hE+vFSJqB2nBBGMB+3BTWHWT7uOR9RpWC1j+MgFlOPkCrkhi
 xmH94pv1uOQV9tI3yXi94LMZD27oViHrLys1vmYIK59+dI3V0yiM8nQcigNS8g5bzECJ
 /tar0gV9AxzA8NidZ3EqF2NGBPYfakhnDf8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jt174kbwq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 08:14:25 -0700
Received: from twshared3028.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 08:14:23 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 2EFD16AF7F3F; Mon, 26 Sep 2022 08:14:14 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 0/2] 6.0 updates
Date:   Mon, 26 Sep 2022 08:14:10 -0700
Message-ID: <20220926151412.2515493-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: iC1tA-Gi1wm7-F7RxrjS00f-ci2_eTFp
X-Proofpoint-ORIG-GUID: iC1tA-Gi1wm7-F7RxrjS00f-ci2_eTFp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two liburing updates for 6.0:

Patch 1 updates to account for the single issuer ring being assigned at
ring creation time.

Patch 2 updates man pages from 5.20 -> 6.0

Dylan Yudaken (2):
  handle single issuer task registration at ring creation
  update documentation to reflect no 5.20 kernel

 man/io_uring_prep_recv.3    |  2 +-
 man/io_uring_prep_recvmsg.3 |  2 +-
 man/io_uring_setup.2        |  8 ++++----
 test/defer-taskrun.c        | 12 ++++--------
 test/single-issuer.c        | 14 +++++++-------
 5 files changed, 17 insertions(+), 21 deletions(-)


base-commit: 1cba5d6c9e41e2f55ac4c3f93f5e05f9b5082a3e
--=20
2.30.2

