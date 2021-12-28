Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB3C480C9A
	for <lists+io-uring@lfdr.de>; Tue, 28 Dec 2021 19:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbhL1Sm1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Dec 2021 13:42:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64106 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237093AbhL1Sm1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Dec 2021 13:42:27 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BSBAM4I019034
        for <io-uring@vger.kernel.org>; Tue, 28 Dec 2021 10:42:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Q6Q5kK0R3kRRGraar2F+hK4r7egrABA56Lzto7RR6VM=;
 b=Pp4dfnSEnHOVmOz27dH82t+SbFNzatsBzSGXzS8I5vAuvGs9t4is4QEwacuz0Rv150vr
 f8ooWhAJ5dKV0pmNStoFfzSCxBeJ21GsRk6wjvMsUss0CRndUm5naV+50BWTfueYemn0
 KxQGEf4Yb+WbPDI3DXMRf1jUNRitjxqXUTM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d749t8jfk-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Dec 2021 10:42:26 -0800
Received: from twshared7460.02.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 28 Dec 2021 10:42:00 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 154848B3D9C2; Tue, 28 Dec 2021 10:41:48 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v9 0/5] io_uring: add xattr support
Date:   Tue, 28 Dec 2021 10:41:40 -0800
Message-ID: <20211228184145.1131605-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: N1977EthL6ZlkiFqtRlqiJO03gvv_9BN
X-Proofpoint-ORIG-GUID: N1977EthL6ZlkiFqtRlqiJO03gvv_9BN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-28_10,2021-12-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112280084
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


V9: - keep kvalue in struct xattr_ctx
V8: - introduce xattr_name struct as advised by Linus
    - remove kname_sz field in xattr_ctx
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

 fs/internal.h                 |  28 +++
 fs/io_uring.c                 | 314 ++++++++++++++++++++++++++++++++++
 fs/namei.c                    |  10 +-
 fs/xattr.c                    | 114 ++++++++----
 include/linux/namei.h         |   2 +
 include/uapi/linux/io_uring.h |   8 +-
 6 files changed, 438 insertions(+), 38 deletions(-)


base-commit: b4518682080d3a1cdd6ea45a54ff6772b8b2797a
--=20
2.30.2

