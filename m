Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E1C45AAE7
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 19:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239765AbhKWSLN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 13:11:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239652AbhKWSLM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 13:11:12 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN8OuYt028466
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:08:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7Y/+XGk7M4kHfrKcXs/bjeOtaTMkxR6y9PZlsVVMyN4=;
 b=ouITlEFLG48rrimAhV0gFh2U8nTcGTm3a26Dpa9r4kHywB+uGn4/5t/5twBSqVJ69APD
 d9yILS1X0eqW+WsAPOW++ujS0t1LQkjihWG3qGtwjtHjKVA8yEwVD8j9ot6b8uLKS5QX
 E03nyfkPWcxUuJbzP0OcO3VydWFExC6ABN4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cgvrxkqum-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:08:03 -0800
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 23 Nov 2021 10:08:01 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id E077A6CCCD49; Tue, 23 Nov 2021 10:07:54 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 2/4] liburing: add prepare function for getdents64
Date:   Tue, 23 Nov 2021 10:07:51 -0800
Message-ID: <20211123180753.1598611-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211123180753.1598611-1-shr@fb.com>
References: <20211123180753.1598611-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: ponzS1UiwQCVLJFieveOqtXesHNuH5dD
X-Proofpoint-ORIG-GUID: ponzS1UiwQCVLJFieveOqtXesHNuH5dD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_06,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=567 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230089
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Adds the io_uring_prep_getdents() function to setup a getdents64 call.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 169e098..8deae5a 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -672,6 +672,12 @@ static inline void io_uring_prep_linkat(struct io_ur=
ing_sqe *sqe, int olddfd,
 	sqe->hardlink_flags =3D (__u32) flags;
 }
=20
+static inline void io_uring_prep_getdents(struct io_uring_sqe *sqe, int =
fd,
+					  void *buf, unsigned int count, uint64_t offset)
+{
+	io_uring_prep_rw(IORING_OP_GETDENTS, sqe, fd, buf, count, offset);
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist=
 in
  * the SQ ring
--=20
2.30.2

