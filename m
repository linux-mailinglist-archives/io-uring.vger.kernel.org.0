Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1054646E5
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 06:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346826AbhLAFzT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 00:55:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55838 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346815AbhLAFzQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 00:55:16 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B12Gj7f003443
        for <io-uring@vger.kernel.org>; Tue, 30 Nov 2021 21:51:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nIAZdW8VuTshmBz73AfGJUhGFkxhBZJOLIX2UStYqjE=;
 b=BKuOayT2EsBNrfIPoSyISe7omRx4+wzYUQY3E9wiV3n8YyrLDrGJU3PmTU+zSU10ThwG
 D7k8CgsRsD0QCd+LpF6mliPIpCV73RCTCoZ9da3RLxCJSlyvN4yV6ZbMR23cQv/Gn0eX
 MkC7+nAgwSoDpf5MCo4cAdV+1G5tb/UOERY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cp047rx8g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Nov 2021 21:51:55 -0800
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 21:51:53 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 5ADBE722717F; Tue, 30 Nov 2021 21:51:46 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 0/5] io_uring: add xattr support
Date:   Tue, 30 Nov 2021 21:51:39 -0800
Message-ID: <20211201055144.3141001-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: nnaK3sHw9A1QfVjlux5E0hyVche9HcxT
X-Proofpoint-ORIG-GUID: nnaK3sHw9A1QfVjlux5E0hyVche9HcxT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=962 impostorscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the xattr support to io_uring. The intent is to have a more
complete support for file operations in io_uring.

This change adds support for the following functions to io_uring:
- fgetxattr
- fsetxattr
- getxattr
- setxattr

Patch 1: fs: split off do_user_path_at_empty from user_path_at_empty()
  This splits off a new function do_user_path_at_empty from
  user_path_at_empty that is based on filename and not on a
  user-specified string.

Patch 2: fs: split off setxattr_setup function from setxattr
  Split off the setup part of the setxattr function.

Patch 3: fs: split off do_getxattr from getxattr
  Split of the do_getxattr part from getxattr. This will
  allow it to be invoked it from io_uring.

Patch 4: io_uring: add fsetxattr and setxattr support
  This adds new functions to support the fsetxattr and setxattr
  functions.

Patch 5: io_uring: add fgetxattr and getxattr support
  This adds new functions to support the fgetxattr and getxattr
  functions.


There are two additional patches:
  liburing: Add support for xattr api's.
            This also includes the tests for the new code.
  xfstests: Add support for io_uring xattr support.


Signed-off-by: Stefan Roesch <shr@fb.com>
base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
---
V2: - split off function do_user_path_empty instead of changing
      the function signature of user_path_at
    - Fix datatype size problem in do_getxattr


Stefan Roesch (5):
  fs: split off do_user_path_at_empty from user_path_at_empty()
  fs: split off setxattr_setup function from setxattr
  fs: split off do_getxattr from getxattr
  io_uring: add fsetxattr and setxattr support
  io_uring: add fgetxattr and getxattr support

 fs/internal.h                 |  23 +++
 fs/io_uring.c                 | 327 ++++++++++++++++++++++++++++++++++
 fs/namei.c                    |  10 +-
 fs/xattr.c                    | 106 +++++++----
 include/linux/namei.h         |   2 +
 include/uapi/linux/io_uring.h |   8 +-
 6 files changed, 437 insertions(+), 39 deletions(-)

--=20
2.30.2

