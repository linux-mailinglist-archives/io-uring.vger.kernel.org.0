Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E7147C3F5
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 17:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhLUQkN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 11:40:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37062 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236558AbhLUQkM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 11:40:12 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BLAv0Cm031091
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:40:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=a76+ly2/b29FOVogmBKh6AyZyMjiEd9mim4VtwUfpm0=;
 b=KpHQ1n0XbkRGLQ0vqggI3QHpRMg9n9iwRizZywsiqvEah2q9YnEyUcaM6QtTPqzbKEMh
 kKtxlQBtw0+JzW2nL0SeSidC8noW/23ctXEYSvxlca83ZUZeJlLJY6WISkVEq2pcxblC
 xpMoMze0LwaRVW6NP1xafzXgFBvI3Dfw0Us= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d3dm82bm0-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:40:12 -0800
Received: from twshared21922.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 08:40:09 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A32DB85BEA66; Tue, 21 Dec 2021 08:40:07 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <shr@fb.com>
Subject: [PATCH v7 0/3] io_uring: add getdents64 support
Date:   Tue, 21 Dec 2021 08:40:01 -0800
Message-ID: <20211221164004.119663-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: C1c2hyAQOt9dyBLI80EyoLMH4oTxaNp6
X-Proofpoint-ORIG-GUID: C1c2hyAQOt9dyBLI80EyoLMH4oTxaNp6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_04,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=388
 suspectscore=0 malwarescore=0 clxscore=1015 bulkscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210082
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds support for getdents64 in liburing. The intent is to
provide a more complete I/O interface for io_uring.

Patch 1: fs: add offset parameter to iterate_dir function.
  This adds an offset parameter to the iterate_dir()
  function. The new parameter allows the caller to specify
  the offset to use.

Patch 2: fs: split off vfs_getdents function from getdents64 system call
  This splits of the iterate_dir part of the syscall in its own
  dedicated function. This allows to call the function directly from
  io_uring.

Patch 3: io_uring: add support for getdents64
  Adds the functions to io_uring to support getdents64.

There is also a patch series for the changes to liburing. This includes
a new test. The patch series is called "liburing: add getdents support."

The following tests have been performed:
- new liburing getdents test program has been run
- xfstests have been run
- both tests have been repeated with the kernel memory leak checker
  and no leaks have been reported.


V7: - add loff_t *parameter to iterate_dir function
    - remove do_iterate_dir function
    - change callers of iterate_dir function
v6: - rebased patch series
v5: - remove old patch (v4 contained a patch file from v3)
V4: - silence compiler warnings
V3: - add do_iterate_dir() function to Patch 1
    - make iterate_dir() function call do_iterate_dir()
      This has the advantage that the function signature of iterate_dir
      does not change
V2: - updated the iterate_dir calls in fs/ksmbd, fs/ecryptfs and arch/alp=
ha with
      the additional parameter.


Stefan Roesch (3):
  fs: add offset parameter to iterate_dir function
  fs: split off vfs_getdents function of getdents64 syscall
  io_uring: add support for getdents64

 arch/alpha/kernel/osf_sys.c   |  2 +-
 fs/ecryptfs/file.c            |  2 +-
 fs/exportfs/expfs.c           |  2 +-
 fs/internal.h                 |  8 +++++
 fs/io_uring.c                 | 52 +++++++++++++++++++++++++++++
 fs/ksmbd/smb2pdu.c            |  3 +-
 fs/ksmbd/vfs.c                |  4 +--
 fs/nfsd/nfs4recover.c         |  2 +-
 fs/nfsd/vfs.c                 |  2 +-
 fs/overlayfs/readdir.c        |  6 ++--
 fs/readdir.c                  | 62 +++++++++++++++++++++++++----------
 include/linux/fs.h            |  2 +-
 include/uapi/linux/io_uring.h |  1 +
 13 files changed, 119 insertions(+), 29 deletions(-)


base-commit: d09358c3d161dcea8f02eae1281bc996819cc769
--=20
2.30.2

