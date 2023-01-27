Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467CF67E2C6
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 12:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjA0LLy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 06:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjA0LLv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 06:11:51 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B466E1A96F
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:50 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RB3g1l031828
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=e/DXNYRdhS/ph5Lj7kBU4jz+GWkaCkW1vxf/l2Dj7Ec=;
 b=Wdw7q54JbAyRcp1VjhUPMAHUFLZiazqZ793kfj062fZc/d8jSlU/ffbdsBYIzSlz2IJl
 K2rhE/CoXtT+JvlUy6pTNkMFxuZrxsSeHpxEA1rlN+FniU/ix9CikhAG2BhYH5or4ikO
 ttnT4WlWjY5D2BOFdy8eQBCxDe4YVljJPnmkkVxyGZVx1bivtly11c75X2nrJnD4rurd
 CGu81f26iilDjUdAtJ7gGjk54FMUSOYRQbrboQGEEjOWnnKAN918r5Zupt4iK8DwIR8K
 bVxalhsK36/AIUIFuguWyyBUiZJVOVM+xMI6b9jXZi9ZL7ytBw6PaEpPNPUuFDcqhfB0 cw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nbhhnrbys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 03:11:50 -0800
Received: from twshared6233.02.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 03:11:49 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 4B67CEA01681; Fri, 27 Jan 2023 03:11:44 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 0/2] liburing: patches for drain bug
Date:   Fri, 27 Jan 2023 03:11:31 -0800
Message-ID: <20230127111133.2551653-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: WW8bY1-jqQqebUeZXxOjOGyVFxpIK7WP
X-Proofpoint-ORIG-GUID: WW8bY1-jqQqebUeZXxOjOGyVFxpIK7WP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_06,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two patches for the drain bug I just sent a patch for.  Patch 1 definitel=
y
fails, but patch 2 I am sending just in case as it exercises some more
code paths.

Dylan Yudaken (2): add a test using drain with IORING_SETUP_DEFER_TASKRUN
  run link_drain test with defer_taskrun too

 test/defer-taskrun.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
 test/link_drain.c    | 34 +++++++++++++++++++++++++++++----
 2 files changed, 75 insertions(+), 4 deletions(-)


base-commit: 328cad5e53a38b07139c9059cdff6cee359a5313
--=20
2.30.2

