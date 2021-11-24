Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0D245D111
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 00:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243086AbhKXXUa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 18:20:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17838 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244755AbhKXXU0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 18:20:26 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOKFBOt006437
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 15:17:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=NgS2KZzbA1W+gv5+zMwv/8mC21+P6aOYVkg7arqXcuY=;
 b=lNmFL73fz0R/aflPaJq3uid167EpS1vZhdEBydHBBi1cvzBEv5mtmiXWbbEpzyq2XO5n
 bZKAKCbr+ggOWLH5DvFkAa2pXwq0eytDq56dwwWZqJS3MyV36mbMgi5p6ai5s0lgGZ7g
 ihg/clqyjOOGQfukMkVFd7Kpjqboqap4nhk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3chje5vwxb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 15:17:15 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 15:17:14 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9B2A66DDBB76; Wed, 24 Nov 2021 15:17:10 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v2 0/3] io_uring: add getdents64 support
Date:   Wed, 24 Nov 2021 15:16:57 -0800
Message-ID: <20211124231700.1158521-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: wf4HYBNdzfE3XDsGs_3C4AZWg8f6cbkY
X-Proofpoint-GUID: wf4HYBNdzfE3XDsGs_3C4AZWg8f6cbkY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_06,2021-11-24_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=628 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111240114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds support for getdents64 in liburing. The intent is to
provide a more complete I/O interface for io_uring.

Patch 1: fs: add parameter use_fpos to iterate_dir()
  This adds a new parameter to the function iterate_dir() so the
  caller can specify if the position is the file position or the
  position stored in the buffer context.

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
V2: Updated the iterate_dir calls in fs/ksmbd, fs/ecryptfs and arch/alpha=
 with
    the additional parameter.

Stefan Roesch (3):
  fs: add parameter use_fpos to iterate_dir function
  fs: split off vfs_getdents function of getdents64 syscall
  io_uring: add support for getdents64

 arch/alpha/kernel/osf_sys.c   |  2 +-
 fs/ecryptfs/file.c            |  2 +-
 fs/exportfs/expfs.c           |  2 +-
 fs/internal.h                 |  8 +++++
 fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++
 fs/ksmbd/smb2pdu.c            |  2 +-
 fs/ksmbd/vfs.c                |  4 +--
 fs/nfsd/nfs4recover.c         |  2 +-
 fs/nfsd/vfs.c                 |  2 +-
 fs/overlayfs/readdir.c        |  6 ++--
 fs/readdir.c                  | 64 ++++++++++++++++++++++++++---------
 include/linux/fs.h            |  2 +-
 include/uapi/linux/io_uring.h |  1 +
 13 files changed, 121 insertions(+), 28 deletions(-)


base-commit: f0afafc21027c39544a2c1d889b0cff75b346932
--=20
2.30.2

