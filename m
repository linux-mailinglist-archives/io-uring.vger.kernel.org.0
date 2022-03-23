Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C374E5598
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245200AbiCWPqh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244437AbiCWPqg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:46:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E3A49F05
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:07 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22N6DUOM008849
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=JrSRdJLE93dudHRjrETfrbrVRozCXllmUWJryVf6+nk=;
 b=Be40gFNrNwM25bY2+TGNafKUUFEguF3BhOJAOZSaBQqxGHvd9bJ5etpq/u4xNHD7KM5A
 H+2LLyv6cXsYiaiKfXtxgeecydxQIhYrKcK6N5lLrNiivaxz0CKfA5AmmRQ0Gr8MJZUS
 r6ijLdbaydgBAEdKLykeYv5zI1Ua0P4lx6E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eyj5t88jk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:45:07 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:45:01 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id CB0F6CA0251F; Wed, 23 Mar 2022 08:44:59 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 0/4] liburing: support xattr functions
Date:   Wed, 23 Mar 2022 08:44:53 -0700
Message-ID: <20220323154457.3303391-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: y6RKLz8hU92gZ09QpazcC8X_8_541OWz
X-Proofpoint-ORIG-GUID: y6RKLz8hU92gZ09QpazcC8X_8_541OWz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add xattr support and testing to liburing

Patch 1: liburing: update io_uring
  Update io_uring.h with io_uring kernel changes.

Patch 2: liburing: add fsetxattr and setxattr
  Add new helper functions for fsetxattr and setxattr support
  in liburing.

Patch 3: liburing: add fgetxattr and getxattr
  Add new helper functions for fgetxattr and getxattr support
  in liburing.

Patch 4: liburing: add new tests for xattr
  Adds a  new test program to test the xattr support.

There are also patches for io_uring and xfstests:
- Adds xattr support for io_uring
- Add xattr support to fsstress

Changes:
- V2: Refreshed source

Stefan Roesch (4):
  liburing: Update io_uring in liburing
  liburing: add helper functions for setxattr and fsetxattr
  liburing: Add helper functions for fgetxattr and getxattr
  liburing: Add new test program to verify xattr support

 src/include/liburing.h          |  47 +++-
 src/include/liburing/io_uring.h |  10 +-
 test/Makefile                   |   1 +
 test/xattr.c                    | 425 ++++++++++++++++++++++++++++++++
 4 files changed, 480 insertions(+), 3 deletions(-)
 create mode 100644 test/xattr.c


base-commit: 56066e7a41fdc6a0d0c537c94b2e746554449943
--=20
2.30.2

