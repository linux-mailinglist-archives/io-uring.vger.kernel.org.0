Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E665345AAE9
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 19:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbhKWSLX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 13:11:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61814 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239667AbhKWSLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 13:11:21 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN8OuZ0028466
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:08:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LwgzdZ/Gh6EDqNGoKVzCbBb8MQ9tmEcJoA03t5gp42o=;
 b=pL2bG0aFEetOJyKA8Dszbirhgy+PgI8I3ZpzhwY2AUns6UjDn8mFwBISEPPf+kgwLi6J
 Zb+Hy5pXGfb5DJn7nO57YeiyLPqPfaj1mwyP9htZnzP+ts3fQU6Iyg9Sry5vu8eF0InA
 vhM8/nCDB7IMNtabhOcByOh4U+JEkRKq0Uo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cgvrxkqum-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:08:06 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 23 Nov 2021 10:08:04 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id EA98B6CCCD4D; Tue, 23 Nov 2021 10:07:54 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 4/4] liburing: Add man page for io_uring_prep_getdents call
Date:   Tue, 23 Nov 2021 10:07:53 -0800
Message-ID: <20211123180753.1598611-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211123180753.1598611-1-shr@fb.com>
References: <20211123180753.1598611-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: iC8_OmUN0wCBvrd-gDH9SCO3mAVy_eB7
X-Proofpoint-ORIG-GUID: iC8_OmUN0wCBvrd-gDH9SCO3mAVy_eB7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_06,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230089
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Adds the man page for the io_uring_prep_getdents call.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 man/io_uring_prep_getdents.3 | 64 ++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 man/io_uring_prep_getdents.3

diff --git a/man/io_uring_prep_getdents.3 b/man/io_uring_prep_getdents.3
new file mode 100644
index 0000000..15279f6
--- /dev/null
+++ b/man/io_uring_prep_getdents.3
@@ -0,0 +1,64 @@
+.\" Copyright (C) 2021 Stefan Roesch <shr@fb.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_getdents 3 "November 19, 2021" "liburing-2.1" "liburin=
g Manual"
+.SH NAME
+io_uring_prep_getdents   - prepare getdents64 call
+
+.SH SYNOPSIS
+.nf
+.BR "#include <liburing.h>"
+.PP
+.BI "void io_uring_prep_getdents(struct io_uring_sqe *sqe,"
+.BI "                            int fd,"
+.BI "                            void *buf,"
+.BI "                            unsigned int count,"
+.BI "                            uint64_t offset)"
+
+.SH DESCRIPTION
+.PP
+The io_uring_prep_getdents() prepares a getdents64 request. The submissi=
on queue
+entry
+.I sqe
+is setup to use the file descriptor
+.I fd
+to start writing up to
+.I count
+bytes into the buffer
+.I buf
+starting at
+.I offset.
+
+After the getdents call has been prepared it can be submitted with one o=
f the submit
+functions.
+
+.SH RETURN VALUE
+None
+
+.SH EXAMPLE
+A getdents io_uring call can be prepared like in the following code snip=
pet.
+The io_uring_sqe_set_data(3) call is not necessary, but it helps to corr=
elate the
+request with the results.
+
+.BI "void schedule_readdir(struct io_uring_sqe *sqe, struct dir *dir)"
+.fi
+.BI "{"
+.fi
+.BI "   io_uring_prep_getdents(sqe,"
+.fi
+.BI "                          dir->fd,"
+.fi
+.BI "                          dir->buf,"
+.fi
+.BI "                          sizeof(dir->buf),"
+.fi
+.BI "                          dir->off);"
+.fi
+.BI "   io_uring_sqe_set_data(sqe, dir);
+.fi
+.BI "}"
+
+
+.SH SEE ALSO
+.BR io_uring_get_sqe (3), io_uring_sqe_set_data (3), io_uring_submit (3)=
, io_uring_sqe_get_data (3)
--=20
2.30.2

