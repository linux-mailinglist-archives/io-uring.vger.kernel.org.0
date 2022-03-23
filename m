Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECB04E558C
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242474AbiCWPqB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239204AbiCWPp7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:45:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2FD3B015
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:29 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22N6WTbi000755
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=zp+NEeTEPAGApicR5pW/0sbJQp2itw7lAhiHpnEuHYw=;
 b=W3IvGYWPdTrge/lEQcLHONRKXVGBC3t9HBCScQMBt+bUKDy5zIE0gVWhLzhAy8ztj0lO
 MBSnEPrD6cf+eQUNQo6FXP2iHVtiK6Ru6ky7q6UZTMihG4A7vLLYU0f5zD7A0+KquxVX
 emAk+E9woFiHAklDaoQ24Cqif8y6oYw0+Ac= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ey6ddmtxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:28 -0700
Received: from twshared37304.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:44:27 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 78364CA024C3; Wed, 23 Mar 2022 08:44:22 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v13 0/4] io_uring: add xattr support
Date:   Wed, 23 Mar 2022 08:44:16 -0700
Message-ID: <20220323154420.3301504-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: n2V98kemLuWIDMvm531SsLIeQZrGmwlR
X-Proofpoint-ORIG-GUID: n2V98kemLuWIDMvm531SsLIeQZrGmwlR
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


Changes:
V13: - refreshed the code
     - Review comments mentioned that the statx api in io_uring was
       not following the same pattern as the xattr api. This has
       been fixed by a previous patch (using the same pattern as
       this patch)
V12: - add union to xattr_ctx structure. The getxattr api requires
       a pointer to value and the setxattr requires a const pointer
       to value (with a union this can be unified).
     - use xattr_ctx structure in do_getxattr call.
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

 fs/internal.h                 |  29 ++++
 fs/io_uring.c                 | 294 ++++++++++++++++++++++++++++++++++
 fs/xattr.c                    | 141 ++++++++++------
 include/uapi/linux/io_uring.h |   8 +-
 4 files changed, 426 insertions(+), 46 deletions(-)


base-commit: ad9c6ee642a61adae93dfa35582b5af16dc5173a
--=20
2.30.2

