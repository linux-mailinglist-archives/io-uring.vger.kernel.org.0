Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AD1476514
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 22:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhLOV7c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 16:59:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230306AbhLOV7b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 16:59:31 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BFLiPPP020358
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 13:59:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Ivgbdb74LSR/ebqtsWhU+W+nyb2uC9VUXrbA16sEIEw=;
 b=FSzg+QsmEUUhyFtLOgfptKHfVn97kKYKwelr5pjRwjATpnewdSgYe7bTvKbi9KloPoG/
 fHpPmNBAa7BXIOvxaE63gXJRDw5kMYabAhCGUwc1vnexN4/st4eCyQjFsyOiYrPs4cP5
 33YW9Kv20Y1UdoDfGhbo8VejXdP/Pbzo8Z0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cyga3va34-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 13:59:31 -0800
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 13:59:31 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id CF2FB81A403B; Wed, 15 Dec 2021 13:59:26 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>
Subject: [PATCH v6 0/3] io_uring: add getdents64 support
Date:   Wed, 15 Dec 2021 13:59:21 -0800
Message-ID: <20211215215924.3301586-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: YNkDvtIbS-9cRz5o_Yvt5LKJrPF_7IuD
X-Proofpoint-GUID: YNkDvtIbS-9cRz5o_Yvt5LKJrPF_7IuD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_13,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 mlxlogscore=541 impostorscore=0 phishscore=0 mlxscore=0 adultscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds support for getdents64 in liburing. The intent is to
provide a more complete I/O interface for io_uring.

Patch 1: fs: split off do_iterate_dir from iterate_dir function
  This splits of the function do_iterate_dir() from the iterate_dir()
  function and adds a new parameter. The new parameter allows the
  caller to specify if the position is the file position or the
  position stored in the buffer context.

  The function iterate_dir() calls do_iterate_dir().

Patch 2: fs: split off vfs_getdents function from getdents64 system call
  This splits of the iterate_dir part of the syscall in its own
  dedicated function. This allows to call the function directly from
  liburing.

Patch 3: io_uring: add support for getdents64
  Adds the functions to io_uring to support getdents64.

There is also a patch series for the changes to liburing. This includes
a new test. The patch series is called "liburing: add getdents support."

The following tests have been performed:
- new liburing getdents test program has been run
- xfstests have been run
- both tests have been repeated with the kernel memory leak checker
  and no leaks have been reported.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
v6: - rebased patch series
v5: - remove old patch (v4 contained a patch file from v3)

V4: - silence compiler warnings

V3: - add do_iterate_dir() function to Patch 1
    - make iterate_dir() function call do_iterate_dir()
      This has the advantage that the function signature of iterate_dir
      does not change

V2: Updated the iterate_dir calls in fs/ksmbd, fs/ecryptfs and arch/alpha=
 with
    the additional parameter.


Stefan Roesch (3):
  fs: split off do_iterate_dir from iterate_dir function
  fs: split off vfs_getdents function of getdents64 syscall
  io_uring: add support for getdents64

 fs/internal.h                 |  8 +++++
 fs/io_uring.c                 | 52 +++++++++++++++++++++++++++++
 fs/readdir.c                  | 62 ++++++++++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 111 insertions(+), 12 deletions(-)


base-commit: d09358c3d161dcea8f02eae1281bc996819cc769
--=20
2.30.2

