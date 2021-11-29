Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149B2462418
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhK2WQY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:16:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64216 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231131AbhK2WQY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:16:24 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATIlAHB028209
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:13:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=pVviU5mxg2/Smsx8Rzj+SaCUpgPyEzC+zB0KIO4GyRQ=;
 b=Y5qA+lW7Ss11N2tOxTmq0bDwtLqg1dtXjSPDLzL3LNs7ucNJ5ysyUi8k6WXGJLkKe+NZ
 r0QfwikYV9eHDry1lDpgIsm939K5MpzmxI3/iSQD+0Wv/Sd9gYAk6Gw7lw14tTcT5IcR
 1bObXSwU6fjQRoms6KsPW60vJ1n0zgR0Gbc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cn1as32gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:13:05 -0800
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:13:04 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8DB7D7101604; Mon, 29 Nov 2021 14:12:59 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 0/5] io_uring: add xattr support
Date:   Mon, 29 Nov 2021 14:12:52 -0800
Message-ID: <20211129221257.2536146-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: ruc92T2Mj9t_GSR9AwtNSM9kw6J-X64N
X-Proofpoint-ORIG-GUID: ruc92T2Mj9t_GSR9AwtNSM9kw6J-X64N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=978 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290105
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

Patch 1: fs: make user_path_at_empty() take a struct filename
  The user_path_at_empty filename parameter has been changed
  from a const char user pointer to a filename struct. io_uring
  operates on filenames.
  In addition also the functions that call user_path_at_empty
  in namei.c and stat.c have been modified for this change.

Patch 2: fs: split off setxattr_setup function from setxattr
  Split off the setup part of the setxattr function

Patch 3: fs: split off the vfs_getxattr from getxattr
  Split of the vfs_getxattr part from getxattr. This will
  allow to invoke it from io_uring.

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


Stefan Roesch (5):
  fs: make user_path_at_empty() take a struct filename
  fs: split off setxattr_setup function from setxattr
  fs: split off the vfs_getxattr from getxattr
  io_uring: add fsetxattr and setxattr support
  io_uring: add fgetxattr and getxattr support

 fs/internal.h                 |  23 +++
 fs/io_uring.c                 | 325 ++++++++++++++++++++++++++++++++++
 fs/namei.c                    |   5 +-
 fs/stat.c                     |   7 +-
 fs/xattr.c                    | 114 +++++++-----
 include/linux/namei.h         |   4 +-
 include/uapi/linux/io_uring.h |   8 +-
 7 files changed, 439 insertions(+), 47 deletions(-)


Signed-off-by: Stefan Roesch <shr@fb.com>
base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
--=20
2.30.2

