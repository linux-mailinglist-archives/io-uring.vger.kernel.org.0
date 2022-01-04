Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8713484850
	for <lists+io-uring@lfdr.de>; Tue,  4 Jan 2022 20:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiADTJq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Jan 2022 14:09:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18706 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232029AbiADTJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Jan 2022 14:09:46 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 204GFfRq023079
        for <io-uring@vger.kernel.org>; Tue, 4 Jan 2022 11:09:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=DXeIzVPghLGFxUiVUkz8ASRNUB5lxCLthbUVSkvaEv0=;
 b=TUzJDGx0brQGL46dsNyPbqF1ZtNWRUS8wxER4G8LLKkyv+AQ9c5+WI9FdoWOORnbkgly
 QpeHPZ3xL6cL76+B/55FHLFVIv2IkIR9KGvFZZ37UGVZ4UQaOx2X1t11WC2qkh0nOheo
 vUuHLL7QRvslNcBIYeeDqzqRx3r+iZ4t6L4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dcaerddf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 04 Jan 2022 11:09:45 -0800
Received: from twshared12416.02.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 11:09:44 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id B33558FC8E0B; Tue,  4 Jan 2022 11:09:38 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v11 0/4] io_uring: add xattr support
Date:   Tue, 4 Jan 2022 11:09:32 -0800
Message-ID: <20220104190936.3085647-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cC0WUl8qcnyzaRDPmmlLjpJdluImToxF
X-Proofpoint-ORIG-GUID: cC0WUl8qcnyzaRDPmmlLjpJdluImToxF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_09,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 mlxlogscore=874 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201040126
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

Patch 1: fs: split off setxattr_copy and do_setxattr function from setxat=
tr
  Split off the setup part of the setxattr function in the setxattr_copy
  function. Split off the processing part in do_setxattr.

Patch 2: fs: split off do_getxattr from getxattr
  Split of the do_getxattr part from getxattr. This will
  allow it to be invoked it from io_uring.

Patch 3: io_uring: add fsetxattr and setxattr support
  This adds new functions to support the fsetxattr and setxattr
  functions.

Patch 4: io_uring: add fgetxattr and getxattr support
  This adds new functions to support the fgetxattr and getxattr
  functions.


There are two additional patches:
  liburing: Add support for xattr api's.
            This also includes the tests for the new code.
  xfstests: Add support for io_uring xattr support.


V11: - removed the do_user_path_at_empty function and directly
       call filename_lookup
     - introduce __io_xattr_finish and io_xattr_finish functions
       to unify the cleanup code
     - remove the older __io_setxattr_finish function
V10: - move do_user_path_at_empty definition to fs/internal.h
     - introduce __io_setxattr_finish function
     - introduce __io_getxattr_finish function
V9 : - keep kvalue in struct xattr_ctx
V8 : - introduce xattr_name struct as advised by Linus
     - remove kname_sz field in xattr_ctx
V7 : - split off setxattr in two functions as recommeneded by
       Christian.
V6 : - reverted addition of kname array to xattr_ctx structure
       Adding the kname array increases the io_kiocb beyond 64 bytes
       (increases it to 224 bytes). We try hard to limit it to 64 bytes.
       Keeping the original interface also is a bit more efficient.
     - addressed Pavel's reordering comment
     - addressed Pavel's putname comment
     - addressed Pavel's kvfree comment
     - rebased on for-5.17/io_uring-getdents64
V5 : - add kname array to xattr_ctx structure
V4 : - rebased patch series
V3 : - remove req->file checks in prep functions
     - change size parameter in do_xattr
V2 : - split off function do_user_path_empty instead of changing
       the function signature of user_path_at
     - Fix datatype size problem in do_getxattr


Stefan Roesch (4):
  fs: split off setxattr_copy and do_setxattr function from setxattr
  fs: split off do_getxattr from getxattr
  io_uring: add fsetxattr and setxattr support
  io_uring: add fgetxattr and getxattr support

 fs/internal.h                 |  28 ++++
 fs/io_uring.c                 | 298 ++++++++++++++++++++++++++++++++++
 fs/xattr.c                    | 114 +++++++++----
 include/uapi/linux/io_uring.h |   8 +-
 4 files changed, 411 insertions(+), 37 deletions(-)


base-commit: b4518682080d3a1cdd6ea45a54ff6772b8b2797a
--=20
2.30.2

