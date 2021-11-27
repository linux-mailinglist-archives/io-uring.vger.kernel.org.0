Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E564B45FD08
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 07:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345479AbhK0GJB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 01:09:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39582 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1345286AbhK0GG7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 01:06:59 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1AR2xWii019445
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 22:03:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=7CGJdCgR/z7c7B4bd6YyCl03mU3QwXtFqs0xV6G6teA=;
 b=glbLWnS07W9k50LZ2xSDwhuLODUM/Y/9wkH9TnyWTUr47DHcVlr2TIQXabzRYcX9ztsM
 386CeHKYZtNWjMVZJI/ZYoGv28T9iibzCKlR8cWKXLpT0G5NoMubIX9XifJhjYbZ8tZW
 V1qdVjC+/7IiyAPoQ9rG6ng0/O8U8aaRFrU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3ckcc48ggx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 22:03:45 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 22:03:43 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 102616F679A4; Fri, 26 Nov 2021 22:03:35 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v5 0/3] io_uring: add getdents64 support
Date:   Fri, 26 Nov 2021 22:03:23 -0800
Message-ID: <20211127060326.3018505-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: fC5DMmYKBy-dMQuCe8NhmtMHqCylniDa
X-Proofpoint-ORIG-GUID: fC5DMmYKBy-dMQuCe8NhmtMHqCylniDa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-27_02,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=599
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111270032
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


base-commit: 4d162e24e9979dcb3d7825229982c172ca4bde54
--=20
2.30.2

