Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4509446248D
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhK2WU3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:20:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31792 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233511AbhK2WSc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:18:32 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATIlAKJ028204
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=4F6Ap6W597vjHUSGyt/w/G6qz02i8OKDlgZToh1/F9E=;
 b=qyH5aD45B0PTTTnCcULBqoFBNT8oXQICGpVIrvl4q51f4lK780Qjq5sCUpm0tsx0Rgw9
 dkNMDHzPmwGo/ui1vASTxBj9a9ClJnnT+LfYt/bu5kXeXblb0oWw7DOHujzEDlAVHMG2
 McYsU3Xf+6NnTEppT/2g7lQihpxyFQauCZ4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cn1as32we-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:15:12 -0800
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:15:10 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id EDAFB7101D1D; Mon, 29 Nov 2021 14:15:00 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v1 0/4] liburing: support xattr functions
Date:   Mon, 29 Nov 2021 14:14:54 -0800
Message-ID: <20211129221458.2546542-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: iDiZy8WnMgeAWuql9upviyYpg8FvSTA3
X-Proofpoint-ORIG-GUID: iDiZy8WnMgeAWuql9upviyYpg8FvSTA3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=610 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290105
X-FB-Internal: deliver
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


Signed-off-by: Stefan Roesch <shr@fb.com>
base-commit: 509873c4454012c5810c728695c21911c82acdc4
--=20
2.30.2

