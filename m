Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786CE45AAF3
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 19:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbhKWSNZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 13:13:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44612 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239690AbhKWSNY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 13:13:24 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANA15gs028842
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:10:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=bx8F/NvHVq9m1Onr84v+F4R/4aNnH6gDS03meklp2NY=;
 b=IXXhnzwwUgFcT8GCxAyKjrN8XWJAXXOSK6PT1xs9LXqZpzPp2zt6AKSkpAh7cnLAsI04
 qDqt/Jwc21EiLJvXF8bL9xZWYUI8ki+6efuZMU76ZVdUZ0Xl5XDVpF0BMHR5K3V08l96
 mzPzoKMrFfbafdeoQFI8c2EPl4rzJfSvU80= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cgx62u9tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:10:16 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 23 Nov 2021 10:10:15 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 08DFE6CCDB3F; Tue, 23 Nov 2021 10:10:13 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 0/3] io_uring: add getdents64 support
Date:   Tue, 23 Nov 2021 10:10:07 -0800
Message-ID: <20211123181010.1607630-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: qYV6B6ms4XtVh6_QUoX2QPz6VodSEake
X-Proofpoint-ORIG-GUID: qYV6B6ms4XtVh6_QUoX2QPz6VodSEake
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_06,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=597
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111230089
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds support for getdents64 in liburing. The intent is to
provide a more complete I/O interface for io_uring..=20

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


Stefan Roesch (3):
  fs: add parameter use_fpos to iterate_dir function
  fs: split off vfs_getdents function of getdents64 syscall
  io_uring: add support for getdents64

 fs/exportfs/expfs.c           |  2 +-
 fs/internal.h                 |  8 +++++
 fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++
 fs/nfsd/nfs4recover.c         |  2 +-
 fs/nfsd/vfs.c                 |  2 +-
 fs/overlayfs/readdir.c        |  6 ++--
 fs/readdir.c                  | 64 ++++++++++++++++++++++++++---------
 include/linux/fs.h            |  2 +-
 include/uapi/linux/io_uring.h |  1 +
 9 files changed, 116 insertions(+), 23 deletions(-)

Signed-off-by: Stefan Roesch <shr@fb.com>
--=20
2.30.2

