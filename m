Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392E847E891
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 20:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242793AbhLWT5k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 14:57:40 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350196AbhLWT5j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 14:57:39 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BNIWh2F002070
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 11:57:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=RsGML5PSjkm9MkP0lwEXcaQIocu8tjcRCtIgr8CWA/g=;
 b=dppAd3jdJKEQ19YvXbE9X7NujlgnfPEoMzIWjtIjprDPlvnFh/qk8m2jv3gTcDcU+/FX
 1pHP8DD9ZiRbWlW5XYkCe0rqzwHI6b5nIS+KI31SjanV0P/MZMQRUHQMZejECpE9kkSr
 fmYFxL9Fa9eF/zjqKJEM/5MI6JUsvgIGvHI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d4ftd5se6-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 11:57:39 -0800
Received: from twshared10481.23.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 11:57:12 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id BA1B587A0747; Thu, 23 Dec 2021 11:57:08 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v7 0/5] io_uring: add xattr support
Date:   Thu, 23 Dec 2021 11:56:53 -0800
Message-ID: <20211223195658.2805049-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xO0fzFpGPwlI6oGdD8QJqIXypOLWfNcy
X-Proofpoint-GUID: xO0fzFpGPwlI6oGdD8QJqIXypOLWfNcy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=906 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112230102
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

Patch 2: fs: split off setxattr_copy and do_setxattr function from setxat=
tr
  Split off the setup part of the setxattr function in the setxattr_copy
  function. Split off the processing part in do_setxattr.

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


V7: - split off setxattr in two functions as recommeneded by
      Christian.
V6: - reverted addition of kname array to xattr_ctx structure
      Adding the kname array increases the io_kiocb beyond 64 bytes
      (increases it to 224 bytes). We try hard to limit it to 64 bytes.
      Keeping the original interface also is a bit more efficient.
    - addressed Pavel's reordering comment
    - addressed Pavel's putname comment
    - addressed Pavel's kvfree comment
    - rebased on for-5.17/io_uring-getdents64
V5: - add kname array to xattr_ctx structure
V4: - rebased patch series
V3: - remove req->file checks in prep functions
    - change size parameter in do_xattr
V2: - split off function do_user_path_empty instead of changing
      the function signature of user_path_at
    - Fix datatype size problem in do_getxattr


Stefan Roesch (5):
  fs: split off do_user_path_at_empty from user_path_at_empty()
  fs: split off setxattr_copy and do_setxattr function from setxattr
  fs: split off do_getxattr from getxattr
  io_uring: add fsetxattr and setxattr support
  io_uring: add fgetxattr and getxattr support

 fs/internal.h                 |  25 +++
 fs/io_uring.c                 | 315 ++++++++++++++++++++++++++++++++++
 fs/namei.c                    |  10 +-
 fs/xattr.c                    | 119 +++++++++----
 include/linux/namei.h         |   2 +
 include/uapi/linux/io_uring.h |   8 +-
 6 files changed, 442 insertions(+), 37 deletions(-)


base-commit: b4518682080d3a1cdd6ea45a54ff6772b8b2797a
--=20
2.30.2

