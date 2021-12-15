Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E30F476580
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhLOWRI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:17:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229472AbhLOWRI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:17:08 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BFLiYck016083
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:17:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=llgFdcLg2I/3Yytv92pWfiET0i1jN8rumAav6O0H5vQ=;
 b=CrbwI98hmIVbrJEWJiuNsjNlYBorn32EYef93Po4kIxB73Fsz+GgChfiGKOy58ZUtSFt
 im9hxVsT1QRTMBzOyIOukibLAxluC3Yj2j4HRIzOZ+8FvG80p52jBL0T4QKQYlS1hCM7
 vuVWqzj7scGbJQ3YxqLNfY9WlquMaWzqP7k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cyf7fvwh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:17:08 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 14:17:06 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 5A7E081B0199; Wed, 15 Dec 2021 14:17:05 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>
Subject: [PATCH v4 0/5] io_uring: add xattr support
Date:   Wed, 15 Dec 2021 14:16:57 -0800
Message-ID: <20211215221702.3695098-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: sOYw1PpWjO8INC6CH5SFcqNPlHSE--Ik
X-Proofpoint-ORIG-GUID: sOYw1PpWjO8INC6CH5SFcqNPlHSE--Ik
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_13,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0 spamscore=0
 mlxlogscore=849 priorityscore=1501 suspectscore=0 mlxscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150123
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

---
V4: - rebased patch series
V3: - remove req->file checks in prep functions
    - change size parameter in do_xattr
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
 fs/io_uring.c                 | 321 ++++++++++++++++++++++++++++++++++
 fs/namei.c                    |  10 +-
 fs/xattr.c                    | 106 +++++++----
 include/linux/namei.h         |   2 +
 include/uapi/linux/io_uring.h |   8 +-
 6 files changed, 431 insertions(+), 39 deletions(-)


base-commit: d09358c3d161dcea8f02eae1281bc996819cc769
--=20
2.30.2

