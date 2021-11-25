Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E1045E357
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 00:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347042AbhKYXbV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 18:31:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37580 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347146AbhKYX3U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 18:29:20 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APNOas0009593
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 15:26:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=po7vsb2OFd4Fjv8/wzwN5YcyiczkFQWUYpJ6qU/gW+Y=;
 b=Jpf349dWxrc3Mdb4EeKAjuWtIY34HffvPZfOyqdUcTvuYgB6GEGirHaT+nTn4OPB5iaI
 3BGfEq8O9f6OBTP9nPfbTzdoRxFnr30J7xNGdTPJ4jT0wRhrl5bACU6J5u+zqdyPsbBb
 9iqDp5xIpSZSdwKN08lSPO0oYqR2M+fdQKE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cj6y0v4y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 15:26:08 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 25 Nov 2021 15:26:07 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 34BF96E85F85; Thu, 25 Nov 2021 15:25:56 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v3 0/3] io_uring: add getdents64 support
Date:   Thu, 25 Nov 2021 15:25:46 -0800
Message-ID: <20211125232549.3333746-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: mbFWjK1nSZRXtlTMy5kBw-Xznhvc7eqC
X-Proofpoint-GUID: mbFWjK1nSZRXtlTMy5kBw-Xznhvc7eqC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_07,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=663
 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111250132
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
V3: - add do_iterate_dir() function to Patch 1
    - make iterate_dir() function call do_iterate_dir()
      This has the advantage that the function signature of iterate_dir
      does not change

V2: Updated the iterate_dir calls in fs/ksmbd, fs/ecryptfs and arch/alpha=
 with
    the additional parameter.


Stefan Roesch (3):
  fs: add parameter use_fpos to iterate_dir function
  fs: split off vfs_getdents function of getdents64 syscall
  io_uring: add support for getdents64

 fs/internal.h                 |  8 +++++
 fs/io_uring.c                 | 52 +++++++++++++++++++++++++++++
 fs/readdir.c                  | 61 ++++++++++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 110 insertions(+), 12 deletions(-)


base-commit: de5de0813b7dbbb71fb5d677ed823505a0e685c5
--=20
2.30.2

