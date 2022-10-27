Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC38C60FAB5
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 16:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiJ0Opf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 10:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiJ0OpQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 10:45:16 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3595007A
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:45 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RCQwCU020105
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=i0m3HvjHtQJzfKPhG7yfhZLaobj4QR5Zl/Lyydu9vOo=;
 b=Fhz2MTC364A6Q2rWqsPKvkc5uvgm3668O9ZDwM9M4F5KUhYZgPZ/g4wybrcK4jTRtodU
 VjFqnoee/Vr/5W4gem0ZZOpRO6C4q3SpZwO2zL23RYNrAhcQBWQsThZ9VQsWm6dNoH0U
 GOI6XtOdclasi1C71CGjkGjecAclJIFKKZsIkV4SusAetTq1pYrJDC95gLMdL/BTN50W
 686cgpxCrV/lM4UiDQdRYWnv+FqAEWTinbkrl6BCbfooSF6XReGHpIeFXi4YWYc7MUUI
 xzbolcZBFiJA6ZH5zKFvqM3Tj1f1EwIWeDkDWW4iyIiPJWZGsSicG3bMMPeDivOmmSzF nw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kfagyhksq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 07:44:44 -0700
Received: from twshared9269.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:44:43 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 327488673CAB; Thu, 27 Oct 2022 07:44:34 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH 0/2] io_uring: fix locking in __io_run_local_work
Date:   Thu, 27 Oct 2022 07:44:27 -0700
Message-ID: <20221027144429.3971400-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: KFyAl7P7VOUZ1ZQcQwmLvZGuewVc-d0Z
X-Proofpoint-ORIG-GUID: KFyAl7P7VOUZ1ZQcQwmLvZGuewVc-d0Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If locked was not set in __io_run_local_work, but some task work managed
to lock the context, it would leave things locked indefinitely.  Fix that
by passing the pointer in.

Patch 1 is a tiny cleanup to simplify things
Patch 2 is the fix

Dylan Yudaken (2):
  io_uring: use io_run_local_work_locked helper
  io_uring: unlock if __io_run_local_work locked inside

 io_uring/io_uring.c | 11 +++++------
 io_uring/io_uring.h | 12 ++++++++++--
 2 files changed, 15 insertions(+), 8 deletions(-)


base-commit: 247f34f7b80357943234f93f247a1ae6b6c3a740
--=20
2.30.2

